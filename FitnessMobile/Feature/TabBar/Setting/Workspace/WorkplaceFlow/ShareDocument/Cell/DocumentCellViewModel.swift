//
//  DocumentCellViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 24/10/2023.
//

import SwiftUI

class DocumentCellViewModel: BaseViewModel {
    @Published var image: UIImage?
    var imageSize: Int?
    @Published var document: ImageModel
    
    init(document: ImageModel) {
        self.document = document
    }
    
    @MainActor
    func loadDocumentImageFromApi() {
        guard let url = document.thumbnailImage?.url else {
            image = UIImage(named: "clipboard")
            return
        }
        isLoading = true
        Task {
            do {
                let storageUseCase = StorageUseCase()
                let response = try await storageUseCase.downloadImageWithUrl(url: url)
                image = UIImage(data: response)
                imageSize = response.count
                isLoading = false
            } catch {
                image = nil
                isLoading = false
            }
        }
    }

    func getImage() -> UIImage {
        return image ?? UIImage(named: "clipboard")!
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
