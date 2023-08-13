//
//  TwoFactorSettingViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI

class TwoFactorSettingViewModel: BaseViewModel {
    @Published var isLoading = false
    
    func enable2FA(completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            self.handleError(error: APIError.badRequest(title: "bad", message: "request"))
            completion(Data())
        }
    }

    func disable2FA(completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            self.handleError(error: APIError.badRequest(title: "bad", message: "request"))
            completion(Data())
        }
    }
}
