//
//  QuestionProviderTests.swift
//  ExperimentalTaskTests
//
//  Created by Charlie Williams on 27/09/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Songs_Game

class QuestionProviderTests: XCTestCase {
    
    func testNextQuestionDoesNotCrash() {
        for _ in 0..<1000 {
            _ = QuestionProvider.shared.nextQuestion()
        }
    }
}
