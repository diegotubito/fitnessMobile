//
//  LoginViewModel.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import Foundation

class LoginViewModel: BaseViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    
    @MainActor
    func doLogin(completion: @escaping (LoginEntity.Response?) -> Void) {
        let loginUseCase = LoginUseCase()
        let input = LoginEntity.Input(email: username, password: password)
        isLoading = true
        Task {
            do {
                let response = try await loginUseCase.doLogin(input: input)
                isLoading = false
                completion(response)
            } catch {
                isLoading = false
                handleError(error: error)
                completion(nil)
            }
        }
    }
    
    @MainActor
    func loadUsers() {
        let usecase = UserUseCase()
        Task {
            do {
                let response = try await usecase.getUsers()
                self.users = response.users
            } catch {
                self.handleError(error: error)
            }
        }
    }
}
