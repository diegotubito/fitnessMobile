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
                CustomTextField(customTextFieldManager: viewModel.usernameTextFieldManager, title: "Username", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                CustomTextField(customTextFieldManager: viewModel.emailTextFieldManager, title: "Email", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                CustomTextField(customTextFieldManager: viewModel.passwordTextFieldManager, title: "Password", placeholder: "", footer: "")
                    .padding(.bottom)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)

                CustomTextField(customTextFieldManager: viewModel.repeatPasswordTextFieldManager, title: "Repeat password", placeholder: "", footer: "")
                    .padding(.bottom, 32)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)


                BasicButton(title: "Create", style: .primary, isEnabled: .constant(viewModel.createButtonIsEnabled)) {
                    viewModel.doSighUp { result in
                        if result != nil {
                            coordinator.path.removeLast()
                        } else {
                            coordinator.presentPrimaryAlert(title: "Create", message: "Something went wrong") {
                                
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Sigh Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
