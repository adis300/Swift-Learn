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
    public static var globalChampion: Genome = Genome(genomeId: 0, speciesId: 0) // Not initialized here
    public static var globalSpeciesId: Int = 0

    
    public static var totalAverageFitness: Double = 0.0
    
    public static var activationFunctionSet = ActivationFunc.NEATSet
    
    public static var evaluationFunction = EvaluationFunc("xortest")
    
    
    public static var population : [Genome] = [] // population of genomes
    
    public static var species: [Species] = []    // ordered list of species

    
    fileprivate static func initialize(){
        
        guard Parameter.isInitialized() && Parameter.isValid() else{
            fatalError("NEAT: Parameters must be initialized & valid.")
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
        
        globalChampion = species[0].representative
        
        // Initialize population
        population.forEach { (genome) in
            // First evaluate the genome
            genome.evaluate()
            
            // If not added to existing species create a new species
            speciate(genome: genome)
        }
        
        // Initialize species individual fitness
        species.forEach { (group) in
            group.fitnessShare()
            group.averageFitness()
            group.select(survivalRate: 1)
            
        }
    }
    
    fileprivate init() {
        print("Init has no use")
        NEAT.initialize()
    }
    
    
    public static func speciate(genome: Genome){
        
        var addedToExistingSpecies = false
        for i in 0..<species.count{
            if species[i].representative.distance(to: genome) < Parameter.distanceThreshold{
                species[i].addMember(genome: genome)
                addedToExistingSpecies = true
            }
        }
        if !addedToExistingSpecies{
            createNewSpecies(genome: genome)
        }
    }
    
    fileprivate static func createNewSpecies(genome: Genome){
        genome.speciesId = globalSpeciesId
        globalSpeciesId += 1
        species.append(Species(speciesId: genome.speciesId, genome: genome))
    }
    
    fileprivate static func computeTotalAverageFitness(){
        totalAverageFitness = 0
        species.forEach { (group) in
            if group.maxFitness > globalChampion.fitness{
                globalChampion = group.champion()
            }
            totalAverageFitness += group.previousFitness.last!
        }
    }
    
    public static func removeStaleSpecies(){
        
        species = species.filter({ (group) -> Bool in
            // Preserve the species that has the champion
            return group.isHealthy() || group.speciesId == NEAT.globalChampion.speciesId
        })
        
        species.sort(by:{ $0.fitness() > $1.fitness() })
        
        let survived = Int((Double(species.count) * Parameter.speciesSurvivalRate) + 0.5)
        
        species = Array(species[0..<survived])
        
    }
    
    // Run executes NEAT algorithm.
    public static func run() -> Genome{
        initialize()
        
        print("NEAT: Generation 0: Initial population")
        computeTotalAverageFitness()

        for i in 1 ..< Parameter.numberOfGeneration {
            print("NEAT: Generation \(i)")
            // fitness share
            species.forEach({ (group) in
                group.nextGeneration()
            })
            
            removeStaleSpecies()
            // Compute total average fitness for next round and find the global champion
            computeTotalAverageFitness()
            
            print("NEAT: Species count: \(species.count)")
        }
        
        print("NEAT: Champion fitness is: \(globalChampion.fitness)")
        return globalChampion
    }
    
}

