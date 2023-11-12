//
//  MainView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/11/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var mainModalCoordinator = MainModalCoordinator()
    @Environment(\.scenePhase) var scenePhase
    @StateObject var deepLink = DeepLink()
    @State var firstTime = true
    
    var body: some View {
        VStack {
            Text("Welcome...")
        }
        .fullScreenCover(item: $mainModalCoordinator.modal) { modal in
            switch modal.screen {
            case .splash:
                SplashView()
            case .tabbar(bar: let bar):
                TabBarView(tabBarManager: TabBarManager(selectedTab: bar))
            case .login:
                LoginView(allowSighUp: true)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if UserSession.isRefreshTokenExpired {
                    mainModalCoordinator.modal = MainModalView(screen: .login)
                }
                print("Active")
               
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        .onAppear {
            if UserSession.isRefreshTokenExpired {
                mainModalCoordinator.modal = MainModalView(screen: .login)
            } else {
                mainModalCoordinator.modal = MainModalView(screen: .splash)
            }
        }
        .onOpenURL { url in
            deepLink.parseURL(url)
        }
        .environmentObject(mainModalCoordinator)
        .environmentObject(deepLink)
    }
}

#Preview {
    MainView()
}
