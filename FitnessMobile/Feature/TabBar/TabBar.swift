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
    
    @EnvironmentObject var coordinator: Coordinator
    
    
    @State var shouldShowSplah = false
    
    var body: some View {
        VStack {
            if shouldShowSplah {
                SplashView(shouldShowSplash: $shouldShowSplah)
            } else {
                TabView {
                    HomeView()
                        .frame(maxHeight: .infinity)
                        .tabItem {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Around")
                        }
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
