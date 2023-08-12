//
//  CountryPickerView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 09/08/2023.
//

import SwiftUI

struct CountryPickerView: View {
    @StateObject var viewmodel = CountryPickerViewModel()
    @Environment(\.dismiss) var dismiss
    
    var selectedCountry: (Phone) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewmodel.filteredCountries, id: \.self) { phone in
                    HStack {
                        Text(countryFlag(phone.countryCode))
                        Text(phone.countryName)
                        Spacer()
                        Text("+\(phone.phoneCode)")
                    }
                    .onTapGesture {
                        selectedCountry(phone)
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $viewmodel.searchText)
    }
}

struct CountryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CountryPickerView(selectedCountry: {_ in
            
        })
    }
}
