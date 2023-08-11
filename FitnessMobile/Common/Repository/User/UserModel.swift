//
//  UserModel.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    
    let _id: String
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let isEnabled: Bool
    let role: String
    let phone: Phone?
    let emailVerified: Bool
    let createdAt: String
    let updatedAt: String
}

struct Phone: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    let countryName: String
    var number: String
    let phoneCode: String
    let countryCode: String
}
