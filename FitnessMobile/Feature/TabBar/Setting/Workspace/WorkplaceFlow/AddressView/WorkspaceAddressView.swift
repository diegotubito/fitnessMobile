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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Ingrese una dirección")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                HStack {
                    Text("Buscaremos la mejor aproximación a la dirección ingresada.")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                
                CustomTextField(customTextFieldManager: viewmodel.addressTextField, title: "", placeholder: "", footer: "") { newString in
                    
                } onDidBegin: { didBegin in
                    
                }
                
                BasicButton(title: "Verify Address", style: .primary, isEnabled: .constant(true)) {
                    googleGeocodeManager.fetchAddressInfo(address: viewmodel.addressTextField.text)
                }
                .padding(.bottom, 32)
                
                Spacer()
                
                if let results = googleGeocodeManager.geocodingResponse?.results, !results.isEmpty {
                    HStack {
                        Text("Resultado de la busqueda.")
                            .font(.subheadline)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    List(results, id: \.self) { result in
                        VStack {
                            Text(result.formattedAddress)
                        }
                        .onTapGesture {
                            viewmodel.updateWorkspaceAddress(result: result)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .padding()
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
    }
}
