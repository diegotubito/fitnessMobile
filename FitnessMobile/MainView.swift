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
        case tabbar(bar: TabBarView.Tab)
        case login
    }
}

struct MainView: View {
    @StateObject var mainModalCoordinator = MainModalCoordinator()
    @Environment(\.scenePhase) var scenePhase
    @StateObject var deepLink = DeepLink()
    @State var firstTime = true
    
    var body: some View {
        VStack {
            Text("Welcome...")
        }
        .fullScreenCover(item: $mainModalCoordinator.modal) { modal in
            switch modal.screen {
            case .splash:
                SplashView()
            case .tabbar(bar: let bar):
                TabBarView(selectedTab: .constant(bar))
            case .login:
                LoginView(allowSighUp: true)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if UserSession.isRefreshTokenExpired {
                    mainModalCoordinator.modal = MainModalView(screen: .login)
                }
                print("Active")
               
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if UserSession.isRefreshTokenExpired {
                    mainModalCoordinator.modal = MainModalView(screen: .login)
                } else {
                    if deepLink.deepLinkPath.isEmpty {
                        mainModalCoordinator.modal = MainModalView(screen: .splash)
                    } else {
                        setMainModalView()
                    }
                }
            })
        }
        .onOpenURL { url in
            deepLink.parseURL(url)
            if !UserSession.isRefreshTokenExpired {
               // setMainModalView()
            }
        }
        .environmentObject(mainModalCoordinator)
        .environmentObject(deepLink)
    }
    
    func setMainModalView() {
        switch deepLink.host {
        case "tabbar-home":
            mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .home))
        case "tabbar-setting":
            mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .settings))
        default:
            break
        }
    }
}

#Preview {
    MainView()
}


class DeepLink: ObservableObject {
    @Published var deepLinkPath: [String] = []
    var queryParams: [String: Any] = [:]
    var host: String = ""
    
    func parsePath(path: String) {
        if path.isEmpty { return }
        deepLinkPath = path.components(separatedBy: "/")
        
    }
    
    func parseURL(_ url: URL) {
        guard
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }

        // Process path components, skipping the first "/".
        let pathComponents = url.path().components(separatedBy: "/")

        // Process query items.
        var queryItemsDict = [String: Any]()
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryItemsDict[item.name] = item.value
            }
        }
        host = url.host() ?? ""
        deepLinkPath = pathComponents
        queryParams = queryItemsDict
    }
}
