//
//  WorkspaceManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

class WorkspaceSettingViewModel: BaseViewModel {
    var workspaces: [WorkspaceModel] = []
    @Published var ownWorkspaces: [WorkspaceModel] = []
    @Published var invitedWorkspaces: [WorkspaceModel] = []
    
    let workspaceUseCase: WorkspaceUseCaseProtocol
    
    init(usecase: WorkspaceUseCaseProtocol = WorkspaceUseCase()) {
        self.workspaceUseCase = usecase
    }

    @MainActor
    func loadWorkspacesById() {
        Task {
            isLoading = true
            do {
                let response = try await workspaceUseCase.getWorkspacesBuUserId(_id: UserSession._id)

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
            workspace.members.contains(where: {$0.user._id == UserSession._id})
        }
    }
}
