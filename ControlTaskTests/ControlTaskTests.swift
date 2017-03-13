//
//  ControlTaskTests.swift
//  FindingAVoice
//
//  Created by Charlie Williams on 12/03/2017.
//  Copyright © 2017 Charlie Williams. All rights reserved.
//

import XCTest

class ControlTaskTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsControl() {
        
        XCTAssertEqual(App.current, App.control)
    }
}
    
}
