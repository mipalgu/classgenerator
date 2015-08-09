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


let fileMgr = NSFileManager.defaultManager()
let currentPath = fileMgr.currentDirectoryPath

var input = [String]()
var inputFileName : String!

var varTypes = [String]()
var varNames = [String]()

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
        inputFileName = argument   // will need to test
    }
}


func parseInput(inputText: String) -> Void
{
    var lines =  inputText.componentsSeparatedByString("\n")

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
    
    var username = NSUserName()!
    println("Hello \(username)")

}


func generateC() -> Void
{
    var fileNameParts = inputFileName.componentsSeparatedByString(".")
    var structName = "wb_" + fileNameParts[0]  // just need the first part
    
    


}


/*
    class func write (path: String, content: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool 
    {
        return content.writeToFile(path, atomically: true, encoding: encoding, error: nil)
    }


    text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
*/




let inputFilePath = currentPath + "/" + inputFileName


if fileMgr.fileExistsAtPath(inputFilePath)
{
    println("File exists")
}
else
{
    println("File not found")
}


if fileMgr.isWritableFileAtPath(inputFilePath)
{
    println("File is writable")
}
else
{
    println("File is read-only")
}


let file: NSFileHandle? = NSFileHandle(forReadingAtPath: inputFilePath)

if file == nil
{
    println("File open failed")
}
else
{
    let inputText = String(contentsOfFile: inputFilePath, encoding: NSUTF8StringEncoding, error: nil)
    parseInput(inputText!)
    
    file?.closeFile()
}


