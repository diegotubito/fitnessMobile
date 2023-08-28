//
//  TwoFactorSettingView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI

struct TwoFactorSettingView: View {
    @StateObject var viewmodel = TwoFactorSettingViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    @State var toggleIsEnabled: Bool = true
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            if !UserSession.isTwoFactorEnabled {
                VStack {
                    HStack {
                        Text("Two factor authentication")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Increase your security adding a two factor extra layer.")
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        BasicButton(title: "Secure Your Account", style: .primary, isEnabled: .constant(true)) {
                            coordinator.presentSecondaryAlert(title: "Enable 2FA", message: "You are going to enable two factor auth.") {
                                
                            } secondaryTapped: {
                                enable2FA()
                            }
                        }
                    }
                }
                .padding()
                .overlay(
                    Group {
                        if viewmodel.isLoading {
                            // A transparent view that captures all touches, making underlying views non-interactive
                            ZStack {
                                Color.clear
                                    .contentShape(Rectangle()) // Makes the entire view tappable
                                    .onTapGesture { }
                                    .allowsHitTesting(true) // Captures all touches
                                ProgressView()
                            }
                        } else {
                            Color.clear
                                .contentShape(Rectangle()) // Makes the entire view tappable
                                .allowsHitTesting(false) // Captures all touches
                        }
                    }
                )
                .onReceive(viewmodel.$twoFactorEnabled) { response in
                    if let response = response {
                        let user = UserSession.getUser()
                        UserSession.saveUser(user: user!)
                        UserSession.saveTempToken(value: response.tempToken)
                        let imageData = Data(base64Encoded: response.qrImage)
                        let image = UIImage(data: imageData ?? Data())
                        coordinator.push(.twoFactorEnableInformation(qrImage: image ?? UIImage(), activationCode: response.activationCode))
                    }
                }
                .overlay(
                    Group {
                        CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                        CustomProgressView(isLoading: $viewmodel.isLoading)
                    }
                )
            } else {
                VStack {
                    Toggle("Two Factor Authentication", isOn: $toggleIsEnabled)
                        .padding()
                        .onChange(of: toggleIsEnabled, perform: { newValue in
                            if !newValue {
                                coordinator.presentSecondaryAlert(title: "Disablle 2FA", message: "Disabling this security layer is not recomended.") {
                                    toggleIsEnabled.toggle()
                                } secondaryTapped: {
                                    disable2FA()
                                }
                            }
                        })
                        
                    Spacer()
                }
                .onReceive(viewmodel.$twoFactorDisabled) { response in
                    if response != nil {
                        coordinator.path.removeLast()
                    } else {
                        toggleIsEnabled = true
                    }
                }
                .overlay(
                    Group {
                        CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                        CustomProgressView(isLoading: $viewmodel.isLoading)
                    }
                )
                
            }
        }
        
    }
    
    func enable2FA() {
        viewmodel.enable2FA()
    }
    
    func disable2FA() {
        viewmodel.disable2FA()
    }
}

struct TwoFactorSettingView_Previews: PreviewProvider {
    @State static var userSession = UserSession()
    static var previews: some View {
        TwoFactorSettingView()
            .environmentObject(userSession)
    }
}
