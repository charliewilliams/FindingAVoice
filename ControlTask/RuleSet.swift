//
//  File.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct RuleSet {
    
    var preceding = [String]()
    var following = [String]()
    
    init(precedingCount: Int = 1, followingCount: Int = 1, vocabulary: String = fullVocabulary) {
        
        precondition(vocabulary.characters.count > 1)
        var charactersArray = vocabulary.characters.map() { String($0) }
        
        for _ in 0..<precedingCount {
            preceding.append(charactersArray.randomItem())
            charactersArray = charactersArray.filter() { !preceding.contains($0) }
        }
        
        for _ in 0..<followingCount {
            following.append(charactersArray.randomItem())
            charactersArray = charactersArray.filter() { !following.contains($0) }
        }
    }
}
