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
typealias UpdateUserResult = UserEntity.Update.Response
typealias GetUserByUserNameEmail = UserEntity.GetByUserNameOrEmail.Response
typealias SetProfileImageResult = UserEntity.SetProfileImage.Response

protocol UserRepositoryProtocol {
    func doCreate(request: UserEntity.Create.Request) async throws -> CreateUserResult
    func deleteUser() async throws -> DeleteUserResult
    func getUsers() async throws -> GetUserResult
    func getUsersByUserNameEmail(request: UserEntity.GetByUserNameOrEmail.Request) async throws -> GetUserByUserNameEmail
    func doUpdate(request: UserEntity.Update.Request) async throws -> UpdateUserResult
    func setProfileImage(request: UserEntity.SetProfileImage.Request) async throws -> SetProfileImageResult
}

class UserRepository: ApiNetworkAsync, UserRepositoryProtocol {
    func doCreate(request: UserEntity.Create.Request) async throws -> CreateUserResult {
        config.path = "/api/v1/user"
        config.method = .post
        config.noTokenNeeded = true
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func doUpdate(request: UserEntity.Update.Request) async throws -> UpdateUserResult {
        config.path = "/api/v1/user"
        config.method = .put
        config.addQueryItem(key: "_id", value: UserSession.getUser()?._id ?? "")
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func deleteUser() async throws -> DeleteUserResult {
        config.path = "/api/v1/user"
        config.method = .delete
        config.addQueryItem(key: "_id", value: UserSession.getUser()?._id ?? "")
        return try await apiCall()
    }
    
    func getUsers() async throws -> GetUserResult {
        config.path = "/api/v1/user"
        config.method = .get
        config.noTokenNeeded = true
        return try await apiCall()
    }
    
    func getUsersByUserNameEmail(request: UserEntity.GetByUserNameOrEmail.Request) async throws -> GetUserByUserNameEmail {
        config.path = "/api/v1/user/byUsernameOrEmail"
        config.method = .get
        config.addQueryItem(key: "username", value: request.username)
        
        return try await apiCall()
    }
    
    func setProfileImage(request: UserEntity.SetProfileImage.Request) async throws -> SetProfileImageResult {
        config.path = "/api/v1/user/profile-image"
        config.method = .put
        config.addRequestBody(request)
        return try await apiCall()
    }
}
