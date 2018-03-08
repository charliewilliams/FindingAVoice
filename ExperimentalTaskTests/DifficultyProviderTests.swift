//
//  DifficultyProviderTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 25/09/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Songs_Game

class DifficultyProviderTests: XCTestCase {
    
    func testCurrentDifficultyIsEasyForDay0() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 0), .easy)
    }

    func testCurrentDifficultyIsEasyForDay3() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 3), .easy)
    }

    func testCurrentDifficultyIsMediumForDay4() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 4), .medium)
    }

    func testCurrentDifficultyIsMediumForDay7() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 7), .medium)
    }

    func testCurrentDifficultyIsHardForDay8() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 8), .hard)
    }

    func testCurrentDifficultyIsHardForDay11() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 11), .hard)
    }

    func testCurrentDifficultyIsHardForDay12() {
        XCTAssertEqual(DifficultyProvider.difficulty(forDayNumber: 12), .hard)
    }
}
