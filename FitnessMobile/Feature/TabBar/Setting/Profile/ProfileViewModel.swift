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
    @Published var phoneNumberTextField = CustomTextFieldManager()
    @Published var updateButtonValueIsEnabled = false
    
    @Published var isLoading = false
    @Published var showAlert = false
    
    func convertToNumber(phone: String) -> String {
        return phone.filter { "0123456789".contains($0) }
    }
    
    func updateUser(completion: @escaping (UpdateUserResult?) -> Void) {
        let usecase = UserUseCase()
        isLoading = true
        updateButtonValueIsEnabled = false
        Task {
            do {
                let phoneNumber = convertToNumber(phone: phoneNumberTextField.text)
                let response = try await usecase.doUpdate(firstName: firstNameTextField.text.trimmedAndSingleSpaced(),
                                                          lastName: lastNameTextField.text.trimmedAndSingleSpaced(),
                                                          phoneNumber: phoneNumber)
                DispatchQueue.main.async {
                    self.updateButtonValueIsEnabled = true
                    self.isLoading = false
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.updateButtonValueIsEnabled = true
                    self.showAlert = true
                    self.isLoading = false
                    self.handleError(error: error)
                    completion(nil)
                }
            }
        }
    }
    
    var isValidFirstName: Bool {
        // Check if the first name is not empty
        return !firstNameTextField.text.isEmpty
    }
    
    var isValidLastName: Bool {
        // Check if the last name is not empty
        return !lastNameTextField.text.isEmpty
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
        updateButtonValueIsEnabled = isValid
    }
}
