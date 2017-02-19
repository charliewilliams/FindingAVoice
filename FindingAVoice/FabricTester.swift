//
//  FabricTester.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 19/02/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import Crashlytics

/*
 Push some dummy stuff to Fabric so we can make sure it works
 */

struct FabricTester {
    
    static func runTestLogs() {
        
        let user1Name = "Bob Billy"
        let user1ID = "bb123"
        
        for i in 0..<100 {
            
            Answers.logCustomEvent(withName: "TestEvent", customAttributes: ["testUserId":user1ID, "testUserName":user1Name, "numberOfReportsExpected":100, "reportNumber":i])
        }
        
        let user2Name = "Jane Average"
        let user2ID = "ja456"
        
        for i in 0..<1000 {
            
            Answers.logCustomEvent(withName: "TestEventAverages", customAttributes: ["testUserId":user2ID, "testUserName":user2Name, "numberOfReportsExpected":1000, "reportNumber":i, "value": arc4random_uniform(1000)])
        }
    }
}
