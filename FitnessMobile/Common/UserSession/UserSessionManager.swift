//
//  UserSessionManager.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import SwiftUI

class UserSessionManager: ObservableObject {
    private let userSessionKey = "UserSessionKey"
    private let deviceTokenKey = "DeviceToken"
    private let refreshTokenKey = "RefreshTokenKey"
    private let refreshTokenExpirationKey = "RefreshTokenExpirationKey"
    private let accessTokenKey = "AccessTokenKey"
    private let accessTokenExpirationKey = "AccessTokenExpirationKey"
    private let tempTokenKey = "TempTokenKey"
        
    func saveUser(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            _ = KeychainManager.shared.save(key: userSessionKey, data: data)
            NotificationCenter.default.post(Notification(name: .UserSessionDidChanged))
        } catch {
            print("Error encoding person: \(error)")
        }
        
    }
    
    func getUser() -> User? {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func removeUserSession() {
        _ = KeychainManager.shared.delete(key: userSessionKey)
//        _ = KeychainManager.shared.delete(key: deviceTokenKey)
        _ = KeychainManager.shared.delete(key: refreshTokenKey)
        _ = KeychainManager.shared.delete(key: refreshTokenExpirationKey)
        _ = KeychainManager.shared.delete(key: accessTokenKey)
        _ = KeychainManager.shared.delete(key: accessTokenExpirationKey)
        _ = KeychainManager.shared.delete(key: tempTokenKey)
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
    
    func getFullName() -> String? {
        if let user = getUser() {
            let lastName: String = user.lastName
            let firstName: String = user.firstName
            return "\(firstName), \(lastName)"
        }
        return nil
    }
    
    func getUserName() -> String? {
        let user = getUser()
        return  user?.username
    }
    
    func getEmail() -> String? {
        let user = getUser()
        return user?.email
    }
    
    var isTwoFactorEnabled: Bool {
        let user = getUser()
        let twoFactorEnabled: Bool = user?.twoFactorEnabled ?? false
        return twoFactorEnabled
    }
    
}

/// TEMP TOKEN
extension UserSessionManager {
    func saveTempToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.shared.save(key: tempTokenKey, data: data)
        }
    }
    
    func getTempToken() -> String {
        let data = KeychainManager.shared.load(key: tempTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
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
