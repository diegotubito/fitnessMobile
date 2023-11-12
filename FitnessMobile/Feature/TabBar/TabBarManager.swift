//
//  TabBarManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/11/2023.
//

import Foundation

class TabBarManager: ObservableObject {
    @Published var selectedTab: Tab
    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
    }
    
    enum Tab {
        case home
        case settings
    }
}
