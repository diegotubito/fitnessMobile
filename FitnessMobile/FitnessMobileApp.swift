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
    @StateObject var userSession = UserSession()
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.lightText, .font: UIFont.systemFont(ofSize: 40, weight: .bold)]
      //  appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.yellow]
      //  appearance.doneButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.green]
        appearance.shadowColor = UIColor.gray

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
    }
    
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
