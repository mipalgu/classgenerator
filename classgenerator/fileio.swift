//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin

let fileSize = 4096                /// find a way to get EOF to work so I dont need to do this

var varTypes    = [String]()
var varNames    = [String]()
var varDefaults = [String]()


func parseInput(inputText: String) -> String {
    
    var lines = inputText.characters.split {$0 == "\n"}.map { String($0) }
    var userName = "YOUR NAME"
    
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
        
        if variable.count == 3 {
            
            varTypes.append(variable[0])               // these parallel arrays arent going to cut it
            varNames.append(variable[1])
            varDefaults.append(variable[2])
        }
        else if variable.count == 2 {
            
            varTypes.append(variable[0])               // these parallel arrays arent going to cut it
            varNames.append(variable[1])
            varDefaults.append("")
        }
        else {
            print("Input text file contains too many or not enough values for a variable.")
            exit(EXIT_FAILURE)
        }
    }
    
    if varTypes[0] == "name" {    // a name was included in the input, use it, then remove it
        
        userName = varNames[0]
        varTypes.removeAtIndex(0)
        varNames.removeAtIndex(0)
        varDefaults.removeAtIndex(0)
    }

    return userName
}


func setDefault(varType: String) -> String {
    
    var defaultValue : String
    
    switch varType {
        case "bool":
            defaultValue = "false";
            
        case "int", "int8_t", "uint8_t", "int16_t", "uint16_t", "int32_t", "uint32_t", "int64_t", "uint64_t":
            defaultValue = "0";
            
        default:
            defaultValue = "ADD DEFAULT"
    }
    
    print ("\(varType) set to default value of: \(defaultValue)")
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
        
        print("Unable to read")
        exit(EXIT_FAILURE)
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
    
    let toStringBufferSize = getToStringBufferSize()
    let descriptionBufferSize = getDescriptionBufferSize(toStringBufferSize)
    
    var cStruct1 = "#ifndef \(data.wb)_h \n" +
        
        "#define \(data.wb)_h \n\n" +
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n" +
        "#include <gu_util.h> \n" +
        "#include <stdio.h> \n" +
        "#include <string.h> \n" +
        "#include <stdlib.h> \n\n" +
        
        "#define \(data.caps)_NUMBER_OF_VARIABLES \(varNames.count) \n" +
        "#define \(data.caps)_DESC_BUFFER_SIZE \(descriptionBufferSize) \n" +
        "#define \(data.caps)_TO_STRING_BUFFER_SIZE \(toStringBufferSize) \n\n" +
    
        "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(data.wb)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(data.wb) { \n"
    
    for i in 0...varTypes.count-1 {
        
        cStruct1 += "\t/** \(varNames[i]) COMMENT ON PROPERTY */ \n" +
        "\tPROPERTY(\(varTypes[i]), \(varNames[i]))\n\n"
    }
    
    
    cStruct1 += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    // create description() method
    cStruct1 += "\t/** convert to a description string */  \n" +
        "\tconst char* \(data.wb)_description( const struct \(data.wb)* self, char* descString ) {\n" +
        "\t\tdescString[\(data.caps)_DESC_BUFFER_SIZE+1] = '\\0'; \n" +
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

                    cStruct1 += "\t\tgu_strlcat( descString, \",\", sizeof(',') ); \n\n"
                }
                
                cStruct1 += "\t\tgu_strlcat(descString, \"\(varNames[i])=\", sizeof('\(varNames[i])=') ); \n" +
                    "\t\titoa(\(varNames[i]),buffer,10); \n" +
                    "\t\tgu_strlcat(descString, buffer, sizeof(buffer) ); \n"
        }
        // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                
                cStruct1 += "\n"
                first = false
            }
            else {
                
                cStruct1 += "\t\tgu_strlcat( descString, \",\", sizeof(',') ); \n\n"
            }
            
            cStruct1 += "\t\tgu_strlcat(descString, \"\(varNames[i])=\", sizeof('\(varNames[i])=') ); \n" +
                "\t\tgu_strlcat( descString, \(varNames[i]) ? \"true\" : \"false\", sizeof(\(varNames[i]) ? \"true\" : \"false\") ); \n"
        }
    }

    cStruct1 += "\t\treturn descString; \n" +
        "\t} \n\n"
        
        
    // create to_string method
    cStruct1 += "\t/** convert to a string */  \n" +
        "\tconst char* \(data.wb)_to_string( const struct \(data.wb)* self, char* toString ) {\n" +
        "\t\tchar* toString[\(data.caps)_TO_STRING_BUFFER_SIZE+1] = '\\0'; \n" +
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
                    
                    cStruct1 += "\t\tgu_strlcat( toString, \",\", sizeof(',') ); \n\n"
                }
                
                cStruct1 += "\t\titoa(\(varNames[i]),buffer,10); \n" +
                "\t\tgu_strlcat(toString, buffer, sizeof(buffer)); \n\n"
        }
            // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                
                cStruct1 += "\n"
                first = false
            }
            else {
                
                cStruct1 += "\t\tsgu_strlcat( toString, \",\", sizeof(',') ); \n\n"
            }
            
            cStruct1 += "\t\tgu_strlcat( toString, \(varNames[i]) ? \"true\" : \"false\", sizeof(\(varNames[i]) ? \"true\" : \"false\") ); \n\n"
        }
    }
    
    cStruct1 += "\t\treturn toString; \n" +
        "\t} \n\n"

    // create from_string method
    cStruct1 += "\t/** convert from a string */  \n" +
        "\tstruct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str) {\n\n"
    
    cStruct1 += "\t\tchar* strings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "\t\tchar* descStrings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "\t\tconst char s[2] = \",\";  // delimeters \n" +
        "\t\tconst char e[2] = \"=\";  // delimeters \n" +
        "\t\tchar* tokenS, *tokenE, *token; \n\n" +
        
        "\t\tfor ( int i = 0; i < \(data.caps)_NUMBER_OF_VARIABLES; i++ ) { \n" +
            "\t\tint j = i; \n" +
            "\t\t\ttokenS = strtok(str, s); \n\n" +
        
            "\t\tif (tokenS) { \n" +
            "\t\t\tif ????????? \n\n\n"
        
            "\t\t\tdescStrings[i] = tokenS; \n" +
        
        "\t\t} \n\n" +
    
        "\t\tfor ( int i = 0; i < \(data.caps)_NUMBER_OF_VARIABLES; i++ ) { \n\n" +
        
        "\t\t\ttokenE = strtok(descStrings[i], e); \n\n" +
        
        "\t\t\t// Remove the variable name and equals sign (if there) \n" +
        "\t\t\twhile ( tokenE != NULL ) { \n" +
            "\t\t\t\ttoken = tokenE; \n" +
            "\t\t\t\ttokenE = strtok(NULL, e); \n" +
        "\t\t\t} \n\n" +
        
        "\t\t\tstrings[i] = token; \n" +
        
        "\t\t} \n\n"
    
    for i in 0...varTypes.count-1 {
        
        // if the variable is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
            
            cStruct1 += "\t\tif (strings[\(i)] != NULL) \n" +
                "\t\t\tset_\(varNames[i])((\(varTypes[i]))atoi(strings[\(i)])); \n\n"
        }
        
        else if varTypes[i] == "bool" {
        
            cStruct1 += "\t\tif (strings[\(i)] != NULL) \n" +
                "\t\t\tset_\(varNames[i])(strings[\(i)]); \n\n"
        }
    }
    
    cStruct1 += "\t\treturn self \n" +
        
            "\t} \n" +
        "}; \n" +
        "#endif // WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    return cStruct1
}


