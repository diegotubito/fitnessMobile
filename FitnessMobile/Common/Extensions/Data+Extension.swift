//
//  Data+Extension.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

extension Data {
    var asImage: Image? {
        if let uiImage = UIImage(data: self) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
