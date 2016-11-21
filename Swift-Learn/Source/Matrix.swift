// Matrix.swift
//
// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

public enum Axis {
    case row
    case column
}

public struct Matrix<T> where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    // public typealias Element = T
    
    let rows: Int
    let cols: Int
    var grid: [T]
    
    
    public init(_ size: (Int, Int)) {
        self.rows = size.0
        self.cols = size.1
        
        self.grid = [T](repeating: 0, count: rows * cols)
    }
    
    public init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        
        self.grid = [T](repeating: 0, count: rows * cols)
    }
    
    public init(randomSize size: (Int, Int)) {
        self.rows = size.0
        self.cols = size.1
        
        self.grid = (0..<rows*cols).map{_ in T(arc4random())/T(INT32_MAX) - 1}
    }
    
    public init(rows: Int, cols: Int, repeatedValue: T) {
        self.rows = rows
        self.cols = cols
        
        self.grid = [T](repeating: repeatedValue, count: rows * cols)
    }
    
    public init(_ values: [[T]]) {
        let m: Int = values.count
        let n: Int = values[0].count
        let repeatedValue: T = 0.0
        
        self.init(rows: m, cols: n, repeatedValue: repeatedValue)
        
        for (i, row) in values.enumerated() {
            grid.replaceSubrange(i*n..<i*n+Swift.min(m, row.count), with: row)
        }
    }
    
    public func length() -> Int{
        return grid.count
    }
    
    public subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValidForRow(row, column: column))
            return grid[(row * cols) + column]
        }
        
        set {
            assert(indexIsValidForRow(row, column: column))
            grid[(row * cols) + column] = newValue
        }
    }
    
    public subscript(row row: Int) -> [T] {
        get {
            assert(row < rows)
            let startIndex = row * cols
            let endIndex = row * cols + cols
            return Array(grid[startIndex..<endIndex])
        }
        
        set {
            assert(row < rows)
            assert(newValue.count == cols)
            let startIndex = row * cols
            let endIndex = row * cols + cols
            grid.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }
    
    public subscript(column column: Int) -> [T] {
        get {
            var result = [T](repeating: 0.0, count: rows)
            for i in 0..<rows {
                let index = i * cols + column
                result[i] = self.grid[index]
            }
            return result
        }
        
        set {
            assert(column < cols)
            assert(newValue.count == rows)
            for i in 0..<rows {
                let index = i * cols + column
                grid[index] = newValue[i]
            }
        }
    }
    
    fileprivate func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < cols
    }
}

// MARK: - Printable

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""
        
        for i in 0..<rows {
            let contents = (0..<cols).map{"\(self[i, $0])"}.joined(separator: "\t")
            
            switch (i, rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }
            
            description += "\n"
        }
        
        return description
    }
}

// MARK: - SequenceType

extension Matrix: Sequence {
    public func makeIterator() -> AnyIterator<ArraySlice<T>> {
        let endIndex = rows * cols
        var nextRowStartIndex = 0
        
        return AnyIterator {
            if nextRowStartIndex == endIndex {
                return nil
            }
            
            let currentRowStartIndex = nextRowStartIndex
            nextRowStartIndex += self.cols
            
            return self.grid[currentRowStartIndex..<nextRowStartIndex]
        }
    }
}

extension Matrix: Equatable {}
public func ==<T> (lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return lhs.rows == rhs.rows && lhs.cols == rhs.cols && lhs.grid == rhs.grid
}


// MARK: -

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

public func elmul(_ x: Matrix<Double>, y: Matrix<Double>) -> Matrix<Double> {
    precondition(x.rows == y.rows && x.cols == y.cols, "Matrix must have the same dimensions")
    var result = Matrix<Double>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = x.grid * y.grid
    return result
}

public func elmul(_ x: Matrix<Float>, y: Matrix<Float>) -> Matrix<Float> {
    precondition(x.rows == y.rows && x.cols == y.cols, "Matrix must have the same dimensions")
    var result = Matrix<Float>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = x.grid * y.grid
    return result
}

public func pow(_ x: Matrix<Double>, _ y: Double) -> Matrix<Double> {
    var result = Matrix<Double>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = pow(x.grid, y)
    return result
}

public func pow(_ x: Matrix<Float>, _ y: Float) -> Matrix<Float> {
    var result = Matrix<Float>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = pow(x.grid, y)
    return result
}

public func exp(_ x: Matrix<Double>) -> Matrix<Double> {
    var result = Matrix<Double>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = exp(x.grid)
    return result
}

public func exp(_ x: Matrix<Float>) -> Matrix<Float> {
    var result = Matrix<Float>(rows: x.rows, cols: x.cols, repeatedValue: 0.0)
    result.grid = exp(x.grid)
    return result
}

public func sum(_ x: Matrix<Double>, axis: Axis = .column) -> Matrix<Double> {
    
    switch axis {
    case .column:
        var result = Matrix<Double>(rows: 1, cols: x.cols, repeatedValue: 0.0)
        for i in 0..<x.cols {
            result.grid[i] = sum(x[column: i])
        }
        return result
        
    case .row:
        var result = Matrix<Double>(rows: x.rows, cols: 1, repeatedValue: 0.0)
        for i in 0..<x.rows {
            result.grid[i] = sum(x[row: i])
        }
        return result
    }
}



public func transpose(_ x: Matrix<Float>) -> Matrix<Float> {
    var results = Matrix<Float>(rows: x.cols, cols: x.rows, repeatedValue: 0.0)
    vDSP_mtrans(x.grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.cols))
    
    return results
}

public func transpose(_ x: Matrix<Double>) -> Matrix<Double> {
    var results = Matrix<Double>(rows: x.cols, cols: x.rows, repeatedValue: 0.0)
    vDSP_mtransD(x.grid, 1, &(results.grid), 1, vDSP_Length(results.rows), vDSP_Length(results.cols))
    
    return results
}

// MARK: - Operators

public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    return mul(lhs, x: rhs)
}

public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    return mul(lhs, x: rhs)
}

public func * (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    return mul(lhs, y: rhs)
}

public func * (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    return mul(lhs, y: rhs)
}

// Disi's matrix * vector convenient implementation

public func * (lhs: Matrix<Float>, rhs: Vector<Float>) -> Vector<Float> {
    precondition(lhs.cols == rhs.length(), "Matrix dimensions not compatible with multiplication")
    
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
        Int32(rhs.length()), // First dimension of matrix B
        1.0,
        &results.vector,
        Int32(lhs.rows)) // The size of the first dimention of matrix C; if you are passing a matrix C[m][n], the value should be m.
    return results
}

public func * (lhs: Matrix<Double>, rhs: Vector<Double>) -> Vector<Double> {
    precondition(lhs.cols == rhs.length(), "Matrix dimensions not compatible with multiplication")
    
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
        Int32(rhs.length()), // First dimension of matrix B
        1.0,
        &results.vector,
        Int32(lhs.rows)) // The size of the first dimention of matrix C; if you are passing a matrix C[m][n], the value should be m.
    return results
}

postfix operator ′
public postfix func ′ (value: Matrix<Float>) -> Matrix<Float> {
    return transpose(value)
}

public postfix func ′ (value: Matrix<Double>) -> Matrix<Double> {
    return transpose(value)
}


