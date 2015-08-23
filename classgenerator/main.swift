#!/usr/bin/env xcrun swift

//
//  main.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin

/**
 * Get input filename from command line args
 */

// for now, set command line arg manually
var inputFile = "my_button.txt"

/*
var input = [String]()

for argument in Process.arguments {
    input.append("\(argument)")
}

input.removeAtIndex(0)  //remove the program name

for argument in input {
    switch argument {
        case "a":
            println("a argument");

        case "b":
            println("b argument");

        default:
            inputFileName = workingDirectory + argument   // will need to test
    }
}
*/

var data = ClassData(inputFilename: inputFile)

println("wb: \(data.wb)")
println("camel: \(data.camel)")
println("caps: \(data.caps)")

var inputText = readVariables(data.workingDirectory + inputFile)
parseInput(inputText)

generateWBFile(data)
generateCPPFile(data)






