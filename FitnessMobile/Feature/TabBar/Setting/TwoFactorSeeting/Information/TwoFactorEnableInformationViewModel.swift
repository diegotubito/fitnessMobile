//
//  TwoFactorEnableInformationViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/08/2023.
//

import SwiftUI

class TwoFactorEnableInformationViewModel: BaseViewModel {
    @Published var twoFactorConfirmed: TwoFactorEntity.ConfirmEnable.Response?
    
    @MainActor
    func confirm2FA() {
        Task {
            let usecase = TwoFactorUseCase()
            do {
                let response = try await usecase.confirm2FA()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.twoFactorConfirmed = response
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    self.twoFactorConfirmed = nil
                    self.showError = true
                }
            }
        }
    }
}
