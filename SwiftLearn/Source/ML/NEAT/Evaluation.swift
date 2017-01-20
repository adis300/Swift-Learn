//
//  Evaluation.swift
//  Swift-Learn
//
//  Created by Disi A on 1/19/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

public class EvaluationFunc{
    
    public let evaluate :(Genome) -> Double
    
    init(_ name: String) {
        switch name {
        case "xortest":
            evaluate = EvaluationFunc.xortest
        default:
            fatalError("Evaluation function name not recognized")
        }
    }
    
    fileprivate static func xortest(genome: Genome) -> Double{
        let network = NEATNetwork(genome: genome)
        var score = 0.0
        
        var inputs = [Double](repeating: 0, count: 3)
        
        // 0 xor 0
        inputs[0] = 1.0 // bias
        // 0 xor 0
        inputs[1] = 0.0
        inputs[2] = 0.0
        
        var outputs = network.forwardPropagate(inputs: inputs)
        score += pow((outputs[0] - 0.0), 2.0)
        
        // 0 xor 1
        inputs[1] = 0.0
        inputs[2] = 1.0
        
        outputs = network.forwardPropagate(inputs: inputs)
        score += pow((outputs[0] - 1.0), 2.0)

        // 1 xor 0
        inputs[1] = 1.0
        inputs[2] = 0.0
        
        outputs = network.forwardPropagate(inputs: inputs)
        score += pow((outputs[0] - 1.0), 2.0)
        
        // 1 xor 1
        inputs[1] = 1.0
        inputs[2] = 1.0
        outputs = network.forwardPropagate(inputs: inputs)

        score += pow((outputs[0] - 0.0), 2.0)
        
        return score
    }
    
}
