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
    @Published var showError = false
    @Published var isLoading: Bool = false
    
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
                DispatchQueue.main.async {
                    //NotificationCenter.default.post(Notification(name: .MustLogin))
                }
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
                let message = NSLocalizedString("_JSON_NOT_FOUND_MESSAGE", comment: "")
                
                errorTitle = LocalizedStringKey("_JSON_NOT_FOUND_TITLE")
                errorMessage = LocalizedStringKey(String(format: message, filename ?? ""))
                break
            case .mockFailed:
                break
            case .imageFailed:
                errorTitle = LocalizedStringKey("_IMAGE_FAILED_TITLE")
                errorMessage = LocalizedStringKey("_IMAGE_FAILED_MESSAGE")
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
