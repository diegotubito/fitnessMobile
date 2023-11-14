//
//  LoginView.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewmodel = LoginViewModel()
    @State var showAlert = false
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @State var shouldGoToOTP = false
    @State var otpResult: OTPView.OPTResult = .none
    
    var allowSighUp: Bool
    @State var shouldPresentSignUp = false
    
    var body: some View {
    
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight, Color.Green.midnight]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    
                    HStack {
                        Text("_LOGIN_TITLE")
                            .font(.title)
                            .foregroundColor(Color.Neutral.tone80)
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text("_ALREADY_HAVE_ACCOUNT_MESSAGE")
                                .font(.subheadline)
                                .lineLimit(2, reservesSpace: true)
                                .foregroundColor(Color.Neutral.tone80)
                                .lineLimit(0)
                            Spacer()
                        }
                        VStack(spacing: 16) {
                            TextField("_USERNAME", text: $viewmodel.username)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                            SecureField("_PASSWORD", text: $viewmodel.password)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        
                        VStack(spacing: 16) {
                            BasicButton(title: "_LOGIN_BUTTON_TITLE", style: .primary, isEnabled: .constant(true)) {
                                perfomrLogin()
                            }
                           
                        }
                    }
                    
                    if allowSighUp {
                        VStack {
                            Divider()
                            
                            HStack {
                                Text("_CREATE_ACCOUNT_MESSAGE")
                                    .font(.subheadline)
                                    .lineLimit(2, reservesSpace: true)
                                    .foregroundColor(Color.Neutral.tone80)
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            HStack {
                                Button {
                                    shouldPresentSignUp = true
                                } label: {
                                    Text("_SIGNUP")
                                        .foregroundColor(.accentColor)
                                }
                                Spacer()
                            }
                            
                            Divider()
                        }
                    }
                    
                    List(viewmodel.users, id: \.self) { user in
                        VStack {
                            Text(user.email)
                        }
                        .onTapGesture {
                            self.viewmodel.username = user.email
                            self.viewmodel.password = "admin1234"
                        }
                    }
                    .scrollContentBackground(.hidden)
                    
                }
                .padding()
            }
            .navigationDestination(isPresented: $shouldPresentSignUp) {
                SignUpView()
            }
            
        }
        .onAppear(perform: {
            UserSession.removeUserSession()
            Task {
                await viewmodel.loadUsers()
            }
        })
        .onChange(of: shouldGoToOTP, perform: { newValue in
            switch otpResult {
            case .none, .enableConfirmed:
                break
            case .otpBackButton:
                break
            case .otpSuccess:
                loginSuccessful()
            case .otpBackButtonWithFailure:
                break
            }
        })
        .sheet(isPresented: $shouldGoToOTP, content: {
            OTPView(optResult: $otpResult)

        })
        .onReceive(viewmodel.$loginResponse) { response in
            if let response = response {
                UserSession.saveUser(user: response.user)
                UserSession.saveAccessToken(value: response.accessToken)
                UserSession.saveRefreshToken(value: response.refreshToken)
                UserSession.saveAccessTokenExpirationDate(value: response.accessTokenExpirationDateString)
                UserSession.saveRefreshTokenExpirationDate(value: response.refreshTokenExpirationDateString)
                UserSession.saveTempToken(value: response.tempToken)
                if response.user.twoFactorEnabled {
                    shouldGoToOTP = true
                    return
                }
                loginSuccessful()
            }
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        
    }
    
    func perfomrLogin() {
        viewmodel.doLogin()
    }
    
    func loginSuccessful() {
        mainModalCoordinator.modal = MainModalView(screen: .splash)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(allowSighUp: true)
    }
}
