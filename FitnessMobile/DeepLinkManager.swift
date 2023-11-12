//
//  DeepLinkManager.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 12/11/2023.
//

import SwiftUI

class DeepLink: ObservableObject {
    @Published var deepLinkPath: [String] = []
    var queryParams: [String: Any] = [:]
    var modal: String = ""
    
    func parsePath(path: String) {
        if path.isEmpty { return }
        deepLinkPath = path.components(separatedBy: "/")
        
    }
    
    func parseURL(_ url: URL) {
        guard
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }

        // Process path components, skipping the first "/".
        let pathComponents = url.path().components(separatedBy: "/")

        // Process query items.
        var queryItemsDict = [String: Any]()
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryItemsDict[item.name] = item.value
            }
        }
        modal = url.host() ?? ""
        deepLinkPath = pathComponents
        queryParams = queryItemsDict
    }
}
