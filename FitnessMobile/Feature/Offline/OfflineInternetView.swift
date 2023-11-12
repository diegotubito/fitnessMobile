//
//  OfflineView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct OfflineInternetView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            Text("Not Connected")
        }.onChange(of: networkMonitor.isConnected, perform: { isConnected in
            if isConnected {
                mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .home))
            }
        })
    }
}

struct OfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineInternetView()
    }
}
