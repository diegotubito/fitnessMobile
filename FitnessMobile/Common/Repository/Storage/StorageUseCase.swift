//
//  StorageUseCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 21/08/2023.
//

import Foundation

class StorageUseCase {
    var repository: StorageRepository
    
    init(repository: StorageRepository = StorageRepository()) {
        self.repository = repository
    }
    
    func uploadFile(imageData: Data, filepath: String) async throws -> StorageUploadResult {
        let request = StorageEntity.Upload.Request(imageData: imageData, filepath: filepath)
        return try await repository.uploadFile(request: request)
    }
    
    func downloadFile(filepath: String) async throws -> StorageDownloadResult {
        let request = StorageEntity.Download.Request(filepath: filepath)
        return try await repository.downloadFile(request: request)
    }
    
    func downloadImageWithUrl(url: String) async throws -> StorageDownloadResult {
        let request = StorageEntity.DownloadWithURL.Request(url: url)
        return try await repository.downloadImageWithURL(request: request)
    }
    
    func deleteFile(filepath: String) async throws -> StorageDeleteResult {
        let request = StorageEntity.Delete.Request(filepath: filepath)
        return try await repository.deleteFile(request: request)
    }
}
