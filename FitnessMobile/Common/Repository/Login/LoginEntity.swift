//
//  LoginEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 29/04/2023.
//

import Foundation

struct LoginEntity {
    struct Input {
        let email: String
        let password: String
    }
    
    struct Request: Encodable {
        let email: String
        let password: String
    }
    
    struct Response: Decodable {
        let user: User
        let accessToken: String
        let accessTokenExpirationDateString: String
        let tempToken: String
        let refreshToken: String
        let refreshTokenExpirationDateString: String
    }
    
    struct Refresh {
        struct Response: Decodable {
            let accessToken: String
            let accessTokenExpirationDateString: String
        }
    }
}
