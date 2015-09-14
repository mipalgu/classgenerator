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
    
    var lines = inputText.characters.split {$0 == "\n"}.map { String($0) }
    
    // check for case where the file had a return/s at the end or between lines
    // counting backwards so not to change indexes
    let numberOfLines = lines.count
    for var i = numberOfLines-1; i >= 0; i-- {
        if lines[i] == "" {
            lines.removeAtIndex(i)
        }
    }
    
    for line in lines {
        
        var variable = line.characters.split {$0 == "\t"}.map { String($0) }
        
        varTypes.append(variable[0])               // these parallel arrays arent going to cut it
        varNames.append(variable[1])
    }
    
    for var i = 0; i < varTypes.count; i++ {
        print( "\(varNames[i]) is a \(varTypes[i])")
    }
    
    //   var username = NSUserName()!
    //   println("Hello \(username)")
    
}


func setDefault(varType: String) -> String {
    
    var defaultValue : String
    
    switch varType {
        case "bool":
            defaultValue = "false"
            
        case "int", "int8_t", "uint8_t", "int16_t", "uint16_t", "int32_t", "uint32_t", "int64_t", "uint64_t":
            defaultValue = "0"
            
        default:
            defaultValue = "ADD DEFAULT"
    }
    
    return defaultValue
}



func closeFileStream(fileStream: UnsafeMutablePointer<FILE>) -> Void {
    
    if (fclose(fileStream) != 0) {
        print("Unable to close file\n")
        exit(EXIT_FAILURE)
    }
}



func readVariables(inputFileName: String) -> String {
    
    // open a filestream for reading
    let fs : UnsafeMutablePointer<FILE> = fopen( inputFileName, "r" )
    
    if fs == nil {
        // file did not open
        print("HERE: \(inputFileName) : No such file or directory\n")
        exit(EXIT_FAILURE)
    }
    
    // read from the opened file
    // then close the stream
    
    let line = UnsafeMutablePointer<Int8>.alloc(fileSize)  /// ***** size of file as const?
    // var variables = [String]()
    
    
    //while Int32(line.memory) != EOF {          /// cant get EOF to work!!!!
    // check for errors while reading
    
    
    if (ferror(fs) != 0) {
        
        print("Unable to read");
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




func generateCStruct(data: ClassData) -> String {
    
    var cStruct1 = "#ifndef \(data.wb)_h \n" +
        
        "#define \(data.wb)_h \n\n" +
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n" +
        "#include <gu_util.h> \n" +
        "#include <stdio.h> \n" +
        "#include <string.h> \n" +
        "#include <stdlib.h> \n\n" +
        
        "#define NUMBER_OF_VARIABLES \(varNames.count) \n\n" +
    
        "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(data.wb)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(data.wb) \n" +
        "{ \n"
    
    for i in 0...varTypes.count-1 {
        
        cStruct1 += "\t/** \(varNames[i]) COMMENT ON PROPERTY */ \n" +
        "\tPROPERTY(\(varTypes[i]), \(varNames[i]))\n\n"
    }
    
    
    cStruct1 += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    // create description() method
    cStruct1 += "\t/** convert to a description string */  \n" +
        "\tchar* description() {\n" +
        "\t\tchar descString[0] = '\\0'; \n" +
        "\t\tchar buffer[20]; \n"

    var first = true
        
    for i in 0...varTypes.count-1 {
        
        // if the variabe is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
            
                if first {
                    
                    cStruct1 += "\n"
                    first = false
                }
                else {

                    cStruct1 += "\t\tstrcat( descString, ',' ); \n\n"
                }
                
                cStruct1 += "\t\tstrcat(descString, '\(varNames[i])='); \n" +
                    "\t\titoa(\(varNames[i]),buffer,10); \n" +
                    "\t\tstrcat(descString, buffer); \n"
        }
        // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                
                cStruct1 += "\n"
                first = false
            }
            else {
                
                cStruct1 += "\t\tstrcat( descString, ',' ); \n\n"
            }
            
            cStruct1 += "\t\tstrcat(descString, '\(varNames[i])='); \n" +
                "\t\tchar \(varNames[i])String[6] = \(varNames[i]) ? 'true' : 'false'; \n" +
                "\t\tstrcat( descString, \(varNames[i])String ); \n"
        }
    }

    cStruct1 += "\t\treturn descString; \n" +
        "\t} \n\n"
        
        
    // create to_string method
    cStruct1 += "\t/** convert to a string */  \n" +
        "\tchar* to_string() {\n" +
        "\t\tchar toString[0] = '\\0'; \n" +
        "\t\tchar buffer[20]; \n"
    
    first = true
    
    for i in 0...varTypes.count-1 {
        
        // if the variable is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
                
                if first {
                    
                    cStruct1 += "\n"
                    first = false
                }
                else {
                    
                    cStruct1 += "\t\tstrcat( toString, ',' ); \n\n"
                }
                
                cStruct1 += "\t\titoa(\(varNames[i]),buffer,10); \n" +
                "\t\tstrcat(toString, buffer); \n\n"
        }
            // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                
                cStruct1 += "\n"
                first = false
            }
            else {
                
                cStruct1 += "\t\tstrcat( toString, ',' ); \n\n"
            }
            
            cStruct1 += "\t\tchar \(varNames[i])String[6] = \(varNames[i]) ? 'true' : 'false'; \n" +
            "\t\tstrcat( toString, \(varNames[i])String ); \n\n"
        }
    }
    
    cStruct1 += "\t\treturn toString; \n" +
        "\t} \n\n"

    // create from_string method
    cStruct1 += "\t/** convert from a string */  \n" +
        "\tvoid from_string(char* str) {\n\n"
    
    cStruct1 += "\t\tchar* strings[NUMBER_OF_VARIABLES]; \n" +
        "\t\tchar* descStrings[NUMBER_OF_VARIABLES]; \n" +
        "\t\tconst char s[2] = \",\";  // delimeters \n" +
        "\t\tconst char e[2] = \"=\";  // delimeters \n" +
        "\t\tchar* tokenS, *tokenE; \n\n" +
        
        "\t\tfor ( int i = 0; i < NUMBER_OF_VARIABLES; i++ ) { \n" +
            "\t\t\ttokenS = strtok(str, s); \n" +
            "\t\t\tdescStrings[i] = tokenS; \n" +
        
        "\t\t} \n\n" +
    
        "\t\tfor ( int i = 0; i < NUMBER_OF_VARIABLES; i++ ) { \n\n" +
        
        "\t\t\t// Remove the variable name and equals sign (if there) \n" +
        "\t\t\ttokenE = strtok(descStrings[i], e); \n\n" +

        "\t\t\twhile ( tokenE != NULL ) { \n" +
            "\t\t\t\ttokenE = strtok(NULL, e); \n" +
        "\t\t\t} \n\n" +
        
        "\t\t\tstrings[i] = tokenE; \n" +
        
        "\t\t} \n\n"
    
    for i in 0...varTypes.count-1 {
        
        // if the variable is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
                
            cStruct1 += "\t\tset_\(varNames[i])((\(varTypes[i]))atoi(strings[\(i)])); \n"
        }
        
        else if varTypes[i] == "bool" {
        
            cStruct1 += "\t\tset_\(varNames[i])(strings[\(i)]); \n"
        }
    }
    
    cStruct1 += "\t} \n" +
        "#endif // WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    return cStruct1
}


