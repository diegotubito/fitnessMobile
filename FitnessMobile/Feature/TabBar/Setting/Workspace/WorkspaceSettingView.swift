//
//  WorkspaceView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/09/2023.
//

import SwiftUI

struct WorkspaceSettingView: View {
    @StateObject var viewmodel = WorkspaceViewModel()
    
    func ownerWorkspaceView() -> some View {
        return VStack {
            
            if !viewmodel.ownWorkspaces.isEmpty {
                
                Text("Tus propios Espacios")
                ForEach(viewmodel.ownWorkspaces, id: \.self) { own in
                    Text(own.title)
                }
            }
            
        }
    }
    
    func invitedWorkspaceView() -> some View {
        return VStack {
            
            if !viewmodel.invitedWorkspaces.isEmpty {
                
                Text("Espacios como invitado")
                ForEach(viewmodel.invitedWorkspaces, id: \.self) { invited in
                    Text(invited.title)
                }
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
