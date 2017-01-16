//
//  Gene.swift
//  Swift-Learn
//
//  Created by Disi A on 1/10/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation
import GameKit

// NodeGene is an implementation of each node within a genome.
// Each node includes a node ID (NID), a node type (NType), and
// a pointer to an activation function.

public enum NodeType{
    case output
    case sensor
    case hidden
}

// Neuron cell equivalent
public class NodeGene:Comparable,Equatable{
    
    public var nodeId: Int
    public var nodeType: NodeType
    public var activationFunc: ActivationFunc
    
    init(nodeId:Int, nodeType: NodeType, activationFunc: ActivationFunc) {
        self.nodeId = nodeId
        self.nodeType = nodeType
        self.activationFunc = activationFunc
    }
    
    public func copy() -> NodeGene{
        return NodeGene(nodeId: self.nodeId, nodeType: self.nodeType, activationFunc: self.activationFunc)
    }
}

public func == (lhs: NodeGene, rhs: NodeGene) -> Bool {
    return lhs.nodeId == rhs.nodeId
}

public func < (lhs: NodeGene, rhs: NodeGene) -> Bool {
    return lhs.nodeId < rhs.nodeId
}

public func > (lhs: NodeGene, rhs: NodeGene) -> Bool {
    return lhs.nodeId > rhs.nodeId
}

public func <= (lhs: NodeGene, rhs: NodeGene) -> Bool {
    return lhs.nodeId <= rhs.nodeId
}

public func >= (lhs: NodeGene, rhs: NodeGene) -> Bool {
    return lhs.nodeId >= rhs.nodeId
}
// Synapse equivalent
// ConnGene is an implementation of each connection within a genome.
// It represents a connection between an in-node and an out-node;
// it contains an innovation number and nids of the in-node and the
// out-node, whether if the connection is disabled, and the weight
// of the connection.
public class ConnGene:Comparable,Equatable{
    
    public var disabled = false
    
    public var innovation: Int = 0
    // public var mutation:Int = 0  //Used to see how much mutation has changed the link
    public var input: Int = 0
    public var output: Int = 0
    public var weight: Double = Random.randMinus1To1()
    
    public init(innovation: Int, input:Int, output:Int, weight: Double){
        self.innovation = innovation
        self.input = input
        self.output = output
        self.weight = weight
    }
    
    public init(innovation: Int, input:Int, output:Int){
        self.innovation = innovation
        self.input = input
        self.output = output
    }
    
    public func copy() -> ConnGene{
        let gene = ConnGene(innovation: self.innovation, input: self.input, output: self.output, weight: self.weight)
        gene.disabled = disabled
        // gene.mutation  = mutation
        return gene
    }
    
    // mutate mutates the connection weight.
    public func mutate() {
        if Random.rand0To1() < Parameter.mutateWeightRate {
            weight += Random.standardNormalRandom()
        }
    }
    
    public func toggle(){
        self.disabled = !self.disabled
    }
}

public func == (lhs: ConnGene, rhs: ConnGene) -> Bool {
    return lhs.innovation == rhs.innovation
}

public func < (lhs: ConnGene, rhs: ConnGene) -> Bool {
    return lhs.innovation < rhs.innovation
}

public func > (lhs: ConnGene, rhs: ConnGene) -> Bool {
    return lhs.innovation > rhs.innovation
}

public func <= (lhs: ConnGene, rhs: ConnGene) -> Bool {
    return lhs.innovation <= rhs.innovation
}

public func >= (lhs: ConnGene, rhs: ConnGene) -> Bool {
    return lhs.innovation >= rhs.innovation
}
