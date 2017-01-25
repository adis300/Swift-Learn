//
//  Node.swift
//  Swift-Learn
//
//  Created by Disi A on 1/24/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

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
