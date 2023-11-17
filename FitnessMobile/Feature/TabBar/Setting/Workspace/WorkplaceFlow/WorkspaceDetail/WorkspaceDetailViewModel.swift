//
//  WorkspaceDetailViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

class WorkspaceDetailViewModel: BaseViewModel {
    @Published var workspace: WorkspaceModel
    @Published var invitations: [InvitationModel] = []
    @Published var onDeleteSuccess: Bool = false
    @Published var onDeletedInvitation = false
    
    var selectedMember: WorkspaceModel.WorkspaceMember?
    var selectedInvitation: InvitationModel?
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
    
    var hasLocation: Bool {
        return workspace.location != nil
    }
    
    func getFormattedAddress() -> String? {
        workspace.location?.googleGeocode?.formattedAddress
    }
    
    func getCoordinates() -> String {
        var result = ""
        
        let lattitude = workspace.location?.googleGeocode?.geometry.location.lat
        let longitude = workspace.location?.googleGeocode?.geometry.location.lng
        if let lattitude = lattitude, let longitude = longitude {
            let coordinateString = NSLocalizedString("_COORDINATE", comment: "")
            let latittueString = NSLocalizedString("_LATITUDE", comment: "")
            let longitudeString = NSLocalizedString("_LONGITUDE", comment: "")
            
            result.append("\(coordinateString)\n\(latittueString): \(lattitude)\n\(longitudeString): \(longitude)")
        }
        
        return result
    }
    
    @MainActor
    func loadWorkspacesById() {
        Task {
            let workspaceUseCase = WorkspaceUseCase()
            do {
                let response = try await workspaceUseCase.getWorkspace(_id: workspace._id)
                self.workspace = response.workspace
                self.fetchInvitationsByWorkspace()
                
            } catch {
                self.handleError(error: error)
                self.showError = true
            }
        }
    }
    
    @MainActor
    func removeWorkspace() {
        Task {
            isLoading = true
            do {
                let usecase = WorkspaceUseCase()
                let response = try await usecase.deleteWorkspace(_id: workspace._id)
                isLoading = false
                onDeleteSuccess = true
                deleteWorkspaceDefaultIfNeccesary(workspaceID: response.workspace._id)
            } catch {
                isLoading = false
                showError = true
                handleError(error: error)
            }
        }
    }
    
    @MainActor
    func deleteWorkspaceLocation() {
        Task {
            do {
                isLoading = true
                let usecase = WorkspaceUseCase()
                let response = try await usecase.deleteWorkspaceLocation(_id: workspace._id)
                isLoading = false
                self.loadWorkspacesById()
            } catch {
                isLoading = false
                self.showError = true
                self.handleError(error: error)
            }
        }
    }
    
    func deleteWorkspaceDefaultIfNeccesary(workspaceID: String) {
        if DefaultWorkspace.getDefaultWorkspaceId() == workspaceID {
            DefaultWorkspace.removeDefaultWorkspace()
        }
    }
    
    @MainActor
    func deleteInvitationById() {
        Task {
            guard let _id = selectedInvitation?._id else { return }
            let usecase = InvitationUseCase()
            
            isLoading = true
            
            do {
                let response = try await usecase.deleteInvitationById(_id: _id)
                isLoading = false
                fetchInvitationsByWorkspace()
            } catch {
                isLoading = false
            }
        }
    }
    
    @MainActor
    func fetchInvitationsByWorkspace() {
        Task {
            let usecase = InvitationUseCase()
            do {
                let response = try await usecase.getInvitationsByWorkspaceId(workspaceId: workspace._id)
                invitations = response.invitations
            } catch {
                showError = true
                handleError(error: error)
            }
        }
    }
    
    
    var username: String {
        return selectedMember?.user.username ?? ""
    }
    
    var memberSubtitle: LocalizedStringKey {
        LocalizedStringKey(String(format: NSLocalizedString("_REMOVE_MEMBER_SUBTITLE", comment: ""), username, email))
    }
    
    var email: String {
        selectedMember?.user.email ?? ""
    }
}
