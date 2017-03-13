//
//  Helpers.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 07/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import Firebase

typealias Completion = () -> ()
typealias LoginCompletion = (FIRUser?, Error?) -> ()

func delay(_ delay: Double, closure: @escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

enum App {
    case control
    case experimental
    
    static var current: App {
        if let id = Bundle.main.bundleIdentifier, id.lowercased().contains("control") {
            return .control
        } else {
            return .experimental
        }
    }
}
