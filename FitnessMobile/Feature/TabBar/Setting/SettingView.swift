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
                            Image("laptop-computer")
                            Button("_SETTING_WORKSPACES") {
                                coordinator.push(.workspaceSetting)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                        HStack {
                            Image("users")
                            Button("_SETTING_INVITATIONS") {
                                coordinator.push(.invitationSetting)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                    }
                    Section {
                        HStack {
                            Image("profile")
                            Button("_SETTING_PROFILE", action: {
                                coordinator.push(.profile)
                            })
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                        
                        HStack {
                            Image("key")
                            Button("_SETTING_2FA", action: {
                                coordinator.push(.settingTwoFactor)
                            })
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                       
                    }
                    
                    Section {
                        HStack {
                            Image("log-out")
                            Button("_LOGOUT", action: {
                                coordinator.presentSecondaryAlert(title: "_LOGOUT_ALERT_WARNING_TITLE", message: "_LOGOUT_ALERT_WARNING_MESSAGE") { } secondaryTapped: {
                                    closeSession()
                                }
                            })
                        }
                        .foregroundColor(Color.Dark.tone90)
                        
                        HStack {
                            Image("delete")
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
