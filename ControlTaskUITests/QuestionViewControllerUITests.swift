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
    
    func testFirstQuestionTimesOutAndDoesntBreakSecondQuestion() {
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        // Let the first question time out
        Thread.sleep(forTimeInterval: 11)
        
        app.buttons["Continue"].tap()
        Thread.sleep(forTimeInterval: 3)
        
        // Make sure we can tap the next button
        let validButton = app.buttons["Valid"]
        XCTAssertTrue(validButton.isEnabled)
        validButton.tap()
    }
    
    func testSecondQuestionTimesOutAndDoesntBreakThirdQuestion() {
        
        let app = XCUIApplication()
        app.buttons["Go!"].tap()
        
        // Tap through the first question
        let validButton = app.buttons["Valid"]
        validButton.tap()
        
        // Let the second question time out
        Thread.sleep(forTimeInterval: 12)
        
        app.buttons["Continue"].tap()
        Thread.sleep(forTimeInterval: 3)
        
        // Make sure we can tap the third button
        XCTAssertTrue(validButton.isEnabled)
        validButton.tap()
    }
}
