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
    @EnvironmentObject var userSession: UserSessionManager
    
    @State var toggleIsEnabled: Bool = true
    
    var body: some View {
        if !(userSession.user?.twoFactorEnabled ?? false) {
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
            .overlay {
                if viewmodel.isLoading {
                    ProgressView()
                }
            }
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
                    .onTapGesture {
                        coordinator.presentSecondaryAlert(title: "Disablle 2FA", message: "Disabling this security layer is not recomended.") {
                            disable2FA()
                        } secondaryTapped: { }
                    }
                Spacer()
            }
            
        }
        
    }
    
    func enable2FA() {
        coordinator.push(.twoFactorEnableInformation)
    }
    
    func disable2FA() {
        viewmodel.disable2FA { result in
            if result != nil {
                coordinator.path.removeLast()
            } else {
                coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {}
                toggleIsEnabled.toggle()
            }
        }
    }
}

struct TwoFactorSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorSettingView()
    }
}
