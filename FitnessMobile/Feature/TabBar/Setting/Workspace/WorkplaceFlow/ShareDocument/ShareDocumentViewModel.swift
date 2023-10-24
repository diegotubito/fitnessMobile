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
    
    @MainActor
    func uploadDocumentImage(workspaceId: String, data: Data) {
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let uniqueID = String.generateMongoDBObjectId()
                let response = try await storageUseCase.uploadFile(imageData: data, filepath: "address_documents/\(UserSession._id)/\(uniqueID).png")
                await addDocuemtnUrlToWorskspace(workspaceId: workspaceId, url: response.url, uniqueID: uniqueID)
            } catch {
                handleError(error: error)
                onUploadedImage = false
                isLoading = false
                showError = true
            }
        }
    }
        
    @MainActor
    func addDocuemtnUrlToWorskspace(workspaceId: String, url: String, uniqueID: String) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.addDocumentUrlToWorkspace(_id: workspaceId, url: url, documentId: uniqueID)
                
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
    func removeDocumentImage(workspaceId: String, url: String, documentId: String) {
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.deleteFile(filepath: "address_documents/\(UserSession._id)/\(documentId).png")
                await removeDocuemtnUrlToWorskspace(workspaceId: workspaceId, url: url)
            } catch {
                handleError(error: error)
                onRemovedImage = false
                isLoading = false
                showError = true
            }
        }
    }
    
    @MainActor
    func removeDocuemtnUrlToWorskspace(workspaceId: String, url: String) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.removeDocumentUrlToWorkspace(_id: workspaceId, url: url)
                
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
