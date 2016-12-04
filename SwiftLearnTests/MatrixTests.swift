//
//  MatrixTests.swift
//  SwiftLearn
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class MatrixTests: XCTestCase {
    
    var mat1 = Matrix([[1,2,3],[4,5,6],[7,8,9]])

    var mat2 = Matrix([[1,2],[2,2],[3,3]])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatrixMultiplication() {
        
        let targetMat = Matrix([[14.0,15.0],[32.0,36.0],[50.0,57.0]])

        assert(mat1 * mat2 == targetMat, "Matrix multiplication failed")
        
        assert(mat1 * Vector([1,4,8]) == Vector([33.0, 72.0, 111.0]), "Matrix vector multiplication failed")
        

    }
    
}
