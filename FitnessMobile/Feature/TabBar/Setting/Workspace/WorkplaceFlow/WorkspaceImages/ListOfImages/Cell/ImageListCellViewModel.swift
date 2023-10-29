//
//  ImageListCellViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 29/10/2023.
//

import SwiftUI

class ImageListCellViewModel: BaseViewModel {
    @Published var loadedImage: UIImage?
    var imageSize: Int?
    @Published var image: ImageModel
    
    init(image: ImageModel) {
        self.image = image
    }
    
    @MainActor
    func loadDocumentImageFromApi() {
        guard let url = image.thumbnailImage?.url else {
            loadedImage = UIImage(named: "clipboard")
            return
        }
        isLoading = true
        Task {
            do {
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: url)
                loadedImage = UIImage(data: response)
                imageSize = response.count
                isLoading = false
            } catch {
                loadedImage = nil
                isLoading = false
            }
        }
    }

    func getImage() -> UIImage {
        return loadedImage ?? UIImage(named: "clipboard")!
    }
    
    func getImageSize() -> String {
        guard let imageSize = imageSize else { return "" }
        
        let bytes = Double(imageSize)
        let KB = bytes / 1024.0
        let MB = KB / 1024.0
        
        if MB >= 1.0 {
            return String(format: "%.2f MB", MB)
        } else if KB >= 1.0 {
            return String(format: "%.0f KB", KB)
        } else {
            return String(format: "%.0f bytes", bytes)
        }
    }
}
