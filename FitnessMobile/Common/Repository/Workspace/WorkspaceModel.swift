//
//  WorkspaceModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

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
        let role: String
    }
    
    struct Location: Codable, Hashable {
        let coordinates: [Double]
        let googleGeocode: GoogleGeocodeModel.Result?
    }
    
    enum Status: String, Codable, CaseIterable {
        case notVerified = "NOT_VERIFIED"
        case pending = "PENDING"
        case verified = "VERIFIED"
        case rejected = "REJECTED"
    }
}

