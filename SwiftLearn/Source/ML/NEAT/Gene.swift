//
//  Gene.swift
//  Swift-Learn
//
//  Created by Disi A on 1/10/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation

public class Gene{
    
    public var enabled = true
    
    public var innovation: Int = 0
    public var mutation:Int = 0  //Used to see how much mutation has changed the link
    public var input: Int = 0
    public var output: Int = 0
    public var weight: Double = Random.randMinus1To1()
    
    public func clone() -> Gene{
        let gene = Gene()
        gene.enabled = enabled
        gene.innovation = innovation
        gene.input = input
        gene.output = output
        gene.weight = weight
        gene.mutation  = mutation
        return gene
    }
}
