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
    
    @State var shouldReload = true
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    TextField("_USERNAME", text: $viewmodel.username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    SecureField("_PASSWORD", text: $viewmodel.password)
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
                        Text("_SIGNUP")
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
        .onAppear(perform: {
            if shouldReload {
                viewmodel.loadUsers()
                shouldReload = false
            }
        })
        .navigationTitle("_LOGIN_TITLE")
        
    }
    
    func perfomrLogin() {
        viewmodel.doLogin(completion: { response in
            DispatchQueue.main.async {
                if let response = response {
                    userSession.saveUser(user: response.user, token: response.token)
                } else {
                    coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {
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
