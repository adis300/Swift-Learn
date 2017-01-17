//
//  Parameter.swift
//  Swift-Learn
//
//  Created by Disi A on 1/15/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

public class Parameter{
    
    static var initialized: Bool = false
    
    // Topology parameter
    public static var numberOfSensor: Int = 0
    public static var numberOfOutput: Int = 0
    
    // EA-specific parameters
    public static var populationSize :Int = 0    // population size
    public static var numberOfGeneration :Int = 0     // number of generations
    public static var survivalRate :Double  = 0 // survival rate for reproduction

    // NEAT-specific parameters
    public static var distanceThreshold :Double = 0 // compatibility distance threshold
    public static var dropoffAge :Int = 0     // number of ages for checking stagnation
    
    // Crossover and Mutation rates
    public static var crossoverRate :Double = 0 // crossover rate
    public static var mutateAddNodeRate :Double = 0 // mutation rate for adding a node
    public static var mutateAddConnectionRate :Double = 0// mutation rate for adding a connection
    public static var mutateWeightRate  :Double = 0// mutation rate of weights of connections
    
    // Coefficients for compatibility distance
    public static var coeffExcess :Double = 0// coefficient for excess
    public static var coeffDisjoint :Double = 0// coefficient for disjoint
    public static var coeffWeight :Double = 0 // coefficient for average weight
    
    // Optional parameters
    public static var largeGenomeSizeThreshold: Int = 1
    
    // Static initializer
    public static func initialize(params: [String: Any]){
        if let numOfSensor = params["numberOfSensor"] as? Int{
            numberOfSensor = numOfSensor
        }else{
            print("Parameter: failed to initialize [numberOfSensor]")
            return
        }
        
        if let numOfOutput = params["numberOfOutput"] as? Int{
            numberOfOutput = numOfOutput
        }else{
            print("Parameter: failed to initialize [numberOfOutput]")
            return
        }
        
        if let popSize = params["populationSize"] as? Int{
            populationSize = popSize
        }else{
            print("Parameter: failed to initialize [populationSize]")
            return
        }
        
        if let numOfGeneration = params["numberOfGeneration"] as? Int{
            numberOfGeneration = numOfGeneration
        }else{
            print("Parameter: failed to initialize [numberOfGeneration]")
            return
        }
        
        if let survRate = params["survivalRate"] as? Double{
            survivalRate = survRate
        }else{
            print("Parameter: failed to initialize [survivalRate]")
            return
        }
        
        if let distThreshold = params["distanceThreshold"] as? Double{
            distanceThreshold = distThreshold
        }else{
            print("Parameter: failed to initialize [distanceThreshold]")
            return
        }
        
        if let doAge = params["dropoffAge"] as? Int{
            dropoffAge = doAge
        }else{
            print("Parameter: failed to initialize [dropoffAge]")
            return
        }
        
        if let coRate = params["crossoverRate"] as? Double{
            crossoverRate = coRate
        }else{
            print("Parameter: failed to initialize [crossoverRate]")
            return
        }
        
        if let mutAddNodeRate = params["mutateAddNodeRate"] as? Double{
            mutateAddNodeRate = mutAddNodeRate
        }else{
            print("Parameter: failed to initialize [mutateAddNodeRate]")
            return
        }
        
        if let mutAddConnectionRate = params["mutateAddConnectionRate"] as? Double{
            mutateAddConnectionRate = mutAddConnectionRate
        }else{
            print("Parameter: failed to initialize [mutateAddConnectionRate]")
            return
        }
        
        if let mutWeightRate = params["mutateWeightRate"] as? Double{
            mutateWeightRate = mutWeightRate
        }else{
            print("Parameter: failed to initialize [mutateWeightRate]")
            return
        }
        
        if let excess = params["coeffExcess"] as? Double{
            coeffExcess = excess
        }else{
            print("Parameter: failed to initialize [coeffExcess]")
            return
        }
        
        if let disjoint = params["coeffDisjoint"] as? Double{
            coeffDisjoint = disjoint
        }else{
            print("Parameter: failed to initialize [coeffDisjoint]")
            return
        }
        
        if let weight = params["coeffWeight"] as? Double{
            coeffWeight = weight
        }else{
            print("Parameter: failed to initialize [coeffWeight]")
            return
        }
        
        // Optional parameters
        if let threshold = params["largeGenomeSizeThreshold"] as? Int{
            largeGenomeSizeThreshold = threshold
        }
        
        initialized = true
    }
    
    public static func isInitialized() -> Bool{
        return Parameter.initialized
    }
    
}
