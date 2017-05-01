//
//  Song.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation
import AVFoundation

enum Key: String {
    case title = "Song"
    case id
    case lyrics = "Lyrics"
    case startPoints = "Startpoints"
    case sp1Syllables = "Syllables-sp1"
    case sp1Answers = "Answers-sp1"
    case sp3Syllables = "Syllables-sp3"
    case sp3Answers = "Answers-sp3"
    case sp5Syllables = "Syllables-sp5"
    case sp5Answers = "Answers-sp5"
}

struct Song {
    
    enum KnowledgeLevel: Int {
        case none = -1
        case unknown = 0
        case some = 1
        case well = 2
    }
    
    let id: String
    let title: String
    let lyrics: String
    let startPoints: [Int]
    let syllables: [[Int]]
    let answers: [[String]]
    let audioFilePath: String?
    var audioPlayer: AVAudioPlayer?
    var knowledgeLevel: KnowledgeLevel? {
        
        get {
            return KnowledgeLevel(rawValue: UserDefaults.standard.integer(forKey: "\(title)-suppliedKnowledgeLevel"))
        }
        set(newValue) {
            
            UserDefaults.standard.set(newValue, forKey: "\(title)-suppliedKnowledgeLevel")
            
            if let newValue = newValue {
                Analytics.song(self, markedAs: newValue)
            }
        }
    }
    
    init?(json: [String: AnyObject]) {
        
        self.title = json[Key.title.rawValue] as! String
        self.lyrics = json[Key.lyrics.rawValue] as! String
        
        self.startPoints = (json[Key.startPoints.rawValue] as! String).toIntArray()
        
        let sp1s = (json[Key.sp1Syllables.rawValue] as! String).toIntArray()
        let sp3s = (json[Key.sp3Syllables.rawValue] as! String).toIntArray()
        let sp5s = (json[Key.sp5Syllables.rawValue] as! String).toIntArray()
        
        self.syllables = [sp1s, sp3s, sp5s]
        
        let an1s = (json[Key.sp1Answers.rawValue] as! String).toStringArray()
        let an3s = (json[Key.sp3Answers.rawValue] as! String).toStringArray()
        let an5s = (json[Key.sp5Answers.rawValue] as! String).toStringArray()
        
        self.answers = [an1s, an3s, an5s]
        
        let songId = json[Key.id.rawValue] as! String
        self.id = songId
        self.audioFilePath = Bundle.main.path(forResource: songId, ofType: "mp3")
        
        if let path = audioFilePath, let data = FileManager.default.contents(atPath: path) {
            audioPlayer = try? AVAudioPlayer(data: data)
        }
        
        // return nil if the user has marked this song as unknown
        if let knowledgeLevel = knowledgeLevel, knowledgeLevel == .none {
            return nil
        }
    }
        
    func syllable(atIndex index: Int) -> String {
        
        let separatorSet = CharacterSet(charactersIn: "- ")
        let syllables = lyrics.components(separatedBy: separatorSet)
        
        guard index < syllables.count else {
            assert(false)
            return ""
        }
        
        return syllables[index]
    }
}
