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

if input.count == 0 {
    
    print("File not specified as an argument. USAGE...")
    exit(EXIT_FAILURE)
}


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
            print(" USAGE.... ")
            exit(EXIT_FAILURE);

        default:
            // is this argument a filename?
            let nameWithoutExtension = argument.characters.split {$0 == "."}.map { String($0) }
        
            if nameWithoutExtension.count == 2 {   // have found an extension
                
                if nameWithoutExtension[1] == "txt" && !foundFilename {
                    
                    inputFilenameNoExtension = nameWithoutExtension[0]
                    foundFilename = true
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

// get current working path
var cwd: [Int8] = Array(count: Int(MAXPATHLEN), repeatedValue: 0)
let path = getcwd(&cwd, Int(MAXPATHLEN))
let workingDirectory = String.fromCString(path)! + "/"

// get the text from the input file
var inputText = readVariables(workingDirectory + inputFilenameNoExtension + ".txt")

// return the user name from the inut file
var userName = parseInput(inputText)

var data = ClassData(workingDirectory: workingDirectory, inputFilenameNoExtension: inputFilenameNoExtension, userName: userName)

generateWBFile(data)

if makeCPPWrapper {
    generateCPPFile(data)
}






