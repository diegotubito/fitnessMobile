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
   
    var body: some View {
        
        VStack {
            ProfileHeader()

            ScrollView {
                
                VStack {
                    CustomTextField(customTextFieldManager: viewmodel.firstNameTextField, title: "_FIRST_NAME", placeholder: "", footer: "", textFieldType: .ascii) { newValue in
                        
                    } onDidBegin: { didBegin in
                        if didBegin {
                            viewmodel.firstNameTextField.shouldShowError = false
                        } else {
                            if !viewmodel.isValidFirstName {
                                viewmodel.firstNameTextField.showError(message: "_FIRST_NAME_INCORRECT")
                            }
                        }
                    }
                    .padding(.bottom, 8)
                
                    CustomTextField(customTextFieldManager: viewmodel.lastNameTextField, title: "_LAST_NAME", placeholder: "", footer: ""){ newValue in
                        
                    } onDidBegin: { didBegin in
                        if didBegin {
                            viewmodel.lastNameTextField.shouldShowError = false
                        } else {
                            if !viewmodel.isValidLastName {
                                viewmodel.lastNameTextField.showError(message: "_LAST_NAME_INCORRECT")
                            }
                        }
                    }
                    .padding(.bottom, 8)
                 
                    PhoneTextField(textFieldManager: $viewmodel.phoneNumberTextField) { newValue in
                        
                    } onDidBegin: { didBegin in
                        
                    }

                }
            
                BasicButton(title: "_UPDATE_BUTTON", style: .primary, isEnabled: .constant(viewmodel.isValid)) {
                    updateUser()
                }
                .padding()
            }
            .padding()
        }
        .onReceive(viewmodel.$updateUserResult, perform: { result in
            if let result = result {
                UserSession.saveUser(user: result.user)
                coordinator.path.removeLast()
            }
        })
        .onAppear {
            viewmodel.setupInitValues()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
    
    func updateUser() {
        viewmodel.updateUser()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
