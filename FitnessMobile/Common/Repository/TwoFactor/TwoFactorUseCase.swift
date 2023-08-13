//
//  TwoFactorUseCase.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 13/08/2023.
//

import Foundation

class TwoFactorUseCase {
    var repository: TwoFactorRepository
    
    init(repository: TwoFactorRepository = TwoFactorRepository()) {
        self.repository = repository
    }
    
    func enable2FA() async throws -> ResultTwoFactorEnable {
        let request = TwoFactorEntity.Enable.Request()
        return try await repository.enable2FA(request: request)
    }
    
    func disable2FA() async throws -> ResultTwoFactorDisable {
        let request = TwoFactorEntity.Disable.Request()
        return try await repository.disable2FA(request: request)
    }
    
    func verify2FA(tempToken: String, optToken: String) async throws -> ResultTwoFactorVerify {
        let request = TwoFactorEntity.Verify.Request(tempToken: tempToken,
                                                     otpToken: optToken)
        return try await repository.verify2FA(request: request)
    }
    
    func confirm2FA() async throws -> ResultTwoFactorConfirmEnable {
        let request = TwoFactorEntity.ConfirmEnable.Request()
        return try await repository.confirm2FA(request: request)
    }
}
