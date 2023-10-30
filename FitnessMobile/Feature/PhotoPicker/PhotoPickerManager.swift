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
                let response = try await storageUseCase.downloadImageWithUrl(url: UserSession.getUser()?.profileImage?.thumbnailImage?.url ?? "")
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
    
    func getCompressData(data: Data) -> Data? {
        let originalImage = UIImage(data: data)
        let maxSize: CGFloat = 150.0  // Max thumbnail dimension
        let compressionQuality: CGFloat = 0.1// Compression ratio
        
        return originalImage?.resizedAndCompressed(maxSize: maxSize, compressionQuality: compressionQuality)
    }
    
    @MainActor
    func uploadImage() {
        guard let imageData = imageData else { return }
        Task {
            do {
                isLoading = true
                let documentId = String.generateMongoDBObjectId()
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.uploadFile(imageData: imageData, filepath: "profile_image/\(UserSession._id)/profile_image.png")
                
                let compressImageData = getCompressData(data: imageData)
                let storageThumbnailUseCase = StorageUseCase()
                let responseThumbnail = try await storageThumbnailUseCase.uploadFile(imageData: compressImageData, filepath: "profile_image/\(UserSession._id)/profile_image_thumbnail.png")

                let highResImage = SingleImageModel(url: response.url, size: imageData.count, fileType: "PNG", dimensions: nil)
                let thumbnailImage = SingleImageModel(url: responseThumbnail.url, size: compressImageData?.count ?? 0, fileType: "PNG", dimensions: nil)
                
                await setProfileImage(documentId: documentId, highResImage: highResImage, thumbnailImage: thumbnailImage)
            } catch {
                handleError(error: error)
                imageUploaded = false
                isLoading = false
                showError = true
            }
        }
    }
    
    @MainActor
    func setProfileImage(documentId: String, highResImage: SingleImageModel?, thumbnailImage: SingleImageModel?) async {
        Task {
            do {
                isLoading = true
                let workspaceUseCase = UserUseCase()
                
                //creator id is not needed
                let response = try await workspaceUseCase.setProfileImage(_id: UserSession._id, documentId: documentId, creator: UserSession._id, highResImage: highResImage, thumbnailImage: thumbnailImage)
                
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
    
    @MainActor
    func removeImage() {
        guard let user = UserSession.getUser() else { return }
        Task {
            do {
                
                isLoading = true
                let storageUseCaseHighRes = StorageUseCase()
                let response = try await storageUseCaseHighRes.deleteFile(filepath: "profile_image/\( user._id)/profile_image.png")
                
                let storageUseCaseThumbnail = StorageUseCase()
                let responseThumbnail = try await storageUseCaseThumbnail.deleteFile(filepath: "profile_image/\( user._id)/profile_image_thumbnail.png")
                
                await setProfileImage(documentId: user.profileImage?._id ?? "", highResImage: nil, thumbnailImage: nil)
                
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
