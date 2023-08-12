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
    
    @Published var createButtonIsEnabled = true
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false

    func createUser(completion: @escaping (CreateUserResult?) -> Void) {
        let usecase = UserUseCase()
        isLoading = true
        createButtonIsEnabled = false
        Task {
            do {

                let response = try await usecase.doCreate(username: usernameTextFieldManager.text.trimmedAndSingleSpaced(),
                                                          email: emailTextFieldManager.text.trimmedAndSingleSpaced(),
                                                          password: passwordTextFieldManager.text,
                                                          phone: phoneNumberTextField.phone)
                DispatchQueue.main.async {
                    self.createButtonIsEnabled = true
                    self.isLoading = false
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.createButtonIsEnabled = true
                    self.showAlert = true
                    self.isLoading = false
                    self.handleError(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    func getPhone() -> Phone {
        let user = UserSessionManager().getUserSession()?.user
        let phone = Phone(countryName: user?.phone?.countryName ?? "",
                                                                        number: user?.phone?.number ?? "",
                                                                        phoneCode: user?.phone?.phoneCode ?? "",
                                                                        countryCode: user?.phone?.countryCode ?? "")
        return phone
    }
}
