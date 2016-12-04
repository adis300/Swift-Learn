//
//  ArrayTests.swift
//  SwiftLearn
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class ArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMin(){
        let (minValue, minIndex) = min([1.0,2,3])
        assert(minValue == 1 && minIndex == 0, "Min value test failed")
        
    }
    
    func testArrayOperations(){
        
        assert(([1.0, 2.0, 3.0] + 3 + [1.0, 1, 1]) == [5.0, 6, 7], "Test array addition operator")
        
        assert(((1.0/[1, 2, 3]) .* [1.0, 2, 3]) == [1.0, 1, 1], "Test array hadamod product operator failed")

        let divisionTarget = [1.0/3.0, 2.0/3.0, 3.0/3.0]
        print(([1.0, 2.0, 3.0]/3.0) == divisionTarget, "Test array/Double division failed")
        
        print(([1.0, 2, 3] • [1.0, 2, 3]) == 14, "Test dot product failed")

    }
    
}
