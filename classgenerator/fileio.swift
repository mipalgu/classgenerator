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




func generateWbHeader(data: ClassData) -> String {
    
    var cStruct1 = "#ifndef \(data.wb)_h \n" +
        
        "#define \(data.wb)_h \n\n" +
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#include <gu_util.h> \n" +
        "#include <stdio.h> \n" +
        "#include <string.h> \n" +
        "#include <stdlib.h> \n" +
        "#endif  \n\n"
    
    cStruct1 += "const char* \(data.wb)_description( const struct \(data.wb)* self, char* descString ); \n" +
        "const char* \(data.wb)_to_string( const struct \(data.wb)* self, char* toString ); \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str); \n\n"
    
    
    cStruct1 += "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(data.wb)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(data.wb) { \n"
    
    for i in 0...varTypes.count-1 {
        
        cStruct1 += "\t/** \(varNames[i]) COMMENT ON PROPERTY */ \n" +
        "\tPROPERTY(\(varTypes[i]), \(varNames[i]))\n\n"
    }
    
    cStruct1 += "}; \n\n"
    
    return cStruct1
}




func generateWbC(data: ClassData) -> String {
    
    let toStringBufferSize = getToStringBufferSize()
    let descriptionBufferSize = getDescriptionBufferSize(toStringBufferSize)
    
    var cText = "#include <\(data.wb).h> \n" +
    "#include <gu_util.h> \n" +
    "#include <stdio.h> \n" +
    "#include <string.h> \n" +
    "#include <stdlib.h> \n" +
    
    "#define \(data.caps)_NUMBER_OF_VARIABLES \(varNames.count) \n" +
    "#define \(data.caps)_DESC_BUFFER_SIZE \(descriptionBufferSize) \n" +
    "#define \(data.caps)_TO_STRING_BUFFER_SIZE \(toStringBufferSize) \n\n"
    
    cText += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    // create description() method
    cText += "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description( const struct \(data.wb)* self, char* descString ) {\n" +
    "\tsize_t len; \n"
    
    var first = true
    
    for i in 0...varTypes.count-1 {
        
        // if the variabe is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
                
                if first {
                    cText += "\n"
                }
                else {
                    cText += "\tlen = gu_strlcat( descString, \", \", \(data.caps)_DESC_BUFFER_SIZE ); \n\n"
                }
                
                if !first {
                    cText += "\tif ( len < \(data.caps)_DESC_BUFFER_SIZE ) { \n\t"
                }
                
                cText += "\tsnprintf(descString+len, \(data.caps)_DESC_BUFFER_SIZE-len, \"\(varNames[i])=%d\", \(varNames[i]) ); \n"
                
                if !first {
                    cText += "\t} \n\n"
                }
                
                first = false
        }
            // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "\tlen = gu_strlcat( descString, \", \", \(data.caps)_DESC_BUFFER_SIZE ); \n\n"
            }
            
            if !first {
                cText += "\tif ( len < \(data.caps)_DESC_BUFFER_SIZE ) { \n\t"
            }
            
            cText += "\tgu_strlcat(descString, \"\(varNames[i])=\", \(data.caps)_DESC_BUFFER_SIZE ); \n"
            
            if !first {
                cText += "\t"
            }
            
            cText += "\tgu_strlcat( descString, \(varNames[i]) ? \"true\" : \"false\", \(data.caps)_DESC_BUFFER_SIZE ); \n\n"
            
            if !first {
                cText += "\t} \n\n "
            }
            
            first = false
        }
    }
    
    cText += "\treturn descString; \n" +
    "} \n\n"
    
    
    // create to_string method
    cText += "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string( const struct \(data.wb)* self, char* toString ) {\n" +
    "\tsize_t len; \n"
    
    first = true
    
    for i in 0...varTypes.count-1 {
        
        // if the variable is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
                
                if first {
                    cText += "\n"
                }
                else {
                    cText += "\tlen = gu_strlcat( toString, \", \", \(data.caps)_TO_STRING_BUFFER_SIZE ); \n\n"
                }
                
                if !first {
                    cText += "\tif ( len < \(data.caps)_TO_STRING_BUFFER_SIZE ) { \n\t"
                }
                
                cText += "\tsnprintf(toString+len, \(data.caps)_TO_STRING_BUFFER_SIZE-len, \"\(varNames[i])=%d\", \(varNames[i]) ); \n"
                
                if !first {
                    cText += "\t} \n\n "
                }
                
                first = false
        }
            // if the variable is a bool
        else if varTypes[i] == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "\tsgu_strlcat( toString, \", \", \(data.caps)_TO_STRING_BUFFER_SIZE ); \n\n"
            }
            
            if !first {
                cText += "\tif ( len < \(data.caps)_TO_STRING_BUFFER_SIZE ) { \n\t"
            }
            
            cText += "\tgu_strlcat( toString, \(varNames[i]) ? \"true\" : \"false\", \(data.caps)_TO_STRING_BUFFER_SIZE ); \n\n"
            
            if !first {
                cText += "\t} \n\n "
            }
            
            first = false
        }
    }
    
    cText += "\t\treturn toString; \n" +
    "\t} \n\n"
    
    // create from_string method
    cText += "/** convert from a string */  \n" +
    "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str) {\n\n"
    
    cText += "\tchar* strings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "\tconst char s[3] = \", \";  // delimeters \n" +
        "\tconst char e[2] = \"=\";  // delimeters \n" +
        "\tchar* tokenS, *tokenE, *saveptr; \n\n" +
        
        "\tmemset(descString, NULL, sizeof(\(data.caps)_NUMBER_OF_VARIABLES)); \n\n " +
        
        "\tfor ( int i = 0; i < \(data.caps)_NUMBER_OF_VARIABLES; i++ ) { \n" +
        "\t\tint j = i; \n" +
        "\t\ttokenS = strtok_r(str, s, &saveptr); \n\n" +
        
        "\tif (tokenS) { \n" +
        
        "\t\ttokenE = strchr(tokenS, '='); \n\n" +
        
        "\t\tif (tokenE == NULL) { \n " +
        "\t\t\ttokenE = tokenS; \n " +
        "\t\t} \n" +
        "\t\telse { \n " +
        "\t\t\ttokenE++; \n " +
    "\t\t} \n\n"
    
    for i in 0...varNames.count-1 {
        
        if ( i == 0 ) {
            cText += "\t\tif "
        }
        else {
            cText += "\t\telse if "
        }
        
        cText += "( strcmp(tokenS, \"\(varNames[i])\") == 0 ) { \n " +
            "\t\t\tj = \(i) \n " +
        "\t\t} \n"
    }
    
    cText += "\t\tstrings[j] = tokenE; \n" +
        
    "\t} \n\n"
    
    for i in 0...varTypes.count-1 {
        
        // if the variable is an integer type
        if varTypes[i] == "int" || varTypes[i] == "int8_t" || varTypes[i] == "uint8_t" ||
            varTypes[i] == "int16_t" || varTypes[i] == "uint16_t" || varTypes[i] == "int32_t" ||
            varTypes[i] == "uint32_t" || varTypes[i] == "int64_t" || varTypes[i] == "uint64_t" {
                
                cText += "\tif (strings[\(i)] != NULL) \n" +
                "\t\tset_\(varNames[i])((\(varTypes[i]))atoi(strings[\(i)])); \n\n"
        }
            
        else if varTypes[i] == "bool" {
            
            cText += "\tif (strings[\(i)] != NULL) \n" +
            "\t\tset_\(varNames[i])(strings[\(i)]); \n\n"
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
        "#endif \n" +
        "#include <gu_util.h> \n" +
        "#include <sstream>" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard {\n" +
        
            "\t/** \n" +
            "\t *  ADD YOUR COMMENT DESCRIBING THE CLASS \(data.cpp)\n" +
            "\t * \n" +
            "\t */ \n" +
        
            "\tclass \(data.cpp): public \(data.wb) { \n" +
        
            "\t\t/** Default constructor */ \n" +
            "\t\t\(data.cpp)() : "
    
    for i in 0...varTypes.count-1 {
        
        let defaultValue = varDefaults[i] == "" ? setDefault(varTypes[i]) : varDefaults[i]
        
        cppStruct += "_\(varNames[i])(\(defaultValue))"
        
        if i < varTypes.count-1 {
            cppStruct += ", "
        }
    }
    
    cppStruct += "  {} \n\n" +
        
        "\t\t/** Copy Constructor */ \n" +
    "\t\t\(data.cpp)(const \(data.wb) &other) : \n"
    
    
    for i in 0...varTypes.count-1 {
        
        cppStruct += "\t\t\t_\(varNames[i])(other._\(varNames[i]))"
        
        if i < varTypes.count-1 {
            cppStruct += ", \n"
        }
    }
    
    cppStruct += " {} \n\n" +
        
        "\t\t/** Assignment Operator */ \n" +
        "\t\t\(data.cpp) &operator= (const \(data.wb) &other) { \n"
    
    
    for i in 0...varTypes.count-1 {
        
        cppStruct += "\t\t\t_\(varNames[i]) = other._\(varNames[i]); \n"
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
    
                for i in 0...varTypes.count-1 {
                    
                    if !first {
                        cppStruct += " << \", \"; \n "
                    }
                    
                    cppStruct += "\t\t\t\tss << \"\(varNames[i])=\" << \(varNames[i])"
                    first = false
                }

                cppStruct += "\n\t\t\t\treturn ss.str(); \n" +
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
    
    size += (varNames.count-1) * 2 // commas and spaces
    
    for type in varTypes {
        
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
    }
    
    return size + 1
}



