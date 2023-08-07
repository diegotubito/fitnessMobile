//
//  AccountView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 07/08/2023.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewmodel = ProfileViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("profile_diego")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                    Text("David Diego Gomez")
                        .font(.title2)
                    Text("Diegotubito")
                    Spacer()

                }
            }
            VStack {
                CustomTextField(customTextFieldManager: viewmodel.firstNameTextField, title: "First name", placeholder: "", footer: "")
                CustomTextField(customTextFieldManager: viewmodel.lastNameTextField, title: "Last name", placeholder: "", footer: "")
                CustomTextField(customTextFieldManager: viewmodel.usernameTextField, title: "Username", placeholder: "", footer: "")
                CustomTextField(customTextFieldManager: viewmodel.phoneNumberTextField, title: "Phone number", placeholder: "", footer: "")
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
