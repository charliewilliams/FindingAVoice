//
//  Node.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct Node {
    
    var string: String
    
    init(length: Int) {
        
        let vocabCount = UInt32(fullVocabulary.characters.count)
        let startIndex = fullVocabulary.startIndex
        var string: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(vocabCount)
            string += "\(fullVocabulary[fullVocabulary.index(startIndex, offsetBy: Int(randomValue))])"
        }
        
        self.string = string
    }
}
