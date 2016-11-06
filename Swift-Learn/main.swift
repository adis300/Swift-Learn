//
//  main.swift
//  Swift-Learn
//
//  Created by Disi A on 11/5/16.
//  Copyright © 2016 Votebin. All rights reserved.
//

import Foundation

print("Test framework here!")

var vec = zeros(length: 6)

vec[2...5] = [-6.0,7.0,6,8]

print("Original: vector")
print(vec)

print("Square sum:")
print(vec.sumSq())

print("Mean:")
print(vec.mean())
