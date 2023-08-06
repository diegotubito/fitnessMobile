//
//  FullscreenView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 05/08/2023.
//

import SwiftUI

struct FullscreenView: View {
    @EnvironmentObject var coordinator: Coordinator
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
            Button {
                coordinator.closeModal()
            } label: {
                Text("Close View")
            }

        }
        .navigationTitle("Fullscreen Cover")
    }
}

struct FullscreenView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            FullscreenView(text: "")
        }.environmentObject(coordinator)
    }
}
