//
//  Addition.swift
//  Swift-Learn
//
//  Created by Disi A on 11/21/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

public func addTo(_ target: inout [Float], values: [Float]){
    cblas_saxpy(Int32(target.count), 1.0, values, 1, &target, 1)
}

public func addTo(_ target: inout [Double], values: [Double]){
    cblas_daxpy(Int32(target.count), 1.0, values, 1, &target, 1)
}

public func addTo(_ target: inout [Float], values: [Float], scale: Float){
    catlas_saxpby(Int32(target.count), scale, values, 1, 1.0, &target, 1)
}

public func addTo(_ target: inout [Double], values: [Double], scale: Double){
    catlas_daxpby(Int32(target.count), scale, values, 1, 1.0, &target, 1)
}


public func + (lhs: [Float], rhs: [Float]) -> [Float] {
    var results = [Float](rhs)
    cblas_saxpy(Int32(lhs.count), 1.0, lhs, 1, &results, 1)
    return results
}

public func + (lhs: [Double], rhs: [Double]) -> [Double] {
    var results = [Double](rhs)
    cblas_daxpy(Int32(lhs.count), 1.0, lhs, 1, &results, 1)
    return results
}

public func + (lhs: [Float], rhs: Float) -> [Float] {
    var rhs = rhs
    var results = [Float](repeating: 0, count: lhs.count)
    vDSP_vsadd(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func + (lhs: [Double], rhs: Double) -> [Double] {
    var rhs = rhs
    var results = [Double](repeating: 0, count: lhs.count)
    vDSP_vsaddD(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}
