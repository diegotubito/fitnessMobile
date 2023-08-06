//
//  LoginViewModel.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username: String = "diegodavid@icloud.com"
    @Published var password: String = "admin1234"

    @MainActor
    func doLogin(completion: @escaping (LoginEntity.Response?) -> Void) {
        let loginUseCase = LoginUseCase()
        let input = LoginEntity.Input(email: username, password: password)
        
        Task {
            do {
                let response = try await loginUseCase.doLogin(input: input)
                completion(response)
            } catch {
                completion(nil)
            }
        }
    }
}
