//
//  SongTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import ExperimentalTask

class SongTests: XCTestCase {
    
    var songs: [Song]!
    
    override func setUp() {
        super.setUp()
        
        songs = SongLoader.songs
    }
    
    func testLoadsSongs() {
        XCTAssert(songs.count > 0)
    }
    
    func testFrostySyllables() {
        
        let frosty = songs.filter({ $0.id == "frosty" }).first!
        
        XCTAssertEqual(frosty.syllable(atIndex: 0), "Frost")
        XCTAssertEqual(frosty.syllable(atIndex: 1), "y")
        XCTAssertEqual(frosty.syllable(atIndex: 2), "the")
        XCTAssertEqual(frosty.syllable(atIndex: 3), "snow")
        XCTAssertEqual(frosty.syllable(atIndex: 4), "man")
    }

    func testGreensleevesSyllables() {

        let greensleeves = songs.filter({ $0.id == "greensleeves" }).first!

        XCTAssertEqual(greensleeves.syllable(atIndex: 0), "A")
        XCTAssertEqual(greensleeves.syllable(atIndex: 1), "las")
    }

    func testGreensleevesStartpoints() {

        let greensleeves = songs.filter({ $0.id == "greensleeves" }).first!

        XCTAssertEqual(greensleeves.startPoints, [1, 5, 9])
    }

    func testSixtyFourSyllables() {

        let sixtyfour = songs.filter({ $0.id == "sixtyfour" }).first!

        let separatorSet = CharacterSet(charactersIn: "- ")
        let lyrics = "When I get ol-der, lo-sing my hair, Ma-ny years from now".components(separatedBy: separatorSet)
        XCTAssertEqual(lyrics.underestimatedCount, 14)

        for (index, word) in lyrics.enumerated() {
            XCTAssertEqual(sixtyfour.syllable(atIndex: index), word)
        }

        XCTAssertEqual(sixtyfour.syllable(atIndex: 0), "When")
        XCTAssertEqual(sixtyfour.syllable(atIndex: 1), "I")
    }
}
