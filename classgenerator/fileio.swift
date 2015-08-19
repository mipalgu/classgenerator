//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin
import Foundation

let fileSize = 4096

func closeFileStream(fileStream: UnsafeMutablePointer<FILE>) -> Void {
    
    if (fclose(fileStream) != 0) {
        println("Unable to close file\n")
        exit(EXIT_FAILURE)
    }
}


func readVariables(inputFileName: String) -> String {

    // open a filestream for reading
    var fs : UnsafeMutablePointer<FILE> = fopen( inputFileName, "r" )

    if fs == nil {
        // file did not open
        println("HERE: \(inputFileName) : No such file or directory\n")
        exit(EXIT_FAILURE)
    }

    // read from the opened file
    // then close the stream
    
    var line = UnsafeMutablePointer<Int8>.alloc(fileSize)  /// ***** size of file as const?
    var variables = [String]()
    
    
    //while Int32(line.memory) != EOF {
        // check for errors while reading
        

        if (ferror(fs) != 0) {
    
            println("Unable to read");
            exit(EXIT_FAILURE);
        }
        
        //fgets(line, MAXNAMLEN, fs)
        fread(line, fileSize, 1, fs)       /// ***** size of file as const?
    
        let variable = String.fromCString(line)
    //}
    
    closeFileStream(fs)
    line.destroy()
    
    return variable! // variables

}



func generateC(inputFileName: String, workingDirectory: String) -> Void {
    
    var fileNameParts = inputFileName.componentsSeparatedByString(".")
    var structName = "wb_" + fileNameParts[0]  // just need the first part

    println(structName)

    var cFilePath : String = workingDirectory + "/" + structName + ".h"

    // open a filestream for reading
    var fs : UnsafeMutablePointer<FILE> = fopen( cFilePath, "w" )
    
    if fs == nil {
        // file did not open
        println("HERE: \(inputFileName) : No such file or directory\n")
        exit(EXIT_FAILURE)
    }
    
    var text = "This is a test"
   
    fputs( text, fs )

    
    closeFileStream(fs)
}


