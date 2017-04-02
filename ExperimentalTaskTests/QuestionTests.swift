//
//  QuestionTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import ExperimentalTask

class QuestionTests: XCTestCase {
    
    var songs: [Song]!
    
    override func setUp() {
        super.setUp()
        
        songs = SongLoader.loadSongs()
    }
    
    func testFrostyHighlightsFrostAndSnowWhenSpecified() {
        
        let frosty = songs.filter({ $0.id == "frosty" }).first!
        let questionInfo = (startPoint: 0, stepSizes: [0])
        
        let question = Question(song: frosty, info: questionInfo)
        
        XCTAssertEqual(question.firstHighlight, "Frost")
        XCTAssertEqual(question.secondHighlight, "snow")
    }
    
    func testEasyQuestionFrosty00IsSame() {
        
        let frosty = songs.filter({ $0.id == "frosty" }).first!
        var info = Difficulty.easy.info.first!
        info.stepSizes.removeLast()
        
        let question = Question(song: frosty, info: info)
        
        XCTAssertEqual(question.answer, Answer.same)
    }
    
    func testEasyQuestionFrosty01IsHigher() {
        
        let frosty = songs.filter({ $0.id == "frosty" }).first!
        var info = Difficulty.easy.info.first!
        info.stepSizes.removeFirst()
        
        let question = Question(song: frosty, info: info)
        
        XCTAssertEqual(question.answer, Answer.higher)
    }
}
