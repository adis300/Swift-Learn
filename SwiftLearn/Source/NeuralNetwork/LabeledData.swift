//
//  DateSet.swift
//  Swift-Learn
//
//  Created by Disi A on 11/19/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

public class LabeledData{
    
    let input: Vector<Double>
    let label: Vector<Double>
    
    public init(input: Vector<Double>, label: Vector<Double>) {
        self.input = input
        self.label = label
    }
    
    public init(input: [Double], label: [Double]) {
        self.input = Vector(input)
        self.label = Vector(label)
    }
    
}
