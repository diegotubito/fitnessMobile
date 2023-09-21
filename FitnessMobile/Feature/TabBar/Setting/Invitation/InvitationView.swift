//
//  InvitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import SwiftUI

struct InvitationView: View {
    @StateObject var viewmodel = InvitationViewModel()
    @EnvironmentObject var coordinator: Coordinator
    
    func invitationEmptyView() -> some View {
        return VStack {
            Text("No tienes invitaciones pendientes.")
        }
    }
    
    func invitationNonEmptyView() -> some View {
        return VStack {
            ForEach(viewmodel.invitations, id: \.self) { invitation in
                VStack(spacing: 0){
                   
                    HStack {
                        Text(invitation.workspace.title)
                            .font(.title3)
                        Spacer()
                    }
                    .padding()
                    
                    if let formattedAddress = invitation.workspace.location?.googleGeocode?.formattedAddress {
                        HStack {
                            Text(formattedAddress)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding([.horizontal, .bottom])
                    }
                    if invitation.status == "PENDING" {
                        HStack(spacing: 16) {
                            BasicButton(title: "Reject", style: .secondary, isEnabled: .constant(true)) {
                                viewmodel.rejectInvitation(invitation: invitation)
                            }
                            
                            BasicButton(title: "Accept", style: .primary, isEnabled: .constant(true)) {
                                viewmodel.acceptInvitation(invitation: invitation)
                            }
                        }
                        .padding()
                    } else {
                        HStack {
                            Text(invitation.status)
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding([.horizontal, .bottom])
                    }
                }
                .background(Color.Dark.tone100.opacity(0.5))
                .cornerRadius(10)
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    HStack {
                        Text("You've been invited to the following workspaces.")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    if viewmodel.invitations.isEmpty && !viewmodel.isLoading {
                        invitationEmptyView()
                    } else {
                        invitationNonEmptyView()
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            viewmodel.loadInvitationsByUserId()
        }
        .overlay(
            Group {
                CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                CustomProgressView(isLoading: $viewmodel.isLoading)
            }
        )
        .onReceive(viewmodel.$onAcceptedInvitation) { didAccept in
            if didAccept {
                viewmodel.loadInvitationsByUserId()
            }
        }
        .onReceive(viewmodel.$onRejectedInvitation) { didReject in
            if didReject {
                viewmodel.loadInvitationsByUserId()
            }
        }
    }
}

struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView()
    }
}
