//
//  InputData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 28/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//
//  This struct stores the properties of the input variables
//

import Darwin

struct inputVariable{
    
    var varType : String
    var varName : String
    var varDefault : String
    var varComment : String
    var varArraySize : Int
    
    
    init(varType: String, varName: String, varDefault: String, varComment: String, varArraySize : Int) {
        
        self.varType = varType
        self.varName = varName
        self.varDefault = varDefault
        self.varComment = varComment
        self.varArraySize = varArraySize
    }
}

/// the variables to be used are stored in an array
var inputData : [inputVariable] = []



