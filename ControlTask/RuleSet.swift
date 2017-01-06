//
//  File.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct RuleSet {
    
    var preceding = [Character]()
    var following = [Character]()
    var stride: Int
    var vocabulary: String {
        didSet {
            charactersArray = vocabulary.characters.map() { $0 }
        }
    }
    var charactersArray: [Character]
    
    init(precedingCount: Int = 1, followingCount: Int = 1, vocabulary: String = fullVocabulary, stride: Int = 1) {
        
        precondition(vocabulary.characters.count > 1)
        self.stride = stride
        self.vocabulary = vocabulary
        charactersArray = vocabulary.characters.map() { $0 }
        
        for _ in 0..<precedingCount {
            preceding.append(charactersArray.randomItem())
            charactersArray = charactersArray.filter() { !preceding.contains($0) }
        }
        
        for _ in 0..<followingCount {
            following.append(charactersArray.randomItem())
            charactersArray = charactersArray.filter() { !following.contains($0) }
        }
    }
    
    func stringIsValid(string: String) -> Bool {
        
        for (index, character) in string.characters.enumerated() {
            
            for precedent in preceding {
                if character == precedent {
                    
                    guard string.characters.count > index + stride else {
                        return false
                    }
                    
                    let characterAtAnswer = string[index + stride]
                    if !following.contains(characterAtAnswer) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func string(length: Int, density: Float = 0.5, shouldBeValid: Bool) -> String {
        
        precondition(length > 1)
        precondition(density > 0 && density < 1)
        
        var numberOfOccurrences = Int(Float(length) * density)
        if numberOfOccurrences == 0 { numberOfOccurrences = 1 }
        
        let passiveCharacters = charactersArray.filter() { !preceding.contains($0) }
        
        // build a string of random items from the vocabulary
        // but don't use anything from `preceding`
        var string = ""
        for _ in 0..<length {
            string.append(passiveCharacters.randomItem())
        }
        
        let lastAllowablePrecedentIndex = length - stride
        
        // add as many "rule" occurrences as required
        // if `shouldBeValid`, add the `following` characters
        while numberOfOccurrences > 0 {
            
            let index = Int(arc4random_uniform(UInt32(lastAllowablePrecedentIndex)))
            
            // If we'd screw up an existing occurrence, bail
            if (preceding + following).contains(string[index]) {
                continue
            }
            
            let precedingIndex = string.index(string.startIndex, offsetBy: index)
            let precedingRange = precedingIndex..<string.index(string.startIndex, offsetBy: index + 1)
            string.replaceSubrange(precedingRange, with: String(preceding.randomItem()))
            
            if shouldBeValid {
                
                let followingIndex = string.index(precedingIndex, offsetBy: stride)
                let followingRange = followingIndex..<string.index(precedingIndex, offsetBy: stride + 1)
                string.replaceSubrange(followingRange, with: String(following.randomItem()))
            }
            
            numberOfOccurrences -= 1
        }
        
        
        return string
    }
}
