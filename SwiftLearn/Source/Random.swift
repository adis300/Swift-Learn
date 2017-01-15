//
//  Random.swift
//  Swift-Learn
//
//  Created by Innovation on 11/12/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

class Random{
    
    static func randMinus1To1(length: Int) -> [Double]{
        return (0..<length).map{_ in Double(arc4random())/Double(INT32_MAX) - 1}
    }
    
    static func randMinus1To1() -> Double{
        return Double(arc4random())/Double(INT32_MAX) - 1
    }
    
    static func randN(n:Int) -> Int{
        return Int(arc4random_uniform(UInt32(n)))
    }
    
    static func rand0To1() -> Double{
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    
    static var y2 = 0.0
    static var use_last = false
    ///  static Function to get a random value for a given distribution
    // static func gaussianRandom(_ mean : Double, standardDeviation : Double) -> Double
    static func standardNormalRandom() -> Double

    {
        var y1 : Double
        if (use_last)		        /* use value from previous call */
        {
            y1 = y2
            use_last = false
        }
        else
        {
            var w = 1.0
            var x1 = 0.0
            var x2 = 0.0
            repeat {
                x1 = 2.0 * (Double(arc4random()) / Double(UInt32.max)) - 1.0
                x2 = 2.0 * (Double(arc4random()) / Double(UInt32.max)) - 1.0
                w = x1 * x1 + x2 * x2
            } while ( w >= 1.0 )
            
            w = sqrt( (-2.0 * log( w ) ) / w )
            y1 = x1 * w
            y2 = x2 * w
            use_last = true
        }
        
        return( y1 * 1 )
    }
    
    
    /*
    static func normalDistribution(μ:Double, σ:Double, x:Double) -> Double {
        let a = exp( -1 * pow(x-μ, 2) / ( 2 * pow(σ,2) ) )
        let b = σ * sqrt( 2 * M_PI )
        return a / b
    }
    
    static func standardNormalDistribution(_ x:Double) -> Double {
        return exp( -1 * pow(x, 2) / 2 ) / sqrt( 2 * M_PI )
    }*/
    
}