func generateCPPStruct(data: ClassData) -> String {
    
    var cppStruct = "#ifndef \(data.camel)_DEFINED \n" +
        
        "#define \(data.camel)_DEFINED \n\n" +
        
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#include <cstdlib> \n" +
        "#include <string.h> \n" +
        "#endif \n" +
        "#include <gu_util.h> \n" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard {\n" +
        
            "\t/** \n" +
            "\t *  ADD YOUR COMMENT DESCRIBING THE CLASS \(data.camel)\n" +
            "\t * \n" +
            "\t */ \n" +
        
            "\tclass \(data.camel): public \(data.wb) { \n" +
        
            "\t\t/** Default constructor */ \n" +
            "\t\t\(data.wb)() : "
    
    for i in 0...varTypes.count-1 {
        
        let defaultValue = varDefaults[i] == "" ? setDefault(varTypes[i]) : varDefaults[i]
        
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
                "\t\t} \n\n" +
        
                "\t\t#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
                "\t\tstd::string description() { \n" +
                "\t\t\tchar buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
                "\t\t\t\(data.wb)_description (this, buffer, sizeof(buffer)); \n" +
                "\t\t\tstd::string descr = buffer; \n" +
                "\t\t\treturn descr; \n" +
        
                "\t\t} \n" +
                "\t\t#endif \n" +
        
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
    
    let text = getCreatorDetailsCommentWB(data) + getLicense(data) + generateCStruct(data)
    
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
    
    let text = getCreatorDetailsCommentCPP(data) + getLicense(data) + generateCPPStruct(data)
    
    fputs( text, fs )    /// perhaps use multiple fputs statements instead ????
    
    closeFileStream(fs)
}


func getDescriptionBufferSize(toStringbufferSize: size_t) -> size_t {
    
    
    // total the number of characters in the descrption string
    
    var size: size_t = toStringbufferSize
    
    size += (varNames.count) //* strideofValue("=")    // equals signs
    
    for name in varNames {
    
        size += Int(strlen(name))      // length of the variable names
        //print("\(name) length = \(strlen(name))")
    }
    
    print ("maximum number of characters in the description string is : \(size)")
    return size
}


func getToStringBufferSize() -> size_t {
    
    var size: size_t = 0
    
    size += (varNames.count-1) //* strideofValue(",")  // commas
    
    for type in varTypes {
        
        switch type {
        case "bool":
            size += 5    // 'false' is 5 characters    // boolean is 1 byte
        case "int":
            size += 11   // strideof(Int)
        case "int8_t":
            size += 4    // strideof(Int8)
        case "uint8_t":
            size += 3
        case "int16_t":
            size += 6    //strideof(Int16)
        case "uint16_t":
            size += 5
        case "int32_t":
            size += 11   //strideof(Int32)
        case "uint32_t":
            size += 10
        case "int64_t", "uint64_t":
            size += 20   //strideof(Int64)
        default:
            print("Unknown variable type")
        }
    }
    
    return size
}



