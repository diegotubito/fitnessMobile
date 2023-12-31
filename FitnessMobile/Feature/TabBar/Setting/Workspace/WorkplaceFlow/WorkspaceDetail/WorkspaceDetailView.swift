//
//  WorkspaceDetailView.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI
struct WorkspaceDetailView: View {
    @StateObject var viewmodel: WorkspaceDetailViewModel
    @EnvironmentObject var settingCoordinator: SettingCoordinator
    @EnvironmentObject var mainModalCoordinator: MainModalCoordinator
    @State private var selectedItem: SheetItem? = nil
    @State private var showAlertDeleteWorkspace = false
    
    struct SheetItem: Identifiable {
        let id: UUID? = UUID()
        let sheetView: Sheets
        
        enum Sheets {
            case address
            case member
            case invitation
        }
    }

    func headerView() -> some View {
        HStack {
            DefaultImageView(defaultIamgeViewModel: DefaultImageViewModel(workspace: viewmodel.workspace), size: 100)
                .onTapGesture {
                    settingCoordinator.push(.workspaceImagesView(workspace: viewmodel.workspace))
                }
            
            VStack {
                HStack {
                    Text(viewmodel.workspace.title)
                        .font(.title2)
                        .foregroundColor(Color.Neutral.tone80)
                    Spacer()
                }
                HStack {
                    Text(viewmodel.workspace.subtitle)
                        .font(.title3)
                        .foregroundColor(Color.Neutral.tone80)
                    Spacer()
                }
            }
            
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "pencil")
            }
            .foregroundColor(.accentColor)
            .onTapGesture {
                settingCoordinator.push(.workspaceTitleAndSubtitle(workspace: viewmodel.workspace))
            }
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func notVerifiedView() -> some View {
        return HStack(alignment: .bottom) {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Neutral.tone80)
            Text("_WORKSPACE_DETAIL_VIEW_ADDRESS_NOT_VERIFIED")
                .foregroundColor(Color.Neutral.tone80)
            Button("_WORKSPACE_DETAIL_VIEW_SHARE_DOCUMENT") {
                settingCoordinator.push(.shareDocumentView(workspace: viewmodel.workspace))
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
            Text("_WORKSPACE_DETAIL_VIEW_VERIFICATION_PENDING")
            Button("_WORKSPACE_DETAIL_VIEW_SHARE_DOCUMENT") {
                settingCoordinator.push(.shareDocumentView(workspace: viewmodel.workspace))
            }
            .font(.callout)
            .foregroundColor(.accentColor)
            Spacer()
        }
    }
    
