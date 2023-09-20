//
//  CreateInvitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 19/09/2023.
//

import SwiftUI

struct SearchUserForInvitationView: View {
    @StateObject var viewmodel: SearchUserForInvitationViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Invitar usuario")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                HStack {
                    Text("Busca un usuario con quien quieres compartir este ambiente de trabajo.")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                
                CustomTextField(customTextFieldManager: viewmodel.userTextField, title: "", placeholder: "", footer: "") { newString in
                    
                } onDidBegin: { didBegin in
                    
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                
                BasicButton(title: "Search", style: .primary, isEnabled: .constant(true)) {
                    viewmodel.fetchUsers()
                }
                .padding(.bottom, 32)
                
                Spacer()
                
                if !viewmodel.users.isEmpty {
                    HStack {
                        Text("Resultado de la busqueda.")
                            .font(.subheadline)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    List(viewmodel.users, id: \.self) { user in
                        VStack {
                            Text("\(user.email) (\(user.username))")
                        }
                        .onTapGesture {
                            coordinator.push(.pickRoleForInvitation(workspace: viewmodel.workspace, user: user))
                            
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .padding()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
}
