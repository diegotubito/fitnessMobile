//
//  TabBarManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/11/2023.
//

import Foundation

class TabBarManager: ObservableObject {
    @Published var selectedTab: Tab
    @Published var shouldShowBusinness = false

    
    init(selectedTab: Tab) {
        self.selectedTab = selectedTab
    }
    
    enum Tab {
        case home
        case settings
        case bussiness
    }
    
    func doesHaveDefaultWorkspace() {
        let defaultWorkspace = DefaultWorkspace.getDefaultWorkspace()
        if defaultWorkspace != nil {
            shouldShowBusinness = true
        } else {
            shouldShowBusinness = false
        }
    }
}
