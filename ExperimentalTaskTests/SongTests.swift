//
//  SongTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 02/04/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Songs_Game

class SongTests: XCTestCase {
    
    var songs: [Song]!

    var song: Song!

    let songJSON: [String: Any] = [
        "id":"testID",
        "Song":"test",
        "Lyrics":"foo bar baz",
        "Startpoints":"0, 1, 2",
        "Syllables-sp1":"0, 1, 2",
        "Syllables-sp3":"0, 1, 2",
        "Syllables-sp5":"0, 1, 2",
        "Answers-sp1":"0, 1, 2",
        "Answers-sp3":"0, 1, 2",
        "Answers-sp5":"0, 1, 2"
    ]
    
    override func setUp() {
        super.setUp()

        SongLoader.reset()
        songs = SongLoader.songs

        UserDefaults.standard.removeObject(forKey: "testID-suppliedKnowledgeLevel")

        guard let song = Song(json: songJSON) else {
            XCTFail()
            return
        }

        self.song = song
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

    func testWhenHighlightingForSixtyFour() {

        let sixtyfour = songs.filter({ $0.id == "sixtyfour" }).first!
        var question = Question(song: sixtyfour, difficulty: .easy)!
        question.firstHighlight = "When"
        question.secondHighlight = "lo"

        let attributedText = sixtyfour.attributedText(for: question)

        let attributes = attributedText.attributes(at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: 4))

        guard let attribute = attributes[.backgroundColor] as? UIColor else {
            XCTFail()
            return
        }
        XCTAssertEqual(attribute, UIColor.yellow)
    }

    func testIHighlightingForSixtyFour() {

        let sixtyfour = songs.filter({ $0.id == "sixtyfour" }).first!
        var question = Question(song: sixtyfour, difficulty: .easy)!
        question.firstHighlight = "When"
        question.secondHighlight = "lo"

        let attributedText = sixtyfour.attributedText(for: question)

        let attributes = attributedText.attributes(at: 4, longestEffectiveRange: nil, in: NSRange(location: 0, length: 5))

        XCTAssertNil(attributes[.backgroundColor])
    }

    func testSettingKnowledgeLevelWritesToDefaults() {

        XCTAssertEqual(UserDefaults.standard.integer(forKey: "testID-suppliedKnowledgeLevel"), 0)

        song.knowledgeLevel = .some

        XCTAssertEqual(UserDefaults.standard.integer(forKey: "testID-suppliedKnowledgeLevel"), 1)
    }

    func testReadKnowledgeLevelReadsFromDefaults() {

        UserDefaults.standard.set(-1, forKey: "testID-suppliedKnowledgeLevel")

        guard let level = song.knowledgeLevel, level == Song.KnowledgeLevel.noKnowledge else {
            XCTFail()
            return
        }

        UserDefaults.standard.set(1, forKey: "testID-suppliedKnowledgeLevel")

        guard let level1 = song.knowledgeLevel, level1 == .some else {
            XCTFail()
            return
        }

        UserDefaults.standard.set(2, forKey: "testID-suppliedKnowledgeLevel")

        guard let level2 = song.knowledgeLevel, level2 == .well else {
            XCTFail()
            return
        }
    }

    func testInitReturnsNilIfKnowledgeLevelNone() {

        UserDefaults.standard.set(-1, forKey: "testID-suppliedKnowledgeLevel")
        XCTAssertNil(Song(json: songJSON))
    }

    func testInitReturnsObjectIfNoKnowledgeLevelMarked() {

        UserDefaults.standard.removeObject(forKey: "testID-suppliedKnowledgeLevel")
        XCTAssertNotNil(Song(json: songJSON))
    }

    func testInitReturnsObjectIfKnowledgeLevelSomeOrWell() {

        UserDefaults.standard.set(1, forKey: "testID-suppliedKnowledgeLevel")
        XCTAssertNotNil(Song(json: songJSON))

        UserDefaults.standard.set(2, forKey: "testID-suppliedKnowledgeLevel")
        XCTAssertNotNil(Song(json: songJSON))
    }
}
