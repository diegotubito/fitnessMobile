//
//  UserEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import Foundation

struct UserEntity {
    struct Create {
        struct Request: Codable {
            let username: String
            let email: String
            let password: String
            let firstName: String
            let lastName: String
            let role: String
            let phoneNumber: Int
            let emailVerified: Bool
        }
        
        struct Response: Decodable {
            let user: User
        }
    }
    
    struct Get {
        struct Request: Codable {}
        
        struct Response: Decodable {
            let users: [User]
        }
    }
}
