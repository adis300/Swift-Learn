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
    var biases: [Vector<Double>]
    
    init(_ layerSizes: [Int]) {
        
        precondition(layerSizes.count > 1, "Unable to initialize neural network with no count")
        
        numLayers = layerSizes.count
        self.layerSizes = layerSizes
        
        biases = []
        weights = []
        
        for nodeCount in 1..<layerSizes.count {
            biases.append(Vector<Double>(layerSizes[nodeCount])) // Zero biases for test
            // biases.append(Random.randMinus1To1(length: layerSizes[nodeCount]))
            
            weights.append([])
            
            for _ in 0..<layerSizes[nodeCount] {
                weights[nodeCount - 1].append(Vector(layerSizes[nodeCount - 1])) // Zero weights for test
                // weights[nodeCount - 1].append(Vector(Random.randMinus1To1(length: layerSizes[nodeCount - 1])))
            }
            
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
        var nablaW = weights.map{$0.map{Vector($0.length())}} // Gradient of weights
        
        print(nablaB)
        print(nablaW)
        
        for trainingData in miniBatch {
            let (deltaNablaW, deltaNablaB) = backProp(trainingData)
            for layerNumber in 1..<layerSizes.count {
                addTo(&(nablaB[layerNumber - 1]), values: deltaNablaB[layerNumber - 1])
                
                for nodeNumber in 0..<layerSizes[layerNumber] {
                    addTo(&nablaW[layerNumber - 1][nodeNumber], values: deltaNablaW[layerNumber - 1][nodeNumber])
                }
            }
        }
        
        // TODO: Improve by updating the self.network directly with learning rate.
        // Finally reverse update the network weights and biases by scaling the gradient with learning rate and batch size.
        for layerNumber in 1..<layerSizes.count {
            addTo(&biases[layerNumber - 1], values: nablaB[layerNumber - 1], scale: -eta/miniBatch.count)
            for nodeNumber in 0..<layerSizes[layerNumber] {
                addTo(&weights[layerNumber - 1][nodeNumber], values: nablaW[layerNumber - 1][nodeNumber] , scale: -eta/miniBatch.count)
            }
        }
    }
    
    func backProp(_ dataSet:LabeledData) -> ([[Vector<Double>]], [Vector<Double>]){
        
        // var nablaB = biases.map{Vector($0.length(), repeatedValue: 0.1)} // Gradient of biases
        var nablaB = biases.map{Vector($0.length())}
        var nablaW = weights.map{$0.map{Vector($0.length())}} // Gradient of weights
        
        
        return (nablaW, nablaB)
    }
    
    /*
     def backprop(self, x, y):
     """Return a tuple ``(nabla_b, nabla_w)`` representing the
     gradient for the cost function C_x.  ``nabla_b`` and
     ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
     to ``self.biases`` and ``self.weights``."""
     nabla_b = [np.zeros(b.shape) for b in self.biases]
     nabla_w = [np.zeros(w.shape) for w in self.weights]
     # feedforward
     activation = x
     activations = [x] # list to store all the activations, layer by layer
     zs = [] # list to store all the z vectors, layer by layer
     for b, w in zip(self.biases, self.weights):
     z = np.dot(w, activation)+b
     zs.append(z)
     activation = sigmoid(z)
     activations.append(activation)
     # backward pass
     delta = self.cost_derivative(activations[-1], y) * \
     sigmoid_prime(zs[-1])
     nabla_b[-1] = delta
     nabla_w[-1] = np.dot(delta, activations[-2].transpose())
     # Note that the variable l in the loop below is used a little
     # differently to the notation in Chapter 2 of the book.  Here,
     # l = 1 means the last layer of neurons, l = 2 is the
     # second-last layer, and so on.  It's a renumbering of the
     # scheme in the book, used here to take advantage of the fact
     # that Python can use negative indices in lists.
     for l in xrange(2, self.num_layers):
     z = zs[-l]
     sp = sigmoid_prime(z)
     delta = np.dot(self.weights[-l+1].transpose(), delta) * sp
     nabla_b[-l] = delta
     nabla_w[-l] = np.dot(delta, activations[-l-1].transpose())
     return (nabla_b, nabla_w)
    */
}
