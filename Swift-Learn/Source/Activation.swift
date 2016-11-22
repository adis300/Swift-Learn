//
//  Activation.swift
//  Swift-Learn
//
//  Created by Disi A on 11/12/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation
import Accelerate

public func sigmoidTanh(_ x: Double)-> Double{
    return tanh(x) / 2 + 0.5
}

public func sigmoid(_ x: [Double])-> [Double]{
    
    var results = [Double](x)
    vDSP_vnegD(x, 1, &results, 1, vDSP_Length(Int32(x.count)))
    
    vvexp(&results, results, [Int32(x.count)])
    results += 1
    return 1/results
}

public func sigmoid(_ x: Vector<Double>)-> Vector<Double>{
    return Vector(sigmoid(x.vector))
}

// """Derivative of the sigmoid function."""
public func sigmoidPrime(_ x: [Double]) -> [Double]{
    let sigmoidX = sigmoid(x)
    return sigmoidX .* (1 - sigmoidX)
}

public func sigmoidPrime(_ x: Vector<Double>) -> Vector<Double>{
    return Vector(sigmoidPrime(x.vector))
}


