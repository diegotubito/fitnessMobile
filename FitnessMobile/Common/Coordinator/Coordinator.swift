//
//  Coordinator.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 05/08/2023.
//

import SwiftUI

@MainActor
class Coordinator: ObservableObject {
    
    @Published var path: NavigationPath = NavigationPath()
    @Published var page: PageView = .tabbar
    @Published var sheet: SheetView?
    @Published var modal: ModalView?
    
    @Published var showAlert: Bool = false
    @Published var showSecondaryAlert: Bool = false
    var alertDetail: AlertDetail?
    var completion: (() -> Void)?
    var primaryTapped: (() -> Void)?
    var secondaryTapped: (() -> Void)?
    
    func presentSecondaryAlert(title: LocalizedStringKey, message: LocalizedStringKey, primaryButtonTitle: LocalizedStringKey? = nil, secondaryButtonTitle: LocalizedStringKey? = nil, primaryTapped: @escaping (() -> Void), secondaryTapped: @escaping (() -> Void)) {
        alertDetail = AlertDetail(title: title, message: message, alertStyle: .secondary, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle)
        self.primaryTapped = primaryTapped
        self.secondaryTapped = secondaryTapped
        showAlert = true
    }
    
    func presentDesctructiveAlert(title: String, message: String, primaryButtonTitle: LocalizedStringKey? = nil, secondaryButtonTitle: LocalizedStringKey? = nil, primaryTapped: @escaping (() -> Void), secondaryTapped: @escaping (() -> Void)) {
        alertDetail = AlertDetail(title: LocalizedStringKey(title), message: LocalizedStringKey(message), alertStyle: .destructive, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle)
        self.primaryTapped = primaryTapped
        self.secondaryTapped = secondaryTapped
        showAlert = true
    }
    
    func root() {
        path = NavigationPath()
    }
    
    func push(_ page: PageView) {
        path.append(page)
    }
    
    func presentSheet(_ sheet: SheetView) {
        //self.modal = nil
        self.sheet = sheet
    }
    
    func presentModal(_ modal: ModalView) {
        //self.sheet = nil
        self.modal = modal
    }
    
    func closeModal() {
        self.modal = nil
    }
    
    
    struct AlertDetail: Identifiable {
        let id = UUID()
        var title: LocalizedStringKey
        var message: LocalizedStringKey
        var alertStyle: AlertStyle?
        var primaryButtonTitle: LocalizedStringKey?
        var secondaryButtonTitle: LocalizedStringKey?
    }
    
    enum AlertStyle: Identifiable {
        case secondary
        case destructive
        
        var id: UUID {
            switch self {
            case .secondary, .destructive:
                return UUID()
            }
        }
    }
    
    enum PageView: Hashable {
        case tabbar
        case home
        case deleteAccount
        case signUp
        case profile
        case settingTwoFactor
        case twoFactorEnableInformation(qrImage: UIImage, activationCode: String)
        case workspaceSetting
        case invitationSetting
        case workspaceTitleAndSubtitle(workspace: WorkspaceModel?)
        case workspaceDetail(workspace: WorkspaceModel)
        case addressWorkspace(workspace: WorkspaceModel)
        case searchUsersWorkspace(workspace: WorkspaceModel)
        case pickRoleForInvitation(workspace: WorkspaceModel, user: User)
        case memberDetail(workspace: WorkspaceModel, member: WorkspaceModel.WorkspaceMember)
        case shareDocumentView(workspace: WorkspaceModel)
        case workspaceImagesView(workspace: WorkspaceModel)
        case workspaceEditDefaultImageView(workspace: WorkspaceModel)
        case workspaceEditBackgroundImageView(workspace: WorkspaceModel)
    }
    
    enum SheetView: Identifiable {
        case tac
        
        var id: UUID {
            switch self {
            case .tac:
                return UUID()
            }
        }
    }
    
    enum ModalView: Identifiable {
        case noInternet
        case photoPicker
        case login
      
        var id: UUID {
            switch self {
            case .noInternet, .login, .photoPicker:
                return UUID()
            }
        }
    }
    
    @ViewBuilder
    func getPage(_ page: PageView) -> some View {
        switch page {
        case .tabbar:
            TabBarView()
        case .home:
            HomeView()
        case .deleteAccount:
            DeleteAccountView()
        case .signUp:
            SignUpView()
        case .profile:
            ProfileView()
        case .settingTwoFactor:
            TwoFactorSettingView()
        case .twoFactorEnableInformation(qrImage: let qrImage, activationCode: let activationCode):
            TwoFactorEnableInformationView(qrImage: qrImage, activationCode: activationCode)
        case .workspaceSetting:
            WorkspaceSettingView()
        case .invitationSetting:
            InvitationView()
        case .workspaceDetail(workspace: let workspace):
            WorkspaceDetailView(viewmodel: WorkspaceDetailViewModel(workspace: workspace))
        case .workspaceTitleAndSubtitle(workspace: let workspace):
            TitleAndSubtitleWorkspaceView(viewmodel: WorkspaceTitleAndSubtitleViewModel(workspace: workspace))
        case .addressWorkspace(workspace: let workspace):
            WorkspaceAddressView(viewmodel: WorkspaceAddressViewModel(workspace: workspace))
        case .searchUsersWorkspace(workspace: let workspace):
            SearchUserForInvitationView(viewmodel: SearchUserForInvitationViewModel(workspace: workspace))
        case .pickRoleForInvitation(workspace: let workspace, user: let user):
            PickRoleView(viewmodel: PickRoleViewModel(workspace: workspace, user: user))
        case .memberDetail(workspace: let workspace, member: let member):
            MemberDetailView(viewmodel: MemberDetailViewModel(workspace: workspace, member: member))
        case .shareDocumentView(workspace: let workspace):
            ShareDocumentView(viewmodel: ShareDocumentViewModel(workspace: workspace))
        case .workspaceImagesView(workspace: let workspace):
            WorkspaceImagesView(viewmodel: WorkspaceImagesViewModel(workspace: workspace), defaultBackgroundIamgeViewModel: EditBackgroundImageViewModel(workspace: workspace))
        case .workspaceEditDefaultImageView(workspace: let workspace):
            EditDefaultImageView(viewmodel: EditDefaultImageViewModel(workspace: workspace))
        case .workspaceEditBackgroundImageView(workspace: let workspace):
            EditBackgroundImageView(viewmodel: EditBackgroundImageViewModel(workspace: workspace))
        }
    }
    
    @ViewBuilder
    func getSheet(_ sheet: SheetView) -> some View {
        switch sheet {
        case .tac:
            Text("Terms and Conditions")
        }
    }
    
   @ViewBuilder
    func getModal(_ modal: ModalView) -> some View {
        switch modal {
        case .noInternet:
            OfflineInternetView()
        case .login:
            LoginView(allowSighUp: true)
        case .photoPicker:
            PhotoPickerView()
        }
    }
}

