//
//  UserList.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

struct UserList: View {
    @EnvironmentObject var coordinator: CoordinatorLegacy
    @State var users: [User]
    
    var body: some View {
        VStack {
            List(users, id: \.self) { user in
                VStack {
                    Text(user.email)
                }
                .onTapGesture {
                    
                }
            }
        }
    }
}
