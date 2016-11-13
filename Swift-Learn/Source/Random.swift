//
//  Random.swift
//  Swift-Learn
//
//  Created by Innovation on 11/12/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

class Random{
    
    static func randN1To1(length: Int) -> [Double]{
        return (0..<length).map{_ in Double(arc4random())/Double(INT32_MAX) - 1}
    }
    
}
