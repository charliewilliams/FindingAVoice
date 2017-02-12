//
//  DebugHistory.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 11/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

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
