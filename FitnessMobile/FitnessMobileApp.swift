//
//  FitnessMobileApp.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 31/07/2023.
//

import SwiftUI
import UserNotifications

@main
struct FitnessMobileApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var socketIOManager = SocketIOManager()
    @StateObject var coordinator = Coordinator()
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            CoordinatorMainView()
                .environmentObject(socketIOManager)
                .environmentObject(coordinator)
                .environmentObject(networkMonitor)
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("Active")
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                    }
                }
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                        if granted {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        } else {
                            // User denied notifications or an error occurred
                        }
                    }
                }
        }
    }
}
