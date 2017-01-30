//
//  QuestionTimer.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 14/01/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import Foundation

protocol QuestionTiming: class {
    var perQuestionTimer: QuestionTimer { get }
    func questionDidTimeOut()
}

class QuestionTimer {
    
    weak var delegate: QuestionTiming?
    private let maximumPerQuestionTime: TimeInterval = 10 // 10 sec
    private var timer: Timer!
    
    static let shared = QuestionTimer()
    private init() { }
    
    func clear() {
        
        timer.invalidate()
    }
    
    func reset() {
        
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: maximumPerQuestionTime, repeats: false) { [weak self] _ in
            self?.timerFired()
        }
    }
    
    private func timerFired() {
        
        delegate?.questionDidTimeOut()
    }
}
