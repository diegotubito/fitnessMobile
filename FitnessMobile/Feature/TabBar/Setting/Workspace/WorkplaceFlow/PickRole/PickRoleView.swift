//
//  PickRoleView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 20/09/2023.
//

import SwiftUI

struct PickRoleView: View {
    @StateObject var viewmodel: PickRoleViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    enum Colores: String, CaseIterable {
        case admin = "Admin"
        case user = "User"
        case userReadOnly = "User Read Only"
    }
    
    @State private var selectedColor: Colores = .admin
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Privilegios")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                HStack {
                    Text("Selecciona el privilegio que tendrá el nuevo colaborador.")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                .padding(.bottom)
                
                HStack {
                    Text("Seleccione el privilegio")
                    Spacer()
                    Picker("", selection: $selectedColor) {
                        ForEach(Colores.allCases, id: \.self) { value in
                            Text(value.rawValue)
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                
                BasicButton(title: "Send Invitation", style: .primary, isEnabled: .constant(true)) {
                    viewmodel.sendInvitation()
                }
                .padding(.bottom, 32)
                
                Spacer()
                
            }
            .padding()
        }
        .onReceive(viewmodel.$sendInvitationSuccess, perform: { success in
            if success {
                coordinator.path.removeLast(2)
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
