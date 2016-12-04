//
//  VectorTests.swift
//  SwiftLearn
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class VectorTests: XCTestCase {
    
    var vec: Vector = Vector([-6.0,7.0,6,8,7,3])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVectorElementIndex() {
        vec[2...5] = [-6.0,7.0,6,8]
        assert(vec[2] == -6.0 && vec[3] == 7 && vec[4] == 6 && vec[5] == 8, "Vector element was not properly modified")
        
        vec /= 2
        assert(vec == Vector([-3.0,3.5,-3.0,3.5,3,4]), "Vector in place division failed")
        
        vec -= 2
        assert(vec == Vector([-5.0,1.5,-5.0,1.5,1,2]), "Vector in place subtraction failed")
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testVectorDotProduct(){
        let vecDot = dot(vec,vec)
        assert(vecDot == 243, "Vector dot product test failed.")
    }
    
    func testVectorGridProduct(){
        
        let vecA = Vector([1,4,8])
        assert((vecA *^ vecA) == Matrix([[1,4,8],[4,16,32],[8,32,64]]))
        
    }
    
}
