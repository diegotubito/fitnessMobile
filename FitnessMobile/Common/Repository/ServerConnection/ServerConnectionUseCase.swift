//
//  ServerConnectionUseCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import Foundation

protocol ServerConnectionUseCaseProtocol {
    init(repository: ServerConnectionProtocol)
    func isConnected() async throws -> ServerConnectionResult
}

class ServerConnectionUseCase: ServerConnectionUseCaseProtocol {
    var repository: ServerConnectionProtocol
    
    required init(repository: ServerConnectionProtocol = ServerConnection()) {
        self.repository = repository
    }
    func isConnected() async throws -> ServerConnectionResult {
        return try await repository.isConnected()
    }
}
