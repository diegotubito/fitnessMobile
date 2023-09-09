//
//  CreateWorkspaceViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/09/2023.
//

import SwiftUI

class WorkspaceViewModel: BaseViewModel {
    @Published var titleTextFieldManager = CustomTextFieldManager()
    @Published var subtitleTextFieldManager = CustomTextFieldManager()
    
    var workspace: WorkspaceModel?
    
    @Published var onCreateSuccess: Bool = false
    @Published var onUpdateSuccess: Bool = false
    
    init(workspace: WorkspaceModel?) {
        super.init()
        self.workspace = workspace
    }
    
    func setupInitValues() {
        if isEditing, let workspace = workspace {
            titleTextFieldManager.text = workspace.title
            subtitleTextFieldManager.text = workspace.subtitle
        }
    }
    
    func createWorkspace() {
        onCreateSuccess = false
        handleError(error: APIError.imageFailed)
        showError = true
        
    }
    
    func updateWorkspace() {
        onUpdateSuccess = false
    }
    
    var isEditing: Bool {
        workspace != nil
    }
}
