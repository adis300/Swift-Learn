//
//  Connection.swift
//  Swift-Learn
//
//  Created by Disi A on 1/24/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

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
    public var weight: Double
    
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
        self.weight = Random.normalRandom() //Random.randMinus1To1()
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
            weight += Random.normalRandom()
        }
        if disabled{
            if Random.rand0To1() < Parameter.enableConnectionRate{
                toggle()
            }
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
