//
//  File.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct RuleSet {
    
    var preceding: String = ""
    var following: [String] = []
    
    init(followingCount count: Int = 1) {
        
        var charactersArray = fullVocabulary.characters.map({ String($0) })
        preceding = charactersArray.randomItem()
        
        charactersArray = charactersArray.filter() { $0 != preceding }
        
        following = []
        
        for _ in 0..<count {
            following.append(charactersArray.randomItem())
        }
    }
}
