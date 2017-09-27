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
    
    private var currentQuestion: Question?
    
    private init() {
    
        // Load info about what day of the test it is
    }
    
    func nextQuestion() -> Question {
        
        var songs = SongLoader.songs
        
        if let current = currentQuestion {
            songs = songs.filter { $0.id != current.song.id }
        }

        return nextQuestion(song: songs.randomItem(), difficulty: DifficultyProvider.currentDifficulty)
    }

    func nextQuestion(song: Song, difficulty: Difficulty) -> Question {

        while currentQuestion == nil {
            currentQuestion = Question(song: song, difficulty: difficulty)
        }

        return currentQuestion!
    }
}
