//
//  WorkspaceRepositorySync.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import Foundation

typealias WorkspaceRepositoryResultSync = (Result<WorkspaceResults.FindById, APIError>) -> Void

protocol WorkspaceRepositoryProtocolSync {
    func getWorkspace(completion: @escaping WorkspaceRepositoryResultSync)
}

class WorkspaceRepositorySync: ApiNetwork, WorkspaceRepositoryProtocolSync {
    func getWorkspace(completion: @escaping WorkspaceRepositoryResultSync) {
        config.path = "/api/v1/workspace"
        config.method = .get
        
        apiCall { result in
            completion(result)
        }
    }
}

class WorkspaceRepositoryMockSync: ApiNetworkMock, WorkspaceRepositoryProtocolSync {
    func getWorkspace(completion: @escaping WorkspaceRepositoryResultSync) {
        mockFileName = "load_workspace_by_id_response"
        apiCallMocked(bundle: .main) { result in
            completion(result)
        }
    }
}
