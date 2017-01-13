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
public var NEATSet:[(Double) -> Double] = [NEATActivation.sigmoid]

// CPPNSet returns a set of activation functions that are used in
// CPPN-NEAT algorithm, which includes all provided types of activation
// functions, except for Gaussian function, which can be further added
// by the user.
public var CPPNSet:[(Double) -> Double] = [tanh, sin, cos, NEATActivation.sigmoid, NEATActivation.relu, log, exp, abs, NEATActivation.square, NEATActivation.cube]


public class NEATActivation {
    
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

    
    
}
