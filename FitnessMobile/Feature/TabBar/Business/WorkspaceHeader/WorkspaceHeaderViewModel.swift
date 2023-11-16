//
//  WorkspaceHeaderViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/11/2023.
//

import SwiftUI

class WorkspaceHeaderViewModel: BaseViewModel {
    @Published var defaultWorkspace: WorkspaceModel?
    @Published var onWorkspacesDidLoad = false
    @Published var imageData: Data?
    
    @MainActor
    func loadDefaultWorkspace() {
        Task {
            let usecase = WorkspaceUseCase()
            let defaultWorkspaceId = DefaultWorkspace.getDefaultWorkspaceId()
            if defaultWorkspaceId == defaultWorkspace?._id ?? "" {
                return
            }
            isLoading = true
            do {
                let response = try await usecase.getWorkspace(_id: defaultWorkspaceId)
                defaultWorkspace = response.workspace
                onWorkspacesDidLoad = true
                fetchDefaultImage()
            } catch {
                handleError(error: error)
            }
        }
    }
    
    
    
    @MainActor
    func fetchDefaultImage() {
        guard let url = defaultWorkspace?.defaultImage?.thumbnailImage?.url else { return }
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: url)
                imageData = response
                isLoading = false
            } catch {
                imageData = nil
                isLoading = false
            }
        }
    }
    
    func getImageView() -> Image {
        let defaultImage = Image(systemName: "person.crop.circle.fill")
        return imageData?.asImage ?? defaultImage
    }
}
