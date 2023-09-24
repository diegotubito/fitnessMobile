//
//  WorkspaceAddressViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI
import CoreLocation

class WorkspaceAddressViewModel: BaseViewModel {
    @Published var addressTextField = CustomTextFieldManager()
    @Published var onWorkspaceUpdated: WorkspaceModel?
    @Published var onDeletedLocationWorkspace: WorkspaceModel?

    var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
   
    @MainActor
    func updateWorkspaceAddress(result: GoogleGeocodeModel.Result) {
        Task {
            do {
                let usecase = WorkspaceUseCase()
                let location = WorkspaceModel.Location(coordinates: [result.geometry.location.lng, result.geometry.location.lat],
                                                       googleGeocode: result)
                let response = try await usecase.updateWorkspaceAddress(workspaceId: workspace._id,
                                                                        location: location)
                DispatchQueue.main.async {
                    self.onWorkspaceUpdated = response.workspace
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
}
