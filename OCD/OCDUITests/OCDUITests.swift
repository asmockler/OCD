//
//  OCDUITests.swift
//  OCDUITests
//
//  Created by Andy Mockler on 6/26/17.
//  Copyright © 2017 Andy Mockler. All rights reserved.
//

import XCTest

class OCDUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        let app = XCUIApplication()
        XCUIDevice.shared().orientation = .landscapeLeft
        setupSnapshot(app)
        app.launch()
    }
    
    func testCreateScreenshots() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let window = app.children(matching: .window).element(boundBy: 0)
        let element = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        sleep(2)
        snapshot("01 - Landing Screen")

        element.tap()

        sleep(3)
        snapshot("02 - Instructions")
        element.children(matching: .other).element.tap()

        sleep(4)
        snapshot("03 - Gameplay")
    }
    
}
