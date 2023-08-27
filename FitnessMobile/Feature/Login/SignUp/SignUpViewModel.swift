//
//  SignUpViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class SignUpViewModel: BaseViewModel {
    @Published var usernameTextFieldManager = CustomTextFieldManager()
    @Published var emailTextFieldManager = CustomTextFieldManager()
    @Published var passwordTextFieldManager = CustomTextFieldManager()
    @Published var repeatPasswordTextFieldManager = CustomTextFieldManager()
    @Published var phoneNumberTextField = PhoneNumberTextFieldManager()

    @Published var response: CreateUserResult?
    
    func createUser() {
        let usecase = UserUseCase()
        isLoading = true
        Task {
            do {
                let response = try await usecase.doCreate(username: usernameTextFieldManager.text.trimmedAndSingleSpaced(),
                                                          email: emailTextFieldManager.text.trimmedAndSingleSpaced(),
                                                          password: passwordTextFieldManager.text,
                                                          phone: phoneNumberTextField.phone)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.response = response
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    self.showError = true
                }
            }
        }
    }
}
