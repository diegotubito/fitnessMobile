//
//  ModalCoordinator.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/11/2023.
//

import Combine

class MainModalCoordinator: ObservableObject {
    @Published var modal: MainModalView?
}

class MainModalView: Identifiable {
    var id: String?
    var screen: Screen
    
    init(screen: Screen) {
        self.screen = screen
    }

    enum Screen {
        case splash
        case tabbar(bar: TabBarManager.Tab)
        case login
    }
}
