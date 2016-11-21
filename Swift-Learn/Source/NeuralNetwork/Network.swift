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
    var weights : [Matrix<Double>] = []
    var biases: [Vector<Double>] = []
    
    init(_ layerSizes: [Int]) {
        
        precondition(layerSizes.count > 1, "Unable to initialize neural network with no count")
        
        numLayers = layerSizes.count
        self.layerSizes = layerSizes
        
        for nodeCount in 1..<layerSizes.count {
            // biases.append(Vector<Double>(layerSizes[nodeCount])) // Zero biases for test
            biases.append(Vector<Double>(randomLength: layerSizes[nodeCount]))
            
            // weights.append(Matrix(rows: layerSizes[nodeCount],  cols:layerSizes[nodeCount - 1]))
            weights.append(Matrix(randomSize:(layerSizes[nodeCount], layerSizes[nodeCount - 1])))
        }
    }
    /* 
    Update the network's weights and biases by applying
    gradient descent using backpropagation to a single mini batch.
    The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
    is the learning rate. 
     */
    func updateMiniBatch(miniBatch: [LabeledData], eta: Double){
        
        var nablaB = biases.map{Vector($0.length())} // Gradient of biases
        // var nablaW = weights.map{Matrix(size: ($0.rows, $0.cols))}
        var nablaW = weights.map{Matrix(rows: $0.rows, cols:$0.cols)}
        
        for trainingData in miniBatch {
            let (deltaNablaW, deltaNablaB) = backProp(trainingData)
            for layerNumber in 1..<layerSizes.count {
                nablaB[layerNumber - 1] += deltaNablaB[layerNumber - 1]
                nablaW[layerNumber - 1] += deltaNablaW[layerNumber - 1]
            }
        }
        
        // Finally reverse update the network weights and biases by scaling the gradient with learning rate and batch size.
        for layerNumber in 1..<layerSizes.count {
            addTo(&biases[layerNumber - 1], values: nablaB[layerNumber - 1], scale: -eta/miniBatch.count)
            addTo(&weights[layerNumber - 1], values: nablaW[layerNumber - 1], scale: -eta/miniBatch.count)
        }
    }
    /*
     Return a tuple ``(nabla_w,nabla_b)`` representing the
     gradient for the cost function C_x.  ``nabla_b`` and
     ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
     to `self.weights` and `self.biases`.
     */
    func backProp(_ dataSet:LabeledData) -> ([Matrix<Double>], [Vector<Double>]){
        
        // var nablaB = biases.map{Vector($0.length(), repeatedValue: 0.1)} // Gradient of biases
        var nablaB = biases.map{Vector($0.length())}
        var nablaW = weights.map{Matrix(rows: $0.rows, cols: $0.cols)} // Gradient of weights
        
        // Feedforward
        var activations:[Vector<Double>] = [dataSet.input]
        var zs: [Vector<Double>] = []
        
        for layerNumber in 1..<layerSizes.count {
            let z = weights[layerNumber - 1] * (activations[layerNumber - 1]) + biases[layerNumber - 1]
            zs.append(z)
            activations.append(sigmoid(z))
        }
        
        // Back propagation passes
        var err = activations[activations.endIndex - 1] - dataSet.label
        
        return (nablaW, nablaB)
    }

}
