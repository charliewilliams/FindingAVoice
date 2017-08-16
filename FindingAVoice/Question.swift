//
//  Question.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

typealias QuestionInfo = (startPoint: Int, stepSizes: [Int])

enum Difficulty: String {
    
    case easy
    case medium
    case hard
    
    var info: [QuestionInfo] {
        switch self {
        case .easy:
            return [(startPoint: 0, stepSizes: [0, 1]), (startPoint: 1, stepSizes: [0])]
        case .medium:
            return [(startPoint: 0, stepSizes: [2, 3]), (startPoint: 1, stepSizes: [1])]
        case .hard:
            return [(startPoint: 1, stepSizes: [2, 3]), (startPoint: 2, stepSizes: [0, 1])]
        }
    }
}

enum Answer: String {
    
    case lower = "L"
    case same = "S"
    case higher = "H"
}

struct Question {

    var song: Song
    var difficulty: Difficulty
    
    var firstHighlight: String
    var secondHighlight: String
    
    var answer: Answer
    
    // Testability
    init(song: Song, info: QuestionInfo) {
        
        self.song = song
        self.difficulty = .easy
        
        let index = info.stepSizes.randomItem()
        
        firstHighlight = song.syllable(atIndex: info.startPoint)
        secondHighlight = song.syllable(atIndex: song.syllables[info.startPoint][index])
        answer = Answer(rawValue: song.answers[info.startPoint][index])!
    }
    
    init(song: Song, difficulty: Difficulty) {
        
        self.song = song
        self.difficulty = difficulty
        
        let info = difficulty.info.randomItem()
        let index = info.stepSizes.randomItem()
        
        firstHighlight = song.syllable(atIndex: info.startPoint)
        secondHighlight = song.syllable(atIndex: song.syllables[info.startPoint][index])
        answer = Answer(rawValue: song.answers[info.startPoint][index])!
    }
}
