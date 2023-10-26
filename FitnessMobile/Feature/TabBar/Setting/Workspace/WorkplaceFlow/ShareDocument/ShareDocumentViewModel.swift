//
//  ShareDocumentViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 24/10/2023.
//

import Foundation
import SwiftUI

class ShareDocumentViewModel: BaseViewModel {
    @Published var workspace: WorkspaceModel
    @Published var onRemovedImage: Bool = false
    @Published var onUploadedImage: Bool = false
    
    init(workspace: WorkspaceModel) {
        self.workspace = workspace
        super .init()
    }
    
    @MainActor
    func loadWorkspacesById() {
        isLoading = true
        Task {
            let workspaceUseCase = WorkspaceUseCase()
            do {
                let response = try await workspaceUseCase.getWorkspace(_id: workspace._id)
                self.workspace = response.workspace
                isLoading = false
            } catch {
                self.handleError(error: error)
                self.showError = true
                isLoading = false
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
    func uploadDocumentImage(data: Data) {
        
        Task {
            do {
                isLoading = true
                let storageUseCaseForHighRes = StorageUseCase()
                let documentId = String.generateMongoDBObjectId()
                
                let highResImageResponse = try await storageUseCaseForHighRes.uploadFile(imageData: data, filepath: "address_documents/\(UserSession._id)/\(documentId).png")
                
                let storageUseCaseForThumbnail = StorageUseCase()
                let compressImageData = getCompressData(data: data)
                let thumbnailImageResponse = try await storageUseCaseForThumbnail.uploadFile(imageData: compressImageData, filepath: "address_documents/\(UserSession._id)/\(documentId)_thumbnail.png")
                
                let highResImage = SingleImageModel(url: highResImageResponse.url, size: data.count, fileType: "PNG", dimensions: nil)
                let thumbnailImage = SingleImageModel(url: thumbnailImageResponse.url, size: compressImageData?.count ?? 0, fileType: "PNG", dimensions: nil)

                await addDocuemtnUrlToWorskspace(workspaceId: workspace._id, documentId: documentId, creator: UserSession._id, highResImage: highResImage, thumbnailImage: thumbnailImage)
            } catch {
                handleError(error: error)
                onUploadedImage = false
                isLoading = false
                showError = true
            }
        }
    }
        
    @MainActor
    func addDocuemtnUrlToWorskspace(workspaceId: String, documentId: String, creator: String, highResImage: SingleImageModel, thumbnailImage: SingleImageModel) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.addDocumentUrlToWorkspace(_id: workspaceId, documentId: documentId, creator: creator, highResImage: highResImage, thumbnailImage: thumbnailImage)
                
                onUploadedImage = true
                self.isLoading = false
            } catch {
                onUploadedImage = false
                self.isLoading = false
                self.handleError(error: error)
                showError = true
            }
        }
    }
    
    @MainActor
    func removeDocumentImage(documentId: String) {
        
        Task {
            do {
                isLoading = true
                let storageUseCaseHighRes = StorageUseCase()
                let response = try await storageUseCaseHighRes.deleteFile(filepath: "address_documents/\(UserSession._id)/\(documentId).png")
                
                let storageUseCaseThumbnail = StorageUseCase()
                let response2 = try await storageUseCaseThumbnail.deleteFile(filepath: "address_documents/\(UserSession._id)/\(documentId)_thumbnail.png")
                
                await removeDocuemtnUrlToWorskspace(documentId: documentId)
                
            } catch {
                handleError(error: error)
                onRemovedImage = false
                isLoading = false
                showError = true
            }
        }
    }
    
    @MainActor
    func removeDocuemtnUrlToWorskspace(documentId: String) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.removeDocumentUrlToWorkspace(_id: workspace._id, documentId: documentId)
                
                onRemovedImage = true
                self.isLoading = false
            } catch {
                onRemovedImage = false
                self.isLoading = false
                self.handleError(error: error)
                showError = true
            }
        }
    }
}
