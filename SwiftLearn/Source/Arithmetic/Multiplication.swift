//
//  Multiplication.swift
//  Swift-Learn
//
//  Created by Disi A on 11/22/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

// MARK: Multiplication operator declaration
// Element-wise multiplication
infix operator .*
// Dot product
infix operator •
// Vec A * Transpose B
infix operator *^

// MARK: Array of values implementation

public func * (lhs: [Float], rhs: Float) -> [Float] {
    var rhs = rhs
    var results = [Float](lhs)
    vDSP_vsmul(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func * (lhs: [Double], rhs: Double) -> [Double] {
    var rhs = rhs
    var results = [Double](lhs)
    vDSP_vsmulD(lhs, 1, &rhs, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func * (lhs: Float, rhs: [Float]) -> [Float] {
    return rhs * lhs
}

public func * (lhs: Double, rhs: [Double]) -> [Double] {
    return rhs * lhs
}

public func *= (lhs: inout [Float], rhs: Float){
    var rhs = rhs
    vDSP_vsmul(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

public func *= (lhs: inout [Double], rhs: Double){
    var rhs = rhs
    vDSP_vsmulD(lhs, 1, &rhs, &lhs, 1, vDSP_Length(lhs.count))
}

// The The Hadamard product / element-wise multiplication
public func .* (lhs: [Float], rhs: [Float]) -> [Float] {
    var results = [Float](lhs)
    vDSP_vmul(lhs, 1, rhs, 1, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func .* (lhs: [Double], rhs: [Double]) -> [Double] {
    var results = [Double](lhs)
    vDSP_vmulD(lhs, 1, rhs, 1, &results, 1, vDSP_Length(lhs.count))
    return results
}

public func dot(_ x: [Float], y: [Float]) -> Float {
    precondition(x.count == y.count, "Vectors must have equal count")
    var result: Float = 0
    vDSP_dotpr(x, 1, y, 1, &result, vDSP_Length(x.count))
    return result
}

public func dot(_ x: [Double], y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")
    var result: Double = 0
    vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))
    return result
}

public func • (lhs: [Double], rhs: [Double]) -> Double {
    return dot(lhs, y: rhs)
}

public func • (lhs: [Float], rhs: [Float]) -> Float {
    return dot(lhs, y: rhs)
}

public func *^ (lhs: [Float], rhs: [Float]) -> [Float] {
    var results = [Float](repeating: 0, count: lhs.count * rhs.count)
    vDSP_mmul(lhs, 1, rhs, 1, &results, 1, vDSP_Length(lhs.count), vDSP_Length(rhs.count), vDSP_Length(1))
    return results
}

public func *^ (lhs: [Double], rhs: [Double]) -> [Double] {
    var results = [Double](repeating: 0, count: lhs.count * rhs.count)
    vDSP_mmulD(lhs, 1, rhs, 1, &results, 1, vDSP_Length(lhs.count), vDSP_Length(rhs.count), vDSP_Length(1))
    return results
}

// MARK: Vector implementation

public func * (lhs: Vector<Float>, rhs: Float) -> Vector<Float> {
    return Vector(lhs.vector * rhs)
}

public func * (lhs: Vector<Double>, rhs: Double) -> Vector<Double> {
    return Vector(lhs.vector * rhs)
}

public func * (lhs: Float, rhs: Vector<Float>) -> Vector<Float> {
    return Vector(rhs.vector * lhs)
}

public func * (lhs: Double, rhs: Vector<Double>) -> Vector<Double> {
    return Vector(rhs.vector * lhs)
}

// The The Hadamard product / element-wise multiplication
public func .* (lhs: Vector<Float>, rhs: Vector<Float>) -> Vector<Float> {
    return Vector(lhs.vector .* rhs.vector)
}

public func .* (lhs: Vector<Double>, rhs: Vector<Double>) -> Vector<Double> {
    return Vector(lhs.vector .* rhs.vector)
}

public func *= (lhs: inout Vector<Float>, rhs: Float){
    var rhs = rhs
    vDSP_vsmul(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length))
}

public func *= (lhs: inout Vector<Double>, rhs: Double){
    var rhs = rhs
    vDSP_vsmulD(lhs.vector, 1, &rhs, &lhs.vector, 1, vDSP_Length(lhs.length))
}

public func dot(_ x: Vector<Float>, y: Vector<Float>) -> Float {
    return dot(x.vector, y: y.vector)
}

public func dot(_ x: Vector<Double>, y: Vector<Double>) -> Double {
    return dot(x.vector, y: y.vector)
}

public func • (lhs: Vector<Float>, rhs: Vector<Float>) -> Float {
    return dot(lhs, y: rhs)
}

public func • (lhs: Vector<Double>, rhs: Vector<Double>) -> Double {
    return dot(lhs, y: rhs)
}


public func *^ (lhs: Vector<Float>, rhs: Vector<Float>) -> Matrix<Float> {
    return Matrix<Float>(rows: lhs.length, cols: rhs.length, values: (lhs.vector *^ rhs.vector))
}

public func *^ (lhs: Vector<Double>, rhs: Vector<Double>) -> Matrix<Double> {
    return Matrix<Double>(rows: lhs.length, cols: rhs.length, values: (lhs.vector *^ rhs.vector))
}


/* Surge implementation
public func mul(_ alpha: Float, _ x: Vector<Float>) -> Vector<Float> {
    var results = Vector(x.vector)
    cblas_sscal(CInt(x.vector.count), alpha, &(results.vector), 1)
    return results
}

public func mul(_ alpha: Double, _ x: Vector<Double>) -> Vector<Double> {
    var results = Vector(x.vector)
    cblas_dscal(CInt(x.vector.count), alpha, &(results.vector), 1)
    return results
}
 */

// MARK: Matrix multiplication implementation
public func * (lhs: Matrix<Float>, rhs: Float ) -> Matrix<Float> {
    var rhs = rhs
    var results = Matrix(rows: lhs.rows, cols: lhs.cols, values: lhs.grid)
    vDSP_vsmul(lhs.grid, 1, &rhs, &results.grid, 1, vDSP_Length(lhs.length))
    return results
}

public func * (lhs: Matrix<Double>, rhs: Double ) -> Matrix<Double> {
    var rhs = rhs
    var results = Matrix(rows: lhs.rows, cols: lhs.cols, values: lhs.grid)
    vDSP_vsmulD(lhs.grid, 1, &rhs, &results.grid, 1, vDSP_Length(lhs.length))
    return results
}

public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    return rhs * lhs
}

public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    return rhs * lhs
}

public func * (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.cols == rhs.rows, "Matrix dimensions not compatible with multiplication")
    var results = Matrix<Float>(rows: lhs.rows, cols: rhs.cols, repeatedValue: 0.0)
    vDSP_mmul(lhs.grid, 1, rhs.grid, 1, &results.grid, 1, vDSP_Length(lhs.rows), vDSP_Length(rhs.cols), vDSP_Length(lhs.cols))
    return results
}

public func * (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.cols == rhs.rows, "Matrix dimensions not compatible with multiplication")
    var results = Matrix<Double>(rows: lhs.rows, cols: rhs.cols, repeatedValue: 0.0)
    vDSP_mmulD(lhs.grid, 1, rhs.grid, 1, &results.grid, 1, vDSP_Length(lhs.rows), vDSP_Length(rhs.cols), vDSP_Length(lhs.cols))
    return results
}

public func .* (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols, "Matrix must have the same dimensions")
    return Matrix<Double>(rows: lhs.rows, cols: lhs.cols, values: lhs.grid .* rhs.grid)
}


