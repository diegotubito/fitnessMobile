//
//  CreateInvitationViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 19/09/2023.
//

import SwiftUI

class SearchUserForInvitationViewModel: BaseViewModel {
    var workspace: WorkspaceModel
    @Published var userTextField = CustomTextFieldManager()
    @Published var users: [User] = []
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
    
    @MainActor
    func fetchUsers() {
        Task {
            let usecase = UserUseCase()
            do {
                let response = try await usecase.getUsersByUsernameOrEmail(username: userTextField.text)
                self.users = response.users
            } catch {
                self.handleError(error: error)
                self.showError = true
            }
        }
    }
}
