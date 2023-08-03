//
//  OfflineView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct OfflineView: View {
    @EnvironmentObject var connection: Connection
    
    var body: some View {
        Text("Offline: Server is not connected. \(String(connection.state.hashValue))")
    }
}

struct OfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineView()
    }
}
