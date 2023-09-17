//
//  WorkspaceDetailViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 10/09/2023.
//

import SwiftUI

class WorkspaceDetailViewModel: BaseViewModel {
    var workspace: WorkspaceModel
    
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
            result.append("Coordinates\nlat: \(lattitude)\nlng: \(longitude)")
        }
        
        return result
    }
}
