//
//  CustomAlertView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/08/2023.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var showError: Bool
    @Binding var title: LocalizedStringKey
    @Binding var message: LocalizedStringKey
    
    var body: some View {
        if showError {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color.Neutral.grayText)
                    Divider()
                    Text(message)
                        .foregroundColor(Color.Neutral.grayText)
                        .font(.subheadline)
                    Divider()
                    Button("OK") {
                        showError = false
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
            }
        }
    }
}
struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(showError: .constant(false), title: .constant(""), message: .constant(""))
    }
}
