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
            VStack {
                HStack(spacing: 16) {
                    Image("profile_diego")
                        .resizable()
                        .frame(width: 85, height: 85)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    
                    VStack(spacing: 2) {
                        HStack {
                            Text(UserSessionManager().getFullName())
                                .font(.headline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        HStack {
                            Text(UserSessionManager().getUserName())
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone70)
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        HStack {
                            Text(verbatim: UserSessionManager().getEmail())
                                .font(.subheadline)
                                .foregroundColor(Color.Dark.tone80)
                           
                            Spacer()
                        }
                    }

                    Spacer()

                }
            }
            .padding()
            .background(Color.Neutral.tone90)
            
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
        }
    
    }
    
    func closeSession() {
        userSession.removeUserSession()
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
