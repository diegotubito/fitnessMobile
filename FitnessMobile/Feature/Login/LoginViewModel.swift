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

                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    @MainActor
    func loadUsers() async {
        let usecase = UserUseCase()
        do {
            let response = try await usecase.getUsers()
            self.users = response.users
        } catch {
            self.handleError(error: error)
        }
    }
}
