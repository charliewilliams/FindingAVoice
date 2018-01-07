//
//  File.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct Rule {
    
    enum CreationError: String, Error {
        case impossibleDensity = "Impossibly high density"
        case zeroDensity = "Cannot have zero density"
        case zeroLength = "Cannot have zero string length"
    }
    
    var preceding = [Character]()
    var following = [Character]()
    var stride: Int
    var density: Float
    var vocabulary: String {
        didSet {
            charactersArray = vocabulary.map() { $0 }
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
    var debugFullHistory = DebugHistory()
    
    init(difficulty d: Difficulty, protectedCharacters: [Character] = []) {
        
        switch d {
        case .easy:
            
            let vocab = Array(fullVocabulary.prefix(30)).map({ String($0) }).joined()
            self.init(precedingCount: 1, followingCount: 1, vocabulary: vocab, density: 0.05, stride: 1, protectedCharacters: protectedCharacters)
            
        case .medium:
            
            let vocab = Array(fullVocabulary.prefix(35)).map({ String($0) }).joined()
            self.init(precedingCount: 1, followingCount: 2, vocabulary: vocab, density: 0.14, stride: 2, protectedCharacters: protectedCharacters)
            
        case .hard:
            
            let vocab = Array(fullVocabulary.prefix(40)).map({ String($0) }).joined()
            self.init(precedingCount: 1, followingCount: 3, vocabulary: vocab, density: 0.2, stride: 3, protectedCharacters: protectedCharacters)
        }
    }
    
    init(precedingCount: Int = 1, followingCount: Int = 1, vocabulary: String = fullVocabulary, density: Float = 0.2, stride: Int = 1, protectedCharacters: [Character] = []) {
        
        precondition(vocabulary.count > 1)
        precondition(precedingCount > 0)
        precondition(followingCount > 0)
        precondition(vocabulary.count - protectedCharacters.count >= precedingCount + followingCount, "Trying to make too complex of a ruleset with too small a vocabulary!")
        self.stride = stride
        self.vocabulary = vocabulary
        self.density = density
        charactersArray = vocabulary.map() { $0 }
        
        var passiveCharacters = charactersArray.filter { character -> Bool in
            !protectedCharacters.contains(character)
        }
        
        for _ in 0..<precedingCount {
            preceding.append(passiveCharacters.popRandomItem())
        }
        
        for _ in 0..<followingCount {
            following.append(passiveCharacters.popRandomItem())
        }
        
        // Start out with userFacingDescription; append all the string mutations for debugging
        debugFullHistory.append(userFacingDescription)
    }
    
    func stringIsValid(_ string: String) -> Bool {
        
        for (index, character) in string.enumerated() {
            
            for precedent in preceding {
                if character == precedent {
                    
                    guard string.count > index + stride else {
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
    
    func string(length: Int, mutating existingString: String? = nil, protectedCharacters: [Character] = [], shouldBeValid: Bool) throws -> String {
        
        guard length > 1 else {
            throw CreationError.zeroLength
        }
//        guard density > 0 else {
//            throw RuleCreationError.zeroDensity
//        }
        guard density < 0.6 else {
            throw CreationError.impossibleDensity
        }
        
        var numberOfOccurrencesRemaining = Int(Float(length) * density)
        if numberOfOccurrencesRemaining == 0 { numberOfOccurrencesRemaining = 1 }
        
        let activeCharacters = protectedCharacters + preceding + following
        let passiveCharacters = charactersArray.filter() { !activeCharacters.contains($0) }
        
        var string = existingString ?? randomString(fromCharacters: passiveCharacters, length: length)
        
        debugFullHistory.append("Starting with: \(string).")
        debugFullHistory.append("Making a\(shouldBeValid ? " valid" : "n invalid") \(length)-char string with \(numberOfOccurrencesRemaining) active pair(s).")
        
        let lastAllowablePrecedentIndex = length - stride - 1
        var hasFailed: Bool = false // only used if shouldBeValid == false
        
        // add as many "rule" occurrences as required
        // if `shouldBeValid`, add the `following` characters
        while numberOfOccurrencesRemaining > 0 {
            
            // All the indices that aren't currently part of a pair
            var currentlyPassiveIndices = string.enumerated().flatMap { c -> Int? in
                if passiveCharacters.contains(c.element) {
                    return c.offset
                }
                return nil
            }
            
            // To make a valid string, we can only place our `preceding` character in a place where it can be followed by `following`
            let possibleValidFirstIndices = currentlyPassiveIndices.filter { index -> Bool in
                index + stride < length && passiveCharacters.contains(string[index + stride])
            }
            
            // Safety
            if possibleValidFirstIndices.count == 0 {
                break
            }
            
            // Only put in one failure, to make things more interesting
            let validThisRound = shouldBeValid || hasFailed
            
            let firstIndex = validThisRound ? possibleValidFirstIndices.randomItem() : currentlyPassiveIndices.randomItem()
            
            currentlyPassiveIndices.remove(at: currentlyPassiveIndices.index(of: firstIndex)!)
            debugFullHistory.append("Index of preceding: \(firstIndex)")
            
            defer {
                numberOfOccurrencesRemaining -= 1
            }
            
            // Put the preceding character in place
            string.replace(atIndex: firstIndex, with: preceding.randomItem())
            
            // Look for all the places we can put a following character if we're trying to make an invalid string
            // These indices must not 1) replace an existing precedent character or 2) inadvertently make a valid pair with an existing precedent character
            let followingIndicesToMakeAnInvalidPair = followingIndicesWhichMakeAnInvalidPair(forString: string, passiveCharacters: passiveCharacters)
            
            if !validThisRound {
                debugFullHistory.append("Indices we think we can replace: \(followingIndicesToMakeAnInvalidPair)")
                
                if followingIndicesToMakeAnInvalidPair.count == 0 {
                    debugFullHistory.append("Out of places to put another pair! Bailing…")
                    break
                }
            }
            
            let secondIndex: Int
                
            if validThisRound {
                secondIndex = firstIndex + stride
            } else {
                secondIndex = followingIndicesToMakeAnInvalidPair.randomItem()
                hasFailed = true
                debugFullHistory.append("First invalid pair must be invalid")
            }
            
            // Don't run off the end of the string
            if secondIndex < length {
                string.replace(atIndex: secondIndex, with: following.randomItem())
                debugFullHistory.append("Replaced \(firstIndex) & \(secondIndex): \(string)")
            } else {
                // If we were set to run off the end, we shouldn't be trying to make a valid string.
                assert(shouldBeValid == false)
            }
        }
        
        debugFullHistory.append("\(stringIsValid(string) ? "VALID" : "INVALID"): \(string)")
        return string
    }
    
    func followingIndicesWhichMakeAnInvalidPair(forString string: String, passiveCharacters: [Character]) -> [Int] {
        
        // THIS IS FOR THE FOLLOWING HALF OF A PAIR ONLY
        var followingIndicesMakingAnInvalidPair = [Int]()
        
        for (index, character) in string.enumerated() {
            
            // Make sure we're not replacing an active character
            guard passiveCharacters.contains(character) else {
                continue
            }
            
            // 1. If there's no way a preceding character could come 'stride' characters before this in the string, we're good
            // 2. If a preceding character could, but it isn't, we're also good
            if index - stride < 0 || !preceding.contains(string[index - stride]) {
                followingIndicesMakingAnInvalidPair.append(index)
            }
        }
        
        return followingIndicesMakingAnInvalidPair
    }
    
    func randomString(fromCharacters characters: [Character], length: Int) -> String {
        
        var string = ""
        // build a string of random items from the vocabulary
        // but don't use anything from `preceding`
        for _ in 0..<length {
            string.append(characters.randomItem())
        }
        dprint(string)
        return string
    }
}

// MARK: - Copying / propogating

extension Rule {
    
    func similarCopy() -> Rule {
        return Rule(precedingCount: preceding.count, followingCount: following.count, vocabulary: vocabulary, density: density, stride: stride)
    }
}
