//
//  RuleTests.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Emoji_Game

let testAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

class RuleTests: XCTestCase {
    
    func testUsesVocabulary() {
        
        let testSet = Rule(vocabulary: "XO")
        
        XCTAssertTrue(testSet.preceding == ["O"] || testSet.following == ["O"])
        XCTAssertTrue(testSet.preceding == ["X"] || testSet.following == ["X"])
        XCTAssertNotEqual(testSet.preceding, testSet.following)
    }
    
    func testReadsPrecedingCount() {
        XCTAssertEqual(5, Rule(precedingCount: 5).preceding.count)
    }
    
    func testReadsFollowingCount() {
        XCTAssertEqual(5, Rule(followingCount: 5).following.count)
    }
    
    func testNoDuplicatesWithinPreceding() {
        
        let testSet = Rule(precedingCount: 20, vocabulary: testAlphabet)
        let uniques = Set(testSet.preceding)
        XCTAssertEqual(20, uniques.count)
    }
    
    func testNoDuplicatesBetweenPrecedingAndFollowing() {
        
        let testSet = Rule(precedingCount: 26, followingCount: 26, vocabulary: testAlphabet)
        let uniquesP = Set(testSet.preceding)
        let uniquesF = Set(testSet.following)
        XCTAssertEqual(26, uniquesP.count)
        XCTAssertEqual(26, uniquesF.count)
        XCTAssertEqual(52, Set(testSet.preceding + testSet.following).count)
    }
    
    //
    
