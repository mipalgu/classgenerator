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
    
    init(varType: String, varName: String, varDefault: String) {
        
        self.varType = varType
        self.varName = varName
        self.varDefault = varDefault
    }
}

var inputData : [inputVariable] = []