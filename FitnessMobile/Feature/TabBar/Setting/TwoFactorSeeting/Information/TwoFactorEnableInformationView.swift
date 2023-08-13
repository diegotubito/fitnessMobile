//
//  InformationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/08/2023.
//

import SwiftUI

struct TwoFactorEnableInformationView: View {
    @State var otpResult: OTPView.OPTResult = .none
    @EnvironmentObject var coordinator: Coordinator
    @State var shouldGoToOTP = false
    @State var shouldGoToRoor = false

    var body: some View {
        VStack {
            BasicButton(title: "Continue", style: .primary, isEnabled: .constant(true)) {
                shouldGoToOTP = true
            }
            
            BasicButton(title: "Root", style: .primary, isEnabled: .constant(true)) {
                coordinator.root()
            }
        }
        .onChange(of: shouldGoToOTP, perform: { newValue in
            switch otpResult {
            case .none:
                //init values here
                break
            case .otpBackButton:
                break
            case .otpSuccess:
                break
            case .otpBackButtonWithFailure:
                break
            }
        })
        .sheet(isPresented: $shouldGoToOTP, content: {
            OTPView(optResult: $otpResult)

        })
        .padding()
        
        
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        TwoFactorEnableInformationView()
    }
}
