//
//  DeleteAccountViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class DeleteAccountViewModel: BaseViewModel {
    @Published var deleteResult: DeleteUserResult?
    
    func deleteAccount() {
        let usecase = UserUseCase()
        isLoading = true
        Task {
            do {
                let response = try await usecase.deleteUser()
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.deleteResult = response
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
}

