//
//  VariablesData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 26/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

struct varData {
    
    let defaultValue : String
    let length : Int
    let macro : String
}


// Are complex types needed?
let variables = [

    "bool": varData(defaultValue: "false", length: 5,  macro: "PROPERTY"),
    
    "char":          varData(defaultValue: "0", length: 1, macro: "PROPERTY"),
    "signed char":   varData(defaultValue: "0", length: 2, macro: "PROPERTY"),
    "unsigned char": varData(defaultValue: "0", length: 1, macro: "PROPERTY"),
    
    "int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "signed":       varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "signed int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "unsigned":     varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "unsigned int": varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    
    "int8_t":   varData(defaultValue: "0", length: 4,  macro: "PROPERTY"),
    "uint8_t":  varData(defaultValue: "0", length: 3,  macro: "PROPERTY"),
    "int16_t":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "uint16_t": varData(defaultValue: "0", length: 5,  macro: "PROPERTY"),
    "int32_t":  varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "uint32_t": varData(defaultValue: "0", length: 10, macro: "PROPERTY"),
    "int64_t":  varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "uint64_t": varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    
    "short":             varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "short int":         varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "signed short":      varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "signed short int":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "unsigned short":    varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    "unsigned short int":varData(defaultValue: "0", length: 6,  macro: "PROPERTY"),
    
    "long":              varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "long int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "signed long":       varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "signed long int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY"),
    "unsigned long":     varData(defaultValue: "0", length: 10, macro: "PROPERTY"),
    "unsigned long int": varData(defaultValue: "0", length: 10, macro: "PROPERTY"),
    
    "long long":              varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "long long int":          varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "signed long long":       varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "signed long long int":   varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "unsigned long long":     varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "unsigned long long int": varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    "long64_t":               varData(defaultValue: "0", length: 20, macro: "PROPERTY"),
    
    "float":   varData(defaultValue: "0", length: 64, macro: "PROPERTY"),    // length ???
    "float_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY"),
    
    "double":   varData(defaultValue: "0", length: 64, macro: "PROPERTY"),   // length ???
    "double_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY"),
    
    "long double":   varData(defaultValue: "0", length: 80, macro: "PROPERTY"), // length ???
    "double double": varData(defaultValue: "0", length: 80, macro: "PROPERTY")
]



/*

struct Person {
let age = 0
}

let people = ["tom": Person(age: 12), "dick": Person(age: 7), "harry": Person(age: 50)]

var people_array = [Person](people.values)  //convert to array
people_array.sort({ $0.age > $1.age })      //sort the array


people_array[0].age // 50
people_array[1].age // 12
people_array[2].age // 7

*/