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
        
        return try await doTask(request: createRequest(url: url, method: method))
    }
    
    private func createRequest(url: URL, method: ApiRequestConfiguration.Method) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
        if let token = UserSessionManager.getToken() {
            let authorization = "\(token)"
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
        }
        
        if let deviceToken = UserSessionManager.getDeviceToken() {
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
    
    private func doTask(request: URLRequest) async throws -> Data {
        if UserSessionManager.getUserSession() == nil && config.userIsNeeded {
            throw APIError.userSessionNotFound
        }

        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError(message: "Unknown error")
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
            case 500:
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let message = json?["message"] as? String
                throw APIError.serverError(message: message ?? "")
            default:
                throw APIError.serverError(message: "Unknown error")
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
