//
//  AlertType.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 11/11/2023.
//

import Foundation

enum AlertType {
    case logout
    
    var title: String {
        switch self {
        case .logout:
            return "_LOGOUT_ALERT_WARNING_TITLE"
        }
    }
    
    var message: String {
        switch self {
        case .logout:
            return "_LOGOUT_ALERT_WARNING_MESSAGE"
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .logout:
            return "_LOGOUT"
        }
    }
}
