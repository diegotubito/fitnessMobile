//
//  InvitationListViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

class InvitationListViewModel: BaseViewModel {
    var invitations: [InvitationModel]
   
    init(invitations: [InvitationModel]) {
        self.invitations = invitations
    }
}

