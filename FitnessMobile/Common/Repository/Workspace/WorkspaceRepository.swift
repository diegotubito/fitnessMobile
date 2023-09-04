//
//  WorkspaceRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct WorkspaceResults {
    typealias FindById = WorkspaceEntity.FindByUserId.response
}

protocol WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById
}

class WorkspaceRepository: ApiNetworkAsync, WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById {
        config.path = "/api/v1/workspace-by-user-id"
        config.method = .get
        config.addQueryItem(key: "userId", value: request.userId)
        
        return try await apiCall()
    }
}

class WorkspaceRepositoryMock: ApiNetworkMockAsync, WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById {
        mockFileName = "load_workspace_by_id_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class WorkspaceRepositoryFactory {
    static func create() -> WorkspaceRepositoryProtocol {
        return WorkspaceRepository()
    }
}
