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
    var density: Float
    var vocabulary: String {
        didSet {
            charactersArray = vocabulary.characters.map() { $0 }
        }
    }
    var charactersArray: [Character]
    
    var userFacingDescription: String {
        
        var preceding = self.preceding
        var following = self.following
        
        var preceedingString = "\(preceding.popLast()!)"
        var followingString = "\(following.popLast()!)"
        
        for (index, character) in preceding.enumerated() {
            
            if index == preceding.count - 1 {
                preceedingString += " or \(character)"
            } else {
                preceedingString += ", \(character)"
            }
        }
        
        for (index, character) in following.enumerated() {
            
            if index == following.count - 1 {
                followingString += " or \(character)"
            } else {
                followingString += ", \(character)"
            }
        }
        
        var text = "\(preceedingString) must be followed by \(followingString)"
        
        if stride > 1 {
            text += " \(stride) characters later"
        }
        
        text += "."
        
        return text
    }
    
    init(precedingCount: Int = 1, followingCount: Int = 1, vocabulary: String = fullVocabulary, density: Float = 0.2, stride: Int = 1) {
        
        precondition(vocabulary.characters.count > 1)
        self.stride = stride
        self.vocabulary = vocabulary
        self.density = density
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
    
    func string(length: Int, shouldBeValid: Bool) -> String {
        
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
        var hasFailed: Bool = false // only used if shouldBeValid == false
        
        // add as many "rule" occurrences as required
        // if `shouldBeValid`, add the `following` characters
        while numberOfOccurrences > 0 {
            
            let index = Int(arc4random_uniform(UInt32(lastAllowablePrecedentIndex)))
            
            // If we'd screw up an existing occurrence, bail
            if (preceding + following).contains(string[index]) {
                continue
            }
            
            defer {
                numberOfOccurrences -= 1
            }
            
            // Put the preceding character in place
            let precedingIndex = string.index(string.startIndex, offsetBy: index)
            let precedingRange = precedingIndex..<string.index(string.startIndex, offsetBy: index + 1)
            string.replaceSubrange(precedingRange, with: String(preceding.randomItem()))
            
            // Look for all the places we can put a following character if we're trying to make an invalid string
            // These indices must not 1) replace an existing precedent character or 2) inadvertently make a valid pair with an existing precedent character
            var fakeStrideIndices = [Int]()
            for (index, character) in string.characters.enumerated() {
                if passiveCharacters.contains(character) // Make sure we're not screwing up another pair
                    && index - stride >= 0 // Make sure the next step isn't going to run off the back end of the string
                    && passiveCharacters.contains(string[index - stride]) { // Make sure that the character we're replacing
                    fakeStrideIndices.append(index)
                }
            }
            
            if !shouldBeValid && fakeStrideIndices.count == 0 {
                continue // return?
            }
            
            let thisIndex: Int
                
            if shouldBeValid {
                thisIndex = index + stride
            } else if hasFailed {
                thisIndex = arc4random_uniform(2) == 0 ? index + stride : fakeStrideIndices.randomItem()
            } else {
                thisIndex = fakeStrideIndices.randomItem()
                hasFailed = true
            }
            
            let followingRange = string.index(string.startIndex, offsetBy: thisIndex)..<string.index(string.startIndex, offsetBy: thisIndex + 1)
            string.replaceSubrange(followingRange, with: String(following.randomItem()))
        }
        
        
        return string
    }
}