    func testValidString() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let validString = "XO"
        XCTAssertTrue(rule.stringIsValid(validString))
    }
    
    func testInvalidString() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let invalidString = "XX"
        XCTAssertFalse(rule.stringIsValid(invalidString))
    }
    
    func testValidStringWithMultipleOccurrences() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let validString = "XOABCDXO"
        XCTAssertTrue(rule.stringIsValid(validString))
    }
    
    func testInvalidStringWithMultipleOccurrences() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let invalidString = "XOABCDXX"
        XCTAssertFalse(rule.stringIsValid(invalidString))
    }
    
    func testValidStringWithMultiplePrecedents() {
        
        var rule = Rule()
        rule.preceding = ["X", "Y"]
        rule.following = ["O"]
        
        let validString = "XOYO"
        XCTAssertTrue(rule.stringIsValid(validString))
    }
    
    func testInvalidStringWithMultiplePrecedents() {
        
        var rule = Rule()
        rule.preceding = ["X", "Y"]
        rule.following = ["O"]
        
        let invalidString = "XOOY"
        XCTAssertFalse(rule.stringIsValid(invalidString))
    }
    
    func testValidStringWithMultipleFollows() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O", "P"]
        
        let validString = "XOXP"
        XCTAssertTrue(rule.stringIsValid(validString))
    }
    
    func testInvalidStringWithMultipleFollows() {
        
        var rule = Rule()
        rule.preceding = ["X"]
        rule.following = ["O", "P"]
        
        let invalidString = "XOPX"
        XCTAssertFalse(rule.stringIsValid(invalidString))
    }
    
    //
    
    func testStringHasRequestedLength() {
        
        let rule = Rule()
        
        let testString = try! rule.string(length: 10, shouldBeValid: true)
        XCTAssertEqual(10, testString.count)
        
        let testString2 = try! rule.string(length: 4, shouldBeValid: false)
        XCTAssertEqual(4, testString2.count)
    }
    
    func testCreatedStringIsValid() {
        
        for _ in 0..<1000 {
            let rule = Rule()
            
            let testString = try! rule.string(length: 10, shouldBeValid: true)
            XCTAssertTrue(rule.stringIsValid(testString), "\(testString) should be valid but apparently is invalid?? Rule is: \(rule.debugFullHistory.print())")
        }
    }
    
    func testCreatedStringIsInvalid() {
        
        for _ in 0..<1000 {
            let rule = Rule()
            
            let testString = try! rule.string(length: 10, shouldBeValid: false)
            XCTAssertFalse(rule.stringIsValid(testString), "\(testString) should be invalid but apparently is valid?? Rule is: \(rule.debugFullHistory.print())")
        }
    }
    
    func testForcedXOValidString() {
        
        var rule = Rule(vocabulary: testAlphabet)
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let testString = try! rule.string(length: 2, shouldBeValid: true)
        
        XCTAssertEqual("XO", testString)
    }
    
    func testForcedXOInvalidString() {
        
        var rule = Rule(vocabulary: testAlphabet)
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let testString = try! rule.string(length: 2, shouldBeValid: false)
        
        XCTAssertNotEqual("XO", testString)
    }
    
    func testValidStringWithOneOccurrenceContainsOnePrecedingAndOneFollowingChar() {
        
        var rule = Rule(vocabulary: testAlphabet, density: 0.1)
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let testString = try! rule.string(length: 10, shouldBeValid: true)
        
        XCTAssertEqual(9, testString.replacingOccurrences(of: "X", with: "").count, testString)
        XCTAssertEqual(9, testString.replacingOccurrences(of: "O", with: "").count, testString)
    }
    
    func testInvalidStringWithOneOccurrenceContainsOnePrecedingAndOneFollowingChar() {
        
        var rule = Rule(vocabulary: testAlphabet, density: 0.1)
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let testString = try! rule.string(length: 10, shouldBeValid: false)
        
        XCTAssertEqual(9, testString.replacingOccurrences(of: "X", with: "").count)
        XCTAssertEqual(9, testString.replacingOccurrences(of: "O", with: "").count)
    }
    
    func testLongInvalidStringContainsSomeValidPairs() {
        
        var rule = Rule(vocabulary: testAlphabet, density: 0.5)
        rule.preceding = ["X"]
        rule.following = ["O"]
        
        let testString = try! rule.string(length: 100, shouldBeValid: false)
        
        XCTAssertTrue(testString.contains("XO"))
    }
    
    //
    
    func testThrowsOnImpossibleDensity() {
        
        let impossibleDensity: Float = 0.6
        XCTAssertThrowsError(try Rule(vocabulary: testAlphabet, density: impossibleDensity).string(length: 2, shouldBeValid: true))
    }
    
    func testThrowsOnZeroLength() {
        
        XCTAssertThrowsError(try Rule(vocabulary: testAlphabet, density: 0.25).string(length: 0, shouldBeValid: true))
    }
    
    func testPrecedingAlwaysAppearsInInvalidString() {
        
        // Run tests including randomness a bunch of times
        // This isn't totally ideal but works in practice since we're not Google
        for d in 1...1000 {
            // densities random between 0 and 0.58
            let density = Float(d) / 1700.0
            var rule = Rule(vocabulary: testAlphabet, density: density)
            rule.preceding = ["X"]
            rule.following = ["O"]
            XCTAssertTrue(try! rule.string(length: 20, shouldBeValid: false).contains("X"))
        }
    }
    
    //
    
    func testIndicesMakingWhenEntireStringIsPassive() {
        
        let passive = "ABCDEFG"
        let active = "HI"
        
        let testString = "ABCDEFG"
        let expectedIndices = [0, 1, 2, 3, 4, 5, 6]
        
        var rule = Rule(vocabulary: passive + active, protectedCharacters: ["H", "I"])
        rule.preceding = ["H"]
        rule.following = ["I"]
        let indices = rule.followingIndicesWhichMakeAnInvalidPair(forString: testString, passiveCharacters: ["A", "B", "C", "D", "E", "F", "G"])
        
        XCTAssertEqual(indices, expectedIndices, rule.debugFullHistory.print())
    }
    
    func testIndicesMakingWhenEntireStringIsActive() {
        
        let passive = "ABCDEFG"
        let active = "HI"
        
        let testString = "HIHIHIHI"
        let expectedIndices = [Int]()
        
        let rule = Rule(vocabulary: passive + active)
        let indices = rule.followingIndicesWhichMakeAnInvalidPair(forString: testString, passiveCharacters: ["A", "B", "C", "D", "E", "F", "G"])
        
        XCTAssertEqual(indices, expectedIndices)
    }
    
    func testIndicesMakingSpecificIndexIsPreceding() {
        
        let passive = "ABCDEFG"
        let active = "HI"
        
        let testString = "ABCHEFG"
        let expectedIndices = [0, 1, 2, 5, 6]
        
        var rule = Rule(vocabulary: passive + active)
        rule.preceding = ["H"]
        rule.following = ["I"]
        
        let indices = rule.followingIndicesWhichMakeAnInvalidPair(forString: testString, passiveCharacters: ["A", "B", "C", "D", "E", "F", "G"])
        
        XCTAssertEqual(indices, expectedIndices)
    }
    
    func testIndicesMakingSpecificIndexIsFollowing() {
        
        let passive = "ABCDEFG"
        let active = "HI"
        
        let testString = "ABCIEFG"
        let expectedIndices = [0, 1, 2, 4, 5, 6]
        
        var rule = Rule(vocabulary: passive + active)
        rule.preceding = ["H"]
        rule.following = ["I"]
        
        let indices = rule.followingIndicesWhichMakeAnInvalidPair(forString: testString, passiveCharacters: ["A", "B", "C", "D", "E", "F", "G"])
        
        XCTAssertEqual(indices, expectedIndices)
    }
}
