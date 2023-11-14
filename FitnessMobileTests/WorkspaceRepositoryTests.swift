//
//  WorkspaceRepositoryTests.swift
//  FitnessMobileTests
//
//  Created by David Diego Gomez on 13/11/2023.
//

import XCTest
@testable import FitnessMobile

class WorkspaceRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetWorkspacesByUserId_Success() async throws {
        // Setup your mock network session to return a successful response
        // ...
        
        // Mock setup
        let workspaceRepositoryMock = WorkspaceRepositoryMock(fileName: "load_workspace_by_id_response", isSuccess: true)
        let workspaceUseCase = WorkspaceUseCase(repository: workspaceRepositoryMock)
        let request = WorkspaceEntity.FindByUserId.Request(userId: "validUserId")
      
        do {
            let result = try await workspaceUseCase.getWorkspacesBuUserId(_id: "dfd")
            // Assert that result is as expected
            // ...
            XCTAssertGreaterThan(result.workspaces.count, 0, "Workspaces is empty")

        } catch {
            XCTFail("Expected successful response, received error")
        }
    }
    
    func testLoadWorkspacesById_Success() async throws {
        // Mock setup
        let workspaceRepositoryMock = WorkspaceRepositoryMock(fileName: "load_workspace_by_id_response", isSuccess: true)
        let viewModel = WorkspaceSettingViewModel(usecase: WorkspaceUseCase(repository: workspaceRepositoryMock))

        // Trigger the function
        await viewModel.loadWorkspacesById()

        // Wait for asynchronous operation
        // You might need to adjust this to suit your testing environment
        // It can be a delay or a more sophisticated way of waiting for the async task
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2 seconds for example

        // Now assert the properties
        // You would assert based on what you expect from the mock data
        XCTAssertEqual(viewModel.ownWorkspaces.count, 1, "Own workspaces count mismatch")
        XCTAssertEqual(viewModel.invitedWorkspaces.count, 0, "Invited workspaces count mismatch")
        // Add more assertions as needed based on your mock data

        // Reset UserSession if needed
    }
    
    func testLoadWorkspacesById_Failure() async throws {
        // Adjust the mock to simulate a failure
        // Mock setup
        let workspaceRepositoryMock = WorkspaceRepositoryMock(fileName: "load_workspace_by_id_response", isSuccess: false)
        let viewModel = WorkspaceSettingViewModel(usecase: WorkspaceUseCase(repository: workspaceRepositoryMock))
        
        // Trigger the function
        await viewModel.loadWorkspacesById()

        // Wait for asynchronous operation
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2 seconds, for example

        // Assert failure handling
        XCTAssertTrue(viewModel.showError, "Error flag should be true on failure")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on failure")
        XCTAssertTrue(viewModel.ownWorkspaces.isEmpty, "Own workspaces should be empty on failure")
        XCTAssertTrue(viewModel.invitedWorkspaces.isEmpty, "Invited workspaces should be empty on failure")
    }
}
