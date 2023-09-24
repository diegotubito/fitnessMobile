//
//  WorkspaceUseCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

protocol WorkspaceUseCaseProtocol {
    init(repository: WorkspaceRepositoryProtocol)
    func getWorkspacesBuUserId() async throws -> WorkspaceResults.FindById
    func createWorkspace(ownerId: String, title: String, subtitle: String) async throws -> WorkspaceResults.Create
    func updateWorkspace(workspaceId: String, title: String, subtitle: String) async throws -> WorkspaceResults.Update
    func updateWorkspaceAddress(workspaceId: String, location: WorkspaceModel.Location) async throws -> WorkspaceResults.UpdateAddress
    func deleteWorkspace(_id: String) async throws -> WorkspaceResults.Delete
    func deleteWorkspaceMember(workspace: String, user: String) async throws -> WorkspaceResults.DeleteMember
    func deleteWorkspaceLocation(_id: String) async throws -> WorkspaceResults.DeleteLocation
}

class WorkspaceUseCase: WorkspaceUseCaseProtocol {
    var repository: WorkspaceRepositoryProtocol
    required init(repository: WorkspaceRepositoryProtocol = WorkspaceRepositoryFactory.create() ) {
        self.repository = repository
    }
    
    func getWorkspacesBuUserId() async throws -> WorkspaceResults.FindById {
        let request = WorkspaceEntity.FindByUserId.Request(userId: UserSession._id)
        return try await repository.getWorkspacesByUserId(request: request)
    }

    func createWorkspace(ownerId: String, title: String, subtitle: String) async throws -> WorkspaceResults.Create {
        let request = WorkspaceEntity.Create.Request(owner: ownerId, title: title, subtitle: subtitle)
        return try await repository.createWorkspace(request: request)
    }
    
    func updateWorkspace(workspaceId: String, title: String, subtitle: String) async throws -> WorkspaceResults.Update {
        let request = WorkspaceEntity.Update.Request(_id: workspaceId, title: title, subtitle: subtitle)
        return try await repository.updateWorkspace(request: request)
    }
    
    func updateWorkspaceAddress(workspaceId: String, location: WorkspaceModel.Location) async throws -> WorkspaceResults.UpdateAddress {
        let request = WorkspaceEntity.UpdateAddress.Request(_id: workspaceId, location: location)
        return try await repository.updateWorkspaceAddress(request: request)
    }
    
    func deleteWorkspace(_id: String) async throws -> WorkspaceResults.Delete {
        let request = WorkspaceEntity.Delete.Request(_id: _id)
        return try await repository.deleteWorkspace(request: request)
    }
    
    func deleteWorkspaceMember(workspace: String, user: String) async throws -> WorkspaceResults.DeleteMember {
        let request = WorkspaceEntity.DeleteMember.Request(workspace: workspace, user: user)
        return try await repository.deleteWorkspaceMember(request: request)
    }
    
    func deleteWorkspaceLocation(_id: String) async throws -> WorkspaceResults.DeleteLocation {
        let request = WorkspaceEntity.DeleteLocation.Request(_id: _id)
        return try await repository.deleteWorkspaceLocation(request: request)
    }
}

