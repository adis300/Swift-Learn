//
//  Gene.swift
//  Swift-Learn
//
//  Created by Disi A on 1/10/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

class Gene{
    public var enabled = true
    public var innovation = 0.0
    public var input      = 0.0
    public var output     = 0.0
    public var weight     = Random.randMinus1To1()
}
