//
//  ApplicationVersion.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 26/08/2023.
//

import Foundation

class ApplicationVersion {
    static let shared = ApplicationVersion()
    
    static func getVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "App Version: \(version)"
        }
        
        return ""
    }
    
    static func getVersionAndBundle() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "App Version: \(version), Build Number: \(build)"
        }
        
        return ""
    }
    
    static func getBundle() -> String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "Build Number: \(build)"
        }
        
        return ""
    }
}
