//
//  InputData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 28/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//


struct inputVariable{
    
    var varType : String
    var varName : String
    var varDefault : String
    var varArraySize : Int
    
    init(varType: String, varName: String, varDefault: String, varArraySize : Int) {
        
        self.varType = varType
        self.varName = varName
        self.varDefault = varDefault
        self.varArraySize = varArraySize
    }
}

var inputData : [inputVariable] = []