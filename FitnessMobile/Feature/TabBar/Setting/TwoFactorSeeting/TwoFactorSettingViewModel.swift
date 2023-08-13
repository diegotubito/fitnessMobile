//
//  TwoFactorSettingViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI

class TwoFactorSettingViewModel: BaseViewModel {
    @Published var isLoading = false
    
    @MainActor
    func enable2FA(completion: @escaping (TwoFactorEntity.Enable.Response?) -> Void) {
        Task {
            let usecase = TwoFactorUseCase()
            isLoading = true
            do {
                let response = try await usecase.enable2FA()
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    completion(nil)
                }
            }
        }
    }

    @MainActor
    func disable2FA(completion: @escaping (TwoFactorEntity.Disable.Response?) -> Void) {
        Task {
            let usecase = TwoFactorUseCase()
            isLoading = true
            do {
                let response = try await usecase.disable2FA()
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.handleError(error: error)
                    completion(nil)
                }
            }
        }
    }
}
