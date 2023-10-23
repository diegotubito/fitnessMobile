//
//  PhotoViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class PhotoPickerManager: BaseViewModel {
    @Published var imageData: Data?
    @Published var imageUploaded: Bool = false
    @Published var urlRemoved: Bool = false
    
    @MainActor
    func fetchProfileImage() {
        isLoading = true
        Task {
            guard let user = UserSession.getUser() else { return }

            if let dataFromMemory = await DataCache.getData(identifier: user._id) {
                print("image loaded from cache")
                imageData = dataFromMemory
                isLoading = false
            } else if let dataFromDisk = await DataDisk.getData(identifier: user._id) {
                imageData = dataFromDisk
                DataCache.saveData(data: dataFromDisk, identifier: UserSession._id)
                isLoading = false
            } else {
                loadProfileImageFromApi()
            }
        }
    }
    
    @MainActor
    func loadProfileImageFromApi() {
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: UserSession.getUser()?.profileImage?.url ?? "")
                imageData = response
                DataCache.saveData(data: response, identifier: UserSession._id)
                DataDisk.saveData(data: response, identifier: UserSession._id)
                isLoading = false
                print("image loaded from api")
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
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.uploadFile(imageData: imageData, filepath: "profile_pictures/\(UserSession._id)/profile.png")
                await updateUser(url: response.url)
            } catch {
                handleError(error: error)
                imageUploaded = false
                isLoading = false
                showError = true
            }
        }
    }
    
    @MainActor
    func uploadDocumentImage(workspaceId: String, data: Data) {
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let timestamp = Int(Date().timeIntervalSince1970)
                let response = try await storageUseCase.uploadFile(imageData: data, filepath: "address_documents/\(UserSession._id)/\(timestamp).png")
                await addDocuemtnUrlToWorskspace(workspaceId: workspaceId, url: response.url)
            } catch {
                handleError(error: error)
                imageUploaded = false
                isLoading = false
                showError = true
            }
        }
    }
        
    @MainActor
    func addDocuemtnUrlToWorskspace(workspaceId: String, url: String) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.addDocumentUrlToWorkspace(_id: workspaceId, url: url)
                
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
    
    /*
     
     para haccer un remove document necesito tener un id por cada documento, y guardar ese docuemnto con el id.
     
    @MainActor
    func removeDocumentImage(workspaceId: String, url: String) {
        
        Task {
            do {
                isLoading = true
                let storageUseCase = StorageUseCase()
                let timestamp = Int(Date().timeIntervalSince1970)
                let response = try await storageUseCase.uploadFile(imageData: data, filepath: "address_documents/\(UserSession._id)/\(timestamp).png")
                await addDocuemtnUrlToWorskspace(workspaceId: workspaceId, url: response.url)
            } catch {
                handleError(error: error)
                imageUploaded = false
                isLoading = false
                showError = true
            }
        }
    }
*/
    
    @MainActor
    func removeDocuemtnUrlToWorskspace(workspaceId: String, url: String) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = WorkspaceUseCase()
                let response = try await workspaceUseCase.removeDocumentUrlToWorkspace(_id: workspaceId, url: url)
                
                urlRemoved = true
                self.isLoading = false
            } catch {
                urlRemoved = false
                self.isLoading = false
                self.handleError(error: error)
                showError = true
            }
        }
    }

    
    @MainActor
    func updateUser(url: String) async {
        Task {
            do {
                isLoading = true
                let userUsecase = UserUseCase()
                let response = try await userUsecase.doUpdateProfileImage(url: url)
                UserSession.saveUser(user: response.user)
                DataDisk.removeData(identifier: UserSession._id)
                DataCache.removeData(identifier: UserSession._id)
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
