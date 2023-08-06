//
//  UserRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import Foundation
typealias CreateUserResult = UserEntity.Create.Response
typealias DeleteUserResult = Data
typealias GetUserResult = UserEntity.Get.Response

protocol UserRepositoryProtocol {
    func doCreate(request: UserEntity.Create.Request) async throws -> CreateUserResult
    func deleteUser() async throws -> DeleteUserResult
    func getUsers() async throws -> GetUserResult
}

class UserRepository: ApiNetworkAsync, UserRepositoryProtocol {
    func doCreate(request: UserEntity.Create.Request) async throws -> CreateUserResult {
        config.path = "/api/v1/user"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func deleteUser() async throws -> DeleteUserResult {
        config.path = "/api/v1/user"
        config.method = .delete
        config.addQueryItem(key: "_id", value: UserSessionManager().getUserSession()?.user._id ?? "")
        return try await apiCall()
    }
    
    func getUsers() async throws -> GetUserResult {
        config.path = "/api/v1/user"
        config.method = .get
        return try await apiCall()
    }
}