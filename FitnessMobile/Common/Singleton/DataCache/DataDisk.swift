//
//  DiskDataCache.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import SwiftUI

class DataDisk {
    static let shared = DataDisk()
    
    static func saveData(data: Data, identifier: String) {
        // Get the path to the Caches directory
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(identifier)
        
        do {
            // Write the data to the specified location
            try data.write(to: fileURL)
            print("Data Saved To Disk: \(fileURL)")
        } catch {
            print("Error Saving Data: \(error)")
        }
        
    }
    
    static func getData(identifier: String) async -> Data? {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(identifier)
        
        do {
            let data = try Data(contentsOf: fileURL)
            print("Data loaded from disk")
            return data
        } catch {
            print("Error loading Data from disk: \(error)")
            return nil
        }
    }
    
    static func removeData(identifier: String) {
        // Get the path to the Caches directory
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cacheDirectory.appendingPathComponent(identifier)
        
        do {
            // Remove the Data from the specified location
            try FileManager.default.removeItem(at: fileURL)
            print("Data removed from disk: \(fileURL)")
        } catch {
            print("Error removing Data: \(error)")
        }
    }
}
