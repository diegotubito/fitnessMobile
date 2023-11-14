//
//  DefaultWorkspace.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import Foundation

class DefaultWorkspace {
    static let shared = DefaultWorkspace()
    
    static private let defaultWorkspaceKey = "defaultWorkspaceKey"
    
    static func setDefaultWorkspace(id: String) {
        do {
            let data = try JSONEncoder().encode(id)
            _ = KeychainManager.save(key: defaultWorkspaceKey, data: data)
        } catch {
            print("could not encode value")
        }
    }
    
    static func getDefaultWorkspaceId() -> String {
        guard let data = KeychainManager.load(key: defaultWorkspaceKey) else {
            return ""
        }
        
        do {
            let _id = try JSONDecoder().decode(String.self, from: data)
            return _id
        } catch {
            print("could not decode value")
            return ""
        }
    }
    
    static func removeDefaultWorkspace() {
        _ = KeychainManager.delete(key: defaultWorkspaceKey)
    }
    
    static func hasDefaultWorkspace() -> Bool {
        return !getDefaultWorkspaceId().isEmpty
    }
}
