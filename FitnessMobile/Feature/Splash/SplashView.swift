//
//  SplashView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SplashView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var socketIOManager = SocketIOManager()
    @StateObject var coordinator = Coordinator()
    @Environment(\.scenePhase) var scenePhase

    @State var shouldShowSplash = true
    
    var body: some View {
        VStack {
            if shouldShowSplash {
                Text("Splash View")
            } else {
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
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                shouldShowSplash = false
            })
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
