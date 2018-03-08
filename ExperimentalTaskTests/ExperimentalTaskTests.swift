//
//  ExperimentalTaskTests.swift
//  ExperimentalTaskTests
//
//  Created by Charlie Williams on 06/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest
@testable import Songs_Game

class ExperimentalTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsExperimental() {
        
        XCTAssertEqual(App.current, App.experimental)
    }
}
