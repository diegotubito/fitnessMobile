//
//  InvitationViewModelTests.swift
//  FitnessMobileTests
//
//  Created by David Diego Gomez on 14/11/2023.
//

@testable import FitnessMobile
import XCTest

class InvitationViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadInvitationByUserId_Success() async throws {
        // Mock setup
        let workspaceRepositoryMock = InvitationRepositoryMock(fileName: "invitation_mock_success_response", isSuccess: true)
        let viewModel = InvitationViewModel(invitationUseCase: InvitationUseCase(repository: workspaceRepositoryMock))

        // Trigger the function
        await viewModel.loadInvitationsByUserId()

        // Wait for asynchronous operation
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2 seconds for example

        // Now assert the properties
        // You would assert based on what you expect from the mock data
        XCTAssertEqual(viewModel.invitations.count, 2, "Invitation count mismatch")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
    }
    
    
    func testLoadInvitationByUserId_False() async throws {
        // Mock setup
        let workspaceRepositoryMock = InvitationRepositoryMock(fileName: "invitation_mock_success_response", isSuccess: false)
        let viewModel = InvitationViewModel(invitationUseCase: InvitationUseCase(repository: workspaceRepositoryMock))

        // Trigger the function
        await viewModel.loadInvitationsByUserId()

        // Wait for asynchronous operation
        try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2 seconds for example

        // Now assert the properties
        // You would assert based on what you expect from the mock data
        XCTAssertEqual(viewModel.invitations.count, 0, "Invitation count mismatch")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false")
        XCTAssertTrue(viewModel.showError, "showError should be true")
    }
}
