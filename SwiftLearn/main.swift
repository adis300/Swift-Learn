//
//  main.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

// MARK: Vector test
var vec = Vector([-6.0,7.0,6,8,7,3])
print(vec)
vec[2...5] = [-6.0,7.0,6,8]


print("Original: vector")
print(vec)

print("Square sum:")
print(dot(vec,vec))

// Shuffle operator
print([1,2,3,4].shuffled())

let (minValue, minIndex) = min([1.0,2,3])
print((minValue, minIndex))

// MARK: Arithmic operation tests
print([1.0, 2.0, 3.0] + 3 + [1.0, 1, 1])
print((1.0/[1, 2, 3]) .* [1.0, 2, 3])
print([1.0, 2, 3]/3)
print((1.0/[1, 2, 3]) .* [1.0, 2, 3])
// Dot product
print(([1.0, 2, 3]) • [1.0, 2, 3])

// MARK: Matrix test
var mat1 = Matrix([[1,2,3],[4,5,6],[7,8,9]])
print("mat1 is:");                  print(mat1)
var mat2 = Matrix([[1,1],[2,2],[3,3]])
print("mat2 is:");                  print(mat2)
print("mat1 * mat2 is:");           print(mat1 * mat2)
vec = Vector([1,4,8])
print("vec is:");                   print(vec)
print("mat1 * vec is:");            print(mat1 * vec)

vec /= 2
print("vec after /= 2 is now:");    print(vec)
vec -= 2
print("vec after -= 2 is now:");    print(vec)
 
print("vec * vecTransposed is:");   print(vec *^ vec)

print("Testing vectorized sigmoid function")
print(sigmoid(Vector([1, 2, 3, 4, 5, 6])))


print("Activation test: ")
print(sigmoid([0,1,2,3]))// .map{ return (Double($0))})
print(sigmoidPrime([0,1,2,3]))

// MARK: NeuralNetwork test
var network = Network([3,2])
print(network.biases)
print("Weights: ")
print(network.weights)
/*
// Test updateMiniBatch
network.updateMiniBatch(miniBatch: [LabeledData(input: [1,2,3],label: [1,0])], eta: 3)

// Test backprop
let (deltaW, deltaB) = network.backProp(LabeledData(input: [1,2,3],label: [0,1]))
print("Backprop test:")
print(deltaW)
print(deltaB)
*/
var trainingSet:[LabeledData] = []
for i in 1...100{
    trainingSet.append(LabeledData(input: [0.2,0.3,0.8], label: [1,0]))
    trainingSet.append(LabeledData(input: [0.1,0.1,0.2], label: [1,0]))
    trainingSet.append(LabeledData(input: [0.7,0.1,0.9], label: [1,0]))
    trainingSet.append(LabeledData(input: [0.7,0.7,0.9], label: [1,0]))
}

for i in 1...100{
    trainingSet.append(LabeledData(input: [0.6,0.6,0.2], label: [0,1]))
    trainingSet.append(LabeledData(input: [0.4,0.3,0.1], label: [0,1]))
    trainingSet.append(LabeledData(input: [0.9,0.1,0.7], label: [0,1]))
    trainingSet.append(LabeledData(input: [0.9,0.7,0.7], label: [0,1]))

}

let testSet = [
    LabeledData(input: [0.2,0.3,0.8], label: [1,0]),
    LabeledData(input: [0.2,0.3,0.9], label: [1,0]),
    LabeledData(input: [0.2,0.3,0.4], label: [1,0]),

    LabeledData(input: [0.6,0.6,0.2], label: [0,1]),
    LabeledData(input: [0.7,0.7,0.2], label: [0,1]),
    LabeledData(input: [0.5,0.3,0.2], label: [0,1])

]

network.SGD(trainingSet: trainingSet, epochs: 1000, miniBatchSize: 10, eta: 3, testSet: testSet)
print("Trained weights:")
print(network.weights)
print("Trained biases:")
print(network.biases)

