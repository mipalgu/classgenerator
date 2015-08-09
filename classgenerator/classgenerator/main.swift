#!/usr/bin/env xcrun swift

// Make executable ($ chmod +x main.swift)
//
//  main.swift
//  classgenerator
//
//  Created by Mick Hawkins on 9/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Foundation


var input = [String]()
var fileName : String!

for argument in Process.arguments
{
    input.append("\(argument)")
}

input.removeAtIndex(0)  //remove the program name

for argument in input
{
    switch argument
    {
    case "a":
        println("a argument");
        
    case "b":
        println("b argument");
        
    default:
        fileName = argument
    }
}



var varTypes = [String]()
var varNames = [String]()


func parseFile(fileText: String) -> Void
{
    var lines =  fileText.componentsSeparatedByString("\n")

    for line in lines
    {
        var variable = line.componentsSeparatedByString("\t")
        
        varTypes.append(variable[0])
        varNames.append(variable[1])
    }
    
    for var i = 0; i < varTypes.count; i++
    {
        println( "\(varNames[i]) is a \(varTypes[i])")
    }
}



let filemgr = NSFileManager.defaultManager()
let filepath1 = "/Users/mick/src/MiPal/GUNao/posix/classgenerator/classgenerator/" + fileName

if filemgr.fileExistsAtPath(filepath1)
{
    println("File exists")
}
else
{
    println("File not found")
}


if filemgr.isWritableFileAtPath(filepath1)
{
    println("File is writable")
}
else
{
    println("File is read-only")
}


let file: NSFileHandle? = NSFileHandle(forReadingAtPath: filepath1)

if file == nil
{
    println("File open failed")
}
else
{
    let fileText = String(contentsOfFile: filepath1, encoding: NSUTF8StringEncoding, error: nil)
    parseFile(fileText!)
    file?.closeFile()
}


