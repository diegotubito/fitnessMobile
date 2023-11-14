//
//  WorkspaceRepositoryTests.swift
//  FitnessMobileTests
//
//  Created by David Diego Gomez on 13/11/2023.
//

import XCTest
@testable import FitnessMobile

class WorkspaceSettingViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadWorkspacesById_Success() async throws {
        // Mock setup
        let workspaceRepositoryMock = WorkspaceRepositoryMock(fileName: "load_workspace_by_id_response", isSuccess: true)
        let viewModel = WorkspaceSettingViewModel(usecase: WorkspaceUseCase(repository: workspaceRepositoryMock))

        // Trigger the function
        await viewModel.loadWorkspacesById()

        // Wait for asynchronous operation
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2 seconds for example

        // Now assert the properties
        // You would assert based on what you expect from the mock data
        XCTAssertEqual(viewModel.ownWorkspaces.count, 1, "Own workspaces count mismatch")
        XCTAssertEqual(viewModel.invitedWorkspaces.count, 0, "Invited workspaces count mismatch")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
    }
    
    func testLoadWorkspacesById_Failure() async throws {
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
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
    }
}
