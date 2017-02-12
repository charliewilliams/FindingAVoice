//
//  Array.swift
//  ControlTask
//
//  Created by Charlie Williams on 14/11/2016.
//  Copyright © 2016 Charlie Williams. All rights reserved.
//

import Foundation

extension Array {
    
    func randomItem() -> Element {
        
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    mutating func popRandomItem() -> Element {
        
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return remove(at: index)
    }
}
