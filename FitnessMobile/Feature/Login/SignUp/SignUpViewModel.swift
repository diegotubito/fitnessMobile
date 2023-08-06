//
//  SignUpViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var usernameTextFieldManager = CustomTextFieldManager()
    @Published var emailTextFieldManager = CustomTextFieldManager()
    @Published var passwordTextFieldManager = CustomTextFieldManager()
    @Published var repeatPasswordTextFieldManager = CustomTextFieldManager()
    
    @Published var createButtonIsEnabled = true

    func doSighUp(completion: @escaping (CreateUserResult?) -> Void) {
        let usecase = UserUseCase()
        
        Task {
            do {
                let response = try await usecase.doCreate(username: usernameTextFieldManager.text, email: emailTextFieldManager.text, password: passwordTextFieldManager.text)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
