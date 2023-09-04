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
}
