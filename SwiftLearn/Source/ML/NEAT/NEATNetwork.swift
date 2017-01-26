//
//  NEATNetwork.swift
//  Swift-Learn
//
//  Created by Disi A on 1/18/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

// Node implements a node in a phenotype network; it includes a node ID,
// its activation function, and a signal value that the node holds.
fileprivate class Node {
    var nodeId: Int                      // node id
    var connectedNodes: [Node]           // nodes connected to this node
    var connectionWeights: [Int: Double] // connection weights to the output
    var signal:Double = 0                // stored activation signal
    var activationFunc: ActivationFunc   // activation function
    
    init(gene:NodeGene) {
        nodeId = gene.nodeId
        connectedNodes = []
        connectionWeights = [:]
        signal = 0
        activationFunc = gene.activationFunc
    }
    
    // Output sets and returns the signal of this node after it
    // activates via its activation function.
    func output() -> Double {
        // Clear out old signal value
        var sum = 0.0
        for node in connectedNodes {
            sum += connectionWeights[node.nodeId]! * node.signal
        }
        signal = activationFunc.function(sum)
        return signal
    }
}

public class NEATNetwork{
    
    fileprivate var nodes: [Int: Node] = [:]
    
    fileprivate var maxNodeId:Int
    
    public init(genome: Genome) {
        
        maxNodeId = genome.maxNodeId
        genome.nodes.values.forEach { (nodeGene) in
            nodes[nodeGene.nodeId] = Node(gene: nodeGene)
        }
        
        genome.connections.values.forEach { (connectionGene) in
            if !connectionGene.disabled {
                if let node = nodes[connectionGene.output]{
                    node.connectedNodes.append(self.nodes[connectionGene.input]!)
                    node.connectionWeights[connectionGene.input] = connectionGene.weight
                }
            }
        }
    }
    
    public func forwardPropagate(inputs: [Double]) -> [Double]{

        guard inputs.count == Parameter.numberOfSensor else{
            print("Error: inputs does not match number of sensors")
            return []
        }
        
        // Pop in inputs
        for i in 0 ..< Parameter.numberOfSensor{
            nodes[i]!.signal = inputs[i]
        }
        
        let h = Parameter.numberOfSensor + Parameter.numberOfOutput
        
        // Activate hidden neurons
        if h <= maxNodeId{
            for i in h ... maxNodeId{
                if let node = self.nodes[i]{
                    _ = node.output()
                }
                /*else{
                 print("Skipped node id")
                 }*/
            }
        }
        
        var outputs:[Double] = []
        
        // Finnally trigger the output neuron
        for i in Parameter.numberOfSensor ..< h{
            outputs.append(self.nodes[i]!.output())
        }
        
        return outputs
    }
    
}
