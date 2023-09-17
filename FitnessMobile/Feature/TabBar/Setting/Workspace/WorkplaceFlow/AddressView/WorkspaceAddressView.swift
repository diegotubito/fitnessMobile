//
//  WorkspaceSecondStepView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 09/09/2023.
//

import SwiftUI

struct WorkspaceAddressView: View {
    @StateObject var viewmodel: WorkspaceAddressViewModel
    @StateObject var googleGeocodeManager = GoogleGeocodeManager()
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            CustomTextField(customTextFieldManager: viewmodel.addressTextField, title: "", placeholder: "", footer: "") { newString in
                
            } onDidBegin: { didBegin in
                
            }
            
            if let results = googleGeocodeManager.geocodingResponse?.results {
                List(results, id: \.self) { result in
                    VStack {
                        Text(result.formattedAddress)
                    }
                    .onTapGesture {
                        viewmodel.updateWorkspaceAddress(result: result)
                    }
                }
            }
            
            Spacer()
            
            Button("Verify Address") {
                googleGeocodeManager.fetchAddressInfo(address: viewmodel.addressTextField.text)
            }
        }
        .onReceive(googleGeocodeManager.$onErrorAddress, perform: { onError in
            if !onError {
                print("address not valid")
            }
        })
        .onReceive(googleGeocodeManager.$geocodingResponse, perform: { geocoding in
            print(geocoding)
        })
        .onReceive(viewmodel.$onWorkspaceUpdated, perform: { updateValue in
            if let workspace = updateValue {
                coordinator.path.removeLast(2)
            } 
        })
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .padding()
    }
}
