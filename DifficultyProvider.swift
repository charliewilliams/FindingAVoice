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
        return [.easy, .medium, .hard].randomItem()
    }

    // Calculating which day we're on

    static private var daysInStudy = 14
    static private var secondsPerDay: TimeInterval = 60*60*24

    private enum Keys: String {
        case firstDayOfStudy
    }

    static private var currentDay: Int {

        guard let firstDayOfStudy = firstDayOfStudy else {
            studyBegan()
            return 0
        }

        let secondsSinceStartOfStudy = Date().timeIntervalSince(firstDayOfStudy)

        return Int(secondsSinceStartOfStudy / secondsPerDay)
    }

    static private var firstDayOfStudy: Date? {
        return store.value(forKey: Keys.firstDayOfStudy.rawValue) as? Date
    }

    static private func studyBegan() {
        store.setValue(Date(), forKey: Keys.firstDayOfStudy.rawValue)
    }

    static private var store: UserDefaults {
        return UserDefaults.standard
    }
}
