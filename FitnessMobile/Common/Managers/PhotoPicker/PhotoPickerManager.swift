//
//  PhotoViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class PhotoPickerManager: BaseViewModel {
    @Published var image: Image?
    @Published var imageUploaded: Bool = false
    @Published var isLoading: Bool = false
    
    var storageUseCase = StorageUseCase()
    
    @MainActor
    func fetchProfileImage() {
        Task {
            guard let user = UserSession.getUser() else { return }
            
            if let uiimage = await MemoryImageCache.getImage(identifier: user._id) {
                print("image loaded from cache")
                image = Image(uiImage: uiimage)
            } else if let uuimage = await DiskImageCache.getImage(identifier: user._id) {
                image = Image(uiImage: uuimage)
                MemoryImageCache.saveImage(image: uuimage, identifier: user._id)
            } else {
                loadProfileImageFromApi()
            }
        }
    }
    
    func loadProfileImageFromApi() {
        guard let user = UserSession.getUser() else { return }
        
        Task {
            do {
                isLoading = true
                let response = try await storageUseCase.downloadImageWithUrl(url: user.profileImage?.url ?? "")
                isLoading = false
                if let uiimage = UIImage(data: response) {
                    image = Image(uiImage: uiimage )
                    MemoryImageCache.saveImage(image: uiimage, identifier: user._id)
                    DiskImageCache.saveImage(image: uiimage, identifier: user._id)
                    print("image loaded from api")
                    
                }
            } catch {
                image = nil
                isLoading = false
            }
        }
    }
    
    func uploadImage() {
        Task {
            do {
                isLoading = true
                let uiimageData = UIImage(systemName: "pencil")
                let imageData = uiimageData?.pngData()
                let response = try await storageUseCase.uploadFile(imageData: imageData!, filepath: "test/\(UserSession.getUser()?._id ?? "")/c.png")
                imageUploaded = true
                isLoading = false
            } catch {
                imageUploaded = false
                isLoading = false
            }
        }
    }
    
}
