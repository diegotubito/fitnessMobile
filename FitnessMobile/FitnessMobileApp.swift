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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(socketIOManager)
        }
    }
}
