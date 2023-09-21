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
    
    struct SendInvitation {
        struct Request: Encodable {
            let user: String
            let workspace: String
            let role: String
        }
        
        struct Response: Decodable {
            let invitation: InvitationModel
        }
    }
    
    struct DeleteInvitation {
        struct Request: Encodable {
            let _id: String
        }
        
        struct Response: Decodable {
            let success: Bool
        }
    }
}
