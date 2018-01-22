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
        
        songs = SongLoader.songs
    }

    func testDataDoesNotCauseCrash() {

        for difficulty in [Difficulty.easy, .medium, .hard] {
            for song in songs {
                let _ = Question(song: song, difficulty: difficulty)
            }
        }
    }
    
    func testFrostyTitle() {
        
        let frosty = songs.filter({ $0.id == "frosty" }).first!
        XCTAssertEqual(frosty.title, "Frosty the Snowman")
    }
    
    func testSpangledTitle() {
        
        let spangled = songs.filter({ $0.id == "spangled" }).first!
        XCTAssertEqual(spangled.title, "The Star-Spangled Banner")
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
    
    func testSpangledQuestion20IsLower() {
        
        let spangled = songs.filter({ $0.id == "spangled" }).first!
        var info = Difficulty.hard.info.last!
        info.stepSizes.removeLast()
        
        let question = Question(song: spangled, info: info)
        
        XCTAssertEqual(question.answer, Answer.higher)
    }
    
    func testSpangledQuestion21IsLower() {
        
        let spangled = songs.filter({ $0.id == "spangled" }).first!
        var info = Difficulty.hard.info.last!
        info.stepSizes.removeFirst()
        
        let question = Question(song: spangled, info: info)
        
        XCTAssertEqual(question.answer, Answer.lower)
    }

    func testHighlightsSixtyFour() {

        let sixtyfour = songs.filter({ $0.id == "sixtyfour" }).first!
        let question = Question(song: sixtyfour, difficulty: .easy)!

        XCTAssertTrue(["When", "I"].contains(question.firstHighlight))
        XCTAssertTrue(["lo", "ol"].contains(question.secondHighlight))
    }
}
