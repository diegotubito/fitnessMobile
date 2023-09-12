//
//  WorkspaceSecondStepView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 09/09/2023.
//

import SwiftUI

struct WorkspaceAddressView: View {
    @StateObject var manager = WorkspaceAddressViewModel()
    
    var body: some View {
        VStack {
            CustomTextField(customTextFieldManager: manager.addressTextField, title: "", placeholder: "", footer: "") { newString in
                
            } onDidBegin: { didBegin in
                
            }
            
            Spacer()
            
            Button("Verify Address") {
                manager.verifyAddress()
            }
        }
        .onReceive(manager.$onValidAddress, perform: { isValid in
            if isValid {
                
            }
        })
        .padding()
    }
}
