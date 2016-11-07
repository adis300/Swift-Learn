//
//  Mat.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Accelerate

struct Matrix {
    
    // Flat matrix implementation
    var matrix: [Double]
    let size: (Int, Int)
    
    init(row: Int, col: Int) {
        size = (row,col)
        matrix = [Double](repeating:0, count: row*col)
    }
    
    // MARK: Indexed getter setter implementation
    subscript(row: Int, column: Int) -> Double {
        get {
            return matrix[row * size.1 + column]
        }
        set(newValue) {
            return matrix[row * size.1 + column] = newValue
        }
    }
    
}

