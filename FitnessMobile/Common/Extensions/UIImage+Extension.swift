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
}
