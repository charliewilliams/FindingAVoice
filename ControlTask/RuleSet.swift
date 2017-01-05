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
    
    init(precedingCount: Int = 1, followingCount: Int = 1, vocabulary: String = fullVocabulary, stride: Int = 1) {
        
        precondition(vocabulary.characters.count > 1)
        self.stride = stride
        
        var charactersArray = vocabulary.characters.map() { $0 }
        
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
    
    func string(withValidity valid: Bool) -> String {
        
        return ""
    }
}
