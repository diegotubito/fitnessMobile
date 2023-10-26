//
//  ImageModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 25/10/2023.
//

import Foundation

struct ImageModel: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    let _id: String
    let creator: String
    let highResImage: SingleImageModel?
    let thumbnailImage: SingleImageModel?
}

struct SingleImageModel: Codable, Identifiable, Hashable {
    var id: UUID? = UUID()
    let url: String
    let size: Int?
    let fileType: String?
    let dimensions: Dimensions?
}

struct Dimensions: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    let width: Double
    let height: Double
}
