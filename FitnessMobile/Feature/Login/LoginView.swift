//
//  LoginView.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewmodel = LoginViewModel()
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        TextField("Username", text: $viewmodel.username)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        SecureField("Password", text: $viewmodel.password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        
                        BasicButton(title: "Login", style: .primary, isEnabled: .constant(true)) {
                            Task {
                                await viewmodel.doLogin()
                            }
                        }
                        .padding(.bottom)
                        NavigationLink("Sign Up") {
                            SignUp()
                        }
                        .padding(.bottom)
                       
                    }
                    .padding()
                }
            }
            .alert(isPresented: $viewmodel.showAlert) {
                Alert(title: Text(viewmodel.alertTitle),
                      message: Text(viewmodel.alertMessage),
                      dismissButton: .default(Text(viewmodel.alertButtonTitle)))
            }
            .navigationTitle("Login")
        }
        .onChange(of: viewmodel.onLoginSuccess) { success in
            if success {
                coordinator.closeModal()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
