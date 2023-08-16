//
//  TwoFactorEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/08/2023.
//

import Foundation

struct TwoFactorEntity {
    struct Enable {
        struct Request {}
        struct Response: Decodable {
            let qrImage: String
            let tempToken: String
            let activationCode: String
        }
    }
    
    struct Disable {
        struct Request {}
        struct Response: Decodable {
            let message: String
        }
    }
    
    struct Verify {
        struct Request: Encodable {
            let tempToken: String
            let otpToken: String
        }
        
        struct Response: Decodable {
            let user: User
            let token: String
            let tempToken: String
        }
    }
    
    struct VerifyNoTempToken {
        struct Request: Encodable {
            let otpToken: String
        }
        
        struct Response: Decodable {
            let user: User
            let token: String
        }
    }
    
    struct ConfirmEnable {
        struct Request: Encodable { }
        struct Response: Decodable { }
    }
}
