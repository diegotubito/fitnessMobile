//
//  ContentView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 31/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var socketIOManager = SocketIOManager()
    
    @State var presentLogin = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("Login") {
                presentLogin = true
            }
        }
        .padding()
        .onAppear {
            presentLogin = true
        }
        .onDisappear {
            socketIOManager.socket.disconnect()
        }
        .presentLoginAsModal(shouldNavigate: $presentLogin)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
