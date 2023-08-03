//
//  HomeView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path) {
            Button("Go to level 1", action: {
                router.path.append(Router.Screen.level1(dependency: "mejor esto"))
            })
            
            Button("Go to level 2", action: {
                router.path.append(Router.Screen.level2)
            })
            .navigationDestination(for: Router.Screen.self) { value in
                switch value {
                case .home:
                    HomeView()
                case .level1(let dependency):
                    LevelOneView(dependency: dependency)
                case .level2:
                    LevelTwoView()
                }
            }

            .navigationTitle("Root view")
        }
        
    }
}

struct DetailView: View {
    let text: String
    var body: some View {
        VStack {
            Text("Detail view showing")
            Text(text)
        }
        .navigationTitle(text)
    }
}
