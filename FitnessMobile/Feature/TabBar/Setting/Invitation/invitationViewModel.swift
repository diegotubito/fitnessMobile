//
//  invitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

class InvitationViewModel: BaseViewModel {
    @Published var invitations: [InvitationModel] = []
    
    @MainActor
    func loadInvitationsByUserId() {
        Task {
            let invitationUseCase = InvitationUseCase()
            isLoading = true
            do {
                let response = try await invitationUseCase.getInvitationsByUserId()

                DispatchQueue.main.async {
                    self.invitations = response.invitations
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
}
