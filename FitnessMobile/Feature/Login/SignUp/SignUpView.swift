//
//  SignUp.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @FocusState var currentFocus: Focus?
    
    enum Focus {
        case username
        case email
        case password
        case repeatPassword
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                CustomTextField(customTextFieldManager: viewModel.usernameTextFieldManager, title: "_USERNAME", placeholder: "", footer: "") { newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                .padding(.bottom)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .focused($currentFocus, equals: .username)
                
                
                CustomTextField(customTextFieldManager: viewModel.emailTextFieldManager, title: "_EMAIL", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .email)
                
                CustomTextField(customTextFieldManager: viewModel.passwordTextFieldManager, title: "_PASSWORD", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .password)
                
                CustomTextField(customTextFieldManager: viewModel.repeatPasswordTextFieldManager, title: "_PASSWORD_REPEAT", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom, 32)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .repeatPassword)
                
                PhoneTextField(textFieldManager: $viewModel.phoneNumberTextField) { newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom, 32)
                    .onTapGesture {
                        print("si tapped")
                    }
                
                BasicButton(title: "_CREATE", style: .primary, isEnabled: .constant(viewModel.createButtonIsEnabled)) {
                    viewModel.createUser { result in
                        if result != nil {
                            coordinator.path.removeLast()
                        } else {
                            coordinator.presentPrimaryAlert(title: viewModel.errorTitle, message: viewModel.errorMessage) {
                                
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("_SIGNUP")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
