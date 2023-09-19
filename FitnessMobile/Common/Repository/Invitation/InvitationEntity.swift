//
//  InvitationEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct InvitationEntity {
    struct GetByUserId {
        struct Request: Encodable {
            let userId: String
        }
        
        struct Response: Decodable {
            let invitations: [InvitationModel]
        }
    }
    
    struct ByWorkspace {
        struct Request: Encodable {
            let workspaceId: String
        }
        
        struct Response: Decodable {
            let invitations: [InvitationModel]
        }
    }
}
