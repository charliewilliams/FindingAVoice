//
//  QuestionViewControllerUITests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest

class QuestionViewControllerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testTappingValidButtonDisablesBothButtons() {
        
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        let button = app.buttons["Valid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        XCTAssertFalse(button.isEnabled)
        XCTAssertFalse(app.buttons["Invalid"].isEnabled)
    }
    
    func testTappingInvalidButtonDisablesBothButtons() {
        
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        let button = app.buttons["Invalid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        XCTAssertFalse(button.isEnabled)
        XCTAssertFalse(app.buttons["Valid"].isEnabled)
    }
    
    func testAfterInvalidTapBothButtonsAreEnabledAfterDelay() {
        
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        let button = app.buttons["Invalid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        
        Thread.sleep(forTimeInterval: 7)
        
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(app.buttons["Valid"].isEnabled)
    }
    
    func testAfterValidTapBothButtonsAreEnabledAfterDelay() {
        
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        let button = app.buttons["Valid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        
        Thread.sleep(forTimeInterval: 7)
        
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(app.buttons["Invalid"].isEnabled)
    }
}
