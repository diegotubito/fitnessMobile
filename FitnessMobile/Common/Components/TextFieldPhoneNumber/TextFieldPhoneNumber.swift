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

struct PhoneNumberTextField: View {
    var phone: Phone
    @Binding var textFieldManager: PhoneNumberTextFieldManager
    @State var showSheet: Bool = false
 
    func setTextFields() {
        let countryCode = textFieldManager.phone.countryCode
        let countryName = textFieldManager.phone.countryName
        let phoneCode = textFieldManager.phone.phoneCode
        let flag = countryFlag(countryCode)
        textFieldManager.countryCodeText = "\(flag) \(countryName)(+\(phoneCode))"
        textFieldManager.text = textFieldManager.phone.number
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Country")
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
                        }
                    
                }
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Phone number")
                            .font(.callout)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    TextField("", text: $textFieldManager.text)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            CountryPickerView { country in
                // country comes with an empty number, let's fix that issue.
                var selectedPhone = country
                selectedPhone.number = phone.number
                textFieldManager.phone = selectedPhone
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
