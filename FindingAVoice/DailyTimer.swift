//
//  DailyTimer.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit

// 1. Time the current session
// 2. Add it to any other sessions we've written down since yesterday
// 3. Send a notification if we've passed the max (10 min)
// 4. Return true for hasPlayedMaxTimeToday if we've passed the max

class DailyTimer {

    let sessionsKey = "sessions"
    var disabled: Bool = false
    var store = UserDefaults.standard
    var dailyPlayTime: TimeInterval {

        let minutes: TimeInterval = currentDayNumber == 0 ? 15 : 10
        return minutes * 60
    }
    private var sessionTimer = Timer() // this is crap, this timer gets thrown away but needs to be set in init
    private var sessionStart = Date() // likewise
    let calendar = Calendar.current

    var pastSessionPlayTimes: [String: TimeInterval] {
        return store.object(forKey: sessionsKey) as? [String: TimeInterval] ?? [String: TimeInterval]()
    }

    let numberOfDays = 12
    var currentDayNumber: Int {

        var daysPlayed = Set<Date>()

        for dict in pastSessionPlayTimes {

            guard let interval = TimeInterval(dict.key) else {
                assert(false)
                continue
            }

            let date = Date(timeIntervalSince1970: interval)
            let components = calendar.dateComponents([.month, .day], from: date)
            if let midnightBasedDate = calendar.date(from: components) {
                daysPlayed.insert(midnightBasedDate)
            }
        }

        return daysPlayed.count
    }

    var previouslyStoredPlayTimeFromToday: TimeInterval {
        
        var runningTotal: TimeInterval = 0
        
        for dict in pastSessionPlayTimes {
            
            guard let interval = TimeInterval(dict.key) else {
                assert(false)
                return 0
            }
            
            let date = Date(timeIntervalSince1970: interval)
            if date.isToday {
                runningTotal += dict.value
            }
        }
        
        return runningTotal
    }

    var hasPlayedMaxTimeToday: Bool {

        if disabled { return false }
        return previouslyStoredPlayTimeFromToday >= dailyPlayTime
    }

    static let shared = DailyTimer()

    private init() {

        /*
         If we're launched into a test target, kill it off right away
         */
        guard ProcessInfo.processInfo.arguments.contains("UITestingIgnoreDailyTimer") == false else {
            disabled = true
            return
        }

        NotificationCenter.default.addObserver(forName: UIApplication.significantTimeChangeNotification, object: nil, queue: .main) { (notification) in

            self.sessionStart = Date()
        }

        resume()
    }

    func pause() {
        
        sessionTimer.invalidate()
    }
    
    func resume() {
        
        guard disabled == false else { return }
        
        sessionStart = Date()
        
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
}

private extension DailyTimer {

    var sessionPlayTime: TimeInterval {
        return Date().timeIntervalSince(sessionStart)
    }

    func tick() {

        guard disabled == false else { return }

        // Store this session duration in case the session ends
        var existingDict = pastSessionPlayTimes

        // Key on this session's start time
        existingDict["\(sessionStart.timeIntervalSince1970)"] = sessionPlayTime
        store.set(existingDict, forKey: sessionsKey)

        if hasPlayedMaxTimeToday {
            sendMaxPlayTimeNotification()
        }
    }

    func sendMaxPlayTimeNotification() {
        
        // Log analytics here
        NotificationCenter.default.post(name: Notification.Name(.dailySessionTimeExceeded), object: nil)
        
        sessionTimer.invalidate() // this is ok, right?
    }
}