public func .* (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    precondition(lhs.rows == rhs.rows && lhs.cols == rhs.cols, "Matrix must have the same dimensions")
    return Matrix<Float>(rows: lhs.rows, cols: lhs.cols, values: lhs.grid .* rhs.grid)
}

public func *= (lhs: inout Matrix<Float>, rhs: Float){
    var rhs = rhs
    vDSP_vsmul(lhs.grid, 1, &rhs, &lhs.grid, 1, vDSP_Length(lhs.length))
}

public func *= (lhs: inout Matrix<Double>, rhs: Double){
    var rhs = rhs
    vDSP_vsmulD(lhs.grid, 1, &rhs, &lhs.grid, 1, vDSP_Length(lhs.length))
}

// Disi's matrix * vector convenient implementation

public func * (lhs: Matrix<Float>, rhs: Vector<Float>) -> Vector<Float> {
    precondition(lhs.cols == rhs.length, "Matrix dimensions not compatible with multiplication")
    
    // Because vector is horizontal, we need to change code to B * A' = C
    var results = Vector<Float>(lhs.rows)
    
    cblas_sgemm(CblasColMajor, CblasTrans, CblasNoTrans,
                Int32(lhs.rows), // Number of rows in matrices A and C.  AB = C
        1, // Number of columns in matrices B and C.
        Int32(lhs.cols), // Number of columns in matrix A; number of rows in matrix B.
        1.0, // Scaling factor for the product
        lhs.grid, // Matrix A
        Int32(lhs.cols), // The size of the first dimention of matrix A
        rhs.vector, // Matrix B
        Int32(rhs.length), // First dimension of matrix B
        1.0,
        &results.vector,
        Int32(lhs.rows)) // The size of the first dimention of matrix C; if you are passing a matrix C[m][n], the value should be m.
    return results
}

