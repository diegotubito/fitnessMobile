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
        return VStack(spacing: 0) {
            
            if !viewmodel.ownWorkspaces.isEmpty {
                
                HStack {
                    Text("_YOUR_OWN_WORKSPACE_TITLE")
                        .font(.title)
                        .foregroundColor(Color.Neutral.tone80)

                    Spacer()
                }
                .padding()
                
                List(viewmodel.ownWorkspaces, id: \.self) { own in
                    Text("\(own.title), \(own.subtitle).")
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
                
                HStack {
                    Text("_YOUR_GUEST_WORKSPACE_TITLE")
                        .font(.title)
                        .foregroundColor(Color.Neutral.tone80)
                    Spacer()
                }
                .padding()
                
                List(viewmodel.invitedWorkspaces, id: \.self) { invited in
                    Text("\(invited.title), \(invited.subtitle).")
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
        .toolbar(content: {

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("_NEW_WORSPACE_BUTTON_TITLE") {
                    coordinator.push(.workspaceTitleAndSubtitle(workspace: nil))
                }.disabled(false)
            }
            
        })
    }
}

struct WorkspaceSettingView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceSettingView()
    }
}
