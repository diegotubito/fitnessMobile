//
//  WorkspaceAddressViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI
import CoreLocation

class WorkspaceAddressViewModel: BaseViewModel {
    @Published var addressTextField = CustomTextFieldManager()
    @Published var onValidAddress = false

    func verifyAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressTextField.text) { (placemarks, error) in
            DispatchQueue.main.async {
                if error == nil, let placemarks = placemarks, !placemarks.isEmpty {
                    self.onValidAddress = true
                } else {
                    self.showError = true
                    self.errorTitle = "Invalid Address"
                    self.errorMessage = "Insert a valid address."
                }
            }
        }
    }
}
