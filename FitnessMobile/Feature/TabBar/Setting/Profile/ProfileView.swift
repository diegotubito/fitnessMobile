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
    @State var shouldGoToOTP = false
    @State var otpResult: OTPView.OPTResult = .none
   
    var body: some View {
        
        VStack {
            ProfileHeader()

            ScrollView {
                
                VStack {
                    CustomTextField(customTextFieldManager: viewmodel.firstNameTextField, title: "_FIRST_NAME", placeholder: "", footer: "", textFieldType: .ascii) { newValue in
                        viewmodel.validate()
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
                        viewmodel.validate()
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
            
                BasicButton(title: "_UPDATE_BUTTON", style: .primary, isEnabled: .constant(viewmodel.updateButtonValueIsEnabled)) {
                    shouldGoToOTP = true
                }
                .padding()
            }
            .navigationDestination(isPresented: $shouldGoToOTP, destination: {
                OTPView(optResult: $otpResult)
                
            })
            .padding()
            .onAppear {
                
                switch otpResult {
                case .none:
                    viewmodel.setupInitValues()
                case .otpBackButton:
                    break
                case .otpSuccess:
                    updateUser()
                case .optFailed:
                    break
                }
            }
        }        
    }
    
    func updateUser() {
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
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
