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
    @StateObject var userSession = UserSession()
   
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(socketIOManager)
                .environmentObject(networkMonitor)
                .environmentObject(userSession)
                
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
