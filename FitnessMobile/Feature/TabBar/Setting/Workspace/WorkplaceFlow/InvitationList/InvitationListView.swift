//
//  InvitationListView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

struct InvitationListView: View {
    @StateObject var viewmodel: InvitationListViewModel
    
    var body: some View {
        VStack {
            ForEach(viewmodel.invitations, id: \.self) { invitation in
                HStack {
                    Text("\(invitation.user.email)")
                    Text("\(invitation.status)")
                    
                    Spacer()
                    Image(systemName: "trash")
                        .foregroundColor(Color.Red.truly)
                        .onTapGesture {
                            
                        }
                }
            }
        }
        .onAppear {
            viewmodel.fetchInvitationsByWorkspace()
        }
    }
}
