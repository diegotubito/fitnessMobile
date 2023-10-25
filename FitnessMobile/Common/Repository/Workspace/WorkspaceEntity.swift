//
//  WorkspaceEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct WorkspaceEntity {
    struct Find {
        struct Request: Decodable {
            let _id: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct FindByUserId {
        struct Request: Encodable {
            let userId: String
        }
        
        struct response: Decodable {
            let workspaces: [WorkspaceModel]
        }
    }
    
    struct Create {
        struct Request: Encodable {
            let owner: String
            let title: String
            let subtitle: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct Update {
        struct Request: Encodable {
            let _id: String
            let title: String
            let subtitle: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct Document {
        struct Request: Encodable {
            let _id: String
            let documentId: String
            let url: String
            let size: Int
            let fileType: String
            let dimensions: Dimensions
            let creator: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct UpdateAddress {
        struct Request: Encodable {
            let _id: String
            let location: WorkspaceModel.Location
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct Delete {
        struct Request: Decodable {
            let _id: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct DeleteMember {
        struct Request: Encodable {
            let workspace: String
            let user: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
    
    struct DeleteLocation {
        struct Request: Decodable {
            let _id: String
        }
        
        struct Response: Decodable {
            let workspace: WorkspaceModel
        }
    }
}
