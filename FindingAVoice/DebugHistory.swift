//
//  DebugHistory.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 11/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

/*
 I'm pretty happy with this little class. It lets you have immutable value types 
 (such as Rule and RuleSet in this project)
 with this as a property; you can then mutate the debugHistory property without
 mutating the value type that holds it. When you're in production, you can remove
 this property or make `print` a no-op.
 */

import Foundation

class DebugHistory {
    
    private var strings = [String]()
    
    init(string: String? = nil) {
        
        if let string = string {
            strings = [string]
        }
    }
    
    func append(_ string: String) {
        strings.append(string)
    }
    
    func print() -> String {
        return strings.joined(separator: "\n")
    }
}
