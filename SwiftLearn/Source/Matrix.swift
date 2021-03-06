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
    let length: Int
    var grid: [T]
    
    
    public init(_ size: (Int, Int)) {
        self.rows = size.0
        self.cols = size.1
        self.length = size.0 * size.1
        self.grid = [T](repeating: 0, count: length)
    }
    
    public init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.length = rows * cols

        self.grid = [T](repeating: 0, count: rows * cols)
    }
    
    public init(randomSize size: (Int, Int)) {
        self.rows = size.0
        self.cols = size.1
        self.length = size.0 * size.1

        self.grid = (0..<length).map{_ in T(arc4random())/T(INT32_MAX) - 1}
    }
    
    public init(rows: Int, cols: Int, repeatedValue: T) {
        self.rows = rows
        self.cols = cols
        self.length = rows * cols

        self.grid = [T](repeating: repeatedValue, count: length)
    }
    
    public init(rows: Int, cols: Int, values: [T]) {
        self.rows = rows
        self.cols = cols
        self.length = rows * cols

        self.grid = values
    }
    
    public init(_ values: [[T]]) {
        let m: Int = values.count
        let n: Int = values[0].count

        self.init(rows: m, cols: n, repeatedValue: 0.0)
        
        for (i, row) in values.enumerated() {
            grid.replaceSubrange(i*n..<i*n+Swift.min(m, row.count), with: row)
        }
    }
    
    public func size() -> (Int, Int) {
        return (rows,cols)
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
    
    public var dict: [String: Any] {
        return ["cols": cols, "rows": rows, "grid": grid] as [String : Any]
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

postfix operator ′
public postfix func ′ (value: Matrix<Float>) -> Matrix<Float> {
    return transpose(value)
}

public postfix func ′ (value: Matrix<Double>) -> Matrix<Double> {
    return transpose(value)
}


