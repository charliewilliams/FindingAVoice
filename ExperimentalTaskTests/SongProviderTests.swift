//
//  SongProviderTests.swift
//  ExperimentalTaskTests
//
//  Created by Charlie Williams on 14/03/2018.
//  Copyright © 2018 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Songs_Game

class SongProviderTests: XCTestCase {

    override func setUp() {
        super.setUp()

        UserDefaults.standard.removeObject(forKey: "frosty-suppliedKnowledgeLevel")
    }

    override func tearDown() {
        super.tearDown()

        UserDefaults.standard.removeObject(forKey: "frosty-suppliedKnowledgeLevel")
    }
    
    func testSettingKnowledgeLevelToNoneExcludesSong() {

        var frosty = SongLoader.songs.filter({ $0.id == "frosty" }).first!

        frosty.knowledgeLevel = Song.KnowledgeLevel.noKnowledge

        SongLoader.reset()

        XCTAssertNil(SongLoader.songs.filter({ $0.id == "frosty" }).first)
    }
    
}
