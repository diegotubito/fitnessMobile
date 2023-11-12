//
//  TabBar.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/08/2023.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    
    enum Tab {
        case home
        case settings
    }
   
//    init(selectedTab: Tab) {
//        self.selectedTab = selectedTab
//        UITabBar.appearance().backgroundColor = UIColor(Color.Blue.midnight)
//    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "house")
                        Text("_TAB_BAR_HOME")
                    }
                    .tag(Tab.home)
                
                SettingView()
                    .frame(maxHeight: .infinity)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("_TAB_BAR_SETTING")
                    }
                    .tag(Tab.settings)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.home))
    }
}
