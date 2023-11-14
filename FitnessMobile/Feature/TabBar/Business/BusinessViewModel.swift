//
//  BusinessViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

class BusinessViewModel: BaseViewModel {
    @Published var defaultWorkspace: WorkspaceModel?
    @Published var onWorkspacesDidLoad = false
    
    var defaultWorkspaceId: String
    
    override init() {
        self.defaultWorkspaceId = DefaultWorkspace.getDefaultWorkspaceId()
    }
    
    @MainActor
    func loadWorkspace() {
        Task {
            let usecase = WorkspaceUseCase()
            
            do {
                let response = try await usecase.getWorkspace(_id: defaultWorkspaceId)
                defaultWorkspace = response.workspace
                onWorkspacesDidLoad = true
            } catch {
                handleError(error: error)
            }
        }
    }
}
