//
//  LoginUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 29/04/2023.
//

import Foundation

protocol LoginUseCaseProtocol {
    init(repository: LoginRepositoryProtocol)
    func doLogin(input: LoginEntity.Input) async throws -> LoginResult
    func doRefresh() async throws -> RefreshResult
}

class LoginUseCase: LoginUseCaseProtocol {
    var repository: LoginRepositoryProtocol
    
    required init(repository: LoginRepositoryProtocol = LoginRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func doLogin(input: LoginEntity.Input) async throws -> LoginResult {
        let request = LoginEntity.Request(email: input.email, password: input.password)
        return try await repository.doLogin(request: request)
    }
    
    func doRefresh() async throws -> RefreshResult {
        return try await repository.refreshAccessToken()
    }
}

