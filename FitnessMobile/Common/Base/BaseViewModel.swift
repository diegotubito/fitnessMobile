//
//  BaseViewModel.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 06/08/2023.
//

import SwiftUI

class BaseViewModel: ObservableObject {
    var errorTitle: LocalizedStringKey = ""
    var errorMessage: LocalizedStringKey = ""
    
    func handleError(error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .customError(let title, let message):
                errorTitle = LocalizedStringKey((title ?? ""))
                errorMessage = LocalizedStringKey((message ?? ""))
                break
            case .badRequest(let title, let message):
                errorTitle = LocalizedStringKey((title ?? ""))
                errorMessage = LocalizedStringKey((message ?? ""))
                break
            case .invalidURL:
                break
            case .invalidMethod(let method):
                break
            case .authentication:
                errorTitle = LocalizedStringKey("_401_TITLE")
                errorMessage = LocalizedStringKey("_401_MESSAGE")
                
                break
            case .userSessionNotFound:
                break
            case .notFound(let url):
                errorTitle = LocalizedStringKey("_404_TITLE")
                errorMessage = LocalizedStringKey("_404_MESSAGE")
                break
            case .rateLimitExceeded:
                break
            case .serverError(let title, let message):
                errorTitle = LocalizedStringKey(title)
                errorMessage = LocalizedStringKey(message)
                break
            case .serialization:
                errorTitle = LocalizedStringKey("_SERIALIZE_TITLE")
                errorMessage = LocalizedStringKey("_SERIALIZE_MESSAGE")
                break
            case .jsonFileNotFound(let filename):
                break
            case .mockFailed:
                break
            case .imageFailed:
                break
            case .notAuthorize:
                errorTitle = LocalizedStringKey("_LOGIN_ERROR")
                errorMessage = LocalizedStringKey("_LOGIN_NOT_AUTHORIZED")
            }
        } else {
            errorTitle = LocalizedStringKey("_SERVER_ERROR_TITLE")
            errorMessage = LocalizedStringKey("_SERVER_ERROR_MESSAGE")
        }
    }
}
