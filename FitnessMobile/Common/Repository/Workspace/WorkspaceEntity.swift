//
//  WorkspaceEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 03/09/2023.
//

import Foundation

struct WorkspaceEntity {
    struct FindByUserId {
        struct Request: Encodable {
            let userId: String
        }
        
        struct response: Decodable {
            let workspaces: [WorkspaceModel]
        }
    }
}
