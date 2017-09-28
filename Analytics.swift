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
    static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.timeZone = TimeZone.current
        f.dateStyle = .short
        f.timeStyle = .medium
        return f
    }()
    
    static func configure(withUser user: User) {

        Database.database().isPersistenceEnabled = true

        let userID = user.email?.replacingOccurrences(of: "[@.#$\\[\\]]", with: "-", options: .regularExpression) ?? "email-missing-\(Date().timeIntervalSince1970)"
        db = Database.database().reference().child("user").child(userID)
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
    
    static func log(eventName: String, eventValue: String, responseName: String? = nil, responseValue: String? = nil, wasCorrect: Bool? = nil, measurement: Float? = nil, duration: TimeInterval? = nil, data: [String: String]? = nil) {

        guard let db = db else {
            print("No user, can't store data")
            return
        }

        var blob: Dictionary<String, Any> = [
            "app": App.current.rawValue,
            "time": formatter.string(from: Date()),
            "eventName": eventName,
            "eventValue": eventValue
        ]

        if let measurement = measurement {
            blob["measurement"] = measurement
        }
        if let duration = duration {
            blob["duration"] = duration
        }
        if let responseName = responseName {
            blob["responseName"] = responseName
        }
        if let responseValue = responseValue {
            blob["responseValue"] = responseValue
        }
        if let wasCorrect = wasCorrect {
            blob["wasCorrect"] = wasCorrect ? 1 : 0
        }
        if let data = data {
            blob["data"] = data
        }

        let key = "\(Int(Date().timeIntervalSince1970 * 1000))"
        db.child(key).setValue(blob)

        if let overlayVC = AnalyticsDebugOverlayTableViewController.instance {

            var string = ""

            for (key, value) in blob {
                string += "\(key): \(value) || "
            }

            string = string.trimmingCharacters(in: CharacterSet(charactersIn: "| "))
            overlayVC.data.insert(string, at: 0)
        }
    }
}
