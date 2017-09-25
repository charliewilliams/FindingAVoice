//
//  DifficultyProvider.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 06/05/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

/// Provide a difficulty level based on where the subject
/// is in the study (first day, second day, etc)

struct DifficultyProvider {

    static var currentDifficulty: Difficulty {
        return difficulty(forDayNumber: currentDay)
    }

    static func difficulty(forDayNumber dayNumber: Int) -> Difficulty {

        let index = dayNumber / daysPerDifficulty

        if index < Difficulty.count {
            return [.easy, .medium, .hard][index]
        }
        return .hard
    }
}

private extension DifficultyProvider {

    static let daysActiveInStudy = 12
    static let daysPerDifficulty = 4
    static var store: UserDefaults {
        return UserDefaults.standard
    }
    static var currentDay: Int {
        return DailyTimer.shared.storedDates.count
    }
}
