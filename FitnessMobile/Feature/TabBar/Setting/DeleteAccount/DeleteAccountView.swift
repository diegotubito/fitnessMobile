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
    @EnvironmentObject var userSession: UserSessionManager
    
    var body: some View {
        VStack {
            HStack {
                Text("¿Deseas borrar la cuenta permanentemente?")
                    .font(.title)
                Spacer()
            }
            .padding(.bottom)
            HStack {
                Text("Esta acción borrará todos tus datos permanentemente de todas las bases de datos y no podra recuperarse.")
                Spacer()
            }
            Spacer()
            HStack {
                BasicButton(title: "Delete Account", style: .destructive, isEnabled: .constant(true)) {
                    coordinator.presentDesctructiveAlert(title: "Delete Account", message: "Are you sure you want to delete this account?") {
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
                coordinator.presentPrimaryAlert(title: "Account Delete", message: "Something went wrong") {}
            } else {
                userSession.removeUserSession()
                coordinator.path = NavigationPath()
            }
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
