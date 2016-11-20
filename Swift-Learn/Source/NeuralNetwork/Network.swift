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
    /* 
    Update the network's weights and biases by applying
    gradient descent using backpropagation to a single mini batch.
    The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
    is the learning rate. 
     */
    func updateMiniBatch(miniBatch: [Vector<Double>], eta: Double){
        
        let nablaB = biases.map{$0.map{_ in return 0.0}} // Gradient of biases
        let nablaW = weights.map{$0.map{Vector($0.length())}} // Gradient of weights
        
        print(nablaB)
        print(nablaW)

        
        /*
         for x, y in mini_batch:
         delta_nabla_b, delta_nabla_w = self.backprop(x, y)
         nabla_b = [nb+dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
         nabla_w = [nw+dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
         self.weights = [w-(eta/len(mini_batch))*nw
         for w, nw in zip(self.weights, nabla_w)]
         self.biases = [b-(eta/len(mini_batch))*nb
         for b, nb in zip(self.biases, nabla_b)]
         */
    }
    
    func backProp(data:[Vector<Double>], label:[Double]) -> [Vector<Double>]{
        
        return []
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
