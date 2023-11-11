//
//  SettingCoordinator.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 11/11/2023.
//
import SwiftUI

class SettingCoordinator: ObservableObject {
    @Published var path: [Screen] = []
    
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
    
    enum Screen: Hashable {
        case deleteAccount
        case settingTwoFactor
        case twoFactorEnableInformation(qrImage: UIImage, activationCode: String)
        case profile
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
        case photoPicker
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    @ViewBuilder
    func getPage(_ screen: Screen) -> some View {
        switch screen {
        case .deleteAccount:
            DeleteAccountView()
        case .settingTwoFactor:
            TwoFactorSettingView()
        case .workspaceSetting:
            WorkspaceSettingView()
        case .workspaceDetail(workspace: let workspace):
            WorkspaceDetailView(viewmodel: WorkspaceDetailViewModel(workspace: workspace))
        case .workspaceTitleAndSubtitle(workspace: let workspace):
            TitleAndSubtitleWorkspaceView(viewmodel: WorkspaceTitleAndSubtitleViewModel(workspace: workspace))
        case .invitationSetting:
            InvitationView()
        case .profile:
            ProfileView()
        case .photoPicker:
            PhotoPickerView()
        case .twoFactorEnableInformation(qrImage: let qrImage, activationCode: let activationCode):
            TwoFactorEnableInformationView(qrImage: qrImage, activationCode: activationCode)
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
            WorkspaceImagesView(viewmodel: WorkspaceImagesViewModel(workspace: workspace))
        case .workspaceEditDefaultImageView(workspace: let workspace):
            EditDefaultImageView(viewmodel: DefaultImageViewModel(workspace: workspace))
        case .workspaceEditBackgroundImageView(workspace: let workspace):
            EditBackgroundImageView(viewmodel: DefaultBackgroundImageViewModel(workspace: workspace))
        }
    }
}

