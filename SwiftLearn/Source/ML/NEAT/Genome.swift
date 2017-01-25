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
    public var speciesId: Int
    
    public var nodes: [Int: NodeGene] = [:] // collection of node genes
    public var connections: [Int: ConnGene] = [:] // collection of connection genes
    
    public var fitness:Double = 0 // fitness value of the genome
    
    public var maxInnovationNumber = 0
    
    public init(genomeId:Int, speciesId: Int, nodes: [Int: NodeGene], connections: [Int: ConnGene]){
        
        self.genomeId = genomeId
        self.speciesId = speciesId
        nodes.forEach { (key, value) in
            self.nodes[key] = value.copy()
        }
        
        connections.forEach { (key, value) in
            self.connections[key] = value.copy()
        }        
    }
    
    public func copy(newGenomeId: Int) -> Genome{
        return Genome(genomeId: newGenomeId, speciesId: self.speciesId, nodes: self.nodes, connections: self.connections)
    }
    
    public func copy() -> Genome{
        let genome = Genome(genomeId: genomeId, speciesId: self.speciesId, nodes: self.nodes, connections: self.connections)
        genome.fitness = fitness
        genome.maxInnovationNumber = maxInnovationNumber
        return genome
    }
    
    public init(genomeId:Int, speciesId: Int) {
        
        let numberOfNodes = Parameter.numberOfSensor + Parameter.numberOfOutput
        
        // Tell the connections to pre-allocate storage for the given capacity by doing something like this:
        // connections.reserveCapacity(Parameter.numberOfSensor * Parameter.numberOfOutput)
        
        self.genomeId = genomeId
        self.speciesId = speciesId
        
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
                
                if innovationNumber! > maxInnovationNumber{
                    maxInnovationNumber = innovationNumber!
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
    
    // Distance computes the compatibility distance between this genome
    // and the argument genome. The compatibility distance is a measurement
    // of two genomes' compatibility for speciating them.
    public func distance(to: Genome) -> Double{
        var numDisjoint: Int = 0     // number of disjoint genes
        var numExcess: Int = 0       // number of excess genes
        var numMatch: Int = 0        // number of matching genes
        var avgWeightDiff: Double = 0.0 // average weight differences of matching genes
        
        var smallerMaxInnnovation:Int
        var largerMaxInnovation:Int
        var larger: Genome
        
        if self.maxInnovationNumber < to.maxInnovationNumber{
            smallerMaxInnnovation = self.maxInnovationNumber
            largerMaxInnovation = to.maxInnovationNumber
            larger = to
        }else{
            smallerMaxInnnovation = to.maxInnovationNumber
            largerMaxInnovation = self.maxInnovationNumber
            larger = self
        }
        
        // try innovation numbers from 1 to the small genome's largest innovation numbers to count the number of disjoint genes
        
        for i in 0...smallerMaxInnnovation{
            let thisConn = self.getConnection(innovationNumber: i)
            let thatConn = to.getConnection(innovationNumber: i)
            
            if thisConn != nil && thatConn != nil {
                avgWeightDiff += abs(thisConn!.weight - thatConn!.weight)
                numMatch += 1
            } else if (thisConn != nil && thatConn == nil) || (thisConn == nil && thatConn != nil) {
                numDisjoint += 1
            }
        }
        
        // get average difference if the number of matching genes is
        // larger than 0
        if numMatch > 0 {
            avgWeightDiff /= Double(numMatch)
        }
        
        // count excess genes
        if largerMaxInnovation > smallerMaxInnnovation{
            for i in (smallerMaxInnnovation + 1) ... largerMaxInnovation{
                if larger.getConnection(innovationNumber: i) != nil {
                    numExcess += 1
                }
            }
        }
        
        let N = larger.connections.count
        
        if N > Parameter.largeGenomeSizeThreshold{
            return Parameter.coeffExcess * Double(numExcess)/Double(N) +
                Parameter.coeffDisjoint * Double(numDisjoint)/Double(N) +
                Parameter.coeffWeight * avgWeightDiff
        }else{
            return Parameter.coeffExcess * Double(numExcess) +
                Parameter.coeffDisjoint * Double(numDisjoint) +
                Parameter.coeffWeight * avgWeightDiff
        }
    }
    
    // Crossover returns a child genome created by crossover operation
    // between this genome and other genome provided as an argument; since
    // the two parent genomes have to be in the same species, it is assumed
    // that the child's species id is the same as one of the two parents'
    // (g0 in this implementation).
    public func crossover(partner: Genome, newGenomeId: Int) -> Genome{
        
        // Initialize child
        let child = Genome(genomeId: newGenomeId, speciesId: self.speciesId, nodes: self.nodes, connections: self.connections)
        
        var smallerMaxInnnovation:Int
        var largerMaxInnovation:Int
        var larger: Genome
        
        if self.maxInnovationNumber < partner.maxInnovationNumber{
            smallerMaxInnnovation = self.maxInnovationNumber
            largerMaxInnovation = partner.maxInnovationNumber
            larger = partner
        }else{
            smallerMaxInnnovation = partner.maxInnovationNumber
            largerMaxInnovation = self.maxInnovationNumber
            larger = self
        }
        
        // try innovation numbers from 1 to the small genome's largest innovation numbers to count the number of disjoint genes
        
        for i in 0...smallerMaxInnnovation{
            let thisConn = self.getConnection(innovationNumber: i)
            let thatConn = partner.getConnection(innovationNumber: i)
            
            if thisConn != nil || thatConn != nil{
                if thisConn == nil{
                    child.copyConnection(source: partner, connection: thatConn!)
                }else if thatConn == nil{
                    child.copyConnection(source: self, connection: thisConn!)
                }else{
                    // Proper implementation of mutation by averaging weight
                    if Random.rand0To1() < 0.5{
                        if self.fitness > partner.fitness{
                            child.copyConnection(source: self, connection: thisConn!)
                        }else{
                            child.copyConnection(source: partner, connection: thatConn!)
                        }
                    }else{
                        let probability = Random.rand0To1()
                        if probability < 0.3333333334{
                            child.copyConnection(source: self, connection: thisConn!)
                        }else if probability < 0.6666666667{
                            child.copyConnection(source: partner, connection: thatConn!)
                        }else{
                            child.copyConnectionAverageWeight(source: partner, connection: thatConn!, weight: thisConn!.weight + thatConn!.weight)
                        }
                    }
                }
            }
            
        }
        
        // Deal with excess gene cross over
        if largerMaxInnovation > smallerMaxInnnovation{
            for i in (smallerMaxInnnovation + 1) ... largerMaxInnovation{
                if let conn = larger.getConnection(innovationNumber: i) {
                    child.copyConnection(source: larger, connection: conn)
                }
            }
        }
        child.maxInnovationNumber = largerMaxInnovation

        return child
    }
    
    // copyConn is a helper function of Crossover which copies a connection from
    // other genome to this genome, and nodes that are connected by this
    // connection, accordingly.
    public func copyConnection(source:Genome, connection: ConnGene){
        if self.getConnection(innovationNumber: connection.innovation) == nil{
            self.connections[connection.innovation] = connection //.copy if bug occurs
        }

        if self.getNode(nodeId: connection.input) == nil {
            self.nodes[connection.input] = source.getNode(nodeId: connection.input)
        }

        if self.getNode(nodeId: connection.output) == nil {
            self.nodes[connection.output] = source.getNode(nodeId: connection.output)
        }
    }
    
    // copyConn is a helper function of Crossover which copies a connection from
    // other genome to this genome, and nodes that are connected by this
    // connection, accordingly.
    public func copyConnectionAverageWeight(source:Genome, connection: ConnGene, weight: Double){
        if self.getConnection(innovationNumber: connection.innovation) == nil{
            let newConnection = connection.copy()
            newConnection.weight = weight
            self.connections[connection.innovation] = newConnection
        }
        
        if self.getNode(nodeId: connection.input) == nil {
            self.nodes[connection.input] = source.getNode(nodeId: connection.input)
        }
        
        if self.getNode(nodeId: connection.output) == nil {
            self.nodes[connection.output] = source.getNode(nodeId: connection.output)
        }
    }
    
    // Mutate mutates the genome by adding a node, adding a connection,
    // and by mutating connections' weights.
    public func mutate() {
        // mutation by adding a new node; available only if there is at
        // least one connection in the genome.
        
        // mutation by adding a new node; available only if there is at
        // least one connection in the genome.
        self.mutateAddNode()
        
        // mutation by adding a new connection.
        self.mutateAddConnection()
        
        // mutate connections
        self.connections.forEach { (_, conn) in
            conn.mutate()
        }
    }
    
    func mutateAddNode(){
        
        // mutateAddNode mutates the genome by adding a node between a
        // connection of two nodes. After the newly added node splits the
        // existing connection, two new connections will be added with weights
        // of 1.0 and the original connection's weight, in order to prevent
        // sudden changes in the network's performance.
        if Random.rand0To1() < Parameter.mutateAddNodeRate {
            
            // requires at least one connection
            if connections.count > 0 {
                let oldConn = Array(connections.values)[Random.randN(n: connections.count)]
                if !oldConn.disabled{
                    // Create a new node that will be placed between a connection
                    let newNode = NodeGene(nodeId: nodes.count, nodeType: .hidden, activationFunc: ActivationFunc.randomActivationFunc(set: NEAT.activationFunctionSet))
                    
                    guard self.nodes[newNode.nodeId] == nil else{
                        fatalError("Node already exists, cannot add new node.")
                    }
                    
                    self.nodes[newNode.nodeId] = newNode
                    
                    // The first connection that will be created by spliting an existing
                    // connection will have a weight of 1.0, and will be connected from
                    // the in-node of the existing node to the newly created node.
                    var innovationKey = InnovationKey(input: oldConn.input, output:newNode.nodeId)
                    var innovationNumber = NEAT.innovationTracker[innovationKey]
                    
                    if innovationNumber == nil{
                        innovationNumber = NEAT.globalInnovationNumber
                        // register the new connection innovation
                        NEAT.innovationTracker[innovationKey] = innovationNumber
                        NEAT.globalInnovationNumber += 1
                    }
                    
                    self.connections[innovationNumber!] = ConnGene(innovation: innovationNumber!, input: oldConn.input, output: newNode.nodeId, weight: 1)
                    
                    if innovationNumber! > maxInnovationNumber{
                        maxInnovationNumber = innovationNumber!
                    }
                    
                    // The second new connection will have the same weight as the existing
                    // connection, in order to prevent sudden changes after the mutation, and
                    // will be connected from the new node to the out-node of the existing
                    // connection.
                    innovationKey = InnovationKey(input: newNode.nodeId, output:oldConn.output)
                    innovationNumber = NEAT.innovationTracker[innovationKey]
                    
                    if innovationNumber == nil{
                        innovationNumber = NEAT.globalInnovationNumber
                        // register the new connection innovation
                        NEAT.innovationTracker[innovationKey] = innovationNumber
                        NEAT.globalInnovationNumber += 1
                    }
                    
                    self.connections[innovationNumber!] = ConnGene(innovation: innovationNumber!, input: newNode.nodeId, output: oldConn.output, weight: oldConn.weight)
                    
                    if innovationNumber! > maxInnovationNumber{
                        maxInnovationNumber = innovationNumber!
                    }
                    // Switch off the old connection
                    oldConn.toggle()
                }
            }
        }
    }
    
    func mutateAddConnection(){
        if Random.rand0To1() < Parameter.mutateAddConnectionRate {
            
            // The in-node of the connection to be added can be selected
            // randomly from any node genes.
            let inNode = Array(nodes.values)[Random.randN(n: nodes.count)]
            
            // The out-node can only be randomly selected from nodes that are
            // not sensor nodes.
            let outNodeId = Random.randN(n: nodes.count - Parameter.numberOfSensor) + Parameter.numberOfSensor
            let outNode = nodes[outNodeId]!
            
            // Search for a connection gene that has the same in-node and out-node.
            for (_, conn) in connections{
                if(conn.input == inNode.nodeId && conn.output == outNode.nodeId){
                    return
                }
            }
            
            // A new connection gene with a random weight is added between the
            // selected nodes. If the connection innovation already exists, use
            // the same innovation number as before; use global innovation number,
            // otherwise.
            let innovationKey = InnovationKey(input: inNode.nodeId, output: outNode.nodeId)
            var innovationNumber = NEAT.innovationTracker[innovationKey]
            
            if innovationNumber == nil {
                innovationNumber = NEAT.globalInnovationNumber
                NEAT.innovationTracker[innovationKey] = innovationNumber
                // register the new connection innovation
                NEAT.globalInnovationNumber += 1
            }
            
            connections[innovationNumber!] = ConnGene(innovation: innovationNumber!, input: inNode.nodeId, output: outNode.nodeId)
            
            if innovationNumber! > maxInnovationNumber{
                maxInnovationNumber = innovationNumber!
            }
        }
    }
    
    // status prints the current state of the genome, followed by the current global innovation number.
    public func status(){
        
        print("Genome Status for: GenomeID: \(genomeId)")
        print("Nodes:")
        
        for i in 0 ..< nodes.count {
            if let node =  nodes[i]{
                print("NODE_ID:\(node.nodeId), TYPE:\(node.nodeType), AFN:\(node.activationFunc.name)")
            }
        }
        print("Connections:")
        for i in 0 ... maxInnovationNumber {
            if let conn =  connections[i]{
                print("INNO_NUM:\(conn.innovation), DISABLED:\(conn.disabled), FROM:\(conn.input), TO:\(conn.output), WEIGHT:\(conn.weight)")
            }
        }
    }
    
    public func evaluate(){
        self.fitness = NEAT.evaluationFunction.evaluate(self)
    }
    
}
