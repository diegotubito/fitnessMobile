//
//  SettingView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var userSession: UserSessionManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            List {
                Section {
                    HStack {
                        Button("_SETTING_PROFILE", action: {
                            coordinator.push(.profile)
                        })
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.Dark.tone90)
                    
                    HStack {
                        Button("_SETTING_2FA", action: {
                            coordinator.push(.settingTwoFactor)
                        })
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.Dark.tone90)
                   
                }
                
                Section {
                    Button("_LOGOUT", action: {
                        coordinator.presentSecondaryAlert(title: "_LOGOUT_ALERT_WARNING_TITLE", message: "_LOGOUT_ALERT_WARNING_MESSAGE") { } secondaryTapped: { closeSession() }
                    })
                    .foregroundColor(Color.Dark.tone90)
                    
                    HStack {
                        Button("_DELETE_ACCOUNT", action: {
                            coordinator.push(.deleteAccount)
                        })
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(Color.Red.truly)
                }
            }
            Spacer()
            HStack {
                VStack {
                    Text(ApplicationVersion.getVersionAndBundle())
                    Text(UserSessionManager.getAccessTokenExpirationDateString())
                    Text(UserSessionManager.getRefreshTokenExpirationDateString())
                    Text("Device Token")
                }
                Spacer()
            }
        }
    
    }
    
    func closeSession() {
        NotificationCenter.default.post(Notification(name: .MustLogin))
    }
}

struct SettingView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            SettingView()
        }
        .environmentObject(coordinator)
    }
}
