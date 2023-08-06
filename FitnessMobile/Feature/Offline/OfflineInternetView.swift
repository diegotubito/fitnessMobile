//
//  OfflineView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct OfflineInternetView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text("Not Connected")
        }.onChange(of: networkMonitor.isConnected, perform: { isConnected in
            if isConnected {
                coordinator.closeModal()
            }
        })
    }
}

struct OfflineView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            OfflineInternetView()
        }
        .environmentObject(coordinator)
    }
}
