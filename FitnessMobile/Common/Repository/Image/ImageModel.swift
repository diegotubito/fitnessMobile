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
    let url: String
    let size: Double?
    let dimensions: Dimensions?
    let creator: String
}

struct Dimensions: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    let width: Double
    let height: Double
}
