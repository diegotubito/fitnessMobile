//
//  WorkspaceHeaderViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

class WorkspaceHeaderViewModel: BaseViewModel {
    @Published var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
}
