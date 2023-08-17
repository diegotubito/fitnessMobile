//
//  FitnessMobileApp.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 31/07/2023.
//

import SwiftUI

@main
struct FitnessMobileApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var socketIOManager = SocketIOManager()
    @StateObject var coordinator = Coordinator()
    @StateObject var userSession = UserSessionManager()
    @Environment(\.scenePhase) var scenePhase
   
    var body: some Scene {
        WindowGroup {
            CoordinatorMainView()
                .environmentObject(socketIOManager)
                .environmentObject(coordinator)
                .environmentObject(networkMonitor)
                .environmentObject(userSession)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("Active")
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                    }
                }
        }
    }
}
