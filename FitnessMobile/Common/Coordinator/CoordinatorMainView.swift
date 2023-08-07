//
//  MainView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 05/08/2023.
//

import SwiftUI

struct CoordinatorMainView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var userSession: UserSessionManager
    
    @State var currentPage: Coordinator.PageView = .tabbar
   
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.getPage(currentPage)
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.getSheet(sheet)
                        .presentationDetents([.medium])
                }
                .navigationDestination(for: Coordinator.PageView.self) { page in
                    coordinator.getPage(page)
                }
                .fullScreenCover(item: $coordinator.modal) { modal in
                    coordinator.getModal(modal)
                }
                .alert(isPresented: $coordinator.showAlert) {
                    switch coordinator.alertDetail?.alertStyle ?? .primary {
                    case .primary:
                        return Alert(
                            title: Text(coordinator.alertDetail?.title ?? ""),
                            message: Text(coordinator.alertDetail?.message ?? ""),
                            dismissButton: .cancel(Text(coordinator.alertDetail?.primaryButtonTitle ?? "OK"), action: coordinator.completion)
                        )
                    case .secondary:
                        return Alert(
                            title: Text(coordinator.alertDetail?.title ?? ""),
                            message: Text(coordinator.alertDetail?.message ?? ""),
                            primaryButton: .cancel(Text(coordinator.alertDetail?.primaryButtonTitle ?? "_ALERT_CANCEL"), action: coordinator.primaryTapped),
                            secondaryButton: .default(Text(coordinator.alertDetail?.secondaryButtonTitle ?? "_ALERT_ACCEPT"), action: coordinator.secondaryTapped)
                        )
                    case .destructive:
                        return Alert(
                            title: Text(coordinator.alertDetail?.title ?? ""),
                            message: Text(coordinator.alertDetail?.message ?? ""),
                            primaryButton: .destructive(Text(coordinator.alertDetail?.primaryButtonTitle ?? "_ALERT_REMOVE"), action: coordinator.primaryTapped),
                            secondaryButton: .cancel(Text(coordinator.alertDetail?.secondaryButtonTitle ?? "_ALERT_CANCEL"), action: coordinator.secondaryTapped)
                        )
                    }
                }
                .onChange(of: networkMonitor.isConnected, perform: { isConnected in
                    if !isConnected {
                        coordinator.presentModal(.noInternet)
                    }
                })
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("Active")
                        userSession.checkUser()
                    } else if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .background {
                        print("Background")
                    }
                }
                .onChange(of: userSession.didLogOut) { _ in
                    currentPage = .login
                }
                .onChange(of: userSession.didLogIn) { _ in
                    currentPage = .tabbar
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var coordinator = Coordinator()
    
    static var previews: some View {
        NavigationStack {
            CoordinatorMainView()
        }
        .environmentObject(coordinator)
    }
}
