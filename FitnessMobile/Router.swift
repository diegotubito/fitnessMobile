//
//  HomeNavigationManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path: NavigationPath
    
    init() {
        path = NavigationPath()
    }
    
    func pop() {
        path.removeLast()
    }
    
    func push(_ value: any Hashable) {
        path.append(value)
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    enum Screen: Hashable {
        case home
        case level1(dependency: String)
        case level2
    }
}
