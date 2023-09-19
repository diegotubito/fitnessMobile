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
}

protocol InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId
    func getInvitationsByWorkspace(request: InvitationEntity.ByWorkspace.Request) async throws -> InvitationResult.ByWorkspace
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
}

class InvitationRepositoryFactory {
    static func create() -> InvitationRepositoryProtocol {
        return InvitationRepository()
    }
}
