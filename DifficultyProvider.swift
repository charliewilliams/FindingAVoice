//
//  DifficultyProvider.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/05/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

enum Difficulty {
    case easy
    case medium
    case hard
}

struct DifficultyProvider {
    
    static var currentDifficulty: Difficulty {
        return .medium
    }
}
