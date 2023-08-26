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
            
        }
        
    }
    
    func enable2FA() {
        viewmodel.enable2FA { result in
            if let result = result {
                let user = UserSession.getUser()
                UserSession.saveUser(user: user!)
                UserSession.saveTempToken(value: result.tempToken)
                let imageData = Data(base64Encoded: result.qrImage)
                let image = UIImage(data: imageData ?? Data())
                coordinator.push(.twoFactorEnableInformation(qrImage: image ?? UIImage(), activationCode: result.activationCode))
            } else {
                coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {}
            }
        }
    }
    
    func disable2FA() {
        viewmodel.disable2FA { result in
            if result != nil {
                coordinator.path.removeLast()
            } else {
                coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {}
                toggleIsEnabled = true
            }
        }
    }
}

struct TwoFactorSettingView_Previews: PreviewProvider {
    @State static var userSession = UserSession()
    static var previews: some View {
        TwoFactorSettingView()
            .environmentObject(userSession)
    }
}
