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
    
    var body: some View {
        NavigationStack(path: $settingCoordinator.path) {
            contentView()
                .navigationDestination(for: SettingCoordinator.Screen.self) { value in
                    settingCoordinator.getPage(value)
                }
                .alert(isPresented: $settingCoordinator.showAlert) {
                    switch settingCoordinator.alertDetail?.alertStyle ?? .secondary {
                    case .secondary:
                        return Alert(
                            title: Text(settingCoordinator.alertDetail?.title ?? ""),
                            message: Text(settingCoordinator.alertDetail?.message ?? ""),
                            primaryButton: .cancel(Text(settingCoordinator.alertDetail?.primaryButtonTitle ?? "_ALERT_CANCEL"), action: settingCoordinator.primaryTapped),
                            secondaryButton: .default(Text(settingCoordinator.alertDetail?.secondaryButtonTitle ?? "_ALERT_ACCEPT"), action: settingCoordinator.secondaryTapped)
                        )
                    case .destructive:
                        return Alert(
                            title: Text(settingCoordinator.alertDetail?.title ?? ""),
                            message: Text(settingCoordinator.alertDetail?.message ?? ""),
                            primaryButton: .destructive(Text(settingCoordinator.alertDetail?.primaryButtonTitle ?? "_ALERT_REMOVE"), action: settingCoordinator.primaryTapped),
                            secondaryButton: .cancel(Text(settingCoordinator.alertDetail?.secondaryButtonTitle ?? "_ALERT_CANCEL"), action: settingCoordinator.secondaryTapped)
                        )
                    }
                }
        }
        .environmentObject(settingCoordinator)
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
                                settingCoordinator.presentSecondaryAlert(title: "_LOGOUT_ALERT_WARNING_TITLE", message: "_LOGOUT_ALERT_WARNING_MESSAGE") { } secondaryTapped: {
                                    closeSession()
                                }
                            })
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
    @State static var coordinator = CoordinatorLegacy()
    static var previews: some View {
        NavigationStack {
            SettingView()
        }
        .environmentObject(coordinator)
    }
}
