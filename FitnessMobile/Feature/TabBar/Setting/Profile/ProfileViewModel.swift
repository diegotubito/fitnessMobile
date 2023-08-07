//
//  ProfileViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 07/08/2023.
//

import SwiftUI

class ProfileViewModel: BaseViewModel {
    @Published var usernameTextField = CustomTextFieldManager()
    @Published var firstNameTextField = CustomTextFieldManager()
    @Published var lastNameTextField = CustomTextFieldManager()
    @Published var phoneNumberTextField = CustomTextFieldManager()
}
