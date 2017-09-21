//
//  String.swift
//  ControlTask
//
//  Created by Charlie Williams on 05/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

extension String { // Validation
    
    var isValidName: Bool {
        return characters.count > 3 && containsOnlyLetters()
    }
    
    func containsOnlyLetters() -> Bool {
        
        if self.trimmingCharacters(in: .letters).trimmingCharacters(in: .whitespaces) != "" {
            return false
        }
        return true
    }
}

extension String { // Subscripting
    
    subscript(i: Int) -> Character {
        guard i >= 0 && i < characters.count else { return Character("") }
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(range: CountableRange<Int>) -> Character {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return Character(String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex)]))
    }
    
    subscript(range: ClosedRange<Int>) -> Character {
        let lowerIndex = index(startIndex, offsetBy: max(0,range.lowerBound), limitedBy: endIndex) ?? endIndex
        return Character(String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex)]))
    }
    
    mutating func replace(atIndex index: Int, with newChar: Character) {
        var chars = Array(characters)
        chars[index] = newChar
        self = String(chars)
    }
}

extension String { // Random
    
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomLength = UInt32(letters.characters.count)
        
        let randomString: String = (0 ..< length).reduce(String()) { accum, _ in
            let randomOffset = arc4random_uniform(randomLength)
            let randomIndex = letters.index(letters.startIndex, offsetBy: Int(randomOffset))
            return accum.appending(String(letters[randomIndex]))
        }
        
        return randomString
    } 
}

extension String {
    
    func toIntArray() -> [Int] {
        return trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",").flatMap { Int($0) }
    }
    
    func toStringArray() -> [String] {
        return trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ",")
    }
}
