//
//  DailyTimer.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

// 1. Time the current session
// 2. Add it to any other sessions we've written down since yesterday
// 3. Send a notification if we've passed the max (10 min)
// 4. Return true for hasPlayedMaxTimeToday if we've passed the max

class DailyTimer {
    
    private let maximumDailyPlayTime: TimeInterval = 10 * 60 // 10 min
    private var sessionTimer = Timer() // this is crap
    private let sessionStart = Date()
    var store = UserDefaults.standard
    let sessionsKey = "sessions"
    
    private var sessionPlayTime: TimeInterval {
        return NSDate().timeIntervalSince(sessionStart)
    }
    
    var previouslyStoredPlayTimeFromToday: TimeInterval {
        
        var runningTotal: TimeInterval = 0
        
        for dict in storedDates {
            
            guard let interval = TimeInterval(dict.key) else { fatalError() }
            let date = Date(timeIntervalSince1970: interval)
            if date.isToday {
                runningTotal += dict.value
            }
        }
        
        return runningTotal
    }
    
    var hasPlayedMaxTimeToday: Bool {
        return sessionPlayTime + previouslyStoredPlayTimeFromToday >= maximumDailyPlayTime
    }
    
    private var storedDates: [String: TimeInterval] {
        return store.object(forKey: sessionsKey) as? [String: TimeInterval] ?? [String: TimeInterval]()
    }
    
    static let shared = DailyTimer()
    private init() {

        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
    
    private func tick() {

        // Store this session duration in case the session ends
        var existingDict = storedDates
        
        // Key on this session's start time
        existingDict["\(sessionStart.timeIntervalSince1970)"] = sessionPlayTime
        store.set(existingDict, forKey: sessionsKey)
        
        if hasPlayedMaxTimeToday {
            sendMaxPlayTimeNotification()
        }
    }
    
    private func sendMaxPlayTimeNotification() {
        
        // Log analytics here
        NotificationCenter.default.post(name: Notification.Name(.dailySessionTimeExceeded), object: nil)
        
        self.sessionTimer.invalidate() // this is ok, right?
    }
}
