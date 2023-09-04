//
//  InvitationRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct InvitationResult {
    typealias ByUserId = InvitationEntity.GetByUserId.Response
}

protocol InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId
}

class InvitationRepository: ApiNetworkAsync, InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId {
        config.path = "/api/v1/invitation-by-user"
        config.method = .get
        config.addQueryItem(key: "userId", value: request.userId)
        
        return try await apiCall()
    }
}

class InvitationRepositoryMock: ApiNetworkMockAsync ,InvitationRepositoryProtocol {
    func getInvitationsByUserId(request: InvitationEntity.GetByUserId.Request) async throws -> InvitationResult.ByUserId {
        mockFileName = "invitation_mock_success_response"
        return try await apiCallMocked(bundle: .main)
    }
}

class InvitationRepositoryFactory {
    static func create() -> InvitationRepositoryProtocol {
        return InvitationRepository()
    }
}
