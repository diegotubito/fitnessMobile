//
//  CreateWorkspaceViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/09/2023.
//

import SwiftUI

class WorkspaceTitleAndSubtitleViewModel: BaseViewModel {    
    @Published var titleTextFieldManager = CustomTextFieldManager()
    @Published var subtitleTextFieldManager = CustomTextFieldManager()
    @Published var disabledButton: Bool = false
    
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
    
    @MainActor
    func createWorkspace() {
        Task {
            do {
                let usecase = WorkspaceUseCase()
                let userId = UserSession._id
                let response = try await usecase.createWorkspace(ownerId: userId, title: titleTextFieldManager.text, subtitle: subtitleTextFieldManager.text)
                DispatchQueue.main.async {
                    self.onCreateSuccess = true
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
    func updateWorkspace() {
        guard let workspace = workspace else { return }
        Task {
            do {
                let usecase = WorkspaceUseCase()
                let response = try await usecase.updateWorkspace(workspaceId: workspace._id, title: titleTextFieldManager.text, subtitle: subtitleTextFieldManager.text)
                DispatchQueue.main.async {
                    self.onUpdateSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                    self.handleError(error: error)
                }
            }
        }
    }
    
    var isEditing: Bool {
        workspace != nil
    }
    
    var isTitleValid: Bool {
        return !titleTextFieldManager.text.isEmpty && titleTextFieldManager.text.count < 30
    }
    
    var isSubtitleValid: Bool {
        return !subtitleTextFieldManager.text.isEmpty && subtitleTextFieldManager.text.count < 30
    }

    var isValid: Bool {
        return isSubtitleValid && isTitleValid
    }
    
    func validate() {
        disabledButton = !isValid
    }
}
