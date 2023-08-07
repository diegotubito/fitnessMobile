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
        ScrollView {
            VStack {
                
                Button("_LOGOUT", action: {
                    userSession.removeUserSession()
                })
                Spacer()
                Button("_DELETE_ACCOUNT", action: {
                    coordinator.push(.deleteAccount)
                })
            }
        }
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
