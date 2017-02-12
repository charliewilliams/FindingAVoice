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
}
