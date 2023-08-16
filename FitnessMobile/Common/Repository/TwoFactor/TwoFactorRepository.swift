//
//  TwoFactorRepository.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/08/2023.
//

import Foundation

typealias ResultTwoFactorEnable = TwoFactorEntity.Enable.Response
typealias ResultTwoFactorDisable = TwoFactorEntity.Disable.Response
typealias ResultTwoFactorVerify = TwoFactorEntity.Verify.Response
typealias ResultTwoFactorVerifyNoTempToken = TwoFactorEntity.VerifyNoTempToken.Response
typealias ResultTwoFactorConfirmEnable = TwoFactorEntity.ConfirmEnable.Response

class TwoFactorRepository: ApiNetworkAsync {
    func enable2FA(request: TwoFactorEntity.Enable.Request) async throws -> ResultTwoFactorEnable {
        config.path = "/api/v1/enable2FA"
        config.method = .post
        return try await apiCall()
    }
    
    func disable2FA(request: TwoFactorEntity.Disable.Request) async throws -> ResultTwoFactorDisable {
        config.path = "/api/v1/disable2FA"
        config.method = .post
        return try await apiCall()
    }

    func verify2FA(request: TwoFactorEntity.Verify.Request) async throws -> ResultTwoFactorVerify {
        config.path = "/api/v1/verify2FA"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func verify2FANoTempToken(request: TwoFactorEntity.VerifyNoTempToken.Request) async throws -> ResultTwoFactorVerifyNoTempToken {
        config.path = "/api/v1/verify2FA_withouth_temptoken"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func confirm2FA(request: TwoFactorEntity.ConfirmEnable.Request) async throws -> ResultTwoFactorConfirmEnable {
        config.path = "/api/v1/confirmEnable2FA"
        config.method = .post
        return try await apiCall()
    }
}
