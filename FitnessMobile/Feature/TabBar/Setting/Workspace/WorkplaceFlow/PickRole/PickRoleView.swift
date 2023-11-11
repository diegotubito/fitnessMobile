//
//  PickRoleView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 20/09/2023.
//

import SwiftUI

struct PickRoleView: View {
    @StateObject var viewmodel: PickRoleViewModel
    @EnvironmentObject var settingCoordinator: SettingCoordinator
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("_PICK_ROLE_TITLE")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Text("_PICK_ROLE_SUBTITLE")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                .padding(.bottom)
                
                HStack {
                    Text("_PICK_ROLE_SELECT_TITLE")
                    Spacer()
                    Picker("", selection: $viewmodel.selectedRole) {
                        ForEach(WorkspaceModel.Role.allCases, id: \.self) { value in
                            Text(value.rawValue)
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                
                BasicButton(title: "_PICK_ROLE_BUTTON_TITLE", style: .primary, isEnabled: .constant(true)) {
                    viewmodel.sendInvitation()
                }
                .padding(.bottom, 32)
                
                Spacer()
                
            }
            .padding()
        }
        .onReceive(viewmodel.$sendInvitationSuccess, perform: { success in
            if success {
                settingCoordinator.path.removeLast(2)
            }
        })
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
}
