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
        
        let date = NSDate()
        
        let t = DailyTimer.shared
        t.store = UserDefaults()
        t.store.set(["\(date.timeIntervalSince1970)": TimeInterval(100)], forKey: t.sessionsKey)
        
        XCTAssertEqual(100, t.previouslyStoredPlayTimeFromToday)
    }
}
