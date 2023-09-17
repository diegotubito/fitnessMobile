//
//  WorkspaceRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct WorkspaceResults {
    typealias FindById = WorkspaceEntity.FindByUserId.response
    typealias Create = WorkspaceEntity.Create.Response
    typealias Update = WorkspaceEntity.Update.Response
    typealias UpdateAddress = WorkspaceEntity.UpdateAddress.Response
}

protocol WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById
    func createWorkspace(request: WorkspaceEntity.Create.Request) async throws -> WorkspaceResults.Create
    func updateWorkspace(request: WorkspaceEntity.Update.Request) async throws -> WorkspaceResults.Update
    func updateWorkspaceAddress(request: WorkspaceEntity.UpdateAddress.Request) async throws -> WorkspaceResults.UpdateAddress
}

class WorkspaceRepository: ApiNetworkAsync, WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById {
        config.path = "/api/v1/workspace-by-user-id"
        config.method = .get
        config.addQueryItem(key: "userId", value: request.userId)
        
        return try await apiCall()
    }
    
    func createWorkspace(request: WorkspaceEntity.Create.Request) async throws -> WorkspaceResults.Create {
        config.path = "/api/v1/workspace"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func updateWorkspace(request: WorkspaceEntity.Update.Request) async throws -> WorkspaceResults.Update {
        config.path = "/api/v1/workspace"
        config.addQueryItem(key: "_id", value: request._id)
        config.method = .put
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func updateWorkspaceAddress(request: WorkspaceEntity.UpdateAddress.Request) async throws -> WorkspaceResults.UpdateAddress {
        config.path = "/api/v1/workspace/update-address"
        config.addQueryItem(key: "_id", value: request._id)
        config.method = .put
        config.addRequestBody(request)
        
        return try await apiCall()
    }
}

class WorkspaceRepositoryMock: ApiNetworkMockAsync, WorkspaceRepositoryProtocol {
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById {
        mockFileName = "load_workspace_by_id_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func createWorkspace(request: WorkspaceEntity.Create.Request) async throws -> WorkspaceResults.Create {
        mockFileName = ""
        return try await apiCallMocked(bundle: Bundle.main)
    }

    func updateWorkspace(request: WorkspaceEntity.Update.Request) async throws -> WorkspaceResults.Update {
        mockFileName = ""
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func updateWorkspaceAddress(request: WorkspaceEntity.UpdateAddress.Request) async throws -> WorkspaceResults.UpdateAddress {
        mockFileName = ""
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class WorkspaceRepositoryFactory {
    static func create() -> WorkspaceRepositoryProtocol {
        return WorkspaceRepository()
    }
}
