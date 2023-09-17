//
//  GoogleGeocodeManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 16/09/2023.
//

import SwiftUI

class GoogleGeocodeManager: BaseViewModel {
    @Published var onErrorAddress = false
    @Published var geocodingResponse: GoogleGeocodeModel?
    
    func fetchAddressInfo(address: String) {
        // Replace YOUR_API_KEY with your actual Google API Key
        let apiKey = "AIzaSyCACzBLpI_08wbMNRXVLKgLu1eINjoS54o"
        
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(encodedAddress!)&region=ar&key=\(apiKey)"
        
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(GoogleGeocodeModel.self, from: data)
                        DispatchQueue.main.async {
                            self.geocodingResponse = response
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showError = true
                            self.errorTitle = "Invalid Address"
                            self.errorMessage = "Insert a valid address."
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getComponet(components: [GoogleGeocodeModel.AddressComponent], type: GoogleGeocodeModel.AddressComponentType, nameType: GoogleGeocodeModel.AddressComponentNameType = .long) -> String? {
        for component in components {
            if component.types.contains(type.rawValue) {
                return nameType == .long ? component.longName : component.shortName
            }
        }
        return nil
    }

}
