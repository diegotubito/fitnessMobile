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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userSession: UserSessionManager
    var body: some View {
        NavigationStack {
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
                    NavigationLink("Sign Up") {
                        SignUp()
                    }
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Something went wrong"), message: Text("el usuario o contraseña son incorrectos."))
                })
                .padding()
            }
            .navigationTitle("Login")
        }
    }
    
    func perfomrLogin() {
        viewmodel.doLogin(completion: { response in
            if let response = response {
                userSession.saveUser(user: response.user, token: response.token)
            } else {
                showAlert = true
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
