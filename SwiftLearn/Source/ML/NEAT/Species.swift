//
//  Species.swift
//  Swift-Learn
//
//  Created by Disi A on 1/16/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

// Species is an implementation of species of genomes in NEAT, which
// are separated by measuring compatibility distance among genomes
// within a population.

public class Species{
    
    public var speciesId: Int               // species ID
    public var age: Int = 0                 // species age (in generations)
    public var previousFitness:Double = 0   // previous average fitness
    public var representative: Genome       // species representative
    public var individuals: [Genome] = [] // genomes in this species
    
    // NewSpecies creates a new species given a species ID, and the genome
    // that first populates the new species.
    public init(speciesId: Int, genome: Genome) {
        self.speciesId = speciesId
        self.representative = genome
    }
    
    // AddGenome adds a new genome to this species.
    public func addMember(genome: Genome){
        genome.speciesId = self.speciesId
        self.individuals.append(genome)
    }
    
    // Select sorts the members by their fitness values and update them based on
    // the survival rate; return the remaining members.
    public func select() -> [Genome]{
        
        individuals = individuals.sorted(by:{ $0.fitness > $1.fitness })
        
        let survived = Int((Double(self.individuals.count) * Parameter.survivalRate))
        
        self.individuals = Array(self.individuals[0..<survived])
        
        return self.individuals
    }
    
    // Champion returns the genome with the best fitness value in this species.
    public func champion() -> Genome{
        
        var champion = self.individuals[0]
        
        individuals.forEach { (individual) in
            if(individual.fitness > champion.fitness){
                champion = individual
            }
        }
        return champion
        
    }
    
    // AvgFitness returns the species' average fitness.
    public func averageFitness() -> Double {
        var fitnessSum = 0.0
        
        individuals.forEach { (individual) in
            fitnessSum += individual.fitness
        }

        return fitnessSum / Double(individuals.count)
    }
    
    // IsStagnant checks whether a species is stagnant based on comparison between
    // previous and current average fitnesses; this function call also updates its
    // previous average fitness to the current fitness.
    public func isStagnant() -> Bool {
        let averageFitness = self.averageFitness()
        if self.previousFitness < averageFitness {
            self.previousFitness = averageFitness
            return true
        }
        self.previousFitness = averageFitness
        return false
    }
    
    // TODO: Implement adjusted fitness function with age panelty
    // FitnessShare computes and assigns the shared fitness of genomes via explicit fitness sharing.
    public func fitnessShare() {
        var adjusted: [Int:Double] = [:]
        
        for g0 in self.individuals{
            var adjustment = 0
            for g1 in self.individuals {
                if Species.isCompatible(g0.distance(to: g1)){
                    adjustment += 1
                }
            }
            
            if adjustment > 0{
                adjusted[g0.genomeId] = g0.fitness / Double(adjustment)
            }
        }
        self.individuals.forEach { (individual) in
            if let adjustment = adjusted[individual.genomeId]{
                individual.fitness = adjustment
            }
        }
    }
    
    // sh implements a part of the explicit fitness sharing function, sh.
    // If a compatibility distance 'd' is larger than the compatibility
    // threshold 'dt', return 0; otherwise, return 1.
    public static func isCompatible(_ distance: Double) -> Bool {
        if distance > Parameter.distanceThreshold {
            return false
        }
        return true
    }
    
}
