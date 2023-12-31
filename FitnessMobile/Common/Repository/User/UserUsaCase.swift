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
    
    func doCreate(username: String, email: String, password: String, phone: Phone) async throws -> CreateUserResult {
        let request = UserEntity.Create.Request(username: username,
                                                email: email,
                                                password: password,
                                                firstName: "",
                                                lastName: "",
                                                role: "ADMIN_ROLE",
                                                phoneNumber: "",
                                                emailVerified: false,
                                                phone: UserEntity.RequestPhone(countryName: phone.countryName,
                                                                               number: phone.number,
                                                                               phoneCode: phone.phoneCode,
                                                                               countryCode: phone.countryCode))
        return try await repository.doCreate(request: request)
    }
    
    func doUpdate(firstName: String, lastName: String, phone: Phone) async throws -> UpdateUserResult {
        let request = UserEntity.Update.Request(firstName: firstName,
                                                lastName: lastName,
                                                phone: UserEntity.RequestPhone(countryName: phone.countryName,
                                                                   number: phone.number,
                                                                   phoneCode: phone.phoneCode,
                                                                   countryCode: phone.countryCode))
        return try await repository.doUpdate(request: request)
    }
    
    func setProfileImage(_id: String, documentId: String, creator: String, highResImage: SingleImageModel?, thumbnailImage: SingleImageModel?) async throws -> SetProfileImageResult {
        let request = UserEntity.SetProfileImage.Request(_id: _id,
                                                         documentId: documentId,
                                                         creator: creator,
                                                         highResImage: highResImage,
                                                         thumbnailImage: thumbnailImage)
        return try await repository.setProfileImage(request: request)
    }
    
    func deleteUser() async throws -> DeleteUserResult {
        return try await repository.deleteUser()
    }
    
    func getUsers() async throws -> GetUserResult {
        return try await repository.getUsers()
    }
    
    func getUsersByUsernameOrEmail(username: String) async throws -> GetUserByUserNameEmail {
        let request = UserEntity.GetByUserNameOrEmail.Request(username: username)
        return try await repository.getUsersByUserNameEmail(request: request)
    }
}

