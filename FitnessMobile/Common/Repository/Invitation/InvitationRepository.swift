//
//  InvitationRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct InvitationResult {
    typealias ByUserId = InvitationEntity.GetByUserId.Response
    typealias ByWorkspace = InvitationEntity.ByWorkspace.Response
    typealias SendInvitation = InvitationEntity.SendInvitation.Response
    typealias DeleteById = InvitationEntity.DeleteInvitation.Response
}

protocol InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId
    func getInvitationsByWorkspace(request: InvitationEntity.ByWorkspace.Request) async throws -> InvitationResult.ByWorkspace
    func sendInvitation(request: InvitationEntity.SendInvitation.Request) async throws -> InvitationResult.SendInvitation
    func deleteInvitationById(request: InvitationEntity.DeleteInvitation.Request) async throws -> InvitationResult.DeleteById
}

class InvitationRepository: ApiNetworkAsync, InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId {
        config.path = "/api/v1/invitation-by-user"
        config.method = .get
        config.addQueryItem(key: "userId", value: request.userId)
        
        return try await apiCall()
    }
    
    func getInvitationsByWorkspace(request: InvitationEntity.ByWorkspace.Request) async throws -> InvitationResult.ByWorkspace {
        config.path = "/api/v1/invitation-by-workspace"
        config.method = .get
        config.addQueryItem(key: "workspaceId", value: request.workspaceId)
        
        return try await apiCall()
    }
    
    func sendInvitation(request: InvitationEntity.SendInvitation.Request) async throws -> InvitationResult.SendInvitation {
        config.path = "/api/v1/invitation"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func deleteInvitationById(request: InvitationEntity.DeleteInvitation.Request) async throws -> InvitationResult.DeleteById {
        config.path = "/api/v1/invitation"
        config.method = .delete
        config.addQueryItem(key: "_id", value: request._id)
        
        return try await apiCall()
    }
}

class InvitationRepositoryMock: ApiNetworkMockAsync ,InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId {
        mockFileName = "invitation_mock_success_response"
        return try await apiCallMocked(bundle: .main)
    }
    
    func getInvitationsByWorkspace(request: InvitationEntity.ByWorkspace.Request) async throws -> InvitationResult.ByWorkspace {
        mockFileName = ""
        return try await apiCallMocked(bundle: .main)
    }
    
    func sendInvitation(request: InvitationEntity.SendInvitation.Request) async throws -> InvitationResult.SendInvitation {
        mockFileName = ""
        return try await apiCallMocked(bundle: .main)
    }
    
    func deleteInvitationById(request: InvitationEntity.DeleteInvitation.Request) async throws -> InvitationResult.DeleteById {
        mockFileName = ""
        return try await apiCallMocked(bundle: .main)
    }
}

class InvitationRepositoryFactory {
    static func create() -> InvitationRepositoryProtocol {
        return InvitationRepository()
    }
}
