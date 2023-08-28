//
//  AccountView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 07/08/2023.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewmodel = ProfileViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss
    @FocusState var focus: Focus?
    
    enum Focus: Hashable {
        case name
        case surname
        case phone
    }
   
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {

                ScrollView {
                    
                    VStack {
                        CustomTextField(customTextFieldManager: viewmodel.firstNameTextField, title: "_FIRST_NAME", placeholder: "", footer: "", textFieldType: .ascii) { newValue in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.firstNameTextField.shouldShowError = false
                            } else {
                                focus = .surname
                                if !viewmodel.isValidFirstName {
                                    viewmodel.firstNameTextField.showError(message: "_FIRST_NAME_INCORRECT")
                                }
                            }
                        }
                        .focused($focus, equals: .name)
                    
                        CustomTextField(customTextFieldManager: viewmodel.lastNameTextField, title: "_LAST_NAME", placeholder: "", footer: ""){ newValue in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            if didBegin {
                                viewmodel.lastNameTextField.shouldShowError = false
                            } else {
                                focus = .phone
                                if !viewmodel.isValidLastName {
                                    viewmodel.lastNameTextField.showError(message: "_LAST_NAME_INCORRECT")
                                }
                            }
                        }
                        .focused($focus, equals: .surname)

                        PhoneTextField(textFieldManager: $viewmodel.phoneNumberTextField) { newValue in
                            viewmodel.validate()
                        } onDidBegin: { didBegin in
                            
                        }
                        .focused($focus, equals: .phone)

                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("_SETTING_PROFILE")
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("_ALERT_CANCEL") {
                    dismiss()
                }.disabled(viewmodel.disableCancelButton)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("_UPDATE_BUTTON") {
                    updateUser()
                }.disabled(viewmodel.disableSaveButton)
            }
            
        })
        .onReceive(viewmodel.$updateUserResult, perform: { result in
            if let result = result {
                UserSession.saveUser(user: result.user)
                coordinator.path.removeLast()
            }
        })
        .onAppear {
            focus = .name
            viewmodel.setupInitValues()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
    }
    
    func updateUser() {
        viewmodel.updateUser()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
