//
//  UIImage+Extension.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import SwiftUI

extension UIImage {
    static func createImage(from data: Data) throws -> UIImage {
        if let image = UIImage(data: data) {
            return image
        } else {
            throw APIError.imageFailed
        }
    }
    
    func compress(value: Double) -> UIImage {
        return self
    }
}

extension UIImage {
    
    func resizedAndCompressed(maxSize: CGFloat, compressionQuality: CGFloat) -> Data? {
        let aspectRatio = self.size.width / self.size.height
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        if aspectRatio > 1 {
            // Landscape image
            newWidth = maxSize
            newHeight = maxSize / aspectRatio
        } else {
            // Portrait image
            newWidth = maxSize * aspectRatio
            newHeight = maxSize
        }
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        guard let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        return thumbnailImage.jpegData(compressionQuality: compressionQuality)
    }
}
