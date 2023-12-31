//
//  InvitationUseCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

protocol InvitationUseCaseProtocol {
    init(repository: InvitationRepositoryProtocol)
    func getInvitationsByUserId() async throws -> InvitationResult.ByUserId
    func getInvitationsByWorkspaceId(workspaceId: String) async throws -> InvitationResult.ByWorkspace
    func sendInvitation(workspace: String, user: String, role: String, host: String) async throws -> InvitationResult.SendInvitation
    func deleteInvitationById(_id: String) async throws -> InvitationResult.DeleteById
    func acceptInvitation(_id: String) async throws -> InvitationResult.AcceptInvitation
    func rejectInvitation(_id: String) async throws -> InvitationResult.RejectInvitation
}

class InvitationUseCase: InvitationUseCaseProtocol {
    var repository: InvitationRepositoryProtocol
    
    required init(repository: InvitationRepositoryProtocol = InvitationRepositoryFactory.create() ) {
        self.repository = repository
    }
    
    func getInvitationsByUserId() async throws -> InvitationResult.ByUserId {
        let request = InvitationEntity.GetByUserId.Request(userId: UserSession._id)
        return try await repository.getInvitationsByUserId(request: request)
    }
    
    func getInvitationsByWorkspaceId(workspaceId: String) async throws -> InvitationResult.ByWorkspace {
        let request = InvitationEntity.ByWorkspace.Request(workspaceId: workspaceId)
        return try await repository.getInvitationsByWorkspace(request: request)
    }
    
    func sendInvitation(workspace: String, user: String, role: String, host: String) async throws -> InvitationResult.SendInvitation {
        let request = InvitationEntity.SendInvitation.Request(user: user, workspace: workspace, role: role, host: host)
        return try await repository.sendInvitation(request: request)
    }
    
    func deleteInvitationById(_id: String) async throws -> InvitationResult.DeleteById {
        let request = InvitationEntity.DeleteInvitation.Request(_id: _id)
        return try await repository.deleteInvitationById(request: request)
    }
    
    func acceptInvitation(_id: String) async throws -> InvitationResult.AcceptInvitation {
        let request = InvitationEntity.AcceptInvitation.Request(_id: _id)
        return try await repository.acceptInvitation(request: request)
    }
    
    func rejectInvitation(_id: String) async throws -> InvitationResult.RejectInvitation {
        let request = InvitationEntity.RejectInvitation.Request(_id: _id)
        return try await repository.rejectInvitation(request: request)
    }
}
