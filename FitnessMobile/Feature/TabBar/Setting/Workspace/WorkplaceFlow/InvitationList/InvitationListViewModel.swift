//
//  InvitationListViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

class InvitationListViewModel: BaseViewModel {
    @Published var invitations: [InvitationModel] = []
    var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
    
    @MainActor
    func fetchInvitationsByWorkspace() {
        Task {
            let usecase = InvitationUseCase()
            isLoading = true
            do {
                isLoading = false
                let response = try await usecase.getInvitationsByWorkspaceId(workspaceId: workspace._id)
                invitations = response.invitations
            } catch {
                isLoading = false
                showError = true
                handleError(error: error)
            }
        }
    }
}

