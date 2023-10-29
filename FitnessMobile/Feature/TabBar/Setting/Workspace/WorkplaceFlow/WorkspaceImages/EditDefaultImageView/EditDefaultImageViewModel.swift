//
//  EditDefaultImageViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 28/10/2023.
//


import SwiftUI

class EditDefaultImageViewModel: BaseViewModel {
    @Published var imageData: Data?
    @Published var imageUploaded: Bool = false
    @Published var workspace: WorkspaceModel
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
    }
    
    @MainActor
    func fetchDefaultImage() {
        guard let url = workspace.defaultImage?.thumbnailImage?.url else { return }
        
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
    
    @MainActor
    func uploadImage() {
        guard let imageData = imageData else { return }
        Task {
            do {
                isLoading = true
                
                let documentId = String.generateMongoDBObjectId()
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.uploadFile(imageData: imageData, filepath: "default_image/\(workspace._id)/default_image.png")
                let storageUseCaseThumbnail = StorageUseCase()
                let compressImageData = getCompressData(data: imageData)
                let responseThumbnail = try await storageUseCaseThumbnail.uploadFile(imageData: compressImageData, filepath: "default_image/\(workspace._id)/default_image_thumbnail.png")
                
                let highResImage = SingleImageModel(url: response.url, size: imageData.count, fileType: "PNG", dimensions: nil)
                let thumbnailImage = SingleImageModel(url: responseThumbnail.url, size: compressImageData?.count ?? 0, fileType: "PNG", dimensions: nil)

                await updateWorkspaceDefaultImage(workspaceId: workspace._id, documentId: documentId, creator: UserSession._id, highResImage: highResImage, thumbnailImage: thumbnailImage)
            } catch {
                handleError(error: error)
                imageUploaded = false
                isLoading = false
                showError = true
            }
        }
    }
    
    func getCompressData(data: Data) -> Data? {
        let originalImage = UIImage(data: data)
        let maxSize: CGFloat = 150.0  // Max thumbnail dimension
        let compressionQuality: CGFloat = 0.7  // Compression ratio
        
        return originalImage?.resizedAndCompressed(maxSize: maxSize, compressionQuality: compressionQuality)
    }
    
    @MainActor
    func updateWorkspaceDefaultImage(workspaceId: String, documentId: String, creator: String, highResImage: SingleImageModel, thumbnailImage: SingleImageModel) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.updateWorkspaceDefaultImage(_id: workspaceId, creator: creator, highResImage: highResImage, thumbnailImage: thumbnailImage)
                
                imageUploaded = true
                self.isLoading = false
            } catch {
                imageUploaded = false
                self.isLoading = false
                self.handleError(error: error)
                showError = true
            }
        }
    }
    
    func getImageView() -> Image {
        let defaultImage = Image(systemName: "person.crop.circle.fill")
        return imageData?.asImage ?? defaultImage
    }
}

