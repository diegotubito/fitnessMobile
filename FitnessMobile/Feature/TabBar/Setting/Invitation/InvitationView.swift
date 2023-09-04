//
//  InvitationView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import SwiftUI

struct InvitationView: View {
    @StateObject var viewmodel = InvitationViewModel()
    
    func invitationEmptyView() -> some View {
        return VStack {
            Text("No tienes invitaciones pendientes.")
        }
    }
    
    func invitationNonEmptyView() -> some View {
        return VStack {
            ForEach(viewmodel.invitations, id: \.self) { invitation in
                Text(invitation.workspace.title)
                Text(invitation.status)
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if viewmodel.invitations.isEmpty {
                invitationEmptyView()
            } else {
                invitationNonEmptyView()
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
    }
}

struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView()
    }
}
