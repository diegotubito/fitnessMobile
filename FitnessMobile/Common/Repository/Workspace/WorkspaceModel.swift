//
//  WorkspaceModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation
import SwiftUI

struct WorkspaceModel: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    
    let _id: String
    let title: String
    let subtitle: String
    let isEnabled: Bool
    let owner: String
    let logo: String?
    let createdAt: String
    let updatedAt: String
    let members: [WorkspaceMember]
    let location: Location?
    let locationVerificationStatus: Status?
    
    struct WorkspaceMember: Identifiable, Codable, Hashable {
        var id: UUID? = UUID()
        
        let user: User
        let role: Role
        let host: User
        let createdAt: String
    }
    
    struct Location: Codable, Hashable {
        let coordinates: [Double]
        let googleGeocode: GoogleGeocodeModel.Result?
    }
    
    enum Status: String, Codable, CaseIterable {
        case notVerified = "ADDRESS_NOT_VERIFIED"
        case pending = "ADDRESS_PENDING"
        case verified = "ADDRESS_VERIFIED"
        case rejected = "ADDRESS_REJECTED"
    }
    
    enum Role: String, CaseIterable, Codable {
        case admin = "ADMIN_ROLE"
        case user = "USER_ROLE"
        case userReadOnly = "USER_READ_ONLY_ROLE"
    }
}

