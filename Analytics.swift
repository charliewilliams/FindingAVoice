//
//  Analytics.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 01/05/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import Firebase

struct Analytics {
    
    static var db: DatabaseReference?
    
    static func configure(withUser user: User) {
        
        Database.database().isPersistenceEnabled = true
        db = Database.database().reference(withPath: "/user/\(user.email ?? "email-missing")")
        assert(db != nil, "Database connection nil")
    }
    
    static func logScreen(named name: String) {
        
        log(eventName: "screen", eventValue: name)
    }

    static func songKnowledgeLevelMarked(_ song: Song, duration: TimeInterval) {
        
        log(eventName: "songKnowledge", eventValue: "markResponse", responseName: song.title, responseValue: "\(song.knowledgeLevel?.rawValue ?? -1)", duration: duration)
    }
    
    static func userRelaunchedAfterTimeUp() {
        
        log(eventName: "userRelaunchedAfterTimeUp", eventValue: "launch")
    }
    
    static func log(eventName: String, eventValue: String, responseName: String = "", responseValue: String = "", wasCorrect: Bool = false, measurement: Float = 0, duration: TimeInterval = 0, data: [String: String] = [:]) {
        
        let blob: [String : Any] = [
            "app": App.current.rawValue,
            "timestamp": NSDate().timeIntervalSince1970,
            "eventName": eventName,
            "eventValue": eventValue,
            "responseName": responseName,
            "responseValue": responseValue,
            "wasCorrect": wasCorrect,
            "measurement": measurement,
            "duration": duration,
            "data": data
        ]
        
        guard let db = db else {
            print("No user, can't store data")
            return
        }
        
        db.childByAutoId().setValue(blob) { (e: Error?, ref: DatabaseReference?) in
            
            if let e = e {
                print("error \(e) saving blob \(blob)")
                assertionFailure()
            }
        }
    }
}
