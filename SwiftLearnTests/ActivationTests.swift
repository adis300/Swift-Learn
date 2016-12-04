//
//  ActivationTests.swift
//  SwiftLearn
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class ActivationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSigmoid() {
        let activation = sigmoid(Vector([1, 2, 3, 4, 5, 6]))
        
        assert(activation[0] > 0.73 && activation[0] < 0.74 && activation[1] > 0.88 && activation[1] < 0.89, "Activation test failed")
        
    }
    
    
    
}
