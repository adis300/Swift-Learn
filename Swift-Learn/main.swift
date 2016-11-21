//
//  main.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

print("Starting framework test!")

// MARK: Vector test
// var vec = zeros(length: 6)
// vec[2...5] = [-6.0,7.0,6,8]
/*
var vec = Vector([-6.0,7.0,6,8])

print("Original: vector")
print(vec)

print("Square sum:")
print(dot(vec,vec))
*/

// MARK: Matrix test
var mat = Matrix([[1,2,3],[4,5,6]])
print(mat)
var vec = Vector([1,4,8])
let newVec = mat * vec
print(newVec)

// MARK: NeuralNetwork test
var network = Network([3,3,2])
print(network.biases)
print("Weights: ")
print(network.weights)

print("Activation test: ")
print((0...100).map{ return Activation.sigmoid(Double($0))})

// Test updateMiniBatch
network.updateMiniBatch(miniBatch: [LabeledData(input: [1,2,3],label: [1,0])], eta: 3)

// Test backprop
let (deltaW, deltaB) = network.backProp(LabeledData(input: [1,2,3],label: [0,1]))
print("Backprop test:")
print(deltaW)
print(deltaB)
