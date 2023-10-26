//
//  StorageEntity.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 21/08/2023.
//

import Foundation

struct StorageEntity {
    struct Upload {
        struct Request: Encodable {
            let imageData: Data?
            let filepath: String
        }
        
        struct Response: Decodable {
            let url: String
        }
    }
    
    struct Download {
        struct Request: Encodable {
            let filepath: String
        }
        
        typealias Response = Data

    }
    
    struct DownloadWithURL {
        struct Request: Encodable {
            let url: String
        }
        
        typealias Response = Data

    }
    
    struct Delete {
        struct Request: Encodable {
            let filepath: String
        }
        
        struct Response: Decodable { }

    }
}
