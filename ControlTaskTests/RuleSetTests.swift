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
    
    //
    
    func testStringHasRequestedLength() {
        
        let ruleSet = RuleSet()
        
        let testString = ruleSet.string(length: 10, shouldBeValid: true)
        XCTAssertEqual(10, testString.characters.count)
        
        let testString2 = ruleSet.string(length: 4, shouldBeValid: false)
        XCTAssertEqual(4, testString2.characters.count)
    }
    
    func testCreatedStringIsValid() {
        
        let ruleSet = RuleSet()
        
        let testString = ruleSet.string(length: 10, shouldBeValid: true)
        XCTAssertTrue(ruleSet.stringIsValid(string: testString))
    }
    
    func testCreatedStringIsInvalid() {
        
        let ruleSet = RuleSet()
        
        let testString = ruleSet.string(length: 10, shouldBeValid: false)
        XCTAssertFalse(ruleSet.stringIsValid(string: testString))
    }
    
    func testForcedXOValidString() {
        
        var ruleSet = RuleSet(vocabulary: testAlphabet)
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let testString = ruleSet.string(length: 2, shouldBeValid: true)
        
        XCTAssertEqual("XO", testString)
    }
    
    func testForcedXOInvalidString() {
        
        var ruleSet = RuleSet(vocabulary: testAlphabet)
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let testString = ruleSet.string(length: 2, shouldBeValid: false)
        
        XCTAssertNotEqual("XO", testString)
    }
    
    func testValidStringWithOneOccurrenceContainsOnePrecedingAndOneFollowingChar() {
        
        var ruleSet = RuleSet(vocabulary: testAlphabet, density: 0.1)
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let testString = ruleSet.string(length: 10, shouldBeValid: true)
        
        XCTAssertEqual(9, testString.replacingOccurrences(of: "X", with: "").characters.count, testString)
        XCTAssertEqual(9, testString.replacingOccurrences(of: "O", with: "").characters.count, testString)
    }
    
    func testInvalidStringWithOneOccurrenceContainsOnePrecedingAndOneFollowingChar() {
        
        var ruleSet = RuleSet(vocabulary: testAlphabet, density: 0.1)
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let testString = ruleSet.string(length: 10, shouldBeValid: false)
        
        XCTAssertEqual(9, testString.replacingOccurrences(of: "X", with: "").characters.count)
        XCTAssertEqual(9, testString.replacingOccurrences(of: "O", with: "").characters.count)
    }
    
    func testLongInvalidStringContainsSomeValidPairs() {
        
        var ruleSet = RuleSet(vocabulary: testAlphabet, density: 0.5)
        ruleSet.preceding = ["X"]
        ruleSet.following = ["O"]
        
        let testString = ruleSet.string(length: 1000, shouldBeValid: false)
        
        XCTAssertTrue(testString.contains("XO"))
    }
    
    //
    
    func testThrowsOnImpossibleDensity() {
        
        // ??
    }
    
    
}
