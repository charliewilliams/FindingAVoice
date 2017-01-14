//
//  DebugPrint.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 14/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

let inDebug = UserDefaults.standard.bool(forKey: "debug")

func dprint(_ items: Any...) {
    if inDebug {
        print(items)
    }
}
