//
//  HomeView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Button("Push View", action: {
                coordinator.push(.pushView)
            })
            
            Button("Sheet View", action: {
                coordinator.presentSheet(.tac)
            })

            Button("Fullscreen View", action: {
                coordinator.presentModal(.fullscreenView(text: "this text is from other view"))
            })
            
            Button("Alert", action: {
                coordinator.presentDesctructiveAlert(title: "Title", message: "Message") {
                    print("primary tapped")
                } secondaryTapped: {
                    print("secondary tapped")
                }

            })
            
           
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
        .environmentObject(coordinator)
    }
}
