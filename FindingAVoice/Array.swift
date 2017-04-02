//
//  Array.swift
//  ControlTask
//
//  Created by Charlie Williams on 14/11/2016.
//  Copyright © 2016 Charlie Williams. All rights reserved.
//

import Foundation

extension Array {
    
    func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self.count)))
    }
    
    func randomItem() -> Element {
        return self[randomIndex()]
    }
    
    mutating func popRandomItem() -> Element {
        return remove(at: randomIndex())
    }
}
