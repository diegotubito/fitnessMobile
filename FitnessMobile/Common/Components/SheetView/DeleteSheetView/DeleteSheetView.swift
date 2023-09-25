//
//  DeleteSheetView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 24/09/2023.
//

import SwiftUI

struct DeleteSheetView: View {
    @State var title: LocalizedStringKey
    @State var subtitle: LocalizedStringKey

    var onTapped: ((OptionTapped) -> Void)
    
    init(title: LocalizedStringKey, subtitle: LocalizedStringKey, onTapped: @escaping (OptionTapped) -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.onTapped = onTapped
    }
    
    enum OptionTapped {
        case accept
        case cancel
    }
    
    var body: some View {
        VStack {
            Text(title)
                .padding()
                .font(.title)
            Text(subtitle)
                .font(.subheadline)
            Spacer()
            HStack {
                BasicButton(title: "_REMOVE_MEMBER_CANCEL_BUTTON", style: .secondary, isEnabled: .constant(true)) {
                    onTapped(.cancel)
                }
                BasicButton(title: "_REMOVE_MEMBER_REMOVE_BUTTON", style: .destructive, isEnabled: .constant(true)) {
                    onTapped(.accept)
                }
            }
        }
        .padding()
    }
}

struct DeleteSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSheetView(title: "Test", subtitle: "Abc", onTapped: { tapped in
            
        })
    }
}
