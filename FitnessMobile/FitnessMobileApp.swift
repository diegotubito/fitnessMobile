//
//  FitnessMobileApp.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 31/07/2023.
//

import SwiftUI

@main
struct FitnessMobileApp: App {
    @StateObject var socketIOManager = SocketIOManager()
    @StateObject var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(socketIOManager)
                .environmentObject(coordinator)
        }
    }
}
