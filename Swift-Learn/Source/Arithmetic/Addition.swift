//
//  Addition.swift
//  Swift-Learn
//
//  Created by Disi A on 11/21/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Array of values implementation
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
    var results = [Float](lhs)
    vDSP_vsadd(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func + (lhs: [Double], rhs: Double) -> [Double] {
    var rhs = rhs
    var results = [Double](lhs)
    vDSP_vsaddD(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func += (lhs: inout [Float], rhs: [Float]){
    cblas_saxpy(Int32(lhs.count), 1.0, rhs, 1, &lhs, 1)
}

public func += (lhs: inout [Double], rhs: [Double]){
    cblas_daxpy(Int32(lhs.count), 1.0, rhs, 1, &lhs, 1)
}

public func += (lhs: inout [Float], rhs: Float){
    var rhs = rhs
    vDSP_vsadd(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

public func += (lhs: inout [Double], rhs: Double){
    var rhs = rhs
    vDSP_vsaddD(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

// MARK: Vector addition implementation

public func + (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    precondition(lhs.length() == rhs.length(), "Vector dimensions not compatible with addition")
    
    var results = Vector<Float>(rhs.vector)
    cblas_saxpy(CInt(lhs.vector.count), 1.0, lhs.vector, 1, &(results.vector), 1)
    return results
}

public func + (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    precondition(lhs.length() == rhs.length(), "Vector dimensions not compatible with addition")
    
    var results = Vector<Double>(rhs.vector)
    cblas_daxpy(CInt(lhs.vector.count), 1.0, lhs.vector, 1, &(results.vector), 1)
    return results
}

public func + (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    var rhs = rhs
    var results = Vector<Float>(lhs.length())
    vDSP_vsadd(lhs.vector, 1, &rhs, &results.vector, 1, vDSP_Length(lhs.length()))
    return results
}

public func + (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    var rhs = rhs
    var results = Vector<Double>(lhs.length())
    vDSP_vsaddD(lhs.vector, 1, &rhs, &results.vector, 1, vDSP_Length(lhs.length()))
    return results
}

public func += (lhs: inout Vector<Float>, rhs: Float){
    var rhs = rhs
    vDSP_vsadd(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length()))
}

public func += (lhs: inout Vector<Double>, rhs: Double){
    var rhs = rhs
    vDSP_vsaddD(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length()))
}

public func +=(lhs: inout Vector<Float>, rhs: Vector<Float>){
    cblas_saxpy(Int32(lhs.length()), 1.0, rhs.vector, 1, &lhs.vector, 1)
}

public func +=(lhs: inout Vector<Double>, rhs: Vector<Double>){
    cblas_daxpy(Int32(lhs.length()), 1.0, rhs.vector, 1, &lhs.vector, 1)
}

public func addTo(_ target: inout Vector<Float>, values: Vector<Float>, scale: Float){
    catlas_saxpby(Int32(target.length()), scale, values.vector, 1, 1.0, &target.vector, 1)
}

public func addTo(_ target: inout Vector<Double>, values: Vector<Double>, scale: Double){
    catlas_daxpby(Int32(target.length()), scale, values.vector, 1, 1.0, &target.vector, 1)
}

// MARK: Matrix addition implementation

public func +=(lhs: inout Matrix<Float>, rhs: Matrix<Float>){
    cblas_saxpy(Int32(lhs.length()), 1.0, rhs.grid, 1, &lhs.grid, 1)
}

public func +=(_ lhs: inout Matrix<Double>, rhs: Matrix<Double>){
    cblas_daxpy(Int32(lhs.length()), 1.0, rhs.grid, 1, &lhs.grid, 1)
}

public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols, "Matrix dimensions not compatible with addition")
    
    var results = rhs
    cblas_saxpy(Int32(lhs.grid.count), 1.0, lhs.grid, 1, &(results.grid), 1)
    
    return results
}
public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols, "Matrix dimensions not compatible with addition")
    
    var results = rhs
    cblas_daxpy(Int32(lhs.grid.count), 1.0, lhs.grid, 1, &(results.grid), 1)
    
    return results
}

public func addTo(_ target: inout Matrix<Float>, values: Matrix<Float>, scale: Float){
    catlas_saxpby(Int32(target.length()), scale, values.grid, 1, 1.0, &target.grid, 1)
}

public func addTo(_ target: inout Matrix<Double>, values: Matrix<Double>, scale: Double){
    catlas_daxpby(Int32(target.length()), scale, values.grid, 1, 1.0, &target.grid, 1)
}
