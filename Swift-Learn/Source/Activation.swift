//
//  Activation.swift
//  Swift-Learn
//
//  Created by Innovation on 11/12/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

class Activation{
    
    static func sigmoid(_ x: Double)-> Double{
        return tanh(x) / 2 + 0.5
    }
    
    
}
