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
        
        for layerNumber in 1..<layerSizes.count {
            // biases.append(Vector<Double>(layerSizes[nodeCount])) // Zero biases for test
            biases.append(Vector<Double>(randomLength: layerSizes[layerNumber]))
            
            // weights.append(Matrix(rows: layerSizes[nodeCount],  cols:layerSizes[nodeCount - 1]))
            weights.append(Matrix(randomSize:(layerSizes[layerNumber], layerSizes[layerNumber - 1])))
        }
    }
    
    // Return the output of the network if x is input.

    func feedforward(_ x: Vector<Double>) -> Vector<Double>{
        var a = x
        for layerNumber in 1..<layerSizes.count {
            a = sigmoid(weights[layerNumber - 1] * a + biases[layerNumber - 1])
        }
        // print("Test activation: \(a)")
        return a
    }
    
    
    /*
    Return the number of test inputs for which the neural
    network outputs the correct result. Note that the neural
    network's output is assumed to be the index of whichever
    neuron in the final layer has the highest activation.
     */
    func evaluate(_ testSet: [LabeledData]) -> Int{
        var correctCount: Int = 0
        for testData in testSet{
            let (_, maxIndTest) = max(feedforward(testData.input))
            let (_, maxIndTestLabel) = max(testData.label)
            if maxIndTest == maxIndTestLabel{
                correctCount += 1
            }
        }
        return correctCount
    }
    /*
    Update the network's weights and biases by applying
    gradient descent using backpropagation to a single mini batch.
    The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
    is the learning rate. 
     */
    func updateMiniBatch(miniBatch: [LabeledData], eta: Double){
        
        if miniBatch.count == 0{
            print("Empty mini batch, no update was computed")
            return
        }
        
        var nablaB = biases.map{Vector($0.length)} // Gradient of biases
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
        // print("New weights:")
        // print(weights)
    }
    /*
     Return a tuple ``(nabla_w,nabla_b)`` representing the
     gradient for the cost function C_x.  ``nabla_b`` and
     ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
     to `self.weights` and `self.biases`.
     */
    func backProp(_ dataSet:LabeledData) -> ([Matrix<Double>], [Vector<Double>]){
        
        // var nablaB = biases.map{Vector($0.length, repeatedValue: 0.1)} // Gradient of biases
        // var nablaB = biases.map{Vector($0.length)}
        // var nablaW = weights.map{Matrix(rows: $0.rows, cols: $0.cols)} // Gradient of weights
        
        // Feedforward
        var activations:[Vector<Double>] = [dataSet.input]
        var zs: [Vector<Double>] = []
        
        for layerNumber in 1..<layerSizes.count {
            let z = weights[layerNumber - 1] * (activations[layerNumber - 1]) + biases[layerNumber - 1]
            zs.append(z)
            activations.append(sigmoid(z))
        }
        
        // Back propagation passes
        let costDerivative = activations[activations.endIndex - 1] - dataSet.label
        var delta = costDerivative .* sigmoidPrime(zs[zs.endIndex - 1])
        
        var nablaBReversed = [delta]
        var nablaWReversed = [delta *^ activations[activations.endIndex - 2]]
        /*
         l = 1 means the last layer of neurons, l = 2 is the
         second-last layer, and so on.  It's a renumbering of the
        */
        for lback in 2..<layerSizes.count{
            let sp = sigmoidPrime(zs[zs.endIndex - lback])
            delta = (transpose(weights[weights.endIndex - lback + 1]) * delta) .* sp
            nablaBReversed.append(delta)
            nablaWReversed.append(delta *^ activations[activations.endIndex - lback - 1])
        }
        
        return (nablaWReversed.reversed(), nablaBReversed.reversed())
    }
    
    /* 
    Train the neural network using mini-batch stochastic
    gradient descent.  The ``training_data`` is a list of tuples
    ``(x, y)`` representing the training inputs and the desired
    outputs.  The other non-optional parameters are
    self-explanatory.  If ``test_data`` is provided then the
    network will be evaluated against the test data after each
    epoch, and partial progress printed out.  This is useful for
    tracking progress, but slows things down substantially.
    */
    
    func SGD(trainingSet: [LabeledData], epochs: Int, miniBatchSize: Int, eta: Double, testSet: [LabeledData]?){
        // TODO: Implementa SGD
        for epoch in 1...epochs{ // Defines train epoch many times
            
            var trainingSet = trainingSet.shuffled()
            
            for i in stride(from: 0, to: trainingSet.count, by: miniBatchSize){
                if i + miniBatchSize > trainingSet.count{
                    let miniBatch = Array(trainingSet[i ..< trainingSet.count])
                    updateMiniBatch(miniBatch: miniBatch, eta: eta)
                }else{
                    let miniBatch = Array(trainingSet[i ..< i+miniBatchSize])
                    updateMiniBatch(miniBatch: miniBatch, eta: eta)
                }
            }
            if let testDataSet = testSet{
                print("Epoch \(epoch): \(evaluate(testDataSet)) / \(testDataSet.count)")
            }else{
                print("Epoch \(epoch) complete")
            }
        }
    }
    

}
