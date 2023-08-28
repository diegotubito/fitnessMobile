//
//  ProfileViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 07/08/2023.
//

import SwiftUI

class ProfileViewModel: BaseViewModel {
    @Published var firstNameTextField = CustomTextFieldManager()
    @Published var lastNameTextField = CustomTextFieldManager()
    @Published var phoneNumberTextField = PhoneNumberTextFieldManager()
    @Published var updateUserResult: UpdateUserResult?
    @Published var disableSaveButton: Bool = true
    @Published var disableCancelButton: Bool = false

    private func getPhone() -> Phone {
        let user = UserSession.getUser()
        let phone = Phone(countryName: user?.phone?.countryName ?? "",
                                                                        number: user?.phone?.number ?? "",
                                                                        phoneCode: user?.phone?.phoneCode ?? "",
                                                                        countryCode: user?.phone?.countryCode ?? "")
        return phone
    }
    
    override init() {
        super .init()
        phoneNumberTextField.phone = getPhone()
    }
    
    func convertToNumber(phone: String) -> String {
        return phone.filter { "0123456789".contains($0) }
    }
    
    func setupInitValues() {
        if let user = UserSession.getUser() {
            firstNameTextField.text = user.firstName
            lastNameTextField.text = user.lastName
        }
    }
    
    func updateUser() {
        if !isValid { return }
        let usecase = UserUseCase()
        isLoading = true
        disableSaveButton = true
        disableCancelButton = true
        phoneNumberTextField.phone.number = convertToNumber(phone: phoneNumberTextField.text)
        Task {
            do {
                let response = try await usecase.doUpdate(firstName: firstNameTextField.text.trimmedAndSingleSpaced(),
                                                          lastName: lastNameTextField.text.trimmedAndSingleSpaced(),
                                                          phone: phoneNumberTextField.phone)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.updateUserResult = response
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error: error)
                    self.showError = true
                    self.isLoading = false
                    self.disableSaveButton = false
                    self.disableCancelButton = false
                }
            }
        }
    }
    
    var isValidFirstName: Bool {
        // Check if the first name is not empty
        return !firstNameTextField.text.isEmpty && firstNameTextField.text.count < 30
    }
    
    var isValidLastName: Bool {
        // Check if the last name is not empty
        return !lastNameTextField.text.isEmpty && firstNameTextField.text.count < 30
    }
    
    var isValidPhoneNumber: Bool {
        // Regex pattern to match the format (+XX) 113-593-7260
        let phoneRegex = "^\\(\\+[0-9]{2}\\) [0-9]{3}-[0-9]{3}-[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumberTextField.text)
    }
    
    // Computed property to check if all fields are valid
    var isValid: Bool {
        return isValidFirstName && isValidLastName
    }
    
    func validate() {
        disableSaveButton = !isValid
    }
}
