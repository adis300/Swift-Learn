//
//  ActivationFunc.swift
//  Swift-Learn
//
//  Created by Disi A on 1/12/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

// NEATSet returns a set of activation functions that are used in
// general NEAT algorithm, which only includes Sigmoid function.
public var NEATSet:[ActivationFunc] = [ActivationFunc("sigmoid")]

// CPPNSet returns a set of activation functions that are used in
// CPPN-NEAT algorithm, which includes all provided types of activation
// functions, except for Gaussian function, which can be further added
// by the user.
public var CPPNSet:[ActivationFunc] = [ActivationFunc("tanh"), ActivationFunc("sin"), ActivationFunc("cos"), ActivationFunc("sigmoid"), ActivationFunc("relu"), ActivationFunc("log"), ActivationFunc("exp"), ActivationFunc("abs"), ActivationFunc("square"), ActivationFunc("cube")]

public class ActivationFunc {
    public var name:String
    public let function: (Double) -> Double
    
    static let allFunctionNames = ["sigmoid", "sin","cos","tanh","relu","log","exp","abs","square","cube","identity"]
    
    public init(_ name: String) {
        self.name = name
        
        if name == "random"{
            self.name = ActivationFunc.allFunctionNames[Random.randN(n: ActivationFunc.allFunctionNames.count)]
        }
        switch self.name {
        case "sigmoid":
            function = ActivationFunc.sigmoid
        case "sin":
            function = sin
        case "cos":
            function = cos
        case "tanh":
            function = tanh
        case "relu":
            function = ActivationFunc.relu
        case "log":
            function = log
        case "exp":
            function = exp
        case "abs":
            function = abs
        case "square":
            function = ActivationFunc.square
        case "cube":
            function = ActivationFunc.cube
        case "identity":
            function = ActivationFunc.identity
        default:
            print("ActivationFunc: name unrecognized for:\(name), using sigmoid function as default")
            function = ActivationFunc.sigmoid
        }
    }
    
    static let sigmoid: (Double) -> Double = {x in
        return 1 / (1 + exp(-x))
    }
    
    /* No need to define these activation functions
     static let Tanh: (Double) -> Double = {x in
     return tanh(x)
     }
     
     static let Sin: (Double) -> Double = {x in
     return sin(x)
     }
     */
    
    // ReLU is a rectifier linear unit as an activation function.
    static let relu:(Double) -> Double = {x in
        if x > 0{ return x}
        return 0
    }
    // Square is the square function as an activation function.
    static let square:(Double) -> Double = {x in
        return x * x
    }
    
    // Cube is the cube function as an activation function.
    static let cube:(Double) -> Double = {x in
        return pow(x, 3)
    }
    // Gaussian is the Gaussian distribution function as an activation
    // function; this function is initially not included in CPPNSet, but
    // the users can add this function with custom mu and sigma value.
    static let mu:Double = 1
    static let sigma:Double = 1
    static let gaussian:(Double) -> Double = {x in
        return 1.0 / (sigma * sqrt(2*M_PI)) *
            exp(-pow((x-mu)/sigma, 2.0)/2.0)
    }
    
    static let identity:(Double) -> Double = {x in
        return x
    }
    
    // RandFunc returns a random activation function from a particular function set
    static func randomActivationFunc(set: [(Double) -> Double]) -> (Double) -> Double{
        return set[Random.randN(n: set.count)]
    }

}
