//
//  SplashView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SplashView: View {
    @Binding var shouldShowSplash: Bool
    @StateObject var viewmodel = SplashViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            
            switch viewmodel.serverState {
            case .idle:
                Text("Server connection: idle")
            case .loading:
                Text("Server connection: loading...")
            case .connected:
                Text("Server connection: ✔️")
            case .disconnected:
                Text("Server connection: X")
            }
            
            if viewmodel.serverState == .loading {
                ProgressView()
            }
        }
        .onAppear {
            viewmodel.checkServerConnection()
        }
        .onChange(of: viewmodel.serverState) { state in
            if state == .disconnected {
                coordinator.presentPrimaryAlert(title: "Server", message: "The server is not reachable") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        self.viewmodel.checkServerConnection()
                    })
                }
            } else if state == .connected {
                shouldShowSplash = false
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(shouldShowSplash: .constant(true))
    }
}
