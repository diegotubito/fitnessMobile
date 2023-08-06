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
    var body: some View {
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
                    perfomrLogin()
                }
                .padding()
                
                Button {
                    coordinator.push(.signUp)
                } label: {
                    Text("Sign Up")
                }
            }
            
            .padding()
        }
        .navigationTitle("Login")
        
    }
    
    func perfomrLogin() {
        viewmodel.doLogin(completion: { response in
            DispatchQueue.main.async {
                if let response = response {
                    userSession.saveUser(user: response.user, token: response.token)
                } else {
                    coordinator.presentPrimaryAlert(title: "Login Error", message: "wrong user/password") {
                        
                    }
                }
            }
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            LoginView()
        }.environmentObject(coordinator)
    }
}
