//
//  FitnessMobileUITests.swift
//  FitnessMobileUITests
//
//  Created by David Diego Gomez on 31/07/2023.
//

import XCTest

final class FitnessMobileUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["ui-testing"]
        app.launchEnvironment = ["network-success": "1"]
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func testExample() throws {
        let textView = app.staticTexts["splash_title_text_view"]
        
        XCTAssert(textView.waitForExistence(timeout: 5), "text should exsit")
    }
}
