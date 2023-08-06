//
//  SplashViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var serverState: ServerState = .idle
    
    enum ServerState: Hashable, Equatable {
        case idle
        case loading
        case connected
        case disconnected
    }
    
    @MainActor
    func checkServerConnection() {
        serverState = .loading
        Task {
            let serverUseCase = ServerConnectionUseCase()
            do {
                _ = try await serverUseCase.isConnected()
                self.serverState = .connected
            } catch {
                self.serverState = .disconnected
            }
        }
    }
}
