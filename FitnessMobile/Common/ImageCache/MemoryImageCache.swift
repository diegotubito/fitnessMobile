//
//  MemoryImageCache.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class MemoryImageCache {
    static let shared = MemoryImageCache()
    
    static var imageCache = NSCache<NSString, UIImage>()
    
    static func saveImage(image: UIImage, identifier: String) {
        imageCache.setObject(image, forKey: identifier as NSString)
    }
    
    static func getImage(identifier: String) async -> UIImage? {
        imageCache.object(forKey: identifier as NSString)
    }
}
