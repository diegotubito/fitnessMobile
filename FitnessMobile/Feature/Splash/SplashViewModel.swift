//
//  SplashViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class SplashViewModel: BaseViewModel {
    @Published var workspaces: [WorkspaceModel] = []
    @Published var onWorkspacesDidLoad = false
    
    @MainActor
    func loadWorkspaces() {
        Task {
            let usecase = WorkspaceUseCase()
            
            do {
                let response = try await usecase.getWorkspacesBuUserId(_id: UserSession._id)
                workspaces = response.workspaces
                onWorkspacesDidLoad = true
                configureDefaultWorkspaceIfNeccesary()
            } catch {
                handleError(error: error)
            }
        }
    }
    
    func configureDefaultWorkspaceIfNeccesary() {
        if workspaces.isEmpty {
            DefaultWorkspace.removeDefaultWorkspace()
        } else if !DefaultWorkspace.hasDefaultWorkspace() {
            DefaultWorkspace.setDefaultWorkspace(id: workspaces.first?._id ?? "")
        }
    }
}
