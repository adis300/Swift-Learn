////
//  Vec.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

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
    
    // Returns the count of the vector
    func length() -> Int{
        return vector.count
    }
    
    // Implements the array operator
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
    
    func dot(vecB: Vector) -> Double{
        assert(vector.count == vecB.length(), "Vector must have identical size")
        return vector[0]
    }
    
    func copy() -> Vector {
        let copied = Vector(length: vector.count)
        cblas_dcopy(CInt(vector.count), UnsafeMutablePointer<Double>(mutating: vector), CInt(1), UnsafeMutablePointer<Double>(mutating: copied.vector), CInt(1))
        return copied
    }
    // Indexed getter setter implementation
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

/*
struct StaticArray<
    T : StaticArrayProtocol
> : StaticArrayProtocol, RandomAccessCollection, MutableCollection {
    typealias Indices = CountableRange<Int>
    
    init(_ defaultValue : T.ElemTy) { values = T(defaultValue) }
    var values : T
    func get(_ idx: Int) -> T.ElemTy { return values.get(idx) }
    mutating func set(_ idx: Int,_ val : T.ElemTy) { return values.set(idx, val) }
    func count() -> Int { return values.count() }
    
    typealias Index = Int
    typealias IndexDistance = Int
    let startIndex: Int = 0
    var endIndex: Int { return count()}
    
    subscript(idx: Int) -> T.ElemTy {
        get {
            return get(idx)
        }
        set(val) {
            set(idx, val)
        }
    }
    
    typealias Iterator = IndexingIterator<StaticArray>
    
    subscript(bounds: Range<Index>) -> StaticArray<T> {
        get { fatalError() }
        set { fatalError() }
    }
}*/
