//
//  MemoryImageCache.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class DataCache {
    static let shared = DataCache()
    
    static var dataCache = NSCache<NSString, NSData>()
    
    static func saveData(data: Data, identifier: String) {
        dataCache.setObject(data as NSData, forKey: identifier as NSString)
    }
    
    static func removeData(identifier: String) {
        dataCache.removeObject(forKey: identifier as NSString)
    }
    
    static func getData(identifier: String) async -> Data? {
        return dataCache.object(forKey: identifier as NSString) as? Data
    }
}
