//
//  OTPViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/08/2023.
//

import Foundation

class OTPViewModel: BaseViewModel {
    @Published var isLoading = false
    @Published var firstDigit: String = ""
    @Published var secondDigit: String = ""
    @Published var thirdDigit: String = ""
    @Published var fourthDigit: String = ""
    @Published var fifthDigit: String = ""
    @Published var sixthDigit: String = ""

    @MainActor
    func verify2FA(tempToken: String, completion: @escaping (TwoFactorEntity.Verify.Response?) -> Void) {
        Task {
            let usecase = TwoFactorUseCase()
            isLoading = true
            do {
                let response = try await usecase.verify2FA(tempToken: tempToken, optToken: getDigits())
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
    
    func getDigits() -> String {
        return firstDigit + secondDigit + thirdDigit + fourthDigit + fifthDigit + sixthDigit
    }
}
