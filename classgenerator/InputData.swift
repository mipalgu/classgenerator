//
//  InputData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 28/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

import Darwin

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



func getUserName() -> String {
    
    let pw = getpwuid(getuid())
    
    if pw != nil {
        return String.fromCString(pw.memory.pw_name)!
    }
    else {
        return "YOUR NAME"
    }
}