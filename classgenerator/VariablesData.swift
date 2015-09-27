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
    let converter: String
}


// Are complex types needed?
let variables = [

    "bool": varData(defaultValue: "false", length: 5,  macro: "PROPERTY", format: "", converter: ""),
    
    "char":          varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c", converter: "atoi"),
    "signed char":   varData(defaultValue: "0", length: 2, macro: "PROPERTY", format: "%c", converter: "atoi"),
    "unsigned char": varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c", converter: "atoi"),
    
    "int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi"),
    "signed":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi"),
    "signed int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi"),
    "unsigned":     varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u", converter: "atoi"),
    "unsigned int": varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u", converter: "atoi"),
    
    "int8_t":   varData(defaultValue: "0", length: 4,  macro: "PROPERTY", format: "%d", converter: "atoi"),
    "uint8_t":  varData(defaultValue: "0", length: 3,  macro: "PROPERTY", format: "%u", converter: "atoi"),
    "int16_t":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%d", converter: "atoi"),
    "uint16_t": varData(defaultValue: "0", length: 5,  macro: "PROPERTY", format: "%u", converter: "atoi"),
    "int32_t":  varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi"),
    "uint32_t": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%u", converter: "atoi"),
    "int64_t":  varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%d", converter: "atoi"),
    "uint64_t": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%u", converter: "atoi"),
    
    "short":             varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi"),
    "short int":         varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi"),
    "signed short":      varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi"),
    "signed short int":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi"),
    "unsigned short":    varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u", converter: "atoi"),
    "unsigned short int":varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u", converter: "atoi"),
    
    "long":              varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol"),
    "long int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol"),
    "signed long":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol"),
    "signed long int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol"),
    "unsigned long":     varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu", converter: "atol"),
    "unsigned long int": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu", converter: "atol"),
    
    "long long":              varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll" ),
    "long long int":          varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll"),
    "signed long long":       varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll"),
    "signed long long int":   varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll"),
    "unsigned long long":     varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu", converter: "atoll"),
    "unsigned long long int": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu", converter: "atoll"),
    "long64_t":               varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll"),
    
    "float":   varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%f", converter: "atof"),    // length ???
    "float_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%f", converter: "atof"),
    
    "double":   varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%lf", converter: "atof"),   // length ???
    "double_t": varData(defaultValue: "0", length: 64, macro: "PROPERTY", format: "%lf", converter: "atof"),
    
    "long double":   varData(defaultValue: "0", length: 80, macro: "PROPERTY", format: "%Lf", converter: "atof"), // length ???
    "double double": varData(defaultValue: "0", length: 80, macro: "PROPERTY", format: "%Lf", converter: "atof")
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