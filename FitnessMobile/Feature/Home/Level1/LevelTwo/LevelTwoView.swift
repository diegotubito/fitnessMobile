//
//  LevelTwoView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct LevelTwoView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Text("Level 2")

        BasicButton(title: "back to root", style: .primary, isEnabled: .constant(true)) {
            router.popToRoot()
        }
    }
}

struct LevelTwoView_Previews: PreviewProvider {
    static var previews: some View {
        LevelTwoView()
    }
}
