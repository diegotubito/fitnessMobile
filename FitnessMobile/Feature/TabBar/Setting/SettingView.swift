//
//  SettingView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI


struct SettingView: View {
    @StateObject var settingCoordinator = SettingCoordinator()
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @State private var showAlerLogOut = false
    @EnvironmentObject var deepLink: DeepLink

    var body: some View {
        NavigationStack(path: $settingCoordinator.path) {
            contentView()
                .navigationDestination(for: SettingCoordinator.Screen.self) { value in
                    settingCoordinator.getPage(value)
                }
        }
        .environmentObject(settingCoordinator)
        .onReceive(deepLink.$deepLinkPath, perform: { values in
            if values.isEmpty { return }
            
            DispatchQueue.main.async {
                settingCoordinator.handleDeepLink(values: values, queryParams: deepLink.queryParams)
                deepLink.deepLinkPath.removeAll()
            }
        })
    }
    
    func contentView() -> some View {
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
                                settingCoordinator.push(.workspaceSetting)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                        HStack {
                            Image("users")
                            Button("_SETTING_INVITATIONS") {
                                settingCoordinator.push(.invitationSetting)
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
                                settingCoordinator.push(.profile)
                            })
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color.Dark.tone90)
                        
                        HStack {
                            Image("key")
                            Button("_SETTING_2FA", action: {
                                settingCoordinator.push(.settingTwoFactor)
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
                                showAlerLogOut = true
                            })
                            .alert(isPresented: $showAlerLogOut) {
                                Alert(
                                    title: Text("_LOGOUT_ALERT_WARNING_TITLE"),
                                    message: Text("_LOGOUT_ALERT_WARNING_MESSAGE"),
                                    primaryButton: .default(Text("_LOGOUT"), action: {
                                        closeSession()
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                        .foregroundColor(Color.Dark.tone90)
                        
                        HStack {
                            Image("delete")
                            Button("_DELETE_ACCOUNT", action: {
                                settingCoordinator.push(.deleteAccount)
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
        mainModalCoordinator.modal = MainModalView(screen: .login)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
