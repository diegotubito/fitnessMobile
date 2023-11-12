//
//  SplashView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator

    var body: some View {
        VStack {
            Text("Splash View")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                if UserSession.isRefreshTokenExpired {
                    mainModalCoordinator.modal = MainModalView(screen: .login)
                } else {
                    mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .home))
                }
            })
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
