//
//  Parameter.swift
//  Swift-Learn
//
//  Created by Disi A on 1/15/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

public class Parameter{
    
    fileprivate static var initialized: Bool = false
    
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
    public static var largeGenomeSizeThreshold: Int = 1  // Marks if N should be used when computing the genome distances 
    public static var enableConnectionRate: Double = 0.08  // Re-enables a connection
    public static var maxStagnation: Int = 3
    public static var speciesSurvivalRate: Double = 0.75
    
    public static func initialize(numberOfSensor: Int, numberOfOutput:Int){
        var params:[String: NSNumber] = [:]
        params["numberOfSensor"] = NSNumber(value:numberOfSensor)
        params["numberOfOutput"] = NSNumber(value:numberOfOutput)
        params["populationSize"] = NSNumber(value:50)
        params["numberOfGeneration"] = NSNumber(value:300)
        params["survivalRate"] = NSNumber(value:0.1)
        params["distanceThreshold"] = NSNumber(value: 2.8)
        params["dropoffAge"] = NSNumber(value:15)
        params["crossoverRate"] = NSNumber(value:0.1)
        params["mutateAddNodeRate"] = NSNumber(value:0.12)
        params["mutateAddConnectionRate"] = NSNumber(value:0.12)
        params["mutateWeightRate"] = NSNumber(value:0.1)
        params["coeffExcess"] = NSNumber(value:1.0)
        params["coeffDisjoint"] = NSNumber(value:1.0)
        params["coeffWeight"] = NSNumber(value:2.0)
        // Optionals
        
        initialize(params: params)
    }
    
    // Static initializer
    public static func initialize(params: [String: Any]){
        if let numOfSensor = params["numberOfSensor"] as? NSNumber{
            numberOfSensor = numOfSensor.intValue
        }else{
            fatalError("Parameter: failed to initialize [numberOfSensor]")
        }
        
        if let numOfOutput = params["numberOfOutput"] as? NSNumber{
            numberOfOutput = numOfOutput.intValue
        }else{
            fatalError("Parameter: failed to initialize [numberOfOutput]")
        }
        
        if let popSize = params["populationSize"] as? NSNumber{
            populationSize = popSize.intValue
        }else{
            fatalError("Parameter: failed to initialize [populationSize]")
        }
        
        if let numOfGeneration = params["numberOfGeneration"] as? NSNumber{
            numberOfGeneration = numOfGeneration.intValue
        }else{
            fatalError("Parameter: failed to initialize [numberOfGeneration]")
        }
        
        if let survRate = params["survivalRate"] as? NSNumber{
            survivalRate = survRate.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [survivalRate]")
        }
        
        if let distThreshold = params["distanceThreshold"] as? NSNumber{
            distanceThreshold = distThreshold.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [distanceThreshold]")
        }
        
        if let doAge = params["dropoffAge"] as? NSNumber{
            dropoffAge = doAge.intValue
        }else{
            fatalError("Parameter: failed to initialize [dropoffAge]")
        }
        
        if let coRate = params["crossoverRate"] as? NSNumber{
            crossoverRate = coRate.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [crossoverRate]")
        }
        
        if let mutAddNodeRate = params["mutateAddNodeRate"] as? NSNumber{
            mutateAddNodeRate = mutAddNodeRate.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [mutateAddNodeRate]")
        }
        
        if let mutAddConnectionRate = params["mutateAddConnectionRate"] as? NSNumber{
            mutateAddConnectionRate = mutAddConnectionRate.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [mutateAddConnectionRate]")
        }
        
        if let mutWeightRate = params["mutateWeightRate"] as? NSNumber{
            mutateWeightRate = mutWeightRate.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [mutateWeightRate]")
        }
        
        if let excess = params["coeffExcess"] as? NSNumber{
            coeffExcess = excess.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [coeffExcess]")
        }
        
        if let disjoint = params["coeffDisjoint"] as? NSNumber{
            coeffDisjoint = disjoint.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [coeffDisjoint]")
        }
        
        if let weight = params["coeffWeight"] as? NSNumber{
            coeffWeight = weight.doubleValue
        }else{
            fatalError("Parameter: failed to initialize [coeffWeight]")
        }
        
        // Optional parameters
        if let threshold = params["largeGenomeSizeThreshold"] as? NSNumber{
            largeGenomeSizeThreshold = threshold.intValue
        }
        
        if let enableConnRate = params["enableConnectionRate"] as? NSNumber{
            enableConnectionRate = enableConnRate.doubleValue
        }
        
        if let maxStag = params["maxStagnation"] as? NSNumber{
            maxStagnation = maxStag.intValue
        }
        
        initialized = true
    }
    
    public static func isValid() -> Bool{
        // TODO: Implement parameter is valid function
        return initialized && true
    }
    
    public static func isInitialized() -> Bool{
        return Parameter.initialized
    }
    
}
