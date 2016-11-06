//
//  main.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

print("Test framework here!")

var vec = Vector(length: 20)

vec[5...9] = [6.0,7.0,6,8,3]

print("Sum")
print(vec.sum())

print("Mean:")
print(vec.mean())
