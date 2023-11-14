//
//  BusinessViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

class BusinessViewModel: BaseViewModel {
    @Published var workspaces: [WorkspaceModel] = []
    @Published var defaultWorkspace: WorkspaceModel?
    
    func getWorkspacesFromLocal() {
        let workspaces = DefaultWorkspace.getWorkspaces()
        self.workspaces = workspaces
    }
    
    func getDefaultWorkspace() {
        let defaultWorkspace = DefaultWorkspace.getDefaultWorkspace()
        self.defaultWorkspace = defaultWorkspace
    }
}
