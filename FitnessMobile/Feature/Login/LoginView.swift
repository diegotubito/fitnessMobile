//
//  LoginView.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewmodel = LoginViewModel()
    @State var showAlert = false
    @EnvironmentObject var userSession: UserSessionManager
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
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
        .overlay(content: {
            if viewmodel.isLoading {
                ProgressView()
            }
        })
        .onAppear {
            viewmodel.loadUsers()
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
