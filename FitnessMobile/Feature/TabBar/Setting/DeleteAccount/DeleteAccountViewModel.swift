//
//  DeleteAccountViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class DeleteAccountViewModel: BaseViewModel {
    @Published var isLoading = false
    
    func deleteAccount(completion: @escaping (DeleteUserResult?) -> Void) {
        let usecase = UserUseCase()
        isLoading = true
        Task {
            do {
                let response = try await usecase.deleteUser()
                DispatchQueue.main.async {
                    completion(response)
                    self.isLoading = false
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

