//
//  TwoFactorSettingViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI

class TwoFactorSettingViewModel: BaseViewModel {
    
    @Published var twoFactorEnabled: TwoFactorEntity.Enable.Response?
    @Published var twoFactorDisabled: TwoFactorEntity.Disable.Response?
    
    @MainActor
    func enable2FA() {
        Task {
            let usecase = TwoFactorUseCase()
            isLoading = true
            do {
                let response = try await usecase.enable2FA()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.twoFactorEnabled = response
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    self.showError = true
                }
            }
        }
    }

    @MainActor
    func disable2FA() {
        Task {
            let usecase = TwoFactorUseCase()
            isLoading = true
            do {
                let response = try await usecase.disable2FA()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.twoFactorDisabled = response
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    self.showError = true
                    self.twoFactorDisabled = nil
                }
            }
        }
    }
}
