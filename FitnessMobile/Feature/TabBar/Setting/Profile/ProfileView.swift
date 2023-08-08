//
//  AccountView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 07/08/2023.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewmodel = ProfileViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var userSession: UserSessionManager
    
    var body: some View {
        
        VStack {
            ProfileHeader()

            ScrollView {
                
                VStack {
                    CustomTextField(customTextFieldManager: viewmodel.firstNameTextField, title: "First name", placeholder: "", footer: "", textFieldType: .ascii) { newValue in
                        viewmodel.validate()
                    } onDidBegin: { didBegin in
                        if didBegin {
                            viewmodel.firstNameTextField.shouldShowError = false
                        } else {
                            if !viewmodel.isValidFirstName {
                                viewmodel.firstNameTextField.showError(message: "Must not be empty.")
                            }
                        }
                    }
                    .padding(.bottom, 8)
                
                    CustomTextField(customTextFieldManager: viewmodel.lastNameTextField, title: "Last name", placeholder: "", footer: ""){ newValue in
                        viewmodel.validate()
                    } onDidBegin: { didBegin in
                        if didBegin {
                            viewmodel.lastNameTextField.shouldShowError = false
                        } else {
                            if !viewmodel.isValidLastName {
                                viewmodel.lastNameTextField.showError(message: "Must not be empty.")
                            }
                        }
                    }
                    .padding(.bottom, 8)

                    CustomTextField(customTextFieldManager: viewmodel.phoneNumberTextField, title: "Phone number", placeholder: "", footer: "", textFieldType: .phoneNumber) { newValue in
                        viewmodel.validate()
                    } onDidBegin: { didBegin in
                        if didBegin {
                            viewmodel.phoneNumberTextField.shouldShowError = false
                        } else {
                            if !viewmodel.isValidPhoneNumber {
                                viewmodel.phoneNumberTextField.showError(message: "The format is not correct.")
                            }
                        }
                    }
                    .padding(.bottom, 8)

                }
                BasicButton(title: "Update", style: .primary, isEnabled: .constant(viewmodel.updateButtonValueIsEnabled)) {
                    
                    viewmodel.updateUser { response in
                        if let response = response {
                            let token = userSession.getToken()
                            userSession.saveUser(user: response.user, token: token ?? "")
                            coordinator.path.removeLast()
                        } else {
                            coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {
                                
                            }
                        }
                    }
                }
                .padding()
            }
            .padding()
            .onAppear {
                setupInitValues()
            }
        }
    }
    
    func setupInitValues() {
        if let user = UserSessionManager().getUserSession()?.user {
            viewmodel.firstNameTextField.text = user.firstName
            viewmodel.lastNameTextField.text = user.firstName
            viewmodel.phoneNumberTextField.text = user.phoneNumber
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
