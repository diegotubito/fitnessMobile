//
//  TabBar.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/08/2023.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarManager: TabBarManager
    @EnvironmentObject var deepLink: DeepLink
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            TabView(selection: $tabBarManager.selectedTab) {
                HomeView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "house")
                        Text("_TAB_BAR_HOME")
                    }
                    .tag(TabBarManager.Tab.home)
                
                SettingView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("_TAB_BAR_SETTING")
                    }
                    .tag(TabBarManager.Tab.settings)
            }
        }
        .onAppear {
            setupTabBar()
            
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    setMainModalView()
                })
                print("Active")
               
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        
       
    }
    
    func setMainModalView() {
        switch deepLink.host {
        case "tabbar-home":
            tabBarManager.selectedTab = .home
        case "tabbar-setting":
            tabBarManager.selectedTab = .settings
        default:
            break
        }
    }
    
    func setupTabBar() {
        UITabBar.appearance().backgroundColor = UIColor(Color.Blue.midnight)
        UITabBar.appearance().backgroundImage = UIImage()
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(tabBarManager: TabBarManager(selectedTab: .home))
    }
}