public func * (lhs: Matrix<Double>, rhs: Vector<Double>) -> Vector<Double> {
    precondition(lhs.cols == rhs.length, "Matrix dimensions not compatible with multiplication")
    
    // Because vector is horizontal, we need to change code to B * A' = C
    var results = Vector<Double>(lhs.rows)
    
    cblas_dgemm(CblasColMajor, CblasTrans, CblasNoTrans,
                Int32(lhs.rows), // Number of rows in matrices A and C.  AB = C
        1, // Number of columns in matrices B and C.
        Int32(lhs.cols), // Number of columns in matrix A; number of rows in matrix B.
        1.0, // Scaling factor for the product
        lhs.grid, // Matrix A
        Int32(lhs.cols), // The size of the first dimention of matrix A
        rhs.vector, // Matrix B
        Int32(rhs.length), // First dimension of matrix B
        1.0,
        &results.vector,
        Int32(lhs.rows)) // The size of the first dimention of matrix C; if you are passing a matrix C[m][n], the value should be m.
    return results
}

/* Surge implementation

public func mul(_ alpha: Float, x: Matrix<Float>) -> Matrix<Float> {
    var results = x
    cblas_sscal(Int32(x.grid.count), alpha, &(results.grid), 1)
    
    return results
}

public func mul(_ alpha: Double, x: Matrix<Double>) -> Matrix<Double> {
    var results = x
    cblas_dscal(Int32(x.grid.count), alpha, &(results.grid), 1)
    
    return results
}

public func mul(_ x: Matrix<Float>, y: Matrix<Float>) -> Matrix<Float> {
    precondition(x.cols == y.rows, "Matrix dimensions not compatible with multiplication")
    
    var results = Matrix<Float>(rows: x.rows, cols: y.cols, repeatedValue: 0.0)
    // cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.rows), Int32(y.cols), Int32(x.cols), 1.0, x.grid, Int32(x.cols), y.grid, Int32(y.cols), 0.0, &(results.grid), Int32(results.cols))
    vDSP_mmul(x.grid, 1, y.grid, 1, &results.grid, 1, vDSP_Length(x.rows), vDSP_Length(y.cols), vDSP_Length(x.cols))
    return results
}

public func mul(_ x: Matrix<Double>, y: Matrix<Double>) -> Matrix<Double> {
    precondition(x.cols == y.rows, "Matrix dimensions not compatible with multiplication")
    
    var results = Matrix<Double>(rows: x.rows, cols: y.cols, repeatedValue: 0.0)
    // cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.rows), Int32(y.cols), Int32(x.cols), 1.0, x.grid, Int32(x.cols), y.grid, Int32(y.cols), 0.0, &(results.grid), Int32(results.cols))
    vDSP_mmulD(x.grid, 1, y.grid, 1, &results.grid, 1, vDSP_Length(x.rows), vDSP_Length(y.cols), vDSP_Length(x.cols))
    return results
}
*/
