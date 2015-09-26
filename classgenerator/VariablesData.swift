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
    let format : String    // format specifier to use
}


// Are complex types needed?
let variables = [

    "bool": varData(defaultValue: "false", length: 5,  macro: "PROPERTY", format: ""),
    
    "char":          varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c"),
    "signed char":   varData(defaultValue: "0", length: 2, macro: "PROPERTY", format: "%c"),
    "unsigned char": varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c"),
    
    "int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d"),
    "signed":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d"),
    "signed int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d"),
    "unsigned":     varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u"),
    "unsigned int": varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u"),
    
    "int8_t":   varData(defaultValue: "0", length: 4,  macro: "PROPERTY", format: "%d"),
    "uint8_t":  varData(defaultValue: "0", length: 3,  macro: "PROPERTY", format: "%u"),
    "int16_t":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%d"),
    "uint16_t": varData(defaultValue: "0", length: 5,  macro: "PROPERTY", format: "%u"),
    "int32_t":  varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d"),
    "uint32_t": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%u"),
    "int64_t":  varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%d"),
    "uint64_t": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%u"),
    
    "short":             varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i"),
    "short int":         varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i"),
    "signed short":      varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i"),
    "signed short int":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i"),
    "unsigned short":    varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u"),
    "unsigned short int":varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u"),
    
    "long":              varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld"),
    "long int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld"),
    "signed long":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld"),
    "signed long int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld"),
    "unsigned long":     varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu"),
    "unsigned long int": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu"),
    
    "long long":              varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld"),
    "long long int":          varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld"),
    "signed long long":       varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld"),
    "signed long long int":   varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld"),
    "unsigned long long":     varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu"),
    "unsigned long long int": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu"),
    "long64_t":               varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld"),
    
    "float":   varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%f"),    // length ???
    "float_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%f"),
    
    "double":   varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%lf"),   // length ???
    "double_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%lf"),
    
    "long double":   varData(defaultValue: "0", length: 80, macro: "PROPERTY", format: "%Lf"), // length ???
    "double double": varData(defaultValue: "0", length: 80, macro: "PROPERTY", format: "%Lf")
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