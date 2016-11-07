////
//  Vec.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Accelerate

public struct Vector<T> where T: FloatingPoint, T: ExpressibleByFloatLiteral {
    public typealias Element = T
    
    var vector: [Element]
    
    public init(_ length: Int) {
        vector = [Element](repeating: 0, count: length)
    }
    
    public init(_ length: Int, repeatedValue: Element) {
        vector = [Element](repeating: repeatedValue, count: length)
    }
    
    public init(_ values: [Element]) {
        // let repeatedValue: Element = 0.0
        vector = [Element](values)
        // self.init(length: values.count, repeatedValue: repeatedValue)
        // vector.replaceSubrange(0..<values.count, with: values)
    }
    
    public func length() -> Int{
        return vector.count
    }
    
    public subscript(index: Int) -> Element {
        get {
            // Assert Check index in range?
            return vector[index]
        }
        set {
            // Assert Check index in range?
            vector[index] = newValue
        }
    }
    
    public subscript(indices: CountableRange<Int>) -> [Element] {
        get { return Array(vector[indices]) }
        set{
            precondition(indices.count == newValue.count, "Size of indices must match size of newValue")
            // if let _ = indices.first{
            vector.replaceSubrange(indices, with: newValue)
        }
    }
    
    public subscript(indices: CountableClosedRange<Int>) -> [Element] {
        get { return Array(vector[indices]) }
        set{
            precondition(indices.count == newValue.count, "Size of indices must match size of newValue")
            vector.replaceSubrange(indices, with: newValue)

            assert(indices.count == newValue.count, "Size of indices must match size of newValue")
            var loopCouter = 0
            _ = indices.map{
                vector[$0] = newValue[loopCouter]
                loopCouter += 1
            }
        }
    }
    
    fileprivate func isValidIndex(index: Int) -> Bool {
        return index >= 0 && index < vector.count
    }
    
    /* Algorithmic implementation
    
    func copy() -> Vector {
        let copied = Vector(vector.count)
        cblas_dcopy(CInt(vector.count), UnsafeMutablePointer<Double>(mutating: vector), CInt(1), UnsafeMutablePointer<Double>(mutating: copied.vector), CInt(1))
        return copied
    }
    
    // MARK: Arithmic operations
    func min() -> Double {
        var result: Double = 0.0
        vDSP_minvD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    func max() -> Double {
        var result: Double = 0.0
        vDSP_maxvD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    func sum() -> Double{
        var result: Double = 0.0
        vDSP_sveD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    // Sume of absolute values
    func asum() -> Double {
        return cblas_dasum(CInt(vector.count), vector, 1)
    }
    
    func sumSq() -> Double {
        var result: Double = 0
        vDSP_svesqD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    func mean() -> Double{
        var result: Double = 0.0
        vDSP_meanvD(vector, 1, &result, vDSP_Length(vector.count))
        // return sum() / Double(vector.count)
        return result
    }
    
    func meanMag() -> Double {
        var result: Double = 0.0
        vDSP_meamgvD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    public func meanSquare() -> Double {
        var result: Double = 0.0
        vDSP_measqvD(vector, 1, &result, vDSP_Length(vector.count))
        return result
    }
    
    // MARK: Vector Interop implementation
    func dot(vecB: Vector) -> Double{
        precondition(vector.count == vecB.length(), "Vectors must have equal size")
        
        var result: Double = 0.0
        vDSP_dotprD(vector, 1, vecB.vector, 1, &result, vDSP_Length(vector.count))
        return result
    }*/
}

// MARK: - Printable

extension Vector: CustomStringConvertible {
    public var description: String {
        return vector.description
    }
}

// MARK: - SequenceType

extension Vector: Sequence {
    public func makeIterator() -> AnyIterator<Element> {
        let endIndex = vector.count
        var nextIndex = 0
        
        return AnyIterator {
            if nextIndex == endIndex {
                return nil
            }
            let currentIndex = nextIndex
            nextIndex += 1
            
            return self.vector[currentIndex]
        }
    }
}

extension Vector: Equatable {}
public func ==<T> (leftHandSide: Vector<T>, rightHandSide: Vector<T>) -> Bool {
    return leftHandSide.vector == rightHandSide.vector
}


// MARK: -
// TODO: Confirm in-place addtion works

public func add(_ x: Vector<Float>, _ y: Vector<Float>) -> Vector<Float> {
    precondition(x.length() == y.length(), "Vector dimensions not compatible with addition")
    
    var results = Vector(y.vector)
    cblas_saxpy(CInt(x.vector.count), 1.0, x.vector, 1, &(results.vector), 1)
    return results
}

public func add(_ x: Vector<Double>, _ y: Vector<Double>) -> Vector<Double> {
    precondition(x.length() == y.length(), "Vector dimensions not compatible with addition")
    
    var results = Vector(y.vector)
    cblas_daxpy(CInt(x.vector.count), 1.0, x.vector, 1, &(results.vector), 1)
    return results
}

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

public func dot(_ x: Vector<Float>, _ y: Vector<Float>) -> Float {
    precondition(x.length() == y.length(), "Vectors must have equal length to perform dot product")
    
    var result: Float = 0.0
    vDSP_dotpr(x.vector, 1, y.vector, 1, &result, vDSP_Length(x.length()))
    
    return result
}

public func dot(_ x: Vector<Double>, _ y: Vector<Double>) -> Double {
    precondition(x.length() == y.length(), "Vectors must have equal length to perform dot product")
    
    var result: Double = 0.0
    vDSP_dotprD(x.vector, 1, y.vector, 1, &result, vDSP_Length(x.length()))
    
    return result
}

// Element-vise multiplication (hadamard product)
public func elmul(x: Vector<Float>, _ y: Vector<Float>) -> Vector<Float>{
    precondition(x.length() == y.length(), "Vector dimensions not compatible for hadamard product")
    
    var results = Vector<Float>(x.length()) //[Float](repeating: 0.0, count: x.count)
    vDSP_vmul(x.vector, 1, y.vector, 1, &results.vector, 1, vDSP_Length(x.length()))
    return results
}

public func elmul(x: Vector<Double>, _ y: Vector<Double>) -> Vector<Double>{
    precondition(x.length() == y.length(), "Vector dimensions not compatible for hadamard product")
    
    var results = Vector<Double>(x.length()) //[Float](repeating: 0.0, count: x.count)
    vDSP_vmulD(x.vector, 1, y.vector, 1, &results.vector, 1, vDSP_Length(x.length()))
    return results
}

public func pow(_ x: Vector<Double>, _ y: Double) -> Vector<Double> {
    var result = Vector<Double>(x.length())
    vvpow(&result.vector, x.vector, [Double](repeating: y, count: x.length()), [Int32(x.length())])
    return result
}

public func pow(_ x: Vector<Float>, _ y: Float) -> Vector<Float> {
    var result = Vector<Float>(x.length())
    vvpowf(&result.vector, x.vector, [Float](repeating: y, count: x.length()), [Int32(x.length())])
    return result
}

public func exp(_ x: Vector<Double>) -> Vector<Double> {
    var result = Vector<Double>(x.length())
    vvexp(&result.vector, x.vector, [Int32(x.length())])
    return result
}

public func exp(_ x: Vector<Float>) -> Vector<Float> {
    var result = Vector<Float>(x.length())
    vvexpf(&result.vector, x.vector, [Int32(x.length())])
    return result
}
