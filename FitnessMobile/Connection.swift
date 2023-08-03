//
//  Connection.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

class Connection: ObservableObject {
    @Published var state: State = .waiting
    @ObservedObject var socketManager = SocketIOManager.shared
    
    init() {
        Task {
            await check()
        }
    }
    
    enum State {
        case connected
        case noInternet
        case noServer
        case noUser
        case waiting
    }
    
    @MainActor
    func check() async {
//        if let session = UserSessionManager.getUserSession() {
//            print("session: user connected \(session.user.username)")
//        } else {
//            print("session: there's no user logged in.")
//            state = .noUser
//        }
        
        
            if self.socketManager.isConnected {
                print("session: Socket connected")
                self.state = .connected
            } else {
                print("session: Socket not connected")
                self.state = .noServer
                checkAgain()
            }
    }
    
    func checkAgain() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { time in
            DispatchQueue.global().async {
                Task {
                    await self.check()
                }
            }
        }
    }
    
    @MainActor
    func doCheckServerConnection() async {
        let usecase = ServerConnectionUseCase()
        do {
            let _ = try await usecase.isConnected()
            print("session: server is connected")
            state = .connected
        } catch {
            print("session: server not connected", error)
            state = .noServer
        }
    }
}
