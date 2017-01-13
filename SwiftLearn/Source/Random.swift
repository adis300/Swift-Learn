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
    
}
