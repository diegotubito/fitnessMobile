//
//  UserSessionManager.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import SwiftUI

struct UserSessionModel: Codable {
    let user: User
    let token: String
}

class UserSessionManager: ObservableObject {
    private let userSessionKey = "UserSessionKey"
    private let deviceTokenKey = "DeviceToken"
    @Published var didLogOut: Bool = false
    @Published var didLogIn: Bool = false
    
    init() {
        if getUserSession() == nil {
            didLogOut.toggle()
        }
    }
    
    func saveUser(user: User, token: String) {
        do {
            let userSession = UserSessionModel(user: user, token: token)
            let encoder = JSONEncoder()
            let data = try encoder.encode(userSession)
            _ = KeychainManager.shared.save(key: userSessionKey, data: data)
            didLogIn.toggle()
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
    
    func getToken() -> String? {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserSessionModel.self, from: data)
                return user.token
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func checkUser() {
        if getUserSession() == nil {
            didLogOut.toggle()
        }
    }
    
    func removeUserSession() {
        let _ = KeychainManager.shared.delete(key: userSessionKey)
        didLogOut.toggle()
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
}

