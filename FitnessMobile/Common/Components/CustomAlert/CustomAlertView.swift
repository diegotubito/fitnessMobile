//
//  CustomAlertView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/08/2023.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    @Binding var title: LocalizedStringKey
    @Binding var message: LocalizedStringKey
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.clear
                        .ignoresSafeArea()
                        .background(.ultraThinMaterial)
                
                VStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color.Neutral.grayText)
                 
                    Text(message)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                        .foregroundColor(Color.Neutral.grayText)
                        .font(.subheadline)
        
                    Divider()
                    
                    Button {
                        isPresented = false
                    } label: {
                        VStack {
                            Text("OK")
                        }
                    }
                }
                .padding()
                .background(Color.Neutral.tone80)
                .cornerRadius(15)
                .padding(64)
            }
        }
    }
}
struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(isPresented: .constant(true), title: .constant("Title"), message: .constant("Message"))
    }
}
