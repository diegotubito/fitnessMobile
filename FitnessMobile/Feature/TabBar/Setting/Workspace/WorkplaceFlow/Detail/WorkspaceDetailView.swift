//
//  WorkspaceDetailView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

struct WorkspaceDetailView: View {
    @StateObject var viewmodel: WorkspaceDetailViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    func headerView() -> some View {
        HStack {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                titleAndSubtitleView()
            }
        }
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func titleAndSubtitleView() -> some View {
        return VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "pencil")
                }
                .foregroundColor(.accentColor)
                .onTapGesture {
                    coordinator.push(.workspaceTitleAndSubtitle(workspace: viewmodel.workspace))
                }
                
                HStack {
                    Text(viewmodel.workspace.title)
                    Spacer()
                }
                HStack {
                    Text(viewmodel.workspace.subtitle)
                    Spacer()
                }
            }
            .padding()
            .foregroundColor(Color.Neutral.tone80)
        }
    }
    
    func notVerifiedView() -> some View {
        return HStack(alignment: .bottom) {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Neutral.tone80)
            Text("Address not verified.")
                .foregroundColor(Color.Neutral.tone80)
            Button("Share a document") {
                
            }
            .font(.callout)
            .foregroundColor(.accentColor)
            Spacer()
        }
        
    }
    
    func pendingStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
            Text("Verification pending...")
            Spacer()
        }
    }
    
    func rejectedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
            Text("Verification rejected")
            Button("Upload another document.") {
                
            }
            Spacer()
        }
    }
    
    func verifiedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Green.truly)
            Text("Verified")
            Spacer()
        }
    }
    
    func addressView() -> some View {
        return VStack(spacing: 32) {
            VStack(spacing: 4) {
                HStack {
                    Text("Address")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "pencil")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            coordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                        }
                }
                .padding(.bottom, 4)
                
                
                VStack {
                    if let formattedAddress = viewmodel.getFormattedAddress() {
                        HStack {
                            Text(formattedAddress)
                            Spacer()
                        }
                        
                        HStack {
                            Text(viewmodel.getCoordinates())
                            Spacer()
                        }
                    }
                    
                    switch viewmodel.workspace.locationVerificationStatus {
                        
                    case .notVerified:
                        notVerifiedView()
                        WarningBoxView(title: "Verification Note:", message: "Remeber that verifying your address is mandatory to be visible in user's area. Otherwise, you potential clients would never know you are running a business")
                    case .pending:
                        pendingStatusView()
                    case .verified:
                        verifiedStatusView()
                    case .rejected:
                        rejectedStatusView()
                        WarningBoxView(title: "Verification Note:", message: "Your address has been rejected. Please, change your address and upload new documents")
                    case .none:
                        EmptyView()
                    }
                }
            }
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func noAddressView() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("Address")
                    .font(.headline)
                Spacer()
                Image(systemName: "pencil")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        coordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                    }
            }
            
            HStack {
                Text("No address found.")
                Spacer()
            }
            .padding(.bottom)
            .foregroundColor(Color.Neutral.tone80)
            
            WarningBoxView(title: "Important Note:", message: "Set up your address so that your customers can find you.")
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func colaborators() -> some View {
        return VStack {
            HStack {
                Text("Colaboradores")
                    .font(.headline)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        coordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                    }
            }
            .padding(.bottom, 4)
            MemberListView(viewmodel: MemberViewModel(members: viewmodel.workspace.members))
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func invitations() -> some View {
        return VStack {
            HStack {
                Text("Invitations")
                    .font(.headline)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        coordinator.push(.searchUsersWorkspace(workspace: viewmodel.workspace))
                    }
            }
            .padding(.bottom, 4)
            InvitationListView(viewmodel: InvitationListViewModel(workspace: viewmodel.workspace))
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.Blue.midnight]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    headerView()
                    if viewmodel.hasLocation {
                        addressView()
                    } else {
                        noAddressView()
                    }
                    
                    colaborators()
                    invitations()
                    
                    HStack {
                        BasicButton(title: "Delete Workspace", style: .destructive, isEnabled: .constant(true)) {
                            coordinator.presentDesctructiveAlert(title: "Delete Workspace", message: "Are you sure you want to delete this workspace?") {
                                viewmodel.removeWorkspace()
                            } secondaryTapped: { }
                        }
                        .onReceive(viewmodel.$onDeleteSuccess) { isDeleted in
                            if isDeleted {
                                coordinator.path.removeLast()
                            }
                        }
                    }
                    
                }
            }
            .scrollIndicators(.hidden)
            .overlay(
                Group {
                    CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                    CustomProgressView(isLoading: $viewmodel.isLoading)
                }
            )
        }
    }
}

struct WorkspaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceDetailView(viewmodel: WorkspaceDetailViewModel(workspace: WorkspaceModel(_id: "0",
                                                                                          title: "Test ABC",
                                                                                          subtitle: "Testing subtitle",
                                                                                          isEnabled: true,
                                                                                          owner: "",
                                                                                          logo: "",
                                                                                          createdAt: "",
                                                                                          updatedAt: "",
                                                                                          members: [], location: nil, locationVerificationStatus: nil)))
    }
}
