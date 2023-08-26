//
//  ApiNetworkAsync.swift
//  HayEquipo
//
//  Created by David Gomez on 10/04/2023.
//

import SwiftUI

open class ApiNetworkAsync {
    public var config: ApiRequestConfiguration
    let session: URLSession
    
    public init() {
        config = ApiRequestConfiguration()
        session = URLSession(configuration: .default)
    }
    
    public func apiCall<T: Decodable>() async throws -> T {
        
        do {
            let data = try await performRequest()
            // If T is of type Data, return the data directly without decoding
            if T.self == Data.self {
                return data as! T
            }
            
            let decoder = JSONDecoder()
            JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
            let genericData = try decoder.decode(T.self, from: data)
            return genericData
        } catch let error as APIError {
            throw error
        } catch {
            print(error.localizedDescription)
            print(error)
            throw error
        }
        
    }
    
    private func performRequest() async throws -> Data {
        guard let url = config.getUrl() else {
            throw APIError.invalidURL
        }
        
        guard let method = config.method else {
            throw APIError.invalidMethod(method: config.method?.rawValue)
        }
        
        if UserSession.isAccessTokenExpired && !config.refresingToken && config.noTokenNeeded {
            let loginUseCase = LoginUseCase()
            do {
                let response = try await loginUseCase.doRefresh()
                UserSession.saveAccessToken(value: response.accessToken)
                UserSession.saveAccessTokenExpirationDate(value: response.accessTokenExpirationDateString)
                
                return try await doTask(request: createRequest(url: url, method: method) )

            } catch {
                throw APIError.authentication
            }
        }
        
        return try await doTask(request: createRequest(url: url, method: method) )
    }
    
    private func createRequest(url: URL, method: ApiRequestConfiguration.Method) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if config.imageData != nil {
            request = createMultipartRequest(url: url, method: method)
        }

        let accessToken = UserSession.getAccessToken()
        let authorization = "\(accessToken)"
        request.addValue(authorization, forHTTPHeaderField: "Authorization")
        
        if let deviceToken = UserSession.getDeviceToken() {
            request.setValue(deviceToken, forHTTPHeaderField: "DeviceToken")
        }

        for header in config.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        if let body = config.body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func createMultipartRequest(url: URL, method: ApiRequestConfiguration.Method) -> URLRequest {
        let multipartRequest = MultipartFormDataRequest(url: url)
        multipartRequest.addDataField(fieldName: "file", fileName: "not_used", data: config.imageData!, mimeType: config.mimeType.rawValue)
        return multipartRequest.asURLRequest()
    }
    
    private func doTask(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError(title: "_NOT_KNOWN_TITLE", message: "_NOT_KNOWN_MESSAGE")
        }
        
        logResponse(request: request, data: data, httpResponse: httpResponse)

        guard (200...299).contains(httpResponse.statusCode)
        else {
            switch httpResponse.statusCode {
            case 400:
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let title = json?["title"] as? String
                let message = json?["message"] as? String
                throw APIError.badRequest(title: title, message: message)
            case 432:
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let title = json?["title"] as? String
                let message = json?["message"] as? String
                throw APIError.customError(title: title, message: message)
            case 401:
                
                throw APIError.authentication
            case 404:
                throw APIError.notFound(url: request.url?.absoluteString)
            case 403:
                throw APIError.notAuthorize
            case 500:
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let title = json?["title"] as? String
                let message = json?["message"] as? String
                throw APIError.serverError(title: title ?? "", message: message ?? "")
            default:
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let title = json?["title"] as? String
                let message = json?["message"] as? String

                throw APIError.serverError(title: "_ERROR_NOT_HANDLED_TITLE", message: "\(httpResponse.statusCode) - \(message ?? "")")
            }
        }

        return data
    }
    
    func logResponse(request: URLRequest, data: Data?, httpResponse: HTTPURLResponse) {
        var error = false
        if !(200...299).contains(httpResponse.statusCode) {
            error = true
        }
        print(error ? "🔴" : "🟢")
        print("url:", request.url ?? "")
        print("method:", request.httpMethod ?? "")
        print("headers:", request.allHTTPHeaderFields ?? "")
        if let httpBody = request.httpBody {
            print("body:", String(data: httpBody, encoding: .utf8) ?? "none")
        } else {
            print("body: none")
        }
        
        print("response:", httpResponse)

        if let data = data, let json = try? JSONSerialization.jsonObject(with: data) {
            print("response:", json)
        }
        print(error ? "🔴" : "🟢")
    }
}


struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    var httpBody = NSMutableData()
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func addDataField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(fieldName: fieldName,fileName:fileName,data: data, mimeType: mimeType))
    }
    
    private func dataFormField(fieldName: String,
                               fileName: String,
                               data: Data,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()
        
        fieldData.appendString("--\(boundary)\r\n")
        fieldData.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        fieldData.appendString("Content-Type: \(mimeType)\r\n")
        fieldData.appendString("\r\n")
        fieldData.append(data)
        fieldData.appendString("\r\n")
        return fieldData as Data
    }
    
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        httpBody.appendString("--\(boundary)--")
        request.httpBody = httpBody as Data
        return request
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
