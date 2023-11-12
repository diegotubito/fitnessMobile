//
//  SplashView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @EnvironmentObject var deepLink: DeepLink

    var body: some View {
        VStack {
            Text("Splash View")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                if deepLink.deepLinkPath.isEmpty {
                    mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .home))
                } else {
                    setMainModalView()
                }
            })
        }
    }
    
    // repeat for when the user is not login, after log in we need to check deep link again.
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

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
