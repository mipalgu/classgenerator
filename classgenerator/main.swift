//#!/usr/bin/env xcrun swift

//
//  main.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif



// Get input filename from command line args
var inputFilenameNoExtension = ""

var makeCPPWrapper = false
var makeSwiftWrapper = false
var foundFilename = false
  
var input: [String] = Process.arguments
input.remove(at: 0)      //remove the program name

if input.count == 0 {
    
    print("Filename was not specified as an argument.")
    print("Usage is: classgenerator filename.txt [cs]")
    print("Please see the user manual for more information.")
    exit(EXIT_FAILURE)
}

// check args
// find filename
for argument in input {
    switch argument {
        case "c", "-c":
            makeCPPWrapper = true;

        case "s", "-s":
            makeSwiftWrapper = true;
        
        case "cs", "sc", "-cs", "-sc":
            makeCPPWrapper = true
            makeSwiftWrapper = true
        
        case "usage", "-usage":
            print("Usage is: classgenerator filename.txt [cs]")
            print("Please see the user manual for more information.")
            exit(EXIT_FAILURE);

        default:
            // check, is this argument a filename?
            let nameWithoutExtension = argument.characters.split {$0 == "."}.map { String($0) }
        
            if nameWithoutExtension.count == 2 {   // have found an extension
                
                if nameWithoutExtension[1] == "txt" && !foundFilename {
                    
                    inputFilenameNoExtension = nameWithoutExtension[0]
                    foundFilename = true
                }
                else {
                    print("Unknown file type or too many files specified.")
                    print("Usage is: classgenerator filename.txt [cs]")
                    print("Please see the user manual for more information.")
                    exit(EXIT_FAILURE)
                }
            }
            else {
                print("Unknown argument.")
                print("Usage is: classgenerator filename.txt [cs]")
                print("Please see the user manual for more information.")
                exit(EXIT_FAILURE)
            }
    }
}

/*
// If neither wrapper is specified...
if !makeCPPWrapper && !makeSwiftWrapper {
    
    //makeCPPWrapper = true
    //makeSwiftWrapper = true
    print("No wrappers requested.")
}
*/

// get current working path
var cwd: [Int8] = Array(repeating: 0, count: Int(PATH_MAX))
let path = getcwd(&cwd, Int(PATH_MAX))
let workingDirectory = String(validatingUTF8: path)! + "/"

// get the text from the input file
var inputText = readVariables(workingDirectory + inputFilenameNoExtension + ".txt")

// return the user name from the inut file
var userName = parseInput(inputText)

// determine information about the class to be generated
var data = ClassData(workingDirectory: workingDirectory, inputFilenameNoExtension: inputFilenameNoExtension, userName: userName)

// generate the WB files
print("\nGenerating WB files...")
generateWBFiles(data)


// generate the c++ wrapper
if makeCPPWrapper {
    print("\nGenerating C++ wrapper...")
    generateCPPFile(data)
}

// generate the Swift wrapper
if makeSwiftWrapper {
    print("\nGenerating Swift wrapper and Bridging Header...")
    print("\nNote: The Swift wrapper is in progress.")
    generateSwiftFiles(data)
}

print("\nFiles have been created.")


