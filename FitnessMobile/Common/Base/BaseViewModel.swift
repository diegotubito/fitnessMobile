//
//  BaseViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class BaseViewModel: ObservableObject {
    var errorTitle: String = ""
    var errorMessage: String = ""
    
    func handleError(error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .customError(let title, let message):
                errorTitle = (title ?? "").localized
                errorMessage = (message ?? "").localized
                break
            case .badRequest(let title, let message):
                errorTitle = (title ?? "").localized
                errorMessage = (message ?? "").localized
                break
            case .invalidURL:
                break
            case .invalidMethod(let method):
                break
            case .authentication:
                break
            case .userSessionNotFound:
                break
            case .notFound(let url):
                errorTitle = "_404_TITLE".localized
                errorMessage = "_404_MESSAGE".localized
                break
            case .rateLimitExceeded:
                break
            case .serverError(let title, let message):
                errorTitle = title.localized
                errorMessage = (message).localized
                break
            case .serialization:
                errorTitle = "_SERIALIZE_TITLE".localized
                errorMessage = "_SERIALIZE_MESSAGE".localized
                break
            case .jsonFileNotFound(let filename):
                break
            case .mockFailed:
                break
            case .imageFailed:
                break
            }
        } else {
            errorTitle = "_NOT_KNOWN_TITLE".localized
            errorMessage = "_NOT_KNOWN_MESSAGE".localized
        }
    }
}
