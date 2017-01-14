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
    
    func testStoresTime() {
        
        let date = Date()
        
        let t = DailyTimer.shared
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
}
