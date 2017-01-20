//
//  NEAT.swift
//  Swift-Learn
//
//  Created by Disi A on 1/16/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation



public class NEAT{
    
    static var innovationTracker:[InnovationKey: Int] = [:]
    
    // globalInnovNum is a global variable that keeps track of
    // the chronology of the evolution via historical marking;
    // .In swift, we can use nil for zero, thus, global Innovation number can start from 0
    
    public static var globalInnovationNumber: Int = 0
    
    public static var activationFunctionSet = [ActivationFunc("sigmoid")]
    
    public static var evaluationFunction = EvaluationFunc("xortest")
    
    public static func initialize(){
        
        guard Parameter.isInitialized() && Parameter.isValid() else{
            fatalError("Parameters must be initialized first.")
        }
        
        // Clear out previous training history
        globalInnovationNumber = 0
        innovationTracker = [:]
        
        // initialize population
        for i in 0 ..< Parameter.populationSize{
            population.append(Genome(genomeId: i, speciesId: 0))
        }
        
        // initialize slice of species with one species
        species.append(Species(speciesId: 0, genome: population[0]))
        
    }
    
    fileprivate init() {
        NEAT.initialize()
    }
    
    public static var population : [Genome] = [] // population of genomes
    
    public static var species: [Species] = []    // ordered list of species
    
    
    public static func evaluate(){
        population.forEach { (genome) in
            genome.fitness = evaluationFunction.evaluate(genome)
        }
    }
    
    public static func speciate(){
        
    }
    
}

