//#!/usr/bin/env xcrun swift

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

var makeCPPWrapper = false
var makeSwiftWrapper = false
var foundFilename = false

var input = [String](Process.arguments)
input.removeAtIndex(0)      //remove the program name

//inputFileName = input[0]

for argument in input {
    switch argument {
        case "c":
            print("make a c++ wrapper")
            makeCPPWrapper = true;

        case "s":
            print("make a swift wrapper")
            makeSwiftWrapper = true;

        default:
            
            
            // is this argument a filename?
            let nameWithoutExtension = argument.characters.split {$0 == "."}.map { String($0) }
        
            if nameWithoutExtension[1] == "txt" && !foundFilename {
                
                inputFileName = argument //nameWithoutExtension[0]
                foundFilename = true
            }
            else {
                print("Unknown argument. USAGE...")
                exit(EXIT_FAILURE)
            }
        
    }
}

// If neither are specified, make both
if !makeCPPWrapper && !makeSwiftWrapper {
    
    makeCPPWrapper = true
    makeSwiftWrapper = true
}


/*
let args = Process.arguments

println("This program is named \(args[0]).")
println("There are \(args.count-1) arguments.")

for i in 1..<args.count {
    println("the argument #\(i) is \(args[i])")
}
*/



var data = ClassData(inputFilename: inputFileName)

// print("wb: \(data.wb)")
// print("camel: \(data.camel)")
// print("caps: \(data.caps)")

var inputText = readVariables(data.workingDirectory + inputFileName)
parseInput(inputText)

generateWBFile(data)

if makeCPPWrapper {
    generateCPPFile(data)
}







