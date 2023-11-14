//
//  WorkspaceRepositoryTests.swift
//  FitnessMobileTests
//
//  Created by David Diego Gomez on 13/11/2023.
//

import XCTest
@testable import FitnessMobile

class WorkspaceRepositoryTests: XCTestCase {
    var repository: WorkspaceRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        repository = WorkspaceRepositoryMock()
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    func testGetWorkspacesByUserId_Success() async throws {
        // Setup your mock network session to return a successful response
        // ...
        
        let request = WorkspaceEntity.FindByUserId.Request(userId: "validUserId")
      
        do {
            let result = try await repository.getWorkspacesByUserId(request: request)
            // Assert that result is as expected
            // ...
            XCTAssertGreaterThan(result.workspaces.count, 0, "Workspaces is empty")

        } catch {
            XCTFail("Expected successful response, received error")
        }
    }
    
}
