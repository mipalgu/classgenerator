//
//  Wrapper.swift
//  classgenerator
//
//  Created by Mick Hawkins on 28/10/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

#include bridging header


// public class ArrayTest : wb_array_test { }


extension wb_array_test {
    
    convenience init () {
        self.pressed = false
        self.array16 = {1,2,3,4}
        self.bools = {false,false,false}
    }
}

extension wb_array_test : CustomStringConvertible {
    
    var description: String {
        return "   "
    }
    
    var toString: String {
        
        return "  "
    }
    
}


