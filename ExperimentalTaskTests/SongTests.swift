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
}
