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


// Max with index
public func max(_ x: [Float]) -> (Float, Int){
    var index: UInt = 0
    var value: Float = 0
    vDSP_maxvi(x, 1, &value, &index, vDSP_Length(x.count))
    return (value, Int(index))
}

public func max(_ x: [Double]) -> (Double, Int){
    var index: UInt = 0
    var value: Double = 0
    vDSP_maxviD(x, 1, &value, &index, vDSP_Length(x.count))
    return (value, Int(index))
}

public func max(_ x: Vector<Float>) -> (Float, Int){
    return max(x.vector)
}

public func max(_ x: Vector<Double>) -> (Double, Int){
    return max(x.vector)
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

// Minimum index
public func min(_ x: [Float]) -> (Float, Int){
    var index: UInt = 0
    var value: Float = 0
    vDSP_minvi(x, 1, &value, &index, vDSP_Length(x.count))
    return (value, Int(index))
}

public func min(_ x: [Double]) -> (Double, Int){
    var index: UInt = 0
    var value: Double = 0
    vDSP_minviD(x, 1, &value, &index, vDSP_Length(x.count))
    return (value, Int(index))
}

public func min(_ x: Vector<Float>) -> (Float, Int){
    return min(x.vector)
}

public func min(_ x: Vector<Double>) -> (Double, Int){
    return min(x.vector)
}


