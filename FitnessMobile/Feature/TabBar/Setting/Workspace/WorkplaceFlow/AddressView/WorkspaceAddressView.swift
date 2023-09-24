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
    @State var shouldPresentSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                if viewmodel.workspace.location != nil {
                    VStack {
                        HStack {
                            Text("_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_TITLE")
                                .font(.largeTitle)
                                .foregroundColor(Color.Dark.tone30)
                            Spacer()
                        }
                        .padding(.bottom)
                        HStack {
                            Text(viewmodel.workspace.location?.googleGeocode?.formattedAddress ?? "")
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(Color.Red.truly)
                                .onTapGesture {
                                    shouldPresentSheet = true
                                }
                        }
                    }
                    
                    .padding(.bottom)
                }
                
                HStack {
                    Text("_WORKSPACE_ADDRESS_VIEW_TITLE")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Text("_WORKSPACE_ADDRESS_VIEW_SUBTITLE")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
                    Spacer()
                }
                
                CustomTextField(customTextFieldManager: viewmodel.addressTextField, title: "", placeholder: "", footer: "") { newString in
                    
                } onDidBegin: { didBegin in
                    
                }
                
                BasicButton(title: "_WORKSPACE_ADDRESS_VIEW_BUTTON_TITLE", style: .primary, isEnabled: .constant(true)) {
                    googleGeocodeManager.fetchAddressInfo(address: viewmodel.addressTextField.text)
                }
                .padding(.bottom, 32)
                
                Spacer()
                
                if let results = googleGeocodeManager.geocodingResponse?.results, !results.isEmpty {
                    HStack {
                        Text("_WORKSPACE_ADDRESS_VIEW_RESULT")
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
                print("_WORKSPACE_ADDRESS_VIEW_ADDRESS_NOT_VALID")
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
        .onReceive(viewmodel.$onDeletedLocationWorkspace, perform: { workspaceWithNoLocation in
            if let workspaceWithNoLocation = workspaceWithNoLocation {
                coordinator.path.removeLast(2)
            }
        })
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .sheet(isPresented: $shouldPresentSheet, content: {
            if shouldPresentSheet {
                VStack {
                    Text("_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_REMOVE_TITLE")
                        .padding()
                        .font(.title)
                    Text("_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_REMOVE_SUBTITLE")
                        .font(.subheadline)
                    Spacer()

                    HStack {
                        BasicButton(title: "_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_CANCEL_BUTTON", style: .secondary, isEnabled: .constant(true)) {
                            self.shouldPresentSheet = false
                        }
                        BasicButton(title: "_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_REMOVE_BUTTON", style: .destructive, isEnabled: .constant(true)) {
                            viewmodel.deleteWorkspaceLocation()
                            self.shouldPresentSheet = false
                        }
                    }
                }
                .padding(32)
                .presentationDetents([.medium, .fraction(0.35)])
                .presentationBackground(Color.Blue.midnight)
            }
            
        })
    }
}
