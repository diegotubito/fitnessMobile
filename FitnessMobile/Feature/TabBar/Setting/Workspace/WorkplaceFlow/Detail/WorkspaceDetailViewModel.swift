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
}
