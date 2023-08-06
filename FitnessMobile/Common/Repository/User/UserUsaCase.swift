//
//  UserUsaCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import Foundation

class UserUseCase {
    var repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }
    
    func doCreate(username: String, email: String, password: String) async throws -> CreateUserResult {
        let request = UserEntity.Create.Request(username: username,
                                                email: email,
                                                password: password,
                                                firstName: "",
                                                lastName: "",
                                                role: "ADMIN_ROLE",
                                                phoneNumber: 0,
                                                emailVerified: false)
        return try await repository.doCreate(request: request)
    }
    
    func deleteUser() async throws -> DeleteUserResult {
        return try await repository.deleteUser()
    }
    
    func getUsers() async throws -> GetUserResult {
        return try await repository.getUsers()
    }
}

