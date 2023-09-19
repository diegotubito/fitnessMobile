//
//  WorkspaceView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/09/2023.
//

import SwiftUI

struct WorkspaceSettingView: View {
    @StateObject var viewmodel = WorkspaceSettingViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    func ownerWorkspaceView() -> some View {
        return VStack {
            
            if !viewmodel.ownWorkspaces.isEmpty {
                
                Text("Tus propios Espacios")
                List(viewmodel.ownWorkspaces, id: \.self) { own in
                    Text(own.title)
                        .onTapGesture {
                            coordinator.push(.workspaceDetail(workspace: own))
                        }
                }
                .scrollContentBackground(.hidden)
            }
            
        }
    }
    
    func invitedWorkspaceView() -> some View {
        return VStack {
            
            if !viewmodel.invitedWorkspaces.isEmpty {
                
                Text("Espacios como invitado")
                List(viewmodel.invitedWorkspaces, id: \.self) { invited in
                    Text(invited.title)
                }
                .scrollContentBackground(.hidden)
            }
            
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                ownerWorkspaceView()
                invitedWorkspaceView()
                Spacer()
                Button("Create a new Workspace") {
                    coordinator.push(.workspaceTitleAndSubtitle(workspace: nil))
                }
            }
            
        }
        .onAppear {
            viewmodel.loadWorkspacesById()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
}

struct WorkspaceSettingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceSettingView()
    }
}
