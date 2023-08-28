//
//  SettingView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                ProfileHeader()
                    .cornerRadius(10)
                
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
                .scrollContentBackground(.hidden)
                Spacer()
                HStack {
                    VStack {
                        HStack {
                            Text(ApplicationVersion.getVersionAndBundle())
                            Spacer()
                        }
                        HStack {
                            Text(UserSession.getAccessTokenExpirationDateString())
                            Spacer()
                        }
                        HStack{
                            Text(UserSession.getRefreshTokenExpirationDateString())
                            Spacer()
                        }
                        /*
                        HStack {
                            Text("Device Token \(UserSession.getDeviceToken() ?? "")")
                            Spacer()
                        }
                         */
                    }
                    .padding()
                    .foregroundColor(Color.Neutral.tone90)
                    .font(.subheadline)
                    Spacer()
                }
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
