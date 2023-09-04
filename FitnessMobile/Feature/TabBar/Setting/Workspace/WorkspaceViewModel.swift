//
//  WorkspaceManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

class WorkspaceViewModel: BaseViewModel {
    var workspaces: [WorkspaceModel] = []
    @Published var ownWorkspaces: [WorkspaceModel] = []
    @Published var invitedWorkspaces: [WorkspaceModel] = []

    @MainActor
    func loadWorkspacesById() {
        Task {
            let workspaceUseCase = WorkspaceUseCase()
            isLoading = true
            do {
                let response = try await workspaceUseCase.getWorkspacesBuUserId()

                DispatchQueue.main.async {
                    self.workspaces = response.workspaces
                    self.filterOwnWorkspaces()
                    self.filterInvitedWorkspaces()
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error: error)
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func filterOwnWorkspaces() {
        ownWorkspaces = workspaces.filter({$0.owner == UserSession._id})
    }
    
    func filterInvitedWorkspaces() {
        invitedWorkspaces = workspaces.filter { workspace in
            workspace.members.contains(where: {$0.user == UserSession._id})
        }
    }
}
