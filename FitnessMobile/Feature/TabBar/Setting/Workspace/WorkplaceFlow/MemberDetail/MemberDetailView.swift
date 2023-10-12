//
//  MemberDetailView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 30/09/2023.
//

import SwiftUI

struct MemberDetailView: View {
    @StateObject var viewmodel: MemberDetailViewModel
    @EnvironmentObject var coordinator: Coordinator
    @State var shouldPresentSheet: Bool = false
    @State var uiimage: UIImage?
    
    var body: some View {
        VStack {
            viewmodel.imageLoaded
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                }
                .overlay {
                    if viewmodel.isLoading {
                        ProgressView()
                    }
                }
            
            HStack {
                Text("\(viewmodel.member.user.lastName) \(viewmodel.member.user.firstName)")
            }
            HStack {
                Text(viewmodel.member.user.username)
            }
            Spacer()
        }
        Text(viewmodel.member.role.rawValue)
            .padding()
        Spacer()
        HStack {
            BasicButton(title: "Delete Member", style: .secondary, isEnabled: .constant(true)) {
                shouldPresentSheet = true
            }
            
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .padding()
        
        .sheet(isPresented: $shouldPresentSheet, content: {
            DeleteSheetView(title: "Eliminar Miembro", subtitle: "Estas seguro de eliminar este miembro de tu espacio de trabajo?", onTapped: { optionTapped in
                if optionTapped == .accept {
                    viewmodel.deleteMember()
                } else {
                    shouldPresentSheet = false
                }
            })
            .presentationDetents([.medium, .fraction(0.30)])
            .presentationBackground(Color.Blue.midnight)
        })
        .onReceive(viewmodel.$memberDeleted, perform: { isDeleted in
            if isDeleted {
                coordinator.path.removeLast()
            }
        })
        
        .onAppear {
            viewmodel.loadProfileImageFromApi()
        }
    }
}

