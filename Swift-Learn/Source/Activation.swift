//
//  Activation.swift
//  Swift-Learn
//
//  Created by Disi A on 11/12/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

public func sigmoid(_ x: Double)-> Double{
    return tanh(x) / 2 + 0.5
}

public func sigmoid(_ x: Vector<Double>)-> Vector<Double>{
    return 1.0/(1.0+np.exp(-z))
}
