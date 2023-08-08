//
//  View+Extension.swift
//  HayEquipo
//
//  Created by David Gomez on 02/05/2023.
//

import SwiftUI

extension View {
    func presentLoginAsModal(shouldNavigate: Binding<Bool>) -> some View {
        self.fullScreenCover(isPresented: shouldNavigate, content: {
            LoginView(presentLoginAsModal: true)
        })
    }
}
