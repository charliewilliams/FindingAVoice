//
//  SongLoader.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

struct SongLoader {

    static var songsDidReloadNotificationName: NSNotification.Name = NSNotification.Name(rawValue: "reloadSongsNotificationName")

    private static var _songs: [Song]!
    static var songs: [Song] {
        
        if _songs == nil {
            _songs = loadSongs()
        }
        return _songs
    }
    
    private static func loadSongs() -> [Song] {
        
        let jsonPath = Bundle.main.path(forResource: "SongInfo", ofType: "json")!
        let data = FileManager.default.contents(atPath: jsonPath)!
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        
        let dict = json as! [[String: AnyObject]]
        
        return dict.compactMap { songDict -> Song? in Song(json: songDict) }
    }
    
    static func reset() {
        _songs = nil
        NotificationCenter.default.post(name: songsDidReloadNotificationName, object: nil)
    }
}
