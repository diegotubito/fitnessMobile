//
//  MainView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/11/2023.
//

import SwiftUI

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
        case tabbar
        case login
    }
}

struct MainView: View {
    @StateObject var mainModalCoordinator = MainModalCoordinator()
    
    var body: some View {
        VStack {
            Text("Welcome...")
        }
        .fullScreenCover(item: $mainModalCoordinator.modal) { modal in
            switch modal.screen {
            case .splash:
                SplashView()
            case .tabbar:
                TabBarView()
            case .login:
                LoginView(allowSighUp: true)
            }
        }
        .onAppear {
            mainModalCoordinator.modal = MainModalView(screen: .splash)
        }
        .environmentObject(mainModalCoordinator)
    }
}

#Preview {
    MainView()
}
