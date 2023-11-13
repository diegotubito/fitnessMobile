//
//  SplashView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @StateObject var viewmodel = SplashViewModel()
    
    var body: some View {
        VStack {
            Text("Splash View")
        }
        .onAppear {
            viewmodel.loadWorkspaces()
        }
        .onChange(of: viewmodel.workspaces) { oldValue, newValue in
            mainModalCoordinator.modal = MainModalView(screen: .tabbar(bar: .home))
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
