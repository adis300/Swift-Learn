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
    
    public init(input: [Double], label: Int, labelSize: Int) {
        precondition(labelSize > label, "Cannot create label out of range")
        var labels = [Double](repeating: 0, count: labelSize)
        if label >= 0{
            labels[label] = 1.0
        } // else create all 0 passive labels
        
        self.input = Vector(input)
        self.label = Vector(labels)
    }
    
}
