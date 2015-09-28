//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin

let fileSize = 4096                /// find a way to get EOF to work so I dont need to do this

// var varTypes    = [String]()
// var varNames    = [String]()
// var varDefaults = [String]()

/*
struct inputVariable{

var varType : String
var varName : String
var varDefault : String
}

var inputData : [inputVariable] = []
*/


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
        //var inputVar : inputVariable
        
        if variable.count == 3 {

            let inputVar = inputVariable(varType: variable[0], varName: variable[1], varDefault: variable[2])
            
            inputData.append(inputVar)
            
            //varTypes.append(variable[0])               // these parallel arrays arent going to cut it
            //varNames.append(variable[1])
            //varDefaults.append(variable[2])
        }
        else if variable.count == 2 {
            
            let inputVar = inputVariable(varType: variable[0], varName: variable[1], varDefault: "")
            
            inputData.append(inputVar)
            
            //varTypes.append(variable[0])               // these parallel arrays arent going to cut it
            //varNames.append(variable[1])
            //varDefaults.append("")
        }
        else {
            print("Input text file contains too many or not enough values for a variable.")
            exit(EXIT_FAILURE)
        }
    }
    
    //if varTypes[0] == "name" {    // a name was included in the input, use it, then remove it
    if inputData[0].varType == "name" {

        userName = inputData[0].varName
        inputData.removeAtIndex(0)
        
        //userName = varNames[0]
        //varTypes.removeAtIndex(0)
        //varNames.removeAtIndex(0)
        //varDefaults.removeAtIndex(0)
    }

    return userName
}


