//
//  SignUp.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject var viewmodel = SignUpViewModel()
    @FocusState var currentFocus: Focus?
    @Environment(\.dismiss) var dismiss
    
    enum Focus {
        case username
        case email
        case password
        case repeatPassword
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                CustomTextField(customTextFieldManager: viewmodel.usernameTextFieldManager, title: "_USERNAME", placeholder: "", footer: "") { newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                .padding(.bottom)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .focused($currentFocus, equals: .username)
                
                
                CustomTextField(customTextFieldManager: viewmodel.emailTextFieldManager, title: "_EMAIL", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .email)
                
                CustomTextField(customTextFieldManager: viewmodel.passwordTextFieldManager, title: "_PASSWORD", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .password)
                
                CustomTextField(customTextFieldManager: viewmodel.repeatPasswordTextFieldManager, title: "_PASSWORD_REPEAT", placeholder: "", footer: ""){ newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom, 32)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($currentFocus, equals: .repeatPassword)
                
                PhoneTextField(textFieldManager: $viewmodel.phoneNumberTextField) { newValue in
                    
                } onDidBegin: { didBegin in
                    
                }
                    .padding(.bottom, 32)
                    .onTapGesture {
                        print("si tapped")
                    }
                
                BasicButton(title: "_CREATE", style: .primary, isEnabled: .constant(true)) {
                    viewmodel.createUser()
                }
            }
            .padding()
        }
        .navigationTitle("_SIGNUP")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(viewmodel.$response, perform: { response in
            if response != nil {
                dismiss()
            }
        })
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
