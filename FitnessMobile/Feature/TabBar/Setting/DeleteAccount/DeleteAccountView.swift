//
//  DeleteAccount.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

struct DeleteAccountView: View {
    @StateObject var viewmodel = DeleteAccountViewModel()
    @EnvironmentObject var settingCoordinator: SettingCoordinator
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @EnvironmentObject var userSession: UserSession
    @State var showAlertDeleteAccount = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.Red.midnight, Color.black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("_DELETE_ACCOUNT_TITLE")
                        .font(.largeTitle)
                        .foregroundColor(Color.Dark.tone30)
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
                        showAlertDeleteAccount = true
                    }
                    .alert(isPresented: $showAlertDeleteAccount) {
                        Alert(title: Text("_DELETE_ACCOUNT_BUTTON_TITLE"),
                              message: Text("_DELETE_ACCOUNT_BUTTON_MESSAGE"),
                              primaryButton: .destructive(Text("_DELETE_ACCOUNT"), action: {
                            deleteAccount()
                        }),
                              secondaryButton: .cancel()
                        )
                    }
                }
            }
            .padding()
        }
        .onReceive(viewmodel.$deleteResult, perform: { response in
            if response != nil {
                mainModalCoordinator.modal = MainModalView(screen: .login)
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
                    settingCoordinator.path.removeLast()
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
