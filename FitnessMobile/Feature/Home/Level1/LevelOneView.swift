//
//  LevelOneView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import SwiftUI

struct LevelOneView: View {
    @EnvironmentObject var router: Router
    
    var dependency: String
    
    var body: some View {
        VStack {
            Text("Level 1")
            Text(dependency)
            BasicButton(title: "second lavel", style: .primary, isEnabled: .constant(true)) {
                router.push(Router.Screen.level2)
            }
            BasicButton(title: "pop", style: .primary, isEnabled: .constant(true)) {
                router.pop()
            }
        }
        
    }
}

struct LevelOneView_Previews: PreviewProvider {
    static var previews: some View {
        LevelOneView(dependency: "abc")
                   .environmentObject(Router())
    }
}
