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

var inputFilenameNoExtension = ""

var makeCPPWrapper = false
var makeSwiftWrapper = false
var foundFilename = false

var input: [String] = Process.arguments
input.removeAtIndex(0)      //remove the program name

//inputFileName = input[0]

for argument in input {
    switch argument {
        case "c", "-c":
            print("Generating a C++ wrapper")
            makeCPPWrapper = true;

        case "s", "-s":
            print("Generating a Swift wrapper")
            makeSwiftWrapper = true;
        
        case "cs", "sc", "-cs", "-sc":
            makeCPPWrapper = true
            makeSwiftWrapper = true
            print("Generating both C++ and Swift wrappers");
        
        case "usage", "-usage":
            print(" USAGE.... ");

        default:
            
            // is this argument a filename?
            let nameWithoutExtension = argument.characters.split {$0 == "."}.map { String($0) }
        
            if nameWithoutExtension.count == 2 {   // have found an extension
                
                if nameWithoutExtension[1] == "txt" && !foundFilename {
                    
                    inputFilenameNoExtension = nameWithoutExtension[0]
                    foundFilename = true
                    //print("Filename is : \(inputFilenameNoExtension).txt ")
                }
                else {
                    print("Unknown file type or too many files specified. USAGE...")
                    exit(EXIT_FAILURE)
                }
            }
            else {
                print("Unknown argument. USAGE...")
                exit(EXIT_FAILURE)
            }
    }
}


// If neither wrapper is specified, make both
if !makeCPPWrapper && !makeSwiftWrapper {
    
    makeCPPWrapper = true
    makeSwiftWrapper = true
    print("Generating both C++ and Swift wrappers")
}


/*
let args = Process.arguments

println("This program is named \(args[0]).")
println("There are \(args.count-1) arguments.")

for i in 1..<args.count {
    println("the argument #\(i) is \(args[i])")
}
*/



var data = ClassData(inputFilenameNoExtension: inputFilenameNoExtension)

// print("wb: \(data.wb)")
// print("camel: \(data.camel)")
// print("caps: \(data.caps)")

var inputText = readVariables(data.workingDirectory + data.inputFilename)
parseInput(inputText)

generateWBFile(data)

if makeCPPWrapper {
    generateCPPFile(data)
}







