//
//  PickRoleViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 20/09/2023.
//

import SwiftUI

class PickRoleViewModel: BaseViewModel {
    var workspace: WorkspaceModel
    var user: User
    @Published var selectedRole: WorkspaceModel.Role = .userReadOnly
    
    @Published var sendInvitationSuccess = false
    
    init(workspace: WorkspaceModel, user: User) {
        self.user = user
        self.workspace = workspace
    }
    
    @MainActor
    func sendInvitation() {
        Task {
            do {
                let usecase = InvitationUseCase()
                let response = try await usecase.sendInvitation(workspace: workspace._id, user: user._id, role: selectedRole.rawValue, host: UserSession._id)
                sendInvitationSuccess = true
            } catch {
                handleError(error: error)
                showError = true
            }
        }
    }
}
