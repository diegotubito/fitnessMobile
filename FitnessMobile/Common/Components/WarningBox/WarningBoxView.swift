//
//  WarningBoxView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 11/09/2023.
//

import SwiftUI

struct WarningBoxView: View {
    @State var title: LocalizedStringKey
    @State var message: LocalizedStringKey
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                HStack {
                    Text(title)
                        .foregroundColor(Color.Dark.tone120)
                        .font(.headline)
                        .padding(.bottom, 4)
                    Spacer()
                }
                HStack {
                    Text(message)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
            .padding()
            .foregroundColor(Color.Dark.tone110)
            .background(Color.Neutral.tone70)
            .border(Color.Neutral.placeholder, width: 0.3)
            .shadow(radius: 5)
            .cornerRadius(10)
        }
    }
}

struct WarningBoxView_Previews: PreviewProvider {
    static var previews: some View {
        WarningBoxView(title: "Title", message: "Remeber that verifying your address is mandatory to be visible in user's area. Otherwise, you potential clients would never know you are running a business. Remeber that verifying your address is mandatory to be visible in user's area. Otherwise, you potential clients would never know you are running a business. ")
    }
}
