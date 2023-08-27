//
//  UserSessionManager.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import SwiftUI

class UserSession: ObservableObject {
    
    static let shared = UserSession()
    
    static private let userSessionKey = "UserSessionKey"
    static private let deviceTokenKey = "DeviceToken"
    static private let refreshTokenKey = "RefreshTokenKey"
    static private let refreshTokenExpirationKey = "RefreshTokenExpirationKey"
    static private let accessTokenKey = "AccessTokenKey"
    static private let accessTokenExpirationKey = "AccessTokenExpirationKey"
    static private let tempTokenKey = "TempTokenKey"
        
    static func saveUser(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            _ = KeychainManager.save(key: userSessionKey, data: data)
            NotificationCenter.default.post(Notification(name: .UserSessionDidChanged))
        } catch {
            print("Error encoding person: \(error)")
        }
        
    }
    
    static func getUser() -> User? {
        do {
            if let data = KeychainManager.load(key: userSessionKey) {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            }
            return nil
        } catch {
            return nil
        }
    }
    
    static func removeUserSession() {
        _ = KeychainManager.delete(key: userSessionKey)
//        _ = KeychainManager.delete(key: deviceTokenKey)
        _ = KeychainManager.delete(key: refreshTokenKey)
        _ = KeychainManager.delete(key: refreshTokenExpirationKey)
        _ = KeychainManager.delete(key: accessTokenKey)
        _ = KeychainManager.delete(key: accessTokenExpirationKey)
        _ = KeychainManager.delete(key: tempTokenKey)
        DataCache.removeData(identifier: UserSession._id)
        DataDisk.removeData(identifier: UserSession._id)
    }
    
    static func saveDeviceToken(data: Data) {
        _ = KeychainManager.save(key: deviceTokenKey, data: data)
    }
    
    static func getDeviceToken() -> String? {
        guard let deviceTokenData = KeychainManager.load(key: deviceTokenKey) else {
            return nil
        }
        
        let tokenString = deviceTokenData.reduce("", { $0 + String(format: "%02X", $1) })
        return tokenString
    }
    
    static func getFullName() -> String? {
        if let user = getUser() {
            let lastName: String = user.lastName
            let firstName: String = user.firstName
            return "\(firstName), \(lastName)"
        }
        return nil
    }
    
    static func getUserName() -> String? {
        let user = getUser()
        return  user?.username
    }
    
    static func getEmail() -> String? {
        let user = getUser()
        return user?.email
    }
    
    static var isTwoFactorEnabled: Bool {
        let user = getUser()
        let twoFactorEnabled: Bool = user?.twoFactorEnabled ?? false
        return twoFactorEnabled
    }
    
    static var _id: String {
        return getUser()?._id ?? ""
    }
    
}

/// TEMP TOKEN
extension UserSession {
    static func saveTempToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.save(key: tempTokenKey, data: data)
        }
    }
    
    static func getTempToken() -> String {
        let data = KeychainManager.load(key: tempTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
}

/// REFRESH TOKEN
extension UserSession {
    static func saveRefreshToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.save(key: refreshTokenKey, data: data)
        }
    }
    
    static func getRefreshToken() -> String {
        let data = KeychainManager.load(key: refreshTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
    
    static func saveRefreshTokenExpirationDate(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.save(key: refreshTokenExpirationKey, data: data)
        }
    }
    
    static func getRefreshTokenExpirationDate() -> Date {
        let data = KeychainManager.load(key: refreshTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        return formatter.date(from: stringDate) ?? Date()
    }
    
    static func getRefreshTokenExpirationDateString() -> String {
        let data = KeychainManager.load(key: refreshTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        let newDate = formatter.date(from: stringDate) ?? Date()
        
        return "Refresh Token: \(newDate.toString(format: "dd-MM-yy HH:mm:ss"))"
    }
    
    static var isRefreshTokenExpired: Bool {
        let date = getRefreshTokenExpirationDate()
        return date.isExpired
    }
}

/// ACCESS TOKEN
extension UserSession {
    static func saveAccessToken(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.save(key: accessTokenKey, data: data)
        }
    }
    
    static func getAccessToken() -> String {
        let data = KeychainManager.load(key: accessTokenKey)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
    
    static func saveAccessTokenExpirationDate(value: String) {
        if let data = value.data(using: .utf8) {
            _ = KeychainManager.save(key: accessTokenExpirationKey, data: data)
        }
    }
    
    static func getAccessTokenExpirationDate() -> Date {
        let data = KeychainManager.load(key: accessTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        return formatter.date(from: stringDate) ?? Date()
    }
    
    static func getAccessTokenExpirationDateString() -> String {
        let data = KeychainManager.load(key: accessTokenExpirationKey)
        let stringDate = String(data: data ?? Data(), encoding: .utf8) ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust this as needed
        let newDate = formatter.date(from: stringDate) ?? Date()
        
        return "Access Token: \(newDate.toString(format: "dd-MM-yy HH:mm:ss"))"
    }
    
    static var isAccessTokenExpired: Bool {
        let date = getAccessTokenExpirationDate()
        return date.isExpired
    }
}
