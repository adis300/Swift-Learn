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
    
    public static var ActivationFunctionSet = [ActivationFunc("sigmoid")]
    
    public static func Initialize(){
        
        // Clear out previous training history
        globalInnovationNumber = 0
        innovationTracker = [:]
    }
}

