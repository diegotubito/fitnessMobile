//
//  LoginView.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewmodel = LoginViewModel()
    @State var showAlert = false
    @EnvironmentObject var userSession: UserSessionManager
    @EnvironmentObject var coordinator: Coordinator
    
    @State var shouldGoToOTP = false
    @State var otpResult: OTPView.OPTResult = .none
    
    var allowSighUp: Bool
    
    var body: some View {
        VStack {
            TextField("_USERNAME", text: $viewmodel.username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            SecureField("_PASSWORD", text: $viewmodel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            BasicButton(title: "Login", style: .primary, isEnabled: .constant(viewmodel.loginButtonEnabled)) {
                perfomrLogin()
            }
            .padding()
            
            if !allowSighUp {
                Button {
                    coordinator.push(.signUp)
                } label: {
                    Text("_SIGNUP")
                }
            }
            
            List(viewmodel.users, id: \.self) { user in
                VStack {
                    Text(user.email)
                }
                .onTapGesture {
                    self.viewmodel.username = user.email
                    self.viewmodel.password = "admin1234"
                }
            }
            
        }
        .padding()
        .overlay(content: {
            if viewmodel.isLoading {
                ProgressView()
            }
        })
        .onAppear(perform: {
            userSession.removeUserSession()
            Task {
                await viewmodel.loadUsers()
            }
        })
        .navigationTitle("_LOGIN_TITLE")
        .onChange(of: shouldGoToOTP, perform: { newValue in
            switch otpResult {
            case .none, .enableConfirmed:
                break
            case .otpBackButton:
                break
            case .otpSuccess:
                closeLoginView()
            case .otpBackButtonWithFailure:
                break
            }
        })
        .sheet(isPresented: $shouldGoToOTP, content: {
            OTPView(optResult: $otpResult)

        })
        
    }
    
    func perfomrLogin() {
        viewmodel.doLogin(completion: { response in
            DispatchQueue.main.async {
                if let response = response {
                    userSession.saveUser(user: response.user, token: response.token, tempToken: response.tempToken)
                    if response.user.twoFactorEnabled {
                        shouldGoToOTP = true
                        return
                    }
                    closeLoginView()
                } else {
                    coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {
                    }
                }
            }
        })
    }
    
    func closeLoginView() {
        coordinator.closeModal()
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            LoginView(allowSighUp: true)
        }.environmentObject(coordinator)
    }
}
