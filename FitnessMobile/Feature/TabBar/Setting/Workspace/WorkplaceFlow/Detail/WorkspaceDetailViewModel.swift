//
//  WorkspaceDetailViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

class WorkspaceDetailViewModel: BaseViewModel {
    @Published var workspace: WorkspaceModel
    @Published var onDeleteSuccess: Bool = false
    @Published var onDeletedLocationWorkspace: WorkspaceModel?
    @Published var onDeletedMember: Bool = false
    
    var selectedMember: WorkspaceModel.WorkspaceMember?
    
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
            isLoading = true
            do {
                let response = try await workspaceUseCase.getWorkspace(_id: workspace._id)
                
                DispatchQueue.main.async {
                    self.workspace = response.workspace
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error: error)
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    @MainActor
    func removeWorkspace() {
        Task {
            do {
                let usecase = WorkspaceUseCase()
                let response = try await usecase.deleteWorkspace(_id: workspace._id)
                DispatchQueue.main.async {
                    self.onDeleteSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                    self.handleError(error: error)
                }
            }
        }
    }
    
    @MainActor
    func deleteWorkspaceLocation() {
        Task {
            do {
                let usecase = WorkspaceUseCase()
                let response = try await usecase.deleteWorkspaceLocation(_id: workspace._id)
                DispatchQueue.main.async {
                    self.onDeletedLocationWorkspace = response.workspace
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                    self.handleError(error: error)
                }
            }
        }
    }
    
    @MainActor
    func deleteMember() {
        guard let selectedMember = selectedMember else { return }
        Task {
            let usecase = WorkspaceUseCase()
            
            isLoading = true
            
            do {
                let response = try await usecase.deleteWorkspaceMember(workspace: workspace._id, user: selectedMember.user._id)
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.onDeletedMember = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
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
