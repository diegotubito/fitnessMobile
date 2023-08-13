//
//  TwoFactorEnableInformationViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/08/2023.
//

import SwiftUI

class TwoFactorEnableInformationViewModel: BaseViewModel {
    @Published var isLoading = false
    
    @MainActor
    func confirm2FA(completion: @escaping (TwoFactorEntity.ConfirmEnable.Response?) -> Void) {
        Task {
            let usecase = TwoFactorUseCase()
            do {
                let response = try await usecase.confirm2FA()
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
