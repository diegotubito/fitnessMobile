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
    @Published var isLoading: Bool = false
    
    /// Use Cases
    let storageUseCase = StorageUseCase()
    let userUsecase = UserUseCase()
    
    @MainActor
    func fetchProfileImage() {
        Task {
            guard let user = UserSession.getUser() else { return }
            
            if let dataFromMemory = await DataCache.getData(identifier: user._id) {
                print("image loaded from cache")
                imageData = dataFromMemory
            } else if let dataFromDisk = await DataDisk.getData(identifier: user._id) {
                imageData = dataFromDisk
                DataCache.saveData(data: dataFromDisk, identifier: UserSession._id)
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
                let response = try await storageUseCase.downloadImageWithUrl(url: UserSession.getUser()?.profileImage?.url ?? "")
                isLoading = false
                imageData = response
                DataCache.saveData(data: response, identifier: UserSession._id)
                DataDisk.saveData(data: response, identifier: UserSession._id)
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
                let response = try await storageUseCase.uploadFile(imageData: imageData, filepath: "profile_pictures/\(UserSession._id)/profile.png")
                await updateUser(url: response.url)
            } catch {
                imageUploaded = false
                isLoading = false
            }
        }
    }
    
    @MainActor
    func updateUser(url: String) async {
        Task {
            do {
                isLoading = true
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
            }
        }
    }
    
}
