//
//  StorageRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 21/08/2023.
//

import Foundation

typealias StorageUploadResult = StorageEntity.Upload.Response
typealias StorageDownloadResult = StorageEntity.Download.Response
typealias StorageDownloadWithURLResult = StorageEntity.DownloadWithURL.Response
typealias StorageDeleteResult = StorageEntity.Delete.Response

class StorageRepository: ApiNetworkAsync {
    func uploadFile(request: StorageEntity.Upload.Request) async throws -> StorageUploadResult {
        config.path = "/api/v1/storage"
        config.imageData = request.imageData
        config.mimeType = .png
        config.addQueryItem(key: "filepath", value: request.filepath)
        config.method = .post
        return try await apiCall()
    }
    
    func downloadFile(request: StorageEntity.Download.Request) async throws -> StorageDownloadResult {
        config.path = "/api/v1/storage"
        config.addQueryItem(key: "filepath", value: request.filepath)
        config.method = .get
        return try await apiCall()
    }
    
    func downloadImageWithURL(request: StorageEntity.DownloadWithURL.Request) async throws -> StorageDownloadWithURLResult {
        config.path = "/api/v1/storage/imageUrl"
        config.method = .get
        config.addQueryItem(key: "url", value: request.url)
        
        return try await apiCall()
    }
    
    func deleteFile(request: StorageEntity.Delete.Request) async throws -> StorageDeleteResult {
        config.path = "/api/v1/storage"
        config.addQueryItem(key: "filepath", value: request.filepath)
        config.method = .delete
        return try await apiCall()
    }
}
