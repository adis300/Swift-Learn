//
//  SwiftLearnTests.swift
//  SwiftLearnTests
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class SwiftLearnTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        print("Setting up framework.")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        print("Example test")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
