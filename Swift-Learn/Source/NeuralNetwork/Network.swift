//
//  Network.swift
//  Swift-Learn
//
//  Created by Disi A on 11/7/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

class Network {
    
    var numLayers : Int
    var layerSizes: [Int]
    var weights : [[Vector<Double>]]
    var biases: [[Double]]
    
    //self.biases = [np.random.randn(y, 1) for y in sizes[1:]]
    //self.weights = [np.random.randn(y, x)
    //for x, y in zip(sizes[:-1], sizes[1:])]
    
    init(_ layerSizes: [Int]) {
        
        precondition(layerSizes.count > 1, "Unable to initialize neural network with no count")
        
        numLayers = layerSizes.count
        self.layerSizes = layerSizes
        
        biases = []
        weights = []
        
        for layerNumber in 1..<layerSizes.count {
            
            biases.append(Random.randN1To1(length: layerSizes[layerNumber]))
            
            weights.append([])
            
            for _ in 0..<layerSizes[layerNumber] {
                weights[layerNumber - 1].append(Vector(Random.randN1To1(length: layerSizes[layerNumber - 1])))
            }
            
        }
    }
    
}
