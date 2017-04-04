//
//  QuestionProvider.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 04/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

class QuestionProvider {
    
    static let shared: QuestionProvider = QuestionProvider()
    
    private var currentQuestion: Question?
    
    private init() {
    
        // Load info about what day of the test it is
    }
    
    func nextQuestion() -> Question? {
        
        var songs = SongLoader.songs
        
        if let current = currentQuestion {
            songs = songs.filter { $0.id != current.song.id }
        }
        
        currentQuestion = Question(song: songs.randomItem(), difficulty: .easy)
        
        return currentQuestion
    }
}