func setDefault(varType: String) -> String {
    
/*
    var defaultValue : String
    
    switch varType {
        case "bool":
            defaultValue = "false";
            
        case "int", "int8_t", "uint8_t", "int16_t", "uint16_t", "int32_t", "uint32_t", "int64_t", "uint64_t":
            defaultValue = "0";
            
        default:
            defaultValue = "ADD DEFAULT"
    }
*/
    if let defaultValue = variables[varType]?.defaultValue {
        print ("Unspecified \(varType) set to default value of: \(defaultValue)")
        return defaultValue
    }
    else {
        print ("Unknown type \(varType) set to default value of: \"ADD DEFAULT\"")
        return "ADD DEFAULT"
    }
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




func generateWbHeader(data: ClassData) -> String {
    
    let toStringBufferSize = getToStringBufferSize()
    let descriptionBufferSize = getDescriptionBufferSize(toStringBufferSize)
    
    var cStruct1 = "#ifndef \(data.wb)_h \n" +
        "#define \(data.wb)_h \n\n" +
        "#include <gu_util.h> \n\n"
    
    cStruct1 += "#define \(data.caps)_NUMBER_OF_VARIABLES \(inputData.count) \n" +
        "#define \(data.caps)_DESC_BUFFER_SIZE \(descriptionBufferSize) \n" +
        "#define \(data.caps)_TO_STRING_BUFFER_SIZE \(toStringBufferSize) \n\n"
    
    cStruct1 += "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description( const struct \(data.wb)* self, char* descString, size_t bufferSize ); \n\n" +
        "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string( const struct \(data.wb)* self, char* toString, size_t bufferSize ); \n\n" +
        "/** convert from a string */  \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str); \n\n"
    
    
    cStruct1 += "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(data.wb)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(data.wb) { \n"
    
    for i in 0...inputData.count-1 {
        
        cStruct1 += "\t/** \(inputData[i].varName) COMMENT ON PROPERTY */ \n" +
        "\tPROPERTY(\(inputData[i].varType), \(inputData[i].varName))\n\n"
    }
    
    cStruct1 += "}; \n"
    
    return cStruct1
}




func generateWbC(data: ClassData) -> String {
    
    var cText = "#include <\(data.wb).h> \n" +
    "#include <gu_util.h> \n" +
    "#include <stdio.h> \n" +
    "#include <string.h> \n" +
    "#include <stdlib.h> \n\n"
    
    cText += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    // create description() method
    cText += "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description( const struct \(data.wb)* self, char* descString, size_t bufferSize ) {\n"
    
    if inputData.count > 1 {
        cText += "\tsize_t len; \n"
    }
    
    var first = true
    
    for i in 0...inputData.count-1 {
        
        // if the variable is a bool
        if inputData[i].varType == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "\tlen = gu_strlcat( descString, \", \", bufferSize ); \n\n"
            }
            
            if !first {
                cText += "\tif ( len < bufferSize ) { \n\t"
            }
            
            cText += "\tgu_strlcat( descString, \"\(inputData[i].varName)=\", bufferSize ); \n"
            
            if !first {
                cText += "\t"
            }
            
            cText += "\tgu_strlcat( descString, \(inputData[i].varName) ? \"true\" : \"false\", bufferSize ); \n\n"
            
            if !first {
                cText += "\t} \n\n "
            }
            
            first = false
        }
        
        // if the variabe is a number type
        else {
                if first {
                    cText += "\n"
                }
                else {
                    cText += "\tlen = gu_strlcat( descString, \", \", bufferSize ); \n\n"
                }
                
                if !first {
                    cText += "\tif ( len < bufferSize ) { \n\t"
                }
                
                cText += "\tsnprintf(descString+len, bufferSize-len, \"\(inputData[i].varName)=\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName) ); \n"
                
                if !first {
                    cText += "\t} \n\n"
                }
                
                first = false
        }

    }
    
    cText += "\treturn descString; \n" +
    "} \n\n"
    
    
    // create to_string method
    cText += "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string( const struct \(data.wb)* self, char* toString, size_t bufferSize ) {\n"
    
    if inputData.count > 1 {
        cText += "\tsize_t len; \n"
    }
    
    first = true
    
    for i in 0...inputData.count-1 {
        
        // if the variable is a bool
        if inputData[i].varName == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "\tsgu_strlcat( toString, \", \", bufferSize ); \n\n"
            }
            
            if !first {
                cText += "\tif ( len < bufferSize ) { \n\t"
            }
            
            cText += "\tgu_strlcat( toString, \(inputData[i].varName) ? \"true\" : \"false\", bufferSize ); \n\n"
            
            if !first {
                cText += "\t} \n\n "
            }
            
            first = false
        }
        // if the variable is a number type
        else {
                
            if first {
                cText += "\n"
            }
            else {
                cText += "\tlen = gu_strlcat( toString, \", \", bufferSize ); \n\n"
            }
            
            if !first {
                cText += "\tif ( len < bufferSize ) { \n\t"
            }
            
            cText += "\tsnprintf(toString+len, bufferSize-len, \"\(inputData[i].varName)=\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName) ); \n"
            
            if !first {
                cText += "\t} \n\n "
            }
            
            first = false
        }
    }
    
    cText += "\treturn toString; \n" +
    "} \n\n"
    
    // create from_string method
    cText += "/** convert from a string */  \n" +
    "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str) {\n\n"
    
    cText += "\tchar* strings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "\tconst char s[3] = \", \";  // delimeter \n" +
        "\tconst char e[2] = \"=\";   // delimeter \n" +
        "\tchar* tokenS, *tokenE; \n" +
        "\tchar* saveptr = NULL; \n\n" +
        
        "\tfor ( int i = 0; i < \(data.caps)_NUMBER_OF_VARIABLES; i++ ) { \n" +
        "\t\tint j = i; \n" +
        "\t\ttokenS = strtok_r(str, s, &saveptr); \n\n" +
        
        "\tif (tokenS) { \n" +
        
        "\t\ttokenE = strchr(tokenS, '='); \n\n" +
        
        "\t\tif (tokenE == NULL) { \n " +
        "\t\t\ttokenE = tokenS; \n " +
        "\t\t} \n" +
        "\t\telse { \n " +
        "\t\t\ttokenE++; \n\n "
        
        for i in 0...inputData.count-1 {
            
            if ( i == 0 ) {
                cText += "\t\t\tif "
            }
            else {
                cText += "\t\t\telse if "
            }
            
            cText += "( strcmp(tokenS, \"\(inputData[i].varName)\") == 0 ) { \n " +
                "\t\t\t\tj = \(i) \n " +
                "\t\t\t} \n"
        }
    
    cText += "\t\t} \n\n" +
    
        "\t\tstrings[j] = tokenE; \n" +
        "\t} \n\n"
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varType == "bool" {
            
            cText += "\tif (strings[\(i)] != NULL) \n" +
            "\t\tset_\(inputData[i].varName)(strings[\(i)]); \n\n"
        }
        // the variable is a number type
        else {
            cText += "\tif (strings[\(i)] != NULL) \n" +
            "\t\tset_\(inputData[i].varName)((\(inputData[i].varType))\(variables[inputData[i].varType]!.converter)(strings[\(i)])); \n\n"
        }
    }
    
    cText += "\treturn self \n" +
        
        "} \n" +
    "#endif // WHITEBOARD_POSTER_STRING_CONVERSION \n"
    
    return cText
}




