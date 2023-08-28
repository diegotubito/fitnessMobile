//
//  ServerConnectionRepostory.swift
//  FitnessMobile
//
//  Created by David Diego Gomez on 02/08/2023.
//

import Foundation

typealias ServerConnectionResult = Data

protocol ServerConnectionProtocol {
    func isConnected() async throws -> ServerConnectionResult
}

class ServerConnection: ApiNetworkAsync, ServerConnectionProtocol {
    func isConnected() async throws -> ServerConnectionResult {
        config.path = "/server/connected"
        config.noTokenNeeded = true
        config.method = .get
        return try await apiCall()
    }
}

class ServerConnectionMock: ApiNetworkMockAsync, ServerConnectionProtocol {
    func isConnected() async throws -> ServerConnectionResult {
        mockFileName = "server_connection_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class ServerConnectionRepositoryFactory {
    static func create() -> ServerConnectionProtocol {
        return ServerConnection()
    }
}
