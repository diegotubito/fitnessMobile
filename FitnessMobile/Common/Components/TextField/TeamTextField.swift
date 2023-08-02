//
//  TeamTextField.swift
//  HayEquipo
//
//  Created by David Gomez on 15/05/2023.
//

import SwiftUI

struct TeamTextField: View {
    @Binding var text: String
    @State var title: String
    
    var body: some View {
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

struct TeamTextField_Previews: PreviewProvider {
    static var previews: some View {
        TeamTextField(text: .constant("df"), title: "test")
    }
}
