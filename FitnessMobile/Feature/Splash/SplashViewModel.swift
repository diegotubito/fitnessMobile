//
//  SplashViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class SplashViewModel: BaseViewModel {
    @Published var workspaces: [WorkspaceModel] = []
    
    @MainActor
    func loadWorkspaces() {
        Task {
            let usecase = WorkspaceUseCase()
            
            do {
                let response = try await usecase.getWorkspacesBuUserId(_id: UserSession._id)
                workspaces = response.workspaces
                saveWorkspacesToKeychain(workspaces: response.workspaces)
            } catch {
                handleError(error: error)
            }
        }
    }
    
    func saveWorkspacesToKeychain(workspaces: [WorkspaceModel]) {
        DefaultWorkspace.saveWorkspaces(workspaces: workspaces)
        let defaultWorkspace = DefaultWorkspace.getDefaultWorkspace()
        if  defaultWorkspace == nil,
           let workspace = workspaces.first {
            DefaultWorkspace.saveDefaultWorkspace(workspace: workspace)
        }
    }
}
