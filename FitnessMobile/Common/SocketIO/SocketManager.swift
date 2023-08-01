//
//  SocketManager.swift
//  HayEquipo
//
//  Created by David Gomez on 10/05/2023.
//

import Foundation
import SocketIO
import Combine

struct CurrentHost {
    static let local = "http://127.0.0.1:3000"
    static let remote = "https://ddg-testing-app-01.herokuapp.com"
    
    static func getHost() -> String {
        #if targetEnvironment(simulator)
            return local
        #else
            return remote
        #endif
    }
}

class SocketIOManager: ObservableObject {
    static let shared = SocketIOManager()

    @Published var messageReceived: MessageModel = MessageModel(title: "", message: "", action: .needUpdate)
    
    struct MessageModel: Codable {
        let title: String
        let message: String
        let action: Action?
        
        enum Action: String, Codable {
            case needUpdate
        }
    }
    
    
    @Published var isConnected: Bool = false

    let manager: SocketManager
    var socket: SocketIOClient

    init() {
        manager = SocketManager(socketURL: URL(string: CurrentHost.getHost())!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket

        self.socket.on(clientEvent: .connect) { [weak self] data, ack in
            self?.isConnected = true
            print("Socket: connected")
            
            if let userSession = UserSessionManager.getUserSession() {
                self?.socket.emit("register-user", userSession.user._id)
            }
        }

        //not called if server is killed
        self.socket.on(clientEvent: .disconnect) { [weak self] data, ack in
            self?.isConnected = false
            print("Socket: disconnected")
        }
        
        //added to detect disconnection by server killed
        self.socket.onAny({ (event) in
            if let string = event.items?.first as? String {
                if string == "Could not connect to the server." {
                    if !self.isConnected {return}
                    self.isConnected = false
                }
            }
        })

        

        self.socket.connect()
    
        
        self.socket.on("new-message") { [weak self] (dataArray, ack) -> Void in
            if let message = dataArray[0] as? [String: Any] {
                print("Socket: received message: \(message)")
                
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
                    let decoder = JSONDecoder()
                    self?.messageReceived = try decoder.decode(MessageModel.self, from: jsonData)
                    
                    print(self?.messageReceived.action?.rawValue)

                } catch {
                    print("could not parse message from socket server.")
                }
            }
        }
      
    }
    // Add your custom event listeners here
    
    func sendUserId(userId: String) {
        self.socket.emit("register-user", userId)
    }
    
    func deleteUserId(userId: String) {
        self.socket.emit("unregister-user", userId)
    }
}
