//
//  InvitationModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct InvitationModel: Identifiable, Codable, Hashable {
    let id: UUID?
    
    let _id: String
    let user: User
    let workspace: WorkspaceModel
    let role: WorkspaceModel.Role
    let status: Status
    let expiration: String
    let host: User
    let createdAt: String
    let updatedAt: String
    
    enum Status: String, Codable {
        case pending = "INVITATION_PENDING"
        case accepted = "INVITATION_ACCEPTED"
        case rejected = "INVITATION_REJECTED"
    }
}
