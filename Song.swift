//
//  Song.swift
//  MusicPlayerPrototype
//
//  Created by Charlie Williams on 05/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import UIKit
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
            return KnowledgeLevel(rawValue: UserDefaults.standard.integer(forKey: "\(id)-suppliedKnowledgeLevel"))
        }
        set(newValue) {
            UserDefaults.standard.set(newValue?.rawValue, forKey: "\(id)-suppliedKnowledgeLevel")
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
            assertionFailure("Index \(index) out of bounds for syllable count \(syllables.count) in \(title) (\(lyrics))")
            return ""
        }
        
        return syllables[index]
    }

    func attributedText(for question: Question) -> NSAttributedString {

        let highlightedAttributesSmall: [NSAttributedStringKey: Any] = [
            .backgroundColor: UIColor.yellow,
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
            .font: UIFont.italicSystemFont(ofSize: 36)
        ]

        let mutable = NSMutableAttributedString(string: question.song.lyrics)
        let displayLyrics = question.song.lyrics

        // Find the highlighted bit AS A WHOLE SYLLABLE
        let range1a = (displayLyrics as NSString).range(of: question.firstHighlight + " ")
        let range2a = (displayLyrics as NSString).range(of: question.secondHighlight + " ")
        let range1b = (displayLyrics as NSString).range(of: question.firstHighlight + "-")
        let range2b = (displayLyrics as NSString).range(of: question.secondHighlight + "-")

        var range1 = range1a.location != NSNotFound ? range1a : range1b
        var range2 = range2a.location != NSNotFound ? range2a : range2b
        range1.length -= 1 // remove the space or dash
        range2.length -= 1 // remove the space or dash

        mutable.addAttributes(highlightedAttributesSmall, range: range1)
        mutable.addAttributes(highlightedAttributesSmall, range: range2)

        return mutable
    }
}
