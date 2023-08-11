//
//  OTPView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/08/2023.
//

import SwiftUI

struct OTPView: View {
    @StateObject var viewmodel = OTPViewModel()
    var body: some View {
        Text("Hello, World!")
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
