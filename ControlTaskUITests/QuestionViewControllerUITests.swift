//
//  QuestionViewControllerUITests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 22/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest

class QuestionViewControllerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launchArguments = ["UITestingIgnoreDailyTimer"]
        app.launch()
        
        XCUIDevice.shared().orientation = .landscapeRight
        
        getToQuestionViewController()
    }
    
    func getToQuestionViewController() {
        
        app.buttons["Let's get started!"].tap()
        app.buttons["Go!"].tap()
    }
    
    func testTappingValidButtonDisablesBothButtons() {
        
        let button = app.buttons["Valid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        XCTAssertFalse(button.isEnabled)
        XCTAssertFalse(app.buttons["Invalid"].isEnabled)
    }
    
    func testTappingInvalidButtonDisablesBothButtons() {
        
        let button = app.buttons["Invalid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        XCTAssertFalse(button.isEnabled)
        XCTAssertFalse(app.buttons["Valid"].isEnabled)
    }
    
    func testAfterInvalidTapBothButtonsAreEnabledAfterDelay() {
        
        let button = app.buttons["Invalid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        
        Thread.sleep(forTimeInterval: 7)
        
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(app.buttons["Valid"].isEnabled)
    }
    
    func testAfterValidTapBothButtonsAreEnabledAfterDelay() {
        
        let button = app.buttons["Valid"]
        
        XCTAssertTrue(button.isEnabled)
        
        button.tap()
        
        Thread.sleep(forTimeInterval: 7)
        
        XCTAssertTrue(button.isEnabled)
        XCTAssertTrue(app.buttons["Invalid"].isEnabled)
    }
    
    func testFirstQuestionTimesOutAndDoesntBreakSecondQuestion() {
        
        let button = app.buttons["Continue"]
        
        // Let the first question time out
        Thread.sleep(forTimeInterval: 11)
        
        button.tap()
        Thread.sleep(forTimeInterval: 3)
        
        // Make sure we can tap the next button
        let validButton = app.buttons["Valid"]
        XCTAssertTrue(validButton.isEnabled)
        validButton.tap()
    }
    
    func testSecondQuestionTimesOutAndDoesntBreakThirdQuestion() {
        
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
