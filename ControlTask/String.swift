//
//  String.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

extension String {
    
    subscript(i: Int) -> Character {
        guard i >= 0 && i < characters.count else { return Character("") }
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(range: CountableRange<Int>) -> Character {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return Character(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)])
    }
    
    subscript(range: ClosedRange<Int>) -> Character {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return Character(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)])
    }
}
