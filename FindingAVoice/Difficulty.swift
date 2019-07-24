//
//  Difficulty.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/06/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

typealias QuestionInfo = (startPointIndex: Int, stepSizes: [Int])

enum Difficulty: String {
    case easy
    case medium
    case hard

    var info: [QuestionInfo] {
        switch self {
        case .easy:
            return [(startPointIndex: 0, stepSizes: [0, 1]), (startPointIndex: 1, stepSizes: [0])]
        case .medium:
            return [(startPointIndex: 0, stepSizes: [2, 3]), (startPointIndex: 1, stepSizes: [1])]
        case .hard:
            return [(startPointIndex: 1, stepSizes: [2, 3]), (startPointIndex: 2, stepSizes: [0, 1])]
        }
    }

    static var count: Int {
        return 3
    }
}
