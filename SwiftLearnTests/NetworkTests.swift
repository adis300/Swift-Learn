//
//  NetworkTests.swift
//  SwiftLearn
//
//  Created by Disi A on 12/4/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import XCTest
@testable import SwiftLearn

class NetworkTests: XCTestCase {
    
    var network = Network([3,2])

    var trainingSet:[LabeledData] = []
    let testSet = [
        LabeledData(input: [0.2,0.3,0.8], label: [1,0]),
        LabeledData(input: [0.2,0.3,0.9], label: [1,0]),
        LabeledData(input: [0.2,0.3,0.4], label: [1,0]),
        
        LabeledData(input: [0.6,0.6,0.2], label: [0,1]),
        LabeledData(input: [0.7,0.7,0.2], label: [0,1]),
        LabeledData(input: [0.5,0.3,0.2], label: [0,1])
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        for _ in 1...100{
            trainingSet.append(LabeledData(input: [0.2,0.3,0.8], label: [1,0]))
            trainingSet.append(LabeledData(input: [0.1,0.1,0.2], label: [1,0]))
            trainingSet.append(LabeledData(input: [0.7,0.1,0.9], label: [1,0]))
            trainingSet.append(LabeledData(input: [0.7,0.7,0.9], label: [1,0]))
        }
        
        for _ in 1...100{
            trainingSet.append(LabeledData(input: [0.6,0.6,0.2], label: [0,1]))
            trainingSet.append(LabeledData(input: [0.4,0.3,0.1], label: [0,1]))
            trainingSet.append(LabeledData(input: [0.9,0.1,0.7], label: [0,1]))
            trainingSet.append(LabeledData(input: [0.9,0.7,0.7], label: [0,1]))
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNetworkSGD() {
        network.SGD(trainingSet: trainingSet, epochs: 1000, miniBatchSize: 10, eta: 3, testSet: testSet)
        assert(network.biases[0][0] > 2 && network.biases[0][0] < 3, "Biase test failed")
        
        assert(network.weights[0][0,0] > -24 && network.weights[0][0,0] < -23, "Weight test failed")
        
    }
    
    
    
}
