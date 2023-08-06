//
//  TabBar.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/08/2023.
//

import SwiftUI

struct TabBarView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.Blue.midnight)
    }
    
    var body: some View {
        VStack {
            TabView {
                HomeView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                SettingView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
            }
        }
        .onAppear {
            print("tabbar appeared")
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
