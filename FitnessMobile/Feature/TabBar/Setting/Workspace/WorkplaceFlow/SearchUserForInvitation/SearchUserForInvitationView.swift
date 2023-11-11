//
//  CreateInvitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 19/09/2023.
//

import SwiftUI

struct SearchUserForInvitationView: View {
    @StateObject var viewmodel: SearchUserForInvitationViewModel
    @EnvironmentObject var settingCoordinator: SettingCoordinator
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("_INVITATION_SEARCH_USER_TITLE")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Text("_INVITATION_SEARCH_USER_SUBTITLE")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                
                CustomTextField(customTextFieldManager: viewmodel.userTextField, title: "", placeholder: "", footer: "") { newString in
                    
                } onDidBegin: { didBegin in
                    
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                
                BasicButton(title: "_INVITATION_SEARCH_USER_BUTTON_TITLE", style: .primary, isEnabled: .constant(true)) {
                    viewmodel.fetchUsers()
                }
                .padding(.bottom, 32)
                
                Spacer()
                
                if !viewmodel.users.isEmpty {
                    HStack {
                        Text("_INVITATION_SEARCH_USER_RESULT_TITLE")
                            .font(.subheadline)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    List(viewmodel.users, id: \.self) { user in
                        VStack {
                            Text("\(user.email) (\(user.username))")
                        }
                        .onTapGesture {
                            settingCoordinator.push(.pickRoleForInvitation(workspace: viewmodel.workspace, user: user))
                            
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
