#!/usr/bin/env xcrun swift

//
//  main.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin
import Foundation

var input = [String]()
var inputFileName : String!

//var cwd : UnsafeMutablePointer<Int8>
//let workingDirectory = getcwd(&cwd, UInt(MAXNAMLEN))

let workingDirectory = "/Users/mick/src/MiPal/GUNao/posix/classgenerator/classgenerator/"

//let fileMgr = NSFileManager.defaultManager()
//let workingDirectory = fileMgr.currentDirectoryPath

var varTypes = [String]()
var varNames = [String]()

/*
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

func parseInput(inputText: String) -> Void {
    
    var lines = inputText.componentsSeparatedByString("\n")
    
    // check for case where the file had a return/s at the end or between lines

    for var i = 0; i < lines.count; i++ {
        if lines[i] == "" {
            lines.removeAtIndex(i)
        }
    }
    
    for line in lines {
        
        var variable = line.componentsSeparatedByString("\t")
        
        varTypes.append(variable[0])
        varNames.append(variable[1])
    }
    
    for var i = 0; i < varTypes.count; i++ {
        println( "\(varNames[i]) is a \(varTypes[i])")
    }
    
 //   var username = NSUserName()!
 //   println("Hello \(username)")
    
}


inputFileName = workingDirectory + "mybutton.txt"

var inputText = readVariables(inputFileName)
parseInput(inputText)

generateC("mybutton.txt", workingDirectory)


/*
func generateC() -> Void {
    var fileNameParts = inputFileName.componentsSeparatedByString(".")
    var structName = "wb_" + fileNameParts[0]  // just need the first part
    
    println(structName)
    
    var cFilePath : CChar = currentPath + "/" + structName + ".h"
    
    openFileForWrite(cFilePath)
    var text = "This is a test"
    text.writeToFile(cFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil);
    closeCurrentFile()
}
*/




