//
//  CustomNavigationButton.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

struct CustomNavigationButton: View {
    var action: () -> Void
    var title: LocalizedStringKey
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 14))
        .background(Color.Blue.midnight)  // Your background color
        .cornerRadius(5.0)
    }
}

struct CustomNavigationBackButton: View {
    var action: () -> Void
    var title: LocalizedStringKey = "_BACK_BUTTON"
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 5))
        .background(Color.Blue.midnight)  // Your background color
        .cornerRadius(5.0)
    }
}
