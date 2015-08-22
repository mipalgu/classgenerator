//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin

let fileSize = 4096               /// find a way to get EOF to work so I dont need to do this

var varTypes = [String]()
var varNames = [String]()


func parseInput(inputText: String) -> Void {
    
    var lines = split(inputText) {$0 == "\n"}
    
    // check for case where the file had a return/s at the end or between lines
    // counting backwards so not to change indexes
    let numberOfLines = lines.count
    for var i = numberOfLines-1; i >= 0; i-- {
        if lines[i] == "" {
            lines.removeAtIndex(i)
        }
    }
    
    for line in lines {
        
        var variable = split(line) {$0 == "\t"}
        
        varTypes.append(variable[0])               // these parallel arrays arent going to cut it
        varNames.append(variable[1])
    }
    
    for var i = 0; i < varTypes.count; i++ {
        println( "\(varNames[i]) is a \(varTypes[i])")
    }
    
    //   var username = NSUserName()!
    //   println("Hello \(username)")
    
}



func setDefault(varType: String) -> String {
    
    var defaultValue : String
    
    switch varType {
        case "bool":
            defaultValue = "false"
            
        case "int", "int8_t", "uint8_t", "int16_t", "uint16_t", "int32_t", "uint32_t":
            defaultValue = "0"
            
        default:
            defaultValue = "ADD DEFAULT"
    }
    
    return defaultValue
}



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
    
    
    //while Int32(line.memory) != EOF {          /// cant get EOF to work!!!!
    // check for errors while reading
    
    
    if (ferror(fs) != 0) {
        
        println("Unable to read");
        exit(EXIT_FAILURE);
    }
    
    //fgets(line, MAXNAMLEN, fs)
    fread(line, fileSize, 1, fs)       /// ***** size of file as const? declared above.  
    
    let variable = String.fromCString(line)
    //}
    
    closeFileStream(fs)
    line.destroy()
    
    return variable! // variables
    
}




func generateTopComment(structName: String) -> String {
    
    var comment = "/** \n" +
        " *  /file \(structName).h \n" +
        " * \n" +
        " *  Created by YOUR NAME in YEAR. \n" +    // generate NAME and YEAR
        " *  Copyright (c) YEAR YOUR NAME. \n" +     // generate NAME and YEAR
        " *  All rights reserved. \n" +
        " */ \n\n" +
        
        "#ifndef \(structName)_h \n" +
        "#define \(structName)_h \n\n" +
        
        "#include <gu_util.h> \n\n\n"
    
    return comment
}

func generateCStruct(structName: String) -> String {
    
    var cStruct = "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(structName)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(structName) \n" +
        "{ \n"
    
    
    /// ADD LICENSE INFO HERE
    
    
    for i in 0...varTypes.count-1 {
        
        cStruct += "\t/** \(varNames[i]) COMMENT ON PROPERTY */ \n" +
        "\tPROPERTY(\(varTypes[i]), \(varNames[i]))\n\n"
    }
        
        cStruct += "#ifdef __cplusplus \n\n" +
        
        "\t/** Default constructor */ \n" +
         "\t\(structName)() : "
            
    for i in 0...varTypes.count-1 {
        
        var defaultValue = setDefault(varTypes[i])
        
        cStruct += "_\(varNames[i])(\(defaultValue))"
        
        if i < varTypes.count-1 {
            cStruct += ", "
        }
    }
            
        cStruct += "  {} \n\n" +
        
        "\t/** Copy Constructor */ \n" +
        "\t\(structName)(const  \(structName) &other) : \n"
    
    
    for i in 0...varTypes.count-1 {
    
        cStruct += "\t\t_\(varNames[i])(other._\(varNames[i]))"
        
        if i < varTypes.count-1 {
            cStruct += ", \n"
        }
    }
            
        cStruct += "  {} \n\n" +
        
        "\t/** Assignment Operator */ \n" +
        "\t\(structName) &operator= (const \(structName) &other) { \n"
    
    
    for i in 0...varTypes.count-1 {
        
        cStruct += "\t\t_\(varNames[i]) = other._\(varNames[i]); \n"
    }
    
        cStruct += "\t\treturn *this; \n" +
        "\t} \n" +
        "#endif \n\n" +
        
        "};\n" +
        "#endif //\(structName)_h \n"
    
    
    return cStruct
}



func generateC(filename: Filename) -> Void {

    var cFilePath = filename.workingDirectory + "/" + filename.wb + ".h"
    
    // open a filestream for reading
    var fs : UnsafeMutablePointer<FILE> = fopen( cFilePath, "w" )
    
    if fs == nil {
        // file did not open
        println("\(filename.wb).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    var text = generateTopComment(filename.wb) + generateCStruct(filename.wb)
    
    fputs( text, fs )    /// perhaps use multiple fputs statements instead
    
    closeFileStream(fs)
}