func generateCPPStruct(data: ClassData) -> String {
    
    var cppStruct = "#ifndef \(data.cpp)_DEFINED \n" +
        
        "#define \(data.cpp)_DEFINED \n\n" +
        
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#include <cstdlib> \n" +
        "#include <string.h> \n" +
        "#include <sstream> \n" +
        "#endif \n" +
        "#include <gu_util.h> \n" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard {\n" +
        
            "\t/** \n" +
            "\t *  ADD YOUR COMMENT DESCRIBING THE CLASS \(data.cpp)\n" +
            "\t * \n" +
            "\t */ \n" +
        
            "\tclass \(data.cpp): public \(data.wb) { \n" +
        
            "\t\t/** Default constructor */ \n" +
            "\t\t\(data.cpp)() : "
    
    for i in 0...inputData.count-1 {
        
        let defaultValue = inputData[i].varDefault == "" ? setDefault(inputData[i].varType) : inputData[i].varDefault
        
        cppStruct += "_\(inputData[i].varName)(\(defaultValue))"
        
        if i < inputData.count-1 {
            cppStruct += ", "
        }
    }
    
    cppStruct += "  {} \n\n" +
        
        "\t\t/** Copy Constructor */ \n" +
    "\t\t\(data.cpp)(const \(data.wb) &other) : \n"
    
    
    for i in 0...inputData.count-1 {
        
        cppStruct += "\t\t\t_\(inputData[i].varName)(other._\(inputData[i].varName))"
        
        if i < inputData.count-1 {
            cppStruct += ", \n"
        }
    }
    
    cppStruct += " {} \n\n" +
        
        "\t\t/** Assignment Operator */ \n" +
        "\t\t\(data.cpp) &operator= (const \(data.wb) &other) { \n"
    
    
    for i in 0...inputData.count-1 {
        
        cppStruct += "\t\t\t_\(inputData[i].varName) = other._\(inputData[i].varName); \n"
    }
    
    cppStruct += "\t\t\treturn *this; \n" +
                "\t\t} \n\n" +
        
                "\t\t#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
                "\t\tstd::string description() { \n" +
                "\t\t\t#ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
                "\t\t\tchar buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
                "\t\t\t\(data.wb)_description (this, buffer, sizeof(buffer)); \n" +
                "\t\t\tstd::string descr = buffer; \n" +
                "\t\t\treturn descr; \n" +
                "\t\t\t#else \n" +
        
                "\t\t\tstd::string description() const { \n" +
                "\t\t\t\tstd::ostringstream ss; \n"
    
                var first = true
    
                for i in 0...inputData.count-1 {
                    
                    if !first {
                        cppStruct += " << \", \"; \n "
                    }
                    
                    cppStruct += "\t\t\t\tss << \"\(inputData[i].varName)=\" << \(inputData[i].varName)"
                    first = false
                }

                cppStruct += ";\n\t\t\t\treturn ss.str(); \n" +
                    "\t\t\t} \n" +
    
                "\t\t\t#endif \n" +
        
                "\t\t} \n" +
                "\t\t#endif \n" +
        
            "\t} \n" +
        "} \n"

    return cppStruct
}





func generateWBFiles(data: ClassData) -> Void {

    // make header file
    let headerFilePath = data.workingDirectory + "/" + data.wb + ".h"
    
    // open a filestream for reading
    let fsh : UnsafeMutablePointer<FILE> = fopen( headerFilePath, "w" )
    
    if fsh == nil {
        // file did not open
        print("\(data.wb).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    var commentText = getCreatorDetailsCommentWB(data, fileType: ".h")
    let licenseText = getLicense(data)
    
    let headerText =  commentText + licenseText + generateWbHeader(data)
    
    fputs( headerText, fsh )    /// perhaps use multiple fputs statements instead ????
    closeFileStream(fsh)
    
    
    // make c file
    let cFilePath = data.workingDirectory + "/" + data.wb + ".c"
    
    // open a filestream for reading
    let fsc : UnsafeMutablePointer<FILE> = fopen( cFilePath, "w" )
    
    if fsc == nil {
        // file did not open
        print("\(data.wb).c : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    commentText = getCreatorDetailsCommentWB(data, fileType: ".c")
    
    let cText =  commentText + licenseText + generateWbC(data)
    
    fputs( cText, fsc )    /// perhaps use multiple fputs statements instead ????
    closeFileStream(fsc)
}



func generateCPPFile(data: ClassData) -> Void {
    
    let filePath = data.workingDirectory + "/" + data.cpp + ".h"
    
    // open a filestream for reading
    let fs : UnsafeMutablePointer<FILE> = fopen( filePath, "w" )
    
    if fs == nil {
        // file did not open
        print("\(data.cpp).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    
    let text = getCreatorDetailsCommentCPP(data) + getLicense(data) + generateCPPStruct(data)
    
    fputs( text, fs )    /// perhaps use multiple fputs statements instead ????
    
    closeFileStream(fs)
}


func getDescriptionBufferSize(toStringbufferSize: size_t) -> size_t {
    
    
    // total the number of characters in the descrption string
    
    var size: size_t = toStringbufferSize
    
    size += (inputData.count)      // equals signs
    
    //for name in inputData.varName {
    for i in 0...inputData.count-1 {
        size += Int(strlen(inputData[i].varName)) // length of the variable names
    }
    
    //print ("maximum number of characters in the description string is : \(size)")
    return size
}


func getToStringBufferSize() -> size_t {
    
    var size: size_t = 0
    
    size += (inputData.count-1) * 2 // commas and spaces
    
    for i in 0...inputData.count-1 {
        
        if let typeLength = variables["\(inputData[i].varType)"]?.length {
            size += typeLength
        }
        else {
            size += 255
        }
    }
        
        /*
        switch type {
        case "bool":
            size += 5    // 'false' is 5 characters
        case "int":
            size += 11
        case "int8_t":
            size += 4
        case "uint8_t":
            size += 3
        case "int16_t":
            size += 6
        case "uint16_t":
            size += 5
        case "int32_t":
            size += 11
        case "uint32_t":
            size += 10
        case "int64_t", "uint64_t":
            size += 20
        default:
            print("Unknown variable type")
        }
        */
    
    return size + 1
}



