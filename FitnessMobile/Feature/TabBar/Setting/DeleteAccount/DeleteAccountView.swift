//
//  DeleteAccount.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

struct DeleteAccountView: View {
    @StateObject var viewmodel = DeleteAccountViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        VStack {
            HStack {
                Text("_DELETE_ACCOUNT_TITLE")
                    .font(.title)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Text("_DELETE_ACCOUNT_SUBTITLE")
                Spacer()
            }
            Spacer()
            HStack {
                BasicButton(title: "_DELETE_ACCOUNT", style: .destructive, isEnabled: .constant(true)) {
                    coordinator.presentDesctructiveAlert(title: "_DELETE_ACCOUNT_BUTTON_TITLE", message: "_DELETE_ACCOUNT_BUTTON_MESSAGE") {
                        deleteAccount()
                    } secondaryTapped: { }
                }
            }
        }
        .padding()
        .overlay {
            if viewmodel.isLoading {
                ProgressView()
            }
        }
    }
    
    func deleteAccount() {
        viewmodel.deleteAccount { response in
            if response == nil {
                coordinator.presentPrimaryAlert(title: viewmodel.errorTitle, message: viewmodel.errorMessage) {}
            } else {
                coordinator.path = NavigationPath()
                NotificationCenter.default.post(Notification(name: .MustLogin))
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
