//
//  DeleteAccountViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class DeleteAccountViewModel: ObservableObject {
    @Published var isLoading = false
    
    func deleteAccount(completion: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            completion("Failed deleting account")
        }
    }
}

