//
//  HomeView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var socketManager: SocketIOManager
    
    @State var receivedMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text(receivedMessage)
            }
        }
        .onReceive(socketManager.$messageReceived) { value in
            print(value)
            receivedMessage = value.message
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