    func rejectedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
            Text("_WORKSPACE_DETAIL_VIEW_VERIFICATION_REJECTED")
            Button("_WORKSPACE_DETAIL_VIEW_SHARE_DOCUMENT") {
                settingCoordinator.push(.shareDocumentView(workspace: viewmodel.workspace))
            }
            .font(.callout)
            .foregroundColor(.accentColor)
            Spacer()
        }
    }
    
    func verifiedStatusView() -> some View {
        return HStack {
            Image(systemName: "checkmark.shield.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Green.truly)
            Text("_WORKSPACE_DETAIL_VIEW_VERIFICATION_ACCEPTED")
            Spacer()
        }
    }
    
    func addressView() -> some View {
        return VStack(spacing: 32) {
            VStack(spacing: 4) {
                HStack {
                    Text("_WORKSPACE_DETAIL_VIEW_TITLE")
                        .font(.headline)
                        .foregroundColor(Color.Neutral.tone80)
                    Spacer()
                    Image(systemName: "pencil")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            settingCoordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                        }
                }
                .padding(.bottom, 8)
                
                
                VStack {
                    if let formattedAddress = viewmodel.getFormattedAddress() {
                        HStack {
                            Text(formattedAddress)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(Color.Red.truly)
                                .onTapGesture {
                                    selectedItem = SheetItem(sheetView: .address)
                                }
                        }
                        .padding([.leading, .bottom])
                        
                        HStack {
                            Text(viewmodel.getCoordinates())
                            Spacer()
                        }
                        .padding(.leading)
                    }
                }
                .foregroundColor(Color.Neutral.tone90)
                .padding(.bottom)
                
                VStack {
                    switch viewmodel.workspace.locationVerificationStatus {
                        
                    case .notVerified:
                        notVerifiedView()
                        WarningBoxView(title: "_WORKSPACE_DETAIL_VIEW_WARNING_NOT_VERIFIED_TITLE", message: "_WORKSPACE_DETAIL_VIEW_WARNING_NOT_VERIFIED_MESSAGE")
                    case .pending:
                        pendingStatusView()
                    case .verified:
                        verifiedStatusView()
                    case .rejected:
                        rejectedStatusView()
                        WarningBoxView(title: "_WORKSPACE_DETAIL_VIEW_WARNING_REJECTED_TITLE", message: "_WORKSPACE_DETAIL_VIEW_WARNING_REJECTED_MESSAGE")
                    case .none:
                        EmptyView()
                    }
                }
                .foregroundColor(Color.Neutral.tone90)
            }
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
        
    }
    
    func noAddressView() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("_WORKSPACE_DETAIL_VIEW_TITLE")
                    .font(.headline)
                    .foregroundColor(Color.Neutral.tone80)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        settingCoordinator.push(.addressWorkspace(workspace: viewmodel.workspace))
                    }
            }
            .padding(.bottom, 8)
            
            WarningBoxView(title: "_WORKSPACE_DETAIL_VIEW_WARNING_EMPTY_TITLE", message: "_WORKSPACE_DETAIL_VIEW_WARNING_EMPTY_MESSAGE")
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
    }
    
    func colaborators() -> some View {
        return VStack {
            HStack {
                Text("_WORKSPACE_DETAIL_MEMBER_TITLE")
                    .font(.headline)
                    .foregroundColor(Color.Neutral.tone80)
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        settingCoordinator.push(.searchUsersWorkspace(workspace: viewmodel.workspace))
                    }
            }
            .padding(.bottom, 8)
            MemberListView(viewmodel: MemberViewModel(members: viewmodel.workspace.members), cellTapped: { memberTapped in
                viewmodel.selectedMember = memberTapped
                settingCoordinator.push(.memberDetail(workspace: viewmodel.workspace, member: memberTapped))
                //selectedItem = SheetItem(sheetView: .member)
            })
            .padding(.leading)
        }
        .padding()
        .background(Color.Neutral.tone100.opacity(0.5))
        .cornerRadius(10)
       
    }
    
    func invitations() -> some View {
        return VStack {
            HStack {
                Text("_WORKSPACE_DETAIL_INVITATION_TITLE")
                    .font(.headline)
                    .foregroundColor(Color.Neutral.tone80)
                Spacer()
            }
            .padding(.bottom, 8)
            InvitationListView(viewmodel: InvitationListViewModel(invitations: viewmodel.invitations), trushTapped: { invitationTapped in
                viewmodel.selectedInvitation = invitationTapped
                selectedItem = SheetItem(sheetView: .invitation)
            })
                .padding(.leading)
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
                VStack(spacing: 8) {
                    headerView()
                    if viewmodel.hasLocation {
                        addressView()
                    } else {
                        noAddressView()
                    }
                    
                    colaborators()
                    invitations()
                    
                    HStack {
                        BasicButton(title: "_WORKSPACE_DETAIL_DELETE_BUTTON_TITLE", style: .destructive, isEnabled: .constant(true)) {
                            showAlertDeleteWorkspace = true
                        }
                        .alert(isPresented: $showAlertDeleteWorkspace) {
                            Alert(title: Text("_WORKSPACE_DETAIL_DELETE_WARNING_TITLE"),
                                  message: Text("_WORKSPACE_DETAIL_DELETE_WARNING_MESSAGE"),
                                  primaryButton: .destructive(Text("_WORKSPACE_DETAIL_DELETE_BUTTON_TITLE"), action: {
                                viewmodel.removeWorkspace()
                            }), secondaryButton: .cancel()
                            )
                        }
                    }
                    
                }
            }
            .onAppear {
                viewmodel.loadWorkspacesById()
            }
            .scrollIndicators(.hidden)
            .overlay(
                Group {
                    CustomAlertView(isPresented: $viewmodel.showError, title: $viewmodel.errorTitle, message: $viewmodel.errorMessage)
                    CustomProgressView(isLoading: $viewmodel.isLoading)
                }
            )
        }
        .sheet(item: $selectedItem, onDismiss: {
            
        }, content: { item in
            if item.sheetView == .address {
                DeleteSheetView(title: "_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_REMOVE_TITLE", subtitle: "_WORKSPACE_ADDRESS_VIEW_CURRENT_LOCATION_REMOVE_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        viewmodel.deleteWorkspaceLocation()
                    }
                    selectedItem = .none
                })
                    .presentationDetents([.medium, .fraction(0.30)])
                    .presentationBackground(Color.Blue.midnight)
            } else if item.sheetView == .invitation {
                DeleteSheetView(title: "_REMOVE_INVITATION_TITLE", subtitle: "_REMOVE_INVITATION_SUBTITLE", onTapped: { optionTapped in
                    if optionTapped == .accept {
                        viewmodel.deleteInvitationById()
                    }
                    selectedItem = .none
                })
                    .presentationDetents([.medium, .fraction(0.30)])
                    .presentationBackground(Color.Blue.midnight)
            }
        })
        .onReceive(viewmodel.$onDeleteSuccess) { isDeleted in
            if isDeleted {
                mainModalCoordinator.modal = MainModalView(screen: .splash)
            }
        }
        //.toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.Blue.midnight, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    let workspace = WorkspaceViewModelMock.getWorkspaces().first
    if let workspace = workspace {
        return  WorkspaceDetailView(viewmodel: WorkspaceDetailViewModel(workspace: workspace))
    } else {
        return Text("Loading...")
    }
}
