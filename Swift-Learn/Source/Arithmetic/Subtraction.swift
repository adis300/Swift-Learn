//
//  Subtraction.swift
//  Swift-Learn
//
//  Created by Disi A on 11/21/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Subtraction

public func - (lhs: [Float], rhs: [Float]) -> [Float] {
    var results = [Float](lhs)
    catlas_saxpby(Int32(lhs.count), 1.0, lhs, 1, -1, &results, 1)
    return results
}

public func - (lhs: [Double], rhs: [Double]) -> [Double] {
    var results = [Double](lhs)
    catlas_daxpby(Int32(lhs.count), 1.0, lhs, 1, -1, &results, 1)
    return results
}

public func - (lhs: [Float], rhs: Float) -> [Float] {
    return lhs + (-rhs)
}

public func - (lhs: [Double], rhs: Double) -> [Double] {
    return lhs + (-rhs)
}

public func -= (lhs: inout [Float], rhs: Float){
    var rhs = -rhs
    vDSP_vsadd(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

public func -= (lhs: inout [Double], rhs: Double){
    var rhs = -rhs
    vDSP_vsaddD(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

// MARK: Vector substraction implementation
public func - (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    var results = Vector(lhs.vector)
    catlas_saxpby(Int32(lhs.length), 1.0, lhs.vector, 1, -1, &results.vector, 1)
    return results
}

public func - (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    var results = Vector(lhs.vector)
    catlas_daxpby(Int32(lhs.length), 1.0, lhs.vector, 1, -1, &results.vector, 1)
    return results
}

public func - (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    return lhs + (-rhs)
}

public func - (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    return lhs + (-rhs)
}

public func - (lhs: Float, rhs: Vector<Float>) -> Vector<Float> {
    var results = Vector(rhs.vector)
    vDSP_vneg(rhs.vector, 1, &results.vector, 1, vDSP_Length(Int32(rhs.length)))
    results += 1
    return results
}

public func - (lhs: Double, rhs: Vector<Double>) -> Vector<Double> {
    var results = Vector(rhs.vector)
    vDSP_vnegD(rhs.vector, 1, &results.vector, 1, vDSP_Length(Int32(rhs.length)))
    results += 1
    return results
}

public func -= (lhs: inout Vector<Float>, rhs: Float){
    var rhs = -rhs
    vDSP_vsadd(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length))
}

public func -= (lhs: inout Vector<Double>, rhs: Double){
    var rhs = -rhs
    vDSP_vsaddD(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length))
}
