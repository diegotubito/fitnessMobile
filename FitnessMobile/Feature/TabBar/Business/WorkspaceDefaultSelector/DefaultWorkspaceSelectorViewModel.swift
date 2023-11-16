//
//  WorkspaceDefaultSelectorViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 15/11/2023.
//

import Foundation

class DefaultWorkspaceSelectorViewModel: BaseViewModel {
    @Published var singleSelectorManager = SingleSelectorManager()
    
    func setupOptions(_ workspaces: [WorkspaceModel]) {
        let defaultWorkspace = DefaultWorkspace.getDefaultWorkspaceId()
        singleSelectorManager.options.removeAll()
        for workspace in workspaces {
            let option = SingleSelectorManager.OptionModel(id: workspace._id, title: workspace.title, subtitle: workspace.location?.googleGeocode?.formattedAddress ?? "")
            singleSelectorManager.options.append(option)
            if defaultWorkspace == workspace._id {
                singleSelectorManager.selectedOption = workspace._id
            }
        }
    }
    
    func setDefaultWorkspace(_id: String) {
        
        DefaultWorkspace.setDefaultWorkspace(id: _id)
    }
}
