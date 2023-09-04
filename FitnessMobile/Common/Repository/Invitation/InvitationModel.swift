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
    let user: String
    let workspace: WorkspaceModel
    let role: String
    let status: String
    let expiration: String
}