func generateCPPStruct(data: ClassData) -> String {
    
    var cppStruct = "#ifndef \(data.camel)_DEFINED \n" +
        
        "#define \(data.camel)_DEFINED \n\n" +
        
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#include <cstdlib> \n" +
        "#include <sstream> \n" +
        "#endif \n" +
        "#include <gu_util.h> \n" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard \n" +
        "{ \n" +
        
            "\t/** \n" +
            "\t *  ADD YOUR COMMENT DESCRIBING THE CLASS \(data.camel)\n" +
            "\t * \n" +
            "\t */ \n" +
        
            "\tclass \(data.camel): public \(data.wb) \n" +
            "\t{ \n" +
        
            "\t\t/** Default constructor */ \n" +
            "\t\t\(data.wb)() : "
    
    for i in 0...varTypes.count-1 {
        
        let defaultValue = setDefault(varTypes[i])
        
        cppStruct += "_\(varNames[i])(\(defaultValue))"
        
        if i < varTypes.count-1 {
            cppStruct += ", "
        }
    }
    
    cppStruct += "  {} \n\n" +
        
        "\t\t/** Copy Constructor */ \n" +
    "\t\t\(data.wb)(const  \(data.wb) &other) : \n"
    
    
    for i in 0...varTypes.count-1 {
        
        cppStruct += "\t\t\t_\(varNames[i])(other._\(varNames[i]))"
        
        if i < varTypes.count-1 {
            cppStruct += ", \n"
        }
    }
    
    cppStruct += "  {} \n\n" +
        
        "\t\t/** Assignment Operator */ \n" +
        "\t\t\(data.wb) &operator= (const \(data.wb) &other) { \n"
    
    
    for i in 0...varTypes.count-1 {
        
        cppStruct += "\t\t\t_\(varNames[i]) = other._\(varNames[i]); \n"
    }
    
    cppStruct += "\t\t\treturn *this; \n" +
                "\t\t} \n" +
            "\t} \n" +
        "} \n"

    return cppStruct
}



func generateWBFile(data: ClassData) -> Void {

    let filePath = data.workingDirectory + "/" + data.wb + ".h"
    
    // open a filestream for reading
    let fs : UnsafeMutablePointer<FILE> = fopen( filePath, "w" )
    
    if fs == nil {
        // file did not open
        print("\(data.wb).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    let text = getCreatorDetailsCommentWB(data) + getLicense(data.userName) + generateCStruct(data)
    
    fputs( text, fs )    /// perhaps use multiple fputs statements instead ????
    
    closeFileStream(fs)
}



func generateCPPFile(data: ClassData) -> Void {
    
    let filePath = data.workingDirectory + "/" + data.camel + ".h"
    
    // open a filestream for reading
    let fs : UnsafeMutablePointer<FILE> = fopen( filePath, "w" )
    
    if fs == nil {
        // file did not open
        print("\(data.camel).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    let text = getCreatorDetailsCommentCPP(data) + getLicense(data.userName) + generateCPPStruct(data)
    
    fputs( text, fs )    /// perhaps use multiple fputs statements instead ????
    
    closeFileStream(fs)
}


