//
//  Auxiliary.swift
//  Swift-Learn
//
//  Created by Disi A on 1/16/17.
//  Copyright © 2017 Votebin. All rights reserved.
//

import Foundation


// Innovation classes
struct InnovationKey{
    
    public let input: Int
    public let output: Int
}

func ==(lhs: InnovationKey, rhs: InnovationKey) -> Bool {
    return lhs.input == rhs.input && lhs.output == rhs.output
}

extension InnovationKey: Hashable {
    
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    
    public var hashValue: Int {
        return self.input.hashValue ^ self.output.hashValue
    }
}
