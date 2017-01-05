//
//  RuleSetTests.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import ControlTask

let testAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class RuleSetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        
    }
    
    func testUsesVocabulary() {
        
        let testSet = RuleSet(vocabulary: "XO")
        
        XCTAssertTrue(testSet.preceding == ["O"] || testSet.following == ["O"])
        XCTAssertTrue(testSet.preceding == ["X"] || testSet.following == ["X"])
        XCTAssertNotEqual(testSet.preceding, testSet.following)
    }
    
    func testReadsPrecedingCount() {
        XCTAssertEqual(5, RuleSet(precedingCount: 5).preceding.count)
    }
    
    func testReadsFollowingCount() {
        XCTAssertEqual(5, RuleSet(followingCount: 5).following.count)
    }
    
    func testNoDuplicatesWithinPreceding() {
        
        let testSet = RuleSet(precedingCount: 20, vocabulary: testAlphabet)
        let uniques = Set(testSet.preceding)
        XCTAssertEqual(20, uniques.count)
    }
    
    func testNoDuplicatesBetweenPrecedingAndFollowing() {
        
        let testSet = RuleSet(precedingCount: 26, followingCount: 26, vocabulary: testAlphabet)
        let uniquesP = Set(testSet.preceding)
        let uniquesF = Set(testSet.following)
        XCTAssertEqual(26, uniquesP.count)
        XCTAssertEqual(26, uniquesF.count)
        XCTAssertEqual(52, Set(testSet.preceding + testSet.following).count)
    }
    
    //
    
    func testValidString() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let validString = "XO"
        XCTAssertTrue(ruleSet.stringIsValid(string: validString))
    }
    
    func testInvalidString() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let invalidString = "XX"
        XCTAssertFalse(ruleSet.stringIsValid(string: invalidString))
    }
    
    func testValidStringWithMultipleOccurrences() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let validString = "XOABCDXO"
        XCTAssertTrue(ruleSet.stringIsValid(string: validString))
    }
    
    func testInvalidStringWithMultipleOccurrences() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let invalidString = "XOABCDXX"
        XCTAssertFalse(ruleSet.stringIsValid(string: invalidString))
    }
    
    func testValidStringWithMultiplePrecedents() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X", "Y"]
        ruleSet.following = ["O"]
        
        let validString = "XOYO"
        XCTAssertTrue(ruleSet.stringIsValid(string: validString))
    }
    
    func testInvalidStringWithMultiplePrecedents() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X", "Y"]
        ruleSet.following = ["O"]
        
        let invalidString = "XOOY"
        XCTAssertFalse(ruleSet.stringIsValid(string: invalidString))
    }
    
    func testValidStringWithMultipleFollows() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O", "P"]
        
        let validString = "XOXP"
        XCTAssertTrue(ruleSet.stringIsValid(string: validString))
    }
    
    func testInvalidStringWithMultipleFollows() {
        
        var ruleSet = RuleSet()
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O", "P"]
        
        let invalidString = "XOPX"
        XCTAssertFalse(ruleSet.stringIsValid(string: invalidString))
    }
}
