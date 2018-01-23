//
//  Question.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

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
        
        firstHighlight = song.syllable(atIndex: info.startPointIndex)
        secondHighlight = song.syllable(atIndex: song.syllables[info.startPointIndex][index])
        answer = Answer(rawValue: song.answers[info.startPointIndex][index])!
    }
    
    init?(song: Song, difficulty: Difficulty) {

        let info = difficulty.info.randomItem()

        let strideToAnswer = info.stepSizes.randomItem()
        let raw = song.answers[info.startPointIndex][strideToAnswer].components(separatedBy: .whitespacesAndNewlines).joined()

        guard let answer = Answer(rawValue: raw) else {
            return nil
        }

        self.answer = answer
        self.song = song
        self.difficulty = difficulty

//        let startPoint = song.startPoints[info.startPointIndex]
        firstHighlight = song.syllable(atIndex: info.startPointIndex)

        guard let syllableIndex = song.syllables[safe: info.startPointIndex]?[safe: strideToAnswer] else {
            return nil
        }
        secondHighlight = song.syllable(atIndex: syllableIndex)
    }
}
