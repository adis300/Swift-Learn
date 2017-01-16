//
//  Genome.swift
//  Swift-Learn
//
//  Created by Disi A on 1/15/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

public class Genome {
    public var genomeId: Int
    public var speciesId: Int = 0
    
    public var nodes: [Int: NodeGene] = [:] // collection of node genes
    public var connections: [Int: ConnGene] = [:] // collection of connection genes
    
    public var fitness:Double = 0 // fitness value of the genome
    
    public init(genomeId:Int) {
        
        let numberOfNodes = Parameter.numberOfSensor + Parameter.numberOfOutput
        
        // Tell the connections to pre-allocate storage for the given capacity by doing something like this:
        // connections.reserveCapacity(Parameter.numberOfSensor * Parameter.numberOfOutput)
        
        self.genomeId = genomeId
        
        for i in 0..<Parameter.numberOfSensor{
            nodes[i] = NodeGene(nodeId:i, nodeType:.sensor, activationFunc: ActivationFunc("identity"))
        }
        // nodes = (0..<Parameter.numberOfSensor).map{NodeGene(nodeId:$0, nodeType:.sensor, activationFunc: ActivationFunc("identity"))}
        
        for i in Parameter.numberOfSensor..<numberOfNodes{
            
            let node = NodeGene(nodeId:i, nodeType:.output, activationFunc: ActivationFunc("sigmoid"))
            nodes[i] = node
            
            for j in 0 ..< Parameter.numberOfSensor{
                
                let innovationKey = InnovationKey(input: nodes[j]!.nodeId, output: node.nodeId)
                
                var innovationNumber = NEAT.innovationTracker[innovationKey]
                if innovationNumber == nil{
                    innovationNumber = NEAT.globalInnovationNumber
                    NEAT.innovationTracker[innovationKey] = innovationNumber
                    // register the new connection innovation
                    NEAT.globalInnovationNumber += 1
                }
                connections[innovationNumber!] = ConnGene(innovation: innovationNumber!, input: nodes[j]!.nodeId, output: node.nodeId)
            }
        }
    }
    
    public func getNode(nodeId: Int) -> NodeGene?{
        return nodes[nodeId]
    }
    
    public func getConnection(innovationNumber: Int) -> ConnGene?{
        return connections[innovationNumber]
    }
    
    public func distance(to: Genome){
        var numDisjoint: Int = 0     // number of disjoint genes
        var numExcess: Int = 0       // number of excess genes
        var numMatch: Int = 0        // number of matching genes
        var avgWeightDiff: Double = 0.0 // average weight differences of matching genes
        
        
    }
    
}
