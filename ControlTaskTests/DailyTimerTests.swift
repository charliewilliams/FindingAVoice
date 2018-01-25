//
//  DailyTimerTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import ControlTask

class DailyTimerTests: XCTestCase {

    let t = DailyTimer.shared
    
    func testStoresTime() {
        
        let date = Date()

        t.store = UserDefaults()
        t.store.set(["\(date.timeIntervalSince1970)": TimeInterval(100)], forKey: t.sessionsKey)
        
        XCTAssertEqual(100, t.previouslyStoredPlayTimeFromToday)
    }
    
    func testAddsMultipleStoredTimes() {
        
        let date = Date()
        let date2 = Date(timeInterval: 10, since: date)
        
        let t = DailyTimer.shared
        t.store = UserDefaults()
        t.store.set(["\(date.timeIntervalSince1970)": TimeInterval(100),
                     "\(date2.timeIntervalSince1970)": TimeInterval(150)], forKey: t.sessionsKey)
        
        XCTAssertEqual(250, t.previouslyStoredPlayTimeFromToday)
    }
    
    func testDoesNotAddTimeFromYesterday() {
        
        let date = Date()
        let date2 = Date(timeInterval: -60*60*24, since: date)
        
        let t = DailyTimer.shared
        t.store = UserDefaults()
        t.store.set(["\(date.timeIntervalSince1970)": TimeInterval(100),
                     "\(date2.timeIntervalSince1970)": TimeInterval(150)], forKey: t.sessionsKey)
        
        XCTAssertEqual(100, t.previouslyStoredPlayTimeFromToday)
    }

    func testCurrentDayNumberCountsDaysPlayed() {

        let oneDay: TimeInterval = 60*60*24
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: oneDay)
        let date3 = Date(timeIntervalSince1970: oneDay * 2)

        let value: [String: TimeInterval] = ["\(date1.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date2.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date3.timeIntervalSince1970)": TimeInterval(100)]

        t.store.set(value, forKey: t.sessionsKey)

        XCTAssertEqual(t.currentDayNumber, 3)
    }

    func testCurrentDayNumberDoesntCountDaysNotPlayed() {

        let oneDay: TimeInterval = 60*60*24
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: oneDay)
        let date3 = Date(timeIntervalSince1970: oneDay * 2)
        let date4 = Date(timeIntervalSince1970: oneDay * 5)

        let value: [String: TimeInterval] = ["\(date1.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date2.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date3.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date4.timeIntervalSince1970)": TimeInterval(100)]

        t.store.set(value, forKey: t.sessionsKey)

        XCTAssertEqual(t.currentDayNumber, 4)
    }

    func testCurrentDayNumberDoesntDoubleCountDaysWithMultipleSessions() {

        let oneDay: TimeInterval = 60*60*24
        let date1 = Date(timeIntervalSince1970: 0)
        let date2 = Date(timeIntervalSince1970: oneDay)
        let date3 = Date(timeIntervalSince1970: 5)
        let date4 = Date(timeIntervalSince1970: oneDay + 10)

        let value: [String: TimeInterval] = ["\(date1.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date2.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date3.timeIntervalSince1970)": TimeInterval(100),
                                             "\(date4.timeIntervalSince1970)": TimeInterval(100)]

        t.store.set(value, forKey: t.sessionsKey)

        XCTAssertEqual(t.currentDayNumber, 2)
    }
}
