//
//  DiskImageCache.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class DiskImageCache {
    static let shared = DiskImageCache()
    
    static func saveImage(image: UIImage, identifier: String) {
        // Get the path to the Caches directory
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(identifier)
        
        // Convert the UIImage to Data
        if let data = image.jpegData(compressionQuality: 1) {
            do {
                // Write the data to the specified location
                try data.write(to: fileURL)
                print("Image saved to disk: \(fileURL)")
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
    
    static func getImage(identifier: String) async -> UIImage? {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(identifier)
        
        do {
            let data = try Data(contentsOf: fileURL)
            print("image loaded from disk")
            return UIImage(data: data)
        } catch {
            print("Error loading image from disk: \(error)")
            return nil
        }
    }
}
