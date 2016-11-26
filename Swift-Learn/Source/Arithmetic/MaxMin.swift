//
//  Max.swift
//  Swift-Learn
//
//  Created by Disi A on 11/24/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Maximum

public func max(_ x: [Float]) -> Float {
    var result: Float = 0
    vDSP_maxv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

public func max(_ x: [Double]) -> Double {
    var result: Double = 0
    vDSP_maxvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

public func max(_ x: Vector<Float>) -> Float {
    var result: Float = 0
    vDSP_maxv(x.vector, 1, &result, vDSP_Length(x.length))
    return result
}

public func max(_ x: Vector<Double>) -> Double {
    var result: Double = 0
    vDSP_maxvD(x.vector, 1, &result, vDSP_Length(x.length))
    return result
}


// TODO: Implement max index
public func maxIndex(_ x: [Float]) -> Int{
    return 0
}

public func maxIndex(_ x: [Double]) -> Int{
    return 0
}

public func maxIndex(_ x: Vector<Float>) -> Int{
    return 0
}

public func maxIndex(_ x: Vector<Double>) -> Int{
    return 0
}

// MARK: Minimum

public func min(_ x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_minv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

public func min(_ x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_minvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

public func min(_ x: Vector<Float>) -> Float {
    var result: Float = 0.0
    vDSP_minv(x.vector, 1, &result, vDSP_Length(x.length))
    
    return result
}

public func min(_ x: Vector<Double>) -> Double {
    var result: Double = 0.0
    vDSP_minvD(x.vector, 1, &result, vDSP_Length(x.length))
    
    return result
}

// TODO: Implement min index
public func minIndex(_ x: [Float]) -> Int{
    return 0
}

public func minIndex(_ x: [Double]) -> Int{
    return 0
}

public func minIndex(_ x: Vector<Float>) -> Int{
    return 0
}

public func minIndex(_ x: Vector<Double>) -> Int{
    return 0
}


