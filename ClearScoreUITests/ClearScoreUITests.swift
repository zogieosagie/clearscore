//
//  ClearScoreUITests.swift
//  ClearScoreUITests
//
//  Created by Osagie Zogie-Odigie on 29/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import XCTest

class ClearScoreUITests: XCTestCase {

    override func setUp() {

        continueAfterFailure = false
        
        XCUIDevice.shared.orientation = .portrait


    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRefreshButton() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let refreshReportButton = app.buttons["Refresh report"]
        
        XCTAssertTrue(refreshReportButton.exists, "Failed: Refresh button should exist.")
        
        XCUIDevice.shared.orientation = .landscapeRight
        XCTAssertFalse(refreshReportButton.exists, "Failed: Refresh button should not exist in Landscape.")
        
        XCUIDevice.shared.orientation = .portraitUpsideDown
        XCTAssertFalse(refreshReportButton.exists, "Failed: Refresh button should not exist in Portrait UpsideDown.")
        
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertFalse(refreshReportButton.exists, "Failed: Refresh button should not exist in Landscape Left.")
        
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(refreshReportButton.exists, "Failed: Refresh button should exist.")
        
    }


}
