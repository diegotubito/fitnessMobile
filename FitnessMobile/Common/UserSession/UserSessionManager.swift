//
//  UserSessionManager.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import SwiftUI

struct UserSessionModel: Codable {
    let user: User
    let tempToken: String
}

class UserSessionManager: ObservableObject {
    private let userSessionKey = "UserSessionKey"
    private let deviceTokenKey = "DeviceToken"
    private let refreshTokenKey = "RefreshTokenKey"
    private let refreshTokenExpirationKey = "RefreshTokenExpirationKey"
    private let accessTokenKey = "AccessTokenKey"
    private let accessTokenExpirationKey = "AccessTokenExpirationKey"
    
    @Published var didLogIn: Bool = false
    
    var user: User?
    
    init() {
        self.user = getUserSession()?.user
    }
    
   
        
    func saveUser(user: User, tempToken: String) {
        do {
            let userSession = UserSessionModel(user: user,
                                               tempToken: tempToken)
            let encoder = JSONEncoder()
            let data = try encoder.encode(userSession)
            _ = KeychainManager.shared.save(key: userSessionKey, data: data)
            NotificationCenter.default.post(Notification(name: .UserSessionDidChanged))
        } catch {
            print("Error encoding person: \(error)")
        }
        
    }
    
    func getUserSession() -> UserSessionModel? {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserSessionModel.self, from: data)
                return user
            }
            return nil
        } catch {
            return nil
        }
    }
        
    func getTempToken() -> String {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserSessionModel.self, from: data)
                return user.tempToken
            }
            return ""
        } catch {
            return ""
        }
    }
    
    func removeUserSession() {
        let _ = KeychainManager.shared.delete(key: userSessionKey)
    }
    
    func saveDeviceToken(data: Data) {
        _ = KeychainManager.shared.save(key: deviceTokenKey, data: data)
    }
    
    func getDeviceToken() -> String? {
        guard let deviceTokenData = KeychainManager.shared.load(key: deviceTokenKey) else {
            return nil
        }
        
        let tokenString = deviceTokenData.reduce("", { $0 + String(format: "%02X", $1) })
        return tokenString
    }
    
    func getFullName() -> String {
        let user = getUserSession()
        let lastName: String = user?.user.lastName ?? ""
        let firstName: String = user?.user.firstName ?? ""
        return "\(firstName), \(lastName)"
    }
    
    func getUserName() -> String {
        let user = getUserSession()
        let username: String = user?.user.username ?? ""
        return username
    }
    
    func getEmail() -> String {
        let user = getUserSession()
        let email: String = user?.user.email ?? ""
        return email
    }
    
    var isTwoFactorEnabled: Bool {
        let user = getUserSession()
        let twoFactorEnabled: Bool = user?.user.twoFactorEnabled ?? false
        return twoFactorEnabled
    }
    
}

/// REFRESH TOKEN
extension UserSessionManager {
    func saveRefreshToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.shared.save(key: refreshTokenKey, data: data)
        }
    }
    
    func getRefreshToken() -> String {
        let data = KeychainManager.shared.load(key: refreshTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
    
    func saveRefreshTokenExpirationDate(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.shared.save(key: refreshTokenExpirationKey, data: data)
        }
    }
    
    func getRefreshTokenExpirationDate() -> Date {
        let data = KeychainManager.shared.load(key: refreshTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        return formatter.date(from: stringDate) ?? Date()
    }
    
    var isRefreshTokenExpired: Bool {
        let date = getRefreshTokenExpirationDate()
        return date.isExpired
    }
}

/// ACCESS TOKEN
extension UserSessionManager {
    func saveAccessToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.shared.save(key: accessTokenKey, data: data)
        }
    }
    
    func getAccessToken() -> String {
        let data = KeychainManager.shared.load(key: accessTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
    
    func saveAccessTokenExpirationDate(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.shared.save(key: accessTokenExpirationKey, data: data)
        }
    }
    
    func getAccessTokenExpirationDate() -> Date {
        let data = KeychainManager.shared.load(key: accessTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        return formatter.date(from: stringDate) ?? Date()
    }
    
    var isAccessTokenExpired: Bool {
        let date = getAccessTokenExpirationDate()
        return date.isExpired
    }
}
