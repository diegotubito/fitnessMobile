//
//  OTPView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/08/2023.
//

import SwiftUI

struct OTPView: View {
    @StateObject var viewmodel = OTPViewModel()
    @State var firstDigit: String = ""
    @State var secondDigit: String = ""
    @State var thirdDigit: String = ""
    @State var fourthDigit: String = ""
    @FocusState private var focusedField: FocusedDigit?
    @State var shouldSendCode = false
    @State var isLoading = false
    @Environment(\.dismiss) var dismiss
 
    @Binding var optResult: OPTResult
    
    enum OPTResult {
        case none
        case otpBackButton
        case otpSuccess
        case optFailed
    }
    
    enum FocusedDigit {
        case first
        case second
        case third
        case fourth
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
                genericTextField(digit: $firstDigit, currentTextField: .first)
                    .onChange(of: firstDigit, perform: { newValue in
                        if focusedField == .first && newValue == " " { return }
                        if newValue.isEmpty {
                            focusedField = .first
                        } else {
                            firstDigit = firstDigit.trimmingCharacters(in: .whitespaces)
                            firstDigit = String(firstDigit.prefix(1))
                            focusedField = .second
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .first {
                            firstDigit = " "
                            secondDigit = " "
                            thirdDigit = " "
                            fourthDigit = " "
                        }
                    }
                
                
                genericTextField(digit: $secondDigit, currentTextField: .second)
                    .onChange(of: secondDigit, perform: { newValue in
                        if focusedField == .second && newValue == " " { return }
                        if focusedField == .second {
                            if newValue.isEmpty {
                                focusedField = .first
                            } else {
                                secondDigit = secondDigit.trimmingCharacters(in: .whitespaces)
                                secondDigit = String(secondDigit.prefix(1))
                                focusedField = .third
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .second {
                            secondDigit = " "
                            thirdDigit = " "
                            fourthDigit = " "
                        }
                    }
                
                genericTextField(digit: $thirdDigit, currentTextField: .third)
                    .onChange(of: thirdDigit, perform: { newValue in
                        if focusedField == .third && newValue == " " { return }
                        if focusedField == .third {
                            if newValue.isEmpty {
                                focusedField = .second
                            } else {
                                thirdDigit = thirdDigit.trimmingCharacters(in: .whitespaces)
                                thirdDigit = String(thirdDigit.prefix(1))
                                focusedField = .fourth
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .third {
                            thirdDigit = " "
                            fourthDigit = " "
                        }
                    }
                
                genericTextField(digit: $fourthDigit, currentTextField: .fourth)
                    .onChange(of: fourthDigit, perform: { newValue in
                        if focusedField == .fourth && newValue == " " { return }
                        if focusedField == .fourth {
                            if newValue.isEmpty {
                                focusedField = .third
                            } else {
                                fourthDigit = fourthDigit.trimmingCharacters(in: .whitespaces)
                                fourthDigit = String(fourthDigit.prefix(1))
                                focusedField = nil
                                shouldSendCode = true
                            }
                        }
                    })
                    .onChange(of: focusedField) { newValue in
                        if newValue == .fourth {
                            fourthDigit = " "
                        }
                    }
            }
            .padding()
            
            Text("Didn't get the code?")
            BasicButton(title: "Resend", style: .primary, isEnabled: .constant(true)) {
                
            }
        }
        .overlay(content: {
            if isLoading {
                ProgressView()
            }
        })
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
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    isLoading = false
                    optResult = .otpSuccess
                    dismiss()
                })
            }
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(optResult: .constant(.none))
    }
}
