//
//  Initializer.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

// Initializers by default returns double vectors
func zeros(length:Int) -> Vector<Double>{
    return Vector<Double>(length)
}

func zeros(row:Int, col:Int) -> Matrix<Double>{
    return Matrix<Double>(rows: row, cols: col)
}
