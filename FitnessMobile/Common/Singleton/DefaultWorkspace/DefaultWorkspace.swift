//
//  DefaultWorkspace.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import Foundation

class DefaultWorkspace {
    static let shared = DefaultWorkspace()
    
    static private let workspacesKey = "workspacesKey"
    static private let defaultWorkspaceKey = "defaultWorkspaceKey"

    static func saveWorkspaces(workspaces: [WorkspaceModel]) {
        do {
            let data = try JSONEncoder().encode(workspaces)
            _ = KeychainManager.save(key: workspacesKey, data: data)
        } catch {
            print("Error encoding workspaces: \(error.localizedDescription)")
        }
    }
    
    static func getWorkspaces() -> [WorkspaceModel] {
        do {
            if let data = KeychainManager.load(key: workspacesKey) {
                let workspaces = try JSONDecoder().decode([WorkspaceModel].self, from: data)
                return workspaces
            }
            return []
        } catch {
            return []
        }
    }
    
    static func saveDefaultWorkspace(workspace: WorkspaceModel) {
        do {
            let data = try JSONEncoder().encode(workspace)
            _ = KeychainManager.save(key: defaultWorkspaceKey, data: data)
        } catch {
            print("Error encoding workspace: \(error.localizedDescription)")
        }
    }
    
    static func getDefaultWorkspace() -> WorkspaceModel? {
        do {
            if let data = KeychainManager.load(key: defaultWorkspaceKey) {
                let workspace = try JSONDecoder().decode(WorkspaceModel.self, from: data)
                return workspace
            }
            return nil
        } catch {
            return nil
        }
    }
    
}
