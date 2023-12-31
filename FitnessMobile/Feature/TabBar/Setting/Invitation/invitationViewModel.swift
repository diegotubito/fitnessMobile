//
//  invitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

class InvitationViewModel: BaseViewModel {
    @Published var invitations: [InvitationModel] = []
    @Published var onAcceptedInvitation: Bool = false
    @Published var onRejectedInvitation: Bool = false
    
    let invitationUseCase: InvitationUseCaseProtocol
    
    init(invitationUseCase: InvitationUseCaseProtocol = InvitationUseCase()) {
        self.invitationUseCase = invitationUseCase
    }

    @MainActor
    func loadInvitationsByUserId() {
        Task {
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
    
    @MainActor
    func acceptInvitation(invitation: InvitationModel) {
        Task {
            isLoading = true
            do {
                let response = try await invitationUseCase.acceptInvitation(_id: invitation._id)
                isLoading = false
                onAcceptedInvitation = true
            } catch {
                isLoading = false
                handleError(error: error)
                showError = true
            }
        }
    }

    @MainActor
    func rejectInvitation(invitation: InvitationModel) {
        Task {
            isLoading = true
            do {
                let response = try await invitationUseCase.rejectInvitation(_id: invitation._id)
                isLoading = false
                onRejectedInvitation = true
            } catch {
                isLoading = false
                handleError(error: error)
                showError = true
            }
        }
    }
}
