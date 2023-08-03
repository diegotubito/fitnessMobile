//
//  ContentView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 31/07/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var connection = Connection()
    @StateObject var router = Router()
    
    var body: some View {
        VStack {
            switch connection.state {
            case .connected:
                HomeView()
            case .noInternet:
                OfflineView()
            case .noServer:
                OfflineView()
            case .noUser:
                LoginView()
            case .waiting:
                SplashView()
            }
        }
        .padding()
        .environmentObject(connection)
        .environmentObject(router)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
