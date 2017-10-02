//
//  RuleSet.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 14/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct RuleSet {
    
    private(set) var rules = [Rule]()
    
    var userFacingDescription: String {
        return rules.map({ $0.userFacingDescription }).joined(separator: "\n")
    }
    
    var debugFullHistory: String {
        return rules.map({ $0.debugFullHistory.print() }).joined(separator: "\n—\n")
    }
    var stringLength: Int

    init() {

        let count, stringLength, maxFollowing, maxStride: Int
        let density: Float
        let vocab: String

        switch DifficultyProvider.currentDifficulty {

        case .easy:
            count = 1; stringLength = 10; maxFollowing = 1; maxStride = 1; density = 0.05; vocab = String(fullVocabulary.prefix(30))
        case .medium:
            count = 2; stringLength = 15; maxFollowing = 2; maxStride = 2; density = 0.14; vocab = String(fullVocabulary.prefix(35))
        case .hard:
            count = 2; stringLength = 20; maxFollowing = 3; maxStride = 3; density = 0.20; vocab = String(fullVocabulary.prefix(40))
        }

        self.init(count: count, stringLength: stringLength, vocabulary: vocab, maxPrecedingCount: 1, maxFollowingCount: maxFollowing, density: density, maxStride: maxStride)
    }
    
    init(count: Int, stringLength: Int = 20, vocabulary: String = fullVocabulary, maxPrecedingCount: Int, maxFollowingCount: Int, density: Float, maxStride: Int) {

        self.stringLength = stringLength
        self.vocabulary = vocabulary
        self.maxPrecedingCount = maxPrecedingCount
        self.maxFollowingCount = maxFollowingCount
        self.maxStride = maxStride
        
        var activeCharacters = [Character]()
        
        for _ in 0..<count {
            
            let precedingCount = Int(arc4random_uniform(UInt32(maxPrecedingCount))) + 1
            let followingCount = Int(arc4random_uniform(UInt32(maxFollowingCount))) + 1
            let stride = Int(arc4random_uniform(UInt32(maxStride))) + 1
            
            let rule = Rule(precedingCount: precedingCount, followingCount: followingCount, vocabulary: vocabulary, density: density, stride: stride, protectedCharacters: activeCharacters)
            
            activeCharacters += rule.preceding + rule.following
            
            rules.append(rule)
        }
    }
    
    func string(shouldBeValid: Bool) throws -> String {
        
        let indexOfFailingRule = Int(shouldBeValid ? UInt32.max : arc4random_uniform(UInt32(rules.count)))
        let allActiveChars = rules.flatMap { $0.preceding + $0.following }
        
        var string: String? = nil
        
        for (index, rule) in rules.enumerated() {
            string = try rule.string(length: stringLength, mutating: string, protectedCharacters: allActiveChars, shouldBeValid: indexOfFailingRule != index)
        }
        
        return string!
    }
    
    func stringIsValid(_ string: String) -> Bool {
        
        for rule in rules {
            if !rule.stringIsValid(string) {
                return false
            }
        }
        
        return true
    }
    
    // Make another set using the same parameters
    func similarCopy() -> RuleSet {
        return RuleSet(count: rules.count, stringLength: stringLength, vocabulary: vocabulary, maxPrecedingCount: maxPrecedingCount, maxFollowingCount: maxFollowingCount, density: rules.first!.density, maxStride: maxStride)
    }
    
    // Private for similarCopy() only
    private let vocabulary: String
    private let maxPrecedingCount: Int
    private let maxFollowingCount: Int
    private let maxStride: Int
}
