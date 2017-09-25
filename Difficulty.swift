//
//  Difficulty.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/06/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

typealias QuestionInfo = (startPoint: Int, stepSizes: [Int])

enum Difficulty: String {
    case easy
    case medium
    case hard

    var info: [QuestionInfo] {
        switch self {
        case .easy:
            return [(startPoint: 0, stepSizes: [0, 1]), (startPoint: 1, stepSizes: [0])]
        case .medium:
            return [(startPoint: 0, stepSizes: [2, 3]), (startPoint: 1, stepSizes: [1])]
        case .hard:
            return [(startPoint: 1, stepSizes: [2, 3]), (startPoint: 2, stepSizes: [0, 1])]
        }
    }

    static var count: Int {
        return 3
    }
}
