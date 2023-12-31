//
//  OTPView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/08/2023.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var userSession: UserSession
    @StateObject var viewmodel = OTPViewModel()
    
    @FocusState private var focusedField: FocusedDigit?
    @State var shouldSendCode = false
    @State var isLoading = false
    @Environment(\.dismiss) var dismiss
 
    @Binding var optResult: OPTResult
    @State var errorMessage: LocalizedStringKey = ""
    
    enum OPTResult {
        case none
        case otpBackButton
        case otpSuccess
        case otpBackButtonWithFailure
        case enableConfirmed
    }
    
    enum FocusedDigit {
        case first
        case second
        case third
        case fourth
        case fifth
        case sixth
    }
    
    @ViewBuilder
    func genericTextField(digit: Binding<String>, currentTextField: FocusedDigit) -> some View {
        TextField("", text: digit)
            .frame(height: 70)
            .keyboardType(.numberPad)
            .background(focusedField == currentTextField ? .red : .gray)
            .font(.system(size: 42))
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .accentColor(.clear)
            .focused($focusedField, equals: currentTextField)
    }

    var body: some View {
        VStack {
            HStack {
                genericTextField(digit: $viewmodel.firstDigit, currentTextField: .first)
                    .onChange(of: viewmodel.firstDigit, perform: { newValue in
                        if focusedField == .first && newValue == " " { return }
                        if newValue.isEmpty {
                            focusedField = .first
                        } else {
                            viewmodel.firstDigit = viewmodel.firstDigit.trimmingCharacters(in: .whitespaces)
                            viewmodel.firstDigit = String(viewmodel.firstDigit.prefix(1))
                            focusedField = .second
                            errorMessage = ""
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .first {
                            viewmodel.firstDigit = " "
                            viewmodel.secondDigit = " "
                            viewmodel.thirdDigit = " "
                            viewmodel.fourthDigit = " "
                            viewmodel.fifthDigit = " "
                            viewmodel.sixthDigit = " "
                        }
                    }
                
                
                genericTextField(digit: $viewmodel.secondDigit, currentTextField: .second)
                    .onChange(of: viewmodel.secondDigit, perform: { newValue in
                        if focusedField == .second && newValue == " " { return }
                        if focusedField == .second {
                            if newValue.isEmpty {
                                focusedField = .first
                            } else {
                                viewmodel.secondDigit = viewmodel.secondDigit.trimmingCharacters(in: .whitespaces)
                                viewmodel.secondDigit = String(viewmodel.secondDigit.prefix(1))
                                focusedField = .third
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .second {
                            viewmodel.secondDigit = " "
                            viewmodel.thirdDigit = " "
                            viewmodel.fourthDigit = " "
                            viewmodel.fifthDigit = " "
                            viewmodel.sixthDigit = " "
                        }
                    }
                
                genericTextField(digit: $viewmodel.thirdDigit, currentTextField: .third)
                    .onChange(of: viewmodel.thirdDigit, perform: { newValue in
                        if focusedField == .third && newValue == " " { return }
                        if focusedField == .third {
                            if newValue.isEmpty {
                                focusedField = .second
                            } else {
                                viewmodel.thirdDigit = viewmodel.thirdDigit.trimmingCharacters(in: .whitespaces)
                                viewmodel.thirdDigit = String(viewmodel.thirdDigit.prefix(1))
                                focusedField = .fourth
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .third {
                            viewmodel.thirdDigit = " "
                            viewmodel.fourthDigit = " "
                            viewmodel.fifthDigit = " "
                            viewmodel.sixthDigit = " "
                        }
                    }
                
                genericTextField(digit: $viewmodel.fourthDigit, currentTextField: .fourth)
                    .onChange(of: viewmodel.fourthDigit, perform: { newValue in
                        if focusedField == .fourth && newValue == " " { return }
                        if focusedField == .fourth {
                            if newValue.isEmpty {
                                focusedField = .third
                            } else {
                                viewmodel.fourthDigit = viewmodel.fourthDigit.trimmingCharacters(in: .whitespaces)
                                viewmodel.fourthDigit = String(viewmodel.fourthDigit.prefix(1))
                                focusedField = .fifth
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .fourth {
                            viewmodel.fourthDigit = " "
                            viewmodel.fifthDigit = " "
                            viewmodel.sixthDigit = " "
                        }
                    }
                
                genericTextField(digit: $viewmodel.fifthDigit, currentTextField: .fifth)
                    .onChange(of: viewmodel.fifthDigit, perform: { newValue in
                        if focusedField == .fifth && newValue == " " { return }
                        if focusedField == .fifth {
                            if newValue.isEmpty {
                                focusedField = .fourth
                            } else {
                                viewmodel.fifthDigit = viewmodel.fifthDigit.trimmingCharacters(in: .whitespaces)
                                viewmodel.fifthDigit = String(viewmodel.fifthDigit.prefix(1))
                                focusedField = .sixth
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .fifth {
                            viewmodel.fifthDigit = " "
                            viewmodel.sixthDigit = " "
                        }
                    }
                
                
                genericTextField(digit: $viewmodel.sixthDigit, currentTextField: .sixth)
                    .onChange(of: viewmodel.sixthDigit, perform: { newValue in
                        if focusedField == .sixth && newValue == " " { return }
                        if focusedField == .sixth {
                            if newValue.isEmpty {
                                focusedField = .fifth
                            } else {
                                viewmodel.sixthDigit = viewmodel.sixthDigit.trimmingCharacters(in: .whitespaces)
                                viewmodel.sixthDigit = String(viewmodel.sixthDigit.prefix(1))
                                focusedField = nil
                                shouldSendCode = true
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .sixth {
                            viewmodel.sixthDigit = " "
                        }
                    }
            }
            .padding()
            if !errorMessage.stringKey.isEmpty {
                Text(errorMessage)
                    .foregroundColor(Color.Red.tone90)
            }
            
        }
        .overlay(
            Group {
                if viewmodel.isLoading {
                    // A transparent view that captures all touches, making underlying views non-interactive
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle()) // Makes the entire view tappable
                            .onTapGesture { }
                            .allowsHitTesting(true) // Captures all touches
                        ProgressView()
                    }
                } else {
                    Color.clear
                        .contentShape(Rectangle()) // Makes the entire view tappable
                        .allowsHitTesting(false) // Captures all touches
                }
            }
        )
        .padding(.horizontal)
        .onAppear {
            focusedField = .first
            optResult = .otpBackButton
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("_KEYBOARD_DONE_BUTTON") {
                    focusedField = nil
                }
             }
        }
        .onChange(of: shouldSendCode) { shouldSend in
            if shouldSend {
                verify2FA()
            }
        }
    }
    
    func verify2FA() {
        viewmodel.verify2FA(tempToken: UserSession.getTempToken()) { result in
            if let result = result {
                UserSession.saveUser(user: result.user)
                UserSession.saveAccessToken(value: result.accessToken)
                UserSession.saveAccessTokenExpirationDate(value: result.accessTokenExpirationDateString)
                optResult = .otpSuccess
                dismiss()
            } else {
                errorMessage = viewmodel.errorMessage
                focusedField = .first
                shouldSendCode.toggle()
                optResult = .otpBackButtonWithFailure
            }
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(optResult: .constant(.none))
    }
}
