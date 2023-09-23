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
    @Published var selectedRole: Roles = .userReadOnly
    
    @Published var sendInvitationSuccess = false
    
    init(workspace: WorkspaceModel, user: User) {
        self.user = user
        self.workspace = workspace
    }
    
    enum Roles: LocalizedStringKey, CaseIterable {
        case admin = "_WORSPACE_ADMIN_ROLE"
        case user = "_WORSPACE_USER_ROLE"
        case userReadOnly = "_WORSPACE_USER_READ_ONLY_ROLE"
    }
    
    @MainActor
    func sendInvitation() {
        Task {
            do {
                let usecase = InvitationUseCase()
                let response = try await usecase.sendInvitation(workspace: workspace._id, user: user._id, role: getSelectedRole())
                sendInvitationSuccess = true
            } catch {
                handleError(error: error)
                showError = true
            }
        }
    }
    
    func getSelectedRole() -> String {
        switch selectedRole {
        case .admin:
            return "ADMIN_ROLE"
        case .user:
            return "USER_ROLE"
        case .userReadOnly:
            return "USER_READ_ONLY"
        }
    }
}
