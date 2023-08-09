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



struct PhoneNumberTextField: View {
    @State var text: String = ""
    @State var countryCodeText: String = ""
    
    @State var title: String
    @State var initValue: Phone?
    
    @State var showSheet: Bool = false
    @State var selectedCountry: Phone? {
        didSet {
            if let selectedCountry = selectedCountry {
                countryCodeText = "\(countryFlag(selectedCountry.countryCode))+\(selectedCountry.phoneCode)"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("Country")
                            .font(.callout)
                            .foregroundColor(Color.Dark.tone90)
                       
                    }
                    TextField("", text: $countryCodeText)
                        .padding(12)
                        .multilineTextAlignment(.center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .disabled(true)
                        .onTapGesture {
                            showSheet = true
                        }
                    
                }
                .frame(maxWidth: 90)
                
                VStack(spacing: 0) {
                    HStack {
                        Text(title)
                            .font(.callout)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                    }
                    TextField("", text: $text)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            CountryPickerView { country in
                selectedCountry = country
            }
        }
        .onAppear {
            let string = "\(countryFlag(initValue?.countryCode ?? ""))+\(initValue?.phoneCode ?? "")"
            countryCodeText = string
            text = initValue?.number ?? ""
        }
    }
}
