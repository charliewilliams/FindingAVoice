//
//  RuleSet.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 14/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct RuleSet {
    
    var rules: [Rule]
    
    var userFacingDescription: String {
        return rules.map({ $0.userFacingDescription }).joined(separator: "\n")
    }
    
    func string(length: Int, shouldBeValid: Bool) -> String {
        
        var rules = self.rules
        let allActiveChars = rules.flatMap({ $0.preceding + $0.following })
        let first = rules.removeFirst()
        
        var string = first.string(length: length, shouldBeValid: shouldBeValid)
        
        for rule in rules {
            string = rule.string(length: length, mutating: string, protectedCharacters: allActiveChars, shouldBeValid: shouldBeValid)
        }
        
        return string
    }
    
    func similarCopy() -> RuleSet {
        return RuleSet(rules: rules.map({ $0.similarCopy() }))
    }
}
