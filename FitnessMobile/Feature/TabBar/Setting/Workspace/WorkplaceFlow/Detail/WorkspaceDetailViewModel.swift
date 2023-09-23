//
//  WorkspaceDetailViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

class WorkspaceDetailViewModel: BaseViewModel {
    var workspace: WorkspaceModel
    @Published var onDeleteSuccess: Bool = false
    
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
}
