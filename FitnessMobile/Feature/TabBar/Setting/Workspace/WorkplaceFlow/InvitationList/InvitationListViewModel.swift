//
//  InvitationListViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

class InvitationListViewModel: BaseViewModel {
    @Published var invitations: [InvitationModel] = []
    @Published var onDeletedInvitation = false
    var selectedInvitation: InvitationModel?
    
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
    
    @MainActor
    func deleteInvitationById(_id: String) {
        Task {
            let usecase = InvitationUseCase()
            
            isLoading = true
            
            do {
                let response = try await usecase.deleteInvitationById(_id: _id)
                isLoading = false
                onDeletedInvitation = true
            } catch {
                isLoading = false
            }
        }
    }
}

