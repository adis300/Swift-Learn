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
    public var previousFitness:[Double]     // previous average fitness
    public var maxFitness: Double
    public var representative: Genome       // species representative
    fileprivate var individuals: [Genome]  // genomes in this species
    fileprivate var stagnation: Int = 0
    
    public var speciesGenomeId: Int
    
    // NewSpecies creates a new species given a species ID, and the genome
    // that first populates the new species.
    public init(speciesId: Int, genome: Genome) {
        
        genome.genomeId = 0
        self.speciesGenomeId = 1
        self.maxFitness = genome.fitness
        self.previousFitness = [genome.fitness]
        self.speciesId = speciesId
        self.representative = genome
        self.individuals = [genome]
    }
    
    public func fitness() -> Double{
        if let fit = previousFitness.last{
            return fit
        }
        return -1.0
    }
    
    fileprivate func isEmpty() -> Bool{
        return self.individuals.count == 0
    }
    
    // AddGenome adds a new genome to this species.
    public func addMember(genome: Genome){
        genome.speciesId = self.speciesId
        genome.genomeId = speciesGenomeId
        speciesGenomeId += 1
        self.individuals.append(genome)
    }
    
    // Select sorts the members by their fitness values and update them based on
    // the survival rate; return the remaining members.
    public func select(survivalRate:Double){
        
        individuals = individuals.sorted(by:{ $0.fitness > $1.fitness })
        
        if let maxFit = individuals.first?.fitness{
            maxFitness = maxFit
            
            // Compute survival rate only if there is still individuals left
            var survived = Int((Double(self.individuals.count) * survivalRate) + 0.5)
            
            if survived > Parameter.maxNumberOfSpecies{
                survived = Parameter.maxNumberOfSpecies
            }
            
            self.individuals = Array(self.individuals[0..<survived])
            
            if self.individuals.isEmpty {
                maxFitness = -1
            }
        }
        
        // return self.individuals
    }
    
    // Champion returns the genome with the best fitness value in this species.
    // Individuals are always sorted after select statement
    public func champion() -> Genome{
        return self.individuals[0]
        /*
         var champion = self.individuals[0]

        individuals.forEach { (individual) in
            if(individual.fitness > champion.fitness){
                champion = individual
            }
        }
        
        return champion
         */
    }
    
    // AvgFitness returns the species' average fitness.
    public func averageFitness(){
        if individuals.count > 0 {
            var fitnessSum = 0.0
            
            individuals.forEach { (individual) in
                fitnessSum += individual.fitness
            }
            
            let avgFitness = fitnessSum / Double(individuals.count)
            if let lastFitness = previousFitness.last{
                if avgFitness < lastFitness{
                    stagnation += 1
                }else{
                    stagnation = 0
                }
            }
            previousFitness.append(avgFitness)
            if previousFitness.count > Parameter.maxStagnation {
                previousFitness = Array(previousFitness.suffix(Parameter.maxStagnation))
            }
        }else{
            stagnation += 1
            previousFitness[previousFitness.count - 1] = -1
        }
    }
    
    // IsStagnant checks whether a species is stagnant based on comparison between
    // previous and current average fitnesses; this function call also updates its
    // previous average fitness to the current fitness.
    fileprivate func isStagnant() -> Bool {
        return stagnation > Parameter.maxStagnation
        /*
        if previousFitness.count > 1{
            if previousFitness[previousFitness.count-1] < previousFitness[previousFitness.count - 2]{
                return true
            }
        }
        return false
         */
    }
    
    public func isHealthy() -> Bool{
        return !isStagnant() && !isEmpty()
    }
    
    // TODO: Implement adjusted fitness function with age panelty
    // FitnessShare computes and assigns the shared fitness of genomes via explicit fitness sharing.
    public func fitnessShare() {
        
        /*
        var adjusted: [Int:Double] = [:]
        
        for g0 in self.individuals{
            var adjustment = 0
            for g1 in self.individuals {
                if Species.sh(g0.distance(to: g1)){
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
        }*/
    }
    
    public func nextGeneration(){
                
        // TODO: breed some children using NEAT.totalAverageFitness
        let children:[Genome] = (1...20).map{ _ in
            return breadChild()
        }
        // Evaluate and speciate each child
        children.forEach { (child) in
            child.evaluate()
            NEAT.speciate(genome: child)
        }
        
        
        fitnessShare()
        averageFitness()
        select(survivalRate: Parameter.survivalRate)
        age += 1
    }
    
    public func breadChild() -> Genome {
        let child: Genome
        let g0Ind = Random.randN(n: individuals.count)
        let g0 = individuals[g0Ind]
        if Random.rand0To1() < Parameter.crossoverRate {
            let g1Ind = Random.randN(n: individuals.count)
            // if g0Ind != g1Ind{   // skip checking of same genome crossing over
            let g1 = individuals[g1Ind]
            child = g0.crossover(partner: g1, newGenomeId: individuals.count)
        }else{
            child = g0.copy(newGenomeId: individuals.count)
        }
        child.mutate()
        // addMember(genome: child)
        
        return child
    }

    
    // sh implements a part of the explicit fitness sharing function, sh.
    // If a compatibility distance 'd' is larger than the compatibility
    // threshold 'dt', return 0; otherwise, return 1.
    public static func sh(_ distance: Double) -> Bool { //isCompatible implementation
        if distance > Parameter.distanceThreshold {
            return false
        }
        return true
    }
    
    
}
