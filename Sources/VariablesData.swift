//
//  VariablesData.swift
//  classgenerator
//
//  Created by Mick Hawkins on 26/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//
//  VariablesData.swift contains a dictionary which stores information about the available data types
//


struct varData {
    
    let defaultValue : String
    let length : Int       // maximum number of characters in a string of this type
    let macro : String     // the whiteboard macro
    let format : String    // format specifier to use
    let converter: String  // how to convert from a string to this type
    let swift: String      // the equivalent Swift data type
    let swiftDefaultValue: String?

    var swiftValue: String {
        guard let v = self.swiftDefaultValue else {
            return self.defaultValue
        }
        return v
    }

    init(
        defaultValue: String,
        length: Int,
        macro: String,
        format: String,
        converter: String,
        swift: String,
        swiftDefaultValue: String? = nil
    ) {
        self.defaultValue = defaultValue
        self.length = length
        self.macro = macro
        self.format = format
        self.converter = converter
        self.swift = swift
        self.swiftDefaultValue = swiftDefaultValue
    }

}

// A dictionary of the varible types
let variables = [

    "string": varData(defaultValue: "", length: 0,  macro: "PROPERTY", format: "%s", converter: "", swift: "String"),
    
    "bool": varData(defaultValue: "false", length: 5,  macro: "PROPERTY", format: "", converter: "", swift: "Bool"),
    
    "char":          varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c", converter: "atoi", swift: "String"),
    "signed char":   varData(defaultValue: "0", length: 2, macro: "PROPERTY", format: "%c", converter: "atoi", swift: "String"),
    "unsigned char": varData(defaultValue: "0", length: 1, macro: "PROPERTY", format: "%c", converter: "atoi", swift: "String"),
    
    "int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int"),
    "signed":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int"),
    "signed int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int"),
    "unsigned":     varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt"),
    "unsigned int": varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt"),
    
    "int8_t":   varData(defaultValue: "0", length: 4,  macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int8"),
    "uint8_t":  varData(defaultValue: "0", length: 3,  macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt8"),
    "int16_t":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int16"),
    "uint16_t": varData(defaultValue: "0", length: 5,  macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt16"),
    "int32_t":  varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int32"),
    "uint32_t": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt32"),
    "int64_t":  varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%d", converter: "atoi", swift: "Int64"),
    "uint64_t": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt64"),
    
    "short":             varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi", swift: "Int16"),
    "short int":         varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi", swift: "Int16"),
    "signed short":      varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi", swift: "Int16"),
    "signed short int":  varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%i", converter: "atoi", swift: "Int16"),
    "unsigned short":    varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt16"),
    "unsigned short int":varData(defaultValue: "0", length: 6,  macro: "PROPERTY", format: "%u", converter: "atoi", swift: "UInt16"),
    
    "long":              varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol", swift: "Int32"),
    "long int":          varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol", swift: "Int32"),
    "signed long":       varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol", swift: "Int32"),
    "signed long int":   varData(defaultValue: "0", length: 11, macro: "PROPERTY", format: "%ld", converter: "atol", swift: "Int32"),
    "unsigned long":     varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu", converter: "atol", swift: "UInt32"),
    "unsigned long int": varData(defaultValue: "0", length: 10, macro: "PROPERTY", format: "%lu", converter: "atol", swift: "UInt32"),
    
    "long long":              varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll", swift: "Int64"),
    "long long int":          varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll", swift: "Int64"),
    "signed long long":       varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll", swift: "Int64"),
    "signed long long int":   varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll", swift: "Int64"),
    "unsigned long long":     varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu", converter: "atoll", swift: "UInt64"),
    "unsigned long long int": varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%llu", converter: "atoll", swift: "UInt64"),
    "long64_t":               varData(defaultValue: "0", length: 20, macro: "PROPERTY", format: "%lld", converter: "atoll", swift: "Int64"),
    
    "float":   varData(defaultValue: "0.0f", length: 64, macro: "PROPERTY", format: "%f", converter: "atof", swift: "Float", swiftDefaultValue: "0.0"),
    "float_t": varData(defaultValue: "0.0f", length: 64, macro: "PROPERTY", format: "%f", converter: "atof", swift: "Float", swiftDefaultValue: "0.0"),
    
    "double":   varData(defaultValue: "0.0", length: 64, macro: "PROPERTY", format: "%lf", converter: "atof", swift: "Double"),
    "double_t": varData(defaultValue: "0.0", length: 64, macro: "PROPERTY", format: "%lf", converter: "atof", swift: "Double"),
    
    "long double":   varData(defaultValue: "0.0", length: 80, macro: "PROPERTY", format: "%Lf", converter: "atof", swift: "Float80"),
    "double double": varData(defaultValue: "0.0", length: 80, macro: "PROPERTY", format: "%Lf", converter: "atof", swift: "Float80")
]

