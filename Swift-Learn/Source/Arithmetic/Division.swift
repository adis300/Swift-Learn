//
//  Inverse.swift
//  Swift-Learn
//
//  Created by Disi A on 11/21/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate


// MARK: Divide

public func / (lhs: [Float], rhs: [Float]) -> [Float] {
    var results = [Float](lhs)
    vvdivf(&results, lhs, rhs, [Int32(lhs.count)])
    return results
}

public func / (lhs: [Double], rhs: [Double]) -> [Double] {
    var results = [Double](lhs)
    vvdiv(&results, lhs, rhs, [Int32(lhs.count)])
    return results
}

public func / (lhs: [Float], rhs: Float) -> [Float] {
    var rhs = rhs
    var results = [Float](lhs)
    vDSP_vsdiv(lhs,1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func / (lhs: [Double], rhs: Double) -> [Double] {
    var rhs = rhs
    var results = [Double](lhs)
    vDSP_vsdivD(lhs,1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func / (lhs: Float, rhs: [Float]) -> [Float] {
    var lhs = lhs
    var results = [Float](rhs)
    vDSP_svdiv(&lhs, rhs, 1, &results, 1, vDSP_Length(rhs.count))
    return results
}

public func / (lhs: Double, rhs: [Double]) -> [Double] {
    var lhs = lhs
    var results = [Double](rhs)
    vDSP_svdivD(&lhs, rhs, 1, &results, 1, vDSP_Length(rhs.count))
    return results
}

public func /= (lhs: inout [Float], rhs: Float){
    var rhs = rhs
    vDSP_vsdiv(lhs,1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

public func /= (lhs: inout [Double], rhs: Double){
    var rhs = rhs
    vDSP_vsdivD(lhs,1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

public func / (lhs: Float, rhs: Int) -> Float {
    return lhs/Float(rhs)
}

public func / (lhs: Double, rhs: Int) -> Double {
    return lhs/Double(rhs)
}

// MARK: Vector division implementation

public func /= (lhs: inout Vector<Float>, rhs: Float){
    var rhs = rhs
    vDSP_vsdiv(lhs.vector,1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length()))
}

public func /= (lhs: inout Vector<Double>, rhs: Double){
    var rhs = rhs
    vDSP_vsdivD(lhs.vector,1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length()))
}

public func inv(_ x: inout Vector<Float>){
    var top:Float = 1
    vDSP_svdiv(&top, x.vector, 1, &x.vector, 1, vDSP_Length(x.length()))
}

public func inv(_ x: inout Vector<Double>){
    var top:Double = 1
    vDSP_svdivD(&top, x.vector, 1, &x.vector, 1, vDSP_Length(x.length()))
}

// MARK: Matrix division implementation
public func / (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    let BInv = inv(rhs)
    precondition(lhs.cols == BInv.rows, "Matrix dimensions not compatible")
    return mul(lhs, y: BInv)
}

public func / (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    let BInv = inv(rhs)
    precondition(lhs.cols == BInv.rows, "Matrix dimensions not compatible")
    return mul(lhs, y: BInv)
}

public func / (lhs: Matrix<Double>, rhs: Double) -> Matrix<Double> {
    var result = Matrix<Double>(rows: lhs.rows, cols: lhs.cols, repeatedValue: 0.0)
    result.grid = lhs.grid / rhs;
    return result;
}

public func / (lhs: Matrix<Float>, rhs: Float) -> Matrix<Float> {
    var result = Matrix<Float>(rows: lhs.rows, cols: lhs.cols, repeatedValue: 0.0)
    result.grid = lhs.grid / rhs;
    return result;
}

public func inv(_ x : Matrix<Float>) -> Matrix<Float> {
    precondition(x.rows == x.cols, "Matrix must be square")
    
    var results = x
    
    var ipiv = [__CLPK_integer](repeating: 0, count: x.rows * x.rows)
    var lwork = __CLPK_integer(x.cols * x.cols)
    var work = [CFloat](repeating: 0.0, count: Int(lwork))
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.cols)
    
    sgetrf_(&nc, &nc, &(results.grid), &nc, &ipiv, &error)
    sgetri_(&nc, &(results.grid), &nc, &ipiv, &work, &lwork, &error)
    
    assert(error == 0, "Matrix not invertible")
    
    return results
}

public func inv(_ x : Matrix<Double>) -> Matrix<Double> {
    precondition(x.rows == x.cols, "Matrix must be square")
    
    var results = x
    
    var ipiv = [__CLPK_integer](repeating: 0, count: x.rows * x.rows)
    var lwork = __CLPK_integer(x.cols * x.cols)
    var work = [CDouble](repeating: 0.0, count: Int(lwork))
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.cols)
    
    dgetrf_(&nc, &nc, &(results.grid), &nc, &ipiv, &error)
    dgetri_(&nc, &(results.grid), &nc, &ipiv, &work, &lwork, &error)
    
    assert(error == 0, "Matrix not invertible")
    
    return results
}

