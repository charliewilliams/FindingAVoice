//
//  RuleSetTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import ControlTask

class RuleSetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

    }
    
    func testAllActiveCharactersAreUnique() {
        
        let ruleSet = RuleSet(count: 4, maxPrecedingCount: 3, maxFollowingCount: 3, density: 0, maxStride: 1)
        
        var allActiveCharacters = [Character]()
        
        for rule in ruleSet.rules {
            allActiveCharacters += rule.preceding + rule.following
        }
        
        let set = Set(allActiveCharacters)
        XCTAssertEqual(allActiveCharacters.count, set.count)
    }
    
    func testValid4RuleStringIsValid() {
        
        let ruleSet = RuleSet(count: 4, maxPrecedingCount: 1, maxFollowingCount: 1, density: 0, maxStride: 1)
        
        for _ in 0..<100 {
            let string = try! ruleSet.string(length: 20, shouldBeValid: true)
            XCTAssertTrue(ruleSet.stringIsValid(string), ruleSet.debugFullHistory)
        }
    }
    
    func testInvalid4RuleStringIsInvalid() {
        
        let ruleSet = RuleSet(count: 4, maxPrecedingCount: 1, maxFollowingCount: 1, density: 0, maxStride: 1)
        
        for _ in 0..<100 {
            let string = try! ruleSet.string(length: 20, shouldBeValid: false)
            XCTAssertFalse(ruleSet.stringIsValid(string), ruleSet.debugFullHistory)
        }
    }
    
    func testValid4RulePolyStringIsValid() {
        
        let ruleSet = RuleSet(count: 4, maxPrecedingCount: 3, maxFollowingCount: 3, density: 0, maxStride: 1)
        
        for _ in 0..<100 {
            let string = try! ruleSet.string(length: 20, shouldBeValid: true)
            XCTAssertTrue(ruleSet.stringIsValid(string), ruleSet.debugFullHistory)
        }
    }
    
    func testInvalid4RulePolyStringIsInvalid() {
        
        let ruleSet = RuleSet(count: 4, maxPrecedingCount: 3, maxFollowingCount: 3, density: 0, maxStride: 1)
        
        for _ in 0..<100 {
            let string = try! ruleSet.string(length: 20, shouldBeValid: false)
            XCTAssertFalse(ruleSet.stringIsValid(string), ruleSet.debugFullHistory)
        }
    }
}
