//
//  InvitationListView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 18/09/2023.
//

import SwiftUI

struct InvitationListView: View {
    @StateObject var viewmodel: InvitationListViewModel
    @State var shouldPresentSheet = false
    
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
                            shouldPresentSheet = true
                            viewmodel.selectedInvitation = invitation
                        }
                }
            }
        }
        .sheet(isPresented: $shouldPresentSheet, content: {
            if shouldPresentSheet {
                VStack {
                    Text("_REMOVE_INVITATION_TITLE")
                        .padding()
                        .font(.title)
                    Text(viewmodel.subtitle)
                        .font(.subheadline)
                    Spacer()

                    HStack {
                        BasicButton(title: "_REMOVE_INVITATION_CANCEL_BUTTON", style: .secondary, isEnabled: .constant(true)) {
                            self.shouldPresentSheet = false
                        }
                        BasicButton(title: "_REMOVE_INVITATION_REMOVE_BUTTON", style: .destructive, isEnabled: .constant(true)) {
                            self.viewmodel.deleteInvitationById(_id: viewmodel.selectedInvitation?._id ?? "")
                            self.shouldPresentSheet = false
                        }
                    }
                }
                .padding(32)
                .presentationDetents([.medium, .fraction(0.35)])
                .presentationBackground(Color.Blue.midnight)
            }
            
        })
        .onAppear {
            viewmodel.fetchInvitationsByWorkspace()
        }
        .onReceive(viewmodel.$onDeletedInvitation) { isDeleted in
            if isDeleted {
                viewmodel.fetchInvitationsByWorkspace()
            }
        }
    }
}
