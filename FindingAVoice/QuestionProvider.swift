//
//  QuestionProvider.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

class QuestionProvider {
    
    static let shared = QuestionProvider()

    private var _questions: [Question] = []
    private var questions: [Question] {

        if _questions.isEmpty {
            _questions = SongLoader.songs.flatMap { Question(song: $0, difficulty: DifficultyProvider.currentDifficulty) }
        }
        return _questions
    }
    
    private init() { }
    
    func nextQuestion() -> Question {
        return questions.popRandomItem()
    }
}
