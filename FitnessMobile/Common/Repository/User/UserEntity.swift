//
//  UserEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import Foundation

struct UserEntity {
    struct RequestPhone: Codable {
        let countryName: String
        let number: String
        let phoneCode: String
        let countryCode: String
    }
    
    struct Create {
        struct Request: Codable {
            let username: String
            let email: String
            let password: String
            let firstName: String
            let lastName: String
            let role: String
            let phoneNumber: String
            let emailVerified: Bool
            let phone: RequestPhone
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
    
    struct Update {
        struct Request: Codable {
            let firstName: String
            let lastName: String
            let phone: RequestPhone
        }
        
        struct Response: Decodable {
            let user: User
        }
    }
    
    struct UpdateProfileImage {
        struct Request: Codable {
            let profileImage: ProfileImageRequest
        }
        
        struct Response: Decodable {
            let user: User
        }
    }
    
    struct ProfileImageRequest: Codable {
        let url: String
    }
}
