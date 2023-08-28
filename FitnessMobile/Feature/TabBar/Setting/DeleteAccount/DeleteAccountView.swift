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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.Red.midnight, Color.black]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("_DELETE_ACCOUNT_TITLE")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone80)
                    Spacer()
                }
                .padding(.bottom)
                HStack {
                    Text("_DELETE_ACCOUNT_SUBTITLE")
                        .font(.subheadline)
                        .foregroundColor(Color.Dark.tone90)
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
        }
        .onReceive(viewmodel.$deleteResult, perform: { response in
            if response != nil {
                coordinator.path = NavigationPath()
                NotificationCenter.default.post(Notification(name: .MustLogin))
            }
        })
        .overlay {
            if viewmodel.isLoading {
                ProgressView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("_ALERT_CANCEL") {
                    coordinator.path.removeLast()
                }.disabled(false)
                    .foregroundColor(Color.Red.tone100)
            }
        })
    }
    
    func deleteAccount() {
        viewmodel.deleteAccount()
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
