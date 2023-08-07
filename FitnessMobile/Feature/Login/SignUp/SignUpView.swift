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
    
    var body: some View {
        ScrollView {
            VStack {
                CustomTextField(customTextFieldManager: viewModel.usernameTextFieldManager, title: "_USERNAME", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                CustomTextField(customTextFieldManager: viewModel.emailTextFieldManager, title: "_EMAIL", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                CustomTextField(customTextFieldManager: viewModel.passwordTextFieldManager, title: "_PASSWORD", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)

                CustomTextField(customTextFieldManager: viewModel.repeatPasswordTextFieldManager, title: "_PASSWORD_REPEAT", placeholder: "", footer: "")
                    .padding(.bottom, 32)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)


                BasicButton(title: "_CREATE", style: .primary, isEnabled: .constant(viewModel.createButtonIsEnabled)) {
                    viewModel.doSighUp { result in
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
