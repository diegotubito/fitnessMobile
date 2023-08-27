//
//  CustomProgressView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/08/2023.
//

import SwiftUI

struct CustomProgressView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                }
            }
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(isLoading: .constant(false))
    }
}
