//
//  InvitationListView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

struct InvitationListView: View {
    @ObservedObject var viewmodel: InvitationListViewModel
    
    var trushTapped: ((InvitationModel) -> Void)?
    
    var body: some View {
        VStack {
            ForEach(viewmodel.invitations, id: \.self) { invitation in
                VStack {
                    HStack {
                        Text("\(invitation.user.username)")
                            .font(.callout)
                        Spacer()
                        
                        if invitation.status == .pending {
                            Image(systemName: "trash")
                                .foregroundColor(Color.Red.truly)
                                .onTapGesture {
                                    self.trushTapped?(invitation)
                                }
                        }
                        
                        Text(NSLocalizedString(invitation.status.rawValue, comment: ""))
                            .font(.callout)
                        
                    }
                    .foregroundColor(Color.Neutral.tone90)
                    Divider()
                }
            }
        }
    }
}
