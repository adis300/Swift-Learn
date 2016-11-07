////
//  Vec.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

struct Vector { // <T>
    
    var vector : [Double]//[Any]
    
    init(length: Int) {
        vector = [Double](repeating:0, count: length)
        /*
        if(T.self is Double.Type){
            vector = [Double](repeating:0, count: size)
        }else if (T.self is Int.Type){
            vector = [Int](repeating:0, count: size)
        }else if (T.self is Int32.Type){
            vector = [Int32](repeating:0, count: size)
        }else if (T.self is Int64.Type){
            vector = [Int64](repeating:0, count: size)
        }else if (T.self is Int16.Type){
            vector = [Int16](repeating:0, count: size)
        }else if (T.self is Int8.Type){
            vector = [Int8](repeating:0, count: size)
        }else if (T.self is UInt8.Type){
            vector = [UInt8](repeating:0, count: size)
        }else if (T.self is UInt16.Type){
            vector = [UInt8](repeating:0, count: size)
        }else if (T.self is UInt32.Type){
            vector = [UInt8](repeating:0, count: size)
        }else if (T.self is UInt64.Type){
            vector = [UInt8](repeating:0, count: size)
        }else if (T.self is Float.Type){
            vector = [Float](repeating:0, count: size)
        }else if (T.self is Float32.Type){
            vector = [Float32](repeating:0, count: size)
        }else if (T.self is Float64.Type){
            vector = [Float64](repeating:0, count: size)
        }else {
            assertionFailure("Custom element type does not have default constructor")
            vector = []
        }*/
    }
    
    init(values: [Double]){
        vector = values
    }
    
    // MARK: Array property impl
    func length() -> Int{
        return vector.count
    }
    
    func copy() -> Vector {
        let copied = Vector(length: vector.count)
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
    }
    
    // MARK: Indexed getter setter implementation
    subscript(index:Int) -> Double{
        get {
            // assert(vector[index] is T.Type, "Vector element has to be as defined!")
            return vector[index]
        }
        set {
            // assert(newValue, "Vector element has to be a double!")
            vector[index] = newValue // as! T.Type
        }
    }
    
    subscript(indices: CountableRange<Int>) -> [Double] {
        get { return Array(vector[indices]) }
        set{
            assert(indices.count == newValue.count, "Size of indices must match size of newValue")
            // if let _ = indices.first{
            var loopCouter = 0
            _ = indices.map{
                vector[$0] = newValue[loopCouter]
                loopCouter += 1
            }
        }
    }
    
    subscript(indices: CountableClosedRange<Int>) -> [Double] {
        get { return Array(vector[indices]) }
        set{
            assert(indices.count == newValue.count, "Size of indices must match size of newValue")
            var loopCouter = 0
            _ = indices.map{
                vector[$0] = newValue[loopCouter]
                loopCouter += 1
            }
        }
    }
    
}

// MARK: Future implementation
// TODO: Implement simple vector extension with Swift 3.1 +
// extension Array where Element == Double { }
