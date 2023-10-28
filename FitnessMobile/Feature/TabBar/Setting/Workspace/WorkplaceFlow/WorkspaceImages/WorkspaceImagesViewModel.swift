//
//  WorkspaceImagesViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 27/10/2023.
//

import Foundation

class WorkspaceImagesViewModel: BaseViewModel {
    @Published var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
}
