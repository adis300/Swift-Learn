//
//  DateSet.swift
//  Swift-Learn
//
//  Created by Disi A on 11/19/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

class LabeledData{
    
    let input: Vector<Double>
    let label: Vector<Double>
    
    init(input: Vector<Double>, label: Vector<Double>) {
        self.input = input
        self.label = label
    }
    
    init(input: [Double], label: [Double]) {
        self.input = Vector(input)
        self.label = Vector(label)
    }
    
}
