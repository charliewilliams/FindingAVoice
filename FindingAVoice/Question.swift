//
//  Question.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

typealias QuestionInfo = (startPoint: Int, stepSizes: [Int])

enum Difficulty {
    
    case easy
    case medium
    case hard
    
    var info: [QuestionInfo] {
        switch self {
        case .easy:
            return [(startPoint: 0, stepSizes: [0, 1]), (startPoint: 2, stepSizes: [0])]
        case .medium:
            return [(startPoint: 0, stepSizes: [2, 3]), (startPoint: 2, stepSizes: [1])]
        case .hard:
            return [(startPoint: 2, stepSizes: [2, 3]), (startPoint: 4, stepSizes: [0, 1])]
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
    
    var firstHighlight: String
    var secondHighlight: String
    
    var answer: Answer
    
    init(song: Song, difficulty: Difficulty) {
        
        self.song = song
        
        let thisQuestionInfo = difficulty.info.randomItem()
        
        let index = thisQuestionInfo.stepSizes.randomIndex()
        
        firstHighlight = song.syllable(atIndex: thisQuestionInfo.startPoint)
        secondHighlight = song.syllable(atIndex: thisQuestionInfo.stepSizes[index])
        answer = Answer(rawValue: song.answers[thisQuestionInfo.startPoint][index])!
    }
}
