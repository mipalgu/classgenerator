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
var inputFileName = ""

var input = [String](Process.arguments)

input.removeAtIndex(0)  //remove the program name

for argument in input {
    switch argument {
        case "a":
            print("a argument");

        case "b":
            print("b argument");

        default:
            inputFileName = input[0]
    }
}


var data = ClassData(inputFilename: inputFileName)

print("wb: \(data.wb)")
print("camel: \(data.camel)")
print("caps: \(data.caps)")

var inputText = readVariables(data.workingDirectory + inputFileName)
parseInput(inputText)

generateWBFile(data)
generateCPPFile(data)






