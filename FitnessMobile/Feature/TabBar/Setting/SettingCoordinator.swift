//
//  SettingCoordinator.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 11/11/2023.
//
import SwiftUI

class SettingCoordinator: ObservableObject {
    @Published var path: [Screen] = []
    
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
    
    
    func handleDeepLink(values: [String], queryParams: [String: Any]) {
        if !values.isEmpty {
            for screen in values {
                switch screen {
                case "workspace":
                    push(.workspaceSetting)
                case "invitation":
                    push(.invitationSetting)
                case "workspaceDetail":
                    if let _id = queryParams["_id"] as? String {
                        
                        let viewmodel = WorkspaceModel(_id: _id,
                                                       title: "",
                                                       subtitle: "",
                                                       isEnabled: true,
                                                       owner: "",
                                                       createdAt: "",
                                                       updatedAt: "",
                                                       members: [],
                                                       location: nil,
                                                       locationVerificationStatus: nil,
                                                       documentImages: [],
                                                       defaultImage: nil,
                                                       defaultBackgroundImage: nil,
                                                       images: nil)
                        push(.workspaceDetail(workspace: viewmodel))
                    } else {
                        // Handle the case where the ID is missing or not a string
                        // For example, you might log an error, or push a default detail view
                    }
                default:
                    // Handle unknown screen types
                    // You might log an error or ignore the unknown screen type
                    break
                }
            }
        }
    }
}

