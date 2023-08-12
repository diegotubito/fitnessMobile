//
//  TeamTextField.swift
//  HayEquipo
//
//  Created by David Gomez on 15/05/2023.
//

import SwiftUI

func countryFlag(_ countryCode: String) -> String {
    String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
        UnicodeScalar(127397 + $0.value)
    }))
}

func countryName(_ countryCode: String) -> String {
    return Locale.current.localizedString(forRegionCode: countryCode) ?? ""
}


class PhoneNumberTextFieldManager: ObservableObject {
    @Published var text: String = ""
    @Published var countryCodeText: String = ""
    @Published var phone: Phone = Phone(countryName: "", number: "", phoneCode: "", countryCode: "")
}

struct PhoneTextField: View {
    var phone: Phone
    @Binding var textFieldManager: PhoneNumberTextFieldManager
    @State var showSheet: Bool = false
    @FocusState var currentFocus: States?
    
    enum States: Hashable {
        case phonenumber
    }
    
    func setTextFields() {
        let countryCode = textFieldManager.phone.countryCode
        let countryName = textFieldManager.phone.countryName
        let phoneCode = textFieldManager.phone.phoneCode
        let flag = countryFlag(countryCode)
        textFieldManager.countryCodeText = "\(flag) \(countryName)(+\(phoneCode))"
        textFieldManager.text = textFieldManager.phone.number
    }
    
    var onChanged: ((String) -> Void)
    var onDidBegin: ((Bool) -> Void)
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("_COUNTRY_TEXTFIELD_TITLE")
                            .font(.callout)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                        
                    }
                    TextField("", text: $textFieldManager.countryCodeText)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .disabled(true)
                        .onTapGesture {
                            showSheet = true
                            onDidBegin(true)
                            currentFocus = .phonenumber
                        }
                    
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Text("_PHONE_NUMBER_TEXTFIELD_TITLE")
                            .font(.callout)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    TextField("", text: $textFieldManager.text) { beginEditing in
                        onDidBegin(beginEditing)
                    }
                    .keyboardType(.numberPad)
                    .padding(12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .focused($currentFocus, equals: .phonenumber)
                    .onChange(of: textFieldManager.text) { newValue in
                        textFieldManager.phone.number = newValue
                        onChanged(newValue)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("_KEYBOARD_DONE_BUTTON") {
                                currentFocus = nil
                                onDidBegin(false)
                            }
                         }
                    }
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            CountryPickerView { country in
                textFieldManager.phone = country
                textFieldManager.phone.number = textFieldManager.text
                setTextFields()
            }
        }
        .onAppear {
            textFieldManager.phone = phone
            textFieldManager.text = phone.number
            setTextFields()
        }
    }
}
