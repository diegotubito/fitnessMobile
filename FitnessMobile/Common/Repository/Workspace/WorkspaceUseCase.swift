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
}

