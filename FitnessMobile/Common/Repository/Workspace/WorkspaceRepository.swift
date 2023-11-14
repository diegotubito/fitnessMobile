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
    typealias Delete = WorkspaceEntity.Delete.Response
    typealias DeleteMember = WorkspaceEntity.DeleteMember.Response
    typealias DeleteLocation = WorkspaceEntity.DeleteLocation.Response
    typealias Find = WorkspaceEntity.Find.Response
    typealias DocumentPush = WorkspaceEntity.Document.Push.Response
    typealias DocumentDelete = WorkspaceEntity.Document.Delete.Response
}

protocol WorkspaceRepositoryProtocol {
    func getWorkspace(request: WorkspaceEntity.Find.Request) async throws -> WorkspaceResults.Find
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById
    func createWorkspace(request: WorkspaceEntity.Create.Request) async throws -> WorkspaceResults.Create
    func updateWorkspace(request: WorkspaceEntity.Update.Request) async throws -> WorkspaceResults.Update
    func updateWorkspaceAddress(request: WorkspaceEntity.UpdateAddress.Request) async throws -> WorkspaceResults.UpdateAddress
    func deleteWorkspace(request: WorkspaceEntity.Delete.Request) async throws -> WorkspaceResults.Delete
    func deleteWorkspaceMember(request: WorkspaceEntity.DeleteMember.Request) async throws -> WorkspaceResults.DeleteMember
    func deleteWorkspaceLocation(request: WorkspaceEntity.DeleteLocation.Request) async throws -> WorkspaceResults.DeleteLocation
    func addDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush
    func removeDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete
    func updateWorkspaceDefaultImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush
    func updateWorkspaceDefaultBackgroundImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush
    func pushWorkspaceImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush
    func pullWorkspaceImage(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete
}

class WorkspaceRepository: ApiNetworkAsync, WorkspaceRepositoryProtocol {
    func getWorkspace(request: WorkspaceEntity.Find.Request) async throws -> WorkspaceResults.Find {
        config.path = "/api/v1/workspace"
        config.addQueryItem(key: "_id", value: request._id)
        config.method = .get
        
        return try await apiCall()
    }
    
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
    
    func deleteWorkspace(request: WorkspaceEntity.Delete.Request) async throws -> WorkspaceResults.Delete {
        config.path = "/api/v1/workspace"
        config.method = .delete
        config.addQueryItem(key: "_id", value: request._id)
        
        return try await apiCall()
    }
    
    func deleteWorkspaceLocation(request: WorkspaceEntity.DeleteLocation.Request) async throws -> WorkspaceResults.DeleteLocation {
        config.path = "/api/v1/workspace-delete-location"
        config.method = .delete
        config.addQueryItem(key: "_id", value: request._id)
        
        return try await apiCall()
    }
    
    func deleteWorkspaceMember(request: WorkspaceEntity.DeleteMember.Request) async throws -> WorkspaceResults.DeleteMember {
        config.path = "/api/v1/workspace-delete-member"
        config.method = .delete
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func addDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        config.path = "/api/v1/add-document-workspace"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func removeDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete {
        config.path = "/api/v1/add-document-workspace"
        config.method = .delete
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func updateWorkspaceDefaultImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        config.path = "/api/v1/workspace/default-image"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func updateWorkspaceDefaultBackgroundImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        config.path = "/api/v1/workspace/default-background-image"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func pushWorkspaceImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        config.path = "/api/v1/workspace/image"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func pullWorkspaceImage(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete {
        config.path = "/api/v1/workspace/image"
        config.method = .delete
        config.addRequestBody(request)
        
        return try await apiCall()
    }
}

class WorkspaceRepositoryMock: ApiNetworkMockAsync, WorkspaceRepositoryProtocol {
    var fileName: String
    var isSuccess: Bool
    
    init(fileName: String, isSuccess: Bool) {
        self.fileName = fileName
        self.isSuccess = isSuccess
        super.init()
        mockFileName = fileName
        success = isSuccess
    }
    
    func getWorkspace(request: WorkspaceEntity.Find.Request) async throws -> WorkspaceResults.Find {
        return try await apiCallMocked(bundle: Bundle.main)
    }
   
    func getWorkspacesByUserId(request: WorkspaceEntity.FindByUserId.Request) async throws -> WorkspaceResults.FindById {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func createWorkspace(request: WorkspaceEntity.Create.Request) async throws -> WorkspaceResults.Create {
        return try await apiCallMocked(bundle: Bundle.main)
    }

    func updateWorkspace(request: WorkspaceEntity.Update.Request) async throws -> WorkspaceResults.Update {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func updateWorkspaceAddress(request: WorkspaceEntity.UpdateAddress.Request) async throws -> WorkspaceResults.UpdateAddress {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func deleteWorkspace(request: WorkspaceEntity.Delete.Request) async throws -> WorkspaceResults.Delete {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func deleteWorkspaceLocation(request: WorkspaceEntity.DeleteLocation.Request) async throws -> WorkspaceResults.DeleteLocation {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func deleteWorkspaceMember(request: WorkspaceEntity.DeleteMember.Request) async throws -> WorkspaceResults.DeleteMember {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func addDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func removeDocumentUrlToWorkspace(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func updateWorkspaceDefaultImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func updateWorkspaceDefaultBackgroundImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func pushWorkspaceImage(request: WorkspaceEntity.Document.Push.Request) async throws -> WorkspaceResults.DocumentPush {
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func pullWorkspaceImage(request: WorkspaceEntity.Document.Delete.Request) async throws -> WorkspaceResults.DocumentDelete {
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class WorkspaceRepositoryFactory {
    static func create() -> WorkspaceRepositoryProtocol {
        return WorkspaceRepository()
    }
}
