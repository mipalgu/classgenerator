//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin



let fileSize = 4096                /// find a way to get EOF to work so I dont need to do this


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
        
        var isArray = false
        var inputArraySize : Int = 0
        var variable = line.characters.split {$0 == "\t"}.map { String($0) }
        //var inputVar : inputVariable
        
        // check if this line is an array
        // first, check for [] notation
        let bracketValues = variable[1].characters.split {$0 == "["}.map { String($0) }
        
        if bracketValues.count == 2 {  // found bracket therefore array
            variable[1] = bracketValues[0]
            let size : String = bracketValues[1]
            inputArraySize = Int(String(size.characters.dropLast()))!   // remove the ]
            isArray = true
        }
        else if bracketValues.count == 1 {  // not an array
            variable[1] = bracketValues[0]
        }
        else {
            /// error    ****************************
        }
        
        if !isArray {
            
            let colonValues = variable[0].characters.split {$0 == ":"}.map { String($0) }
            
            if colonValues.count == 2 {  // found colon therefore array
                variable[0] = colonValues[0]
                inputArraySize = Int(colonValues[1])!
            }
            else if colonValues.count == 1 {  // not an array
                variable[0] = colonValues[0]
            }
            else {
                /// error  **************************
            }
        }
        
        if variable.count == 3 {

            let inputVar = inputVariable(varType: variable[0], varName: variable[1], varDefault: variable[2], varArraySize: inputArraySize)
            inputData.append(inputVar)
            //print("\(inputVar.varType) : \(inputVar.varName) : \(inputVar.varDefault) : \(inputVar.varArraySize) ")
        }
        else if variable.count == 2 {  // no default
            
            let inputVar = inputVariable(varType: variable[0], varName: variable[1], varDefault: "", varArraySize: inputArraySize)
            inputData.append(inputVar)
            //print("\(inputVar.varType) : \(inputVar.varName) : \(inputVar.varDefault) : \(inputVar.varArraySize) ")
        }
        else {
            print("Input text file contains too many or not enough values for a variable.")
            exit(EXIT_FAILURE)
        }
    }
    
    
    
    
    // if a name was included in the input, use it, then remove it
    if inputData[0].varType == "author" {

        userName = inputData[0].varName
        inputData.removeAtIndex(0)
    }

    return userName
}


func setDefault(varType: String) -> String {
    
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
        "#include <gu_util.h> \n" +
        "#include \"gusimplewhiteboard.h\" \n\n"
    
    cStruct1 += "#define \(data.caps)_NUMBER_OF_VARIABLES \(inputData.count) \n\n" +
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#define \(data.caps)_DESC_BUFFER_SIZE \(descriptionBufferSize) \n" +
        "#define \(data.caps)_TO_STRING_BUFFER_SIZE \(toStringBufferSize) \n" +
        "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize > 0 {
            
            cStruct1 += "#define \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE \(inputData[i].varArraySize) \n"
        }
    }
    
    
    
    cStruct1 += "\n/** convert to a description string */  \n" +
        "const char* \(data.wb)_description(const struct \(data.wb)* self, char* descString, size_t bufferSize); \n\n" +
        "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string(const struct \(data.wb)* self, char* toString, size_t bufferSize); \n\n" +
        "/** convert from a string */  \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str); \n\n"
    
    
    cStruct1 += "/** \n" +
        " *  ADD YOUR COMMENT DESCRIBING THE STRUCT \(data.wb)\n" +
        " * \n" +
        " */ \n" +
        
        "struct \(data.wb) \n" +
        "{ \n"
    
    for i in 0...inputData.count-1 {
        
        cStruct1 += "    /** \(inputData[i].varName) COMMENT ON PROPERTY */ \n"
        
        if inputData[i].varArraySize == 0 {  // not an array
            cStruct1 += "    PROPERTY(\(inputData[i].varType), \(inputData[i].varName))\n\n"
        }
        else {
            cStruct1 += "    ARRAY_PROPERTY(\(inputData[i].varType), \(inputData[i].varName), \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE)\n\n"
        }
    }
    
    cStruct1 += "}; \n"
    
    return cStruct1
}




func generateWbC(data: ClassData) -> String {
    
    var cText = "#include \"\(data.wb).h\" \n" +
    "#include <stdio.h> \n" +
    "#include <string.h> \n" +
    "#include <stdlib.h> \n\n"
    
    cText += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    // create description() method
    cText += "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description(const struct \(data.wb)* self, char* descString, size_t bufferSize) \n" +
    "{ \n"
    
    if inputData.count > 1 {
        cText += "    size_t len; \n"
    }
    
    
    var first = true
    
    for i in 0...inputData.count-1 {
        
        // if the variable is a bool
        if inputData[i].varType == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "    len = gu_strlcat(descString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                         "    { \n    "
            }
            
            cText += "    gu_strlcat(descString, \"\(inputData[i].varName)=\", bufferSize); \n"
            
            if !first {
                cText += "    "
            }
            
            cText += "    gu_strlcat(descString, \(inputData[i].varName) ? \"true\" : \"false\", bufferSize); \n\n"
            
            if !first {
                cText += "    } \n\n "
            }
            
            first = false
        }
        
        // if the variable is a number type
        else {
                if first {
                    cText += "\n"
                }
                else {
                    cText += "    len = gu_strlcat(descString, \", \", bufferSize); \n\n"
                }
                
                if !first {
                    cText += "    if (len < bufferSize) \n" +
                             "    { \n    "
                }
                
                cText += "    snprintf(descString+len, bufferSize-len, \"\(inputData[i].varName)=\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName) ); \n"
                
                if !first {
                    cText += "    } \n\n"
                }
                
                first = false
        }

    }
    
    
    cText += "\treturn descString; \n" +
    "} \n\n"
    
    
    // create to_string method
    cText += "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string(const struct \(data.wb)* self, char* toString, size_t bufferSize) \n" +
        "{ \n"
    
    if inputData.count > 1 {
        cText += "    size_t len; \n"
    }
    
    first = true
    
    for i in 0...inputData.count-1 {
        
        // if the variable is a bool
        if inputData[i].varName == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "    sgu_strlcat(toString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                         "    { \n    "
            }
            
            cText += "    gu_strlcat(toString, \(inputData[i].varName) ? \"true\" : \"false\", bufferSize); \n\n"
            
            if !first {
                cText += "    } \n\n"
            }
            
            first = false
        }
        // if the variable is a number type
        else {
                
            if first {
                cText += "\n"
            }
            else {
                cText += "    len = gu_strlcat(toString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                         "    { \n    "
            }
            
            cText += "    snprintf(toString+len, bufferSize-len, \"\(inputData[i].varName)=\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName)); \n"
            
            if !first {
                cText += "    } \n\n "
            }
            
            first = false
        }
    }
    
    cText += "    return toString; \n" +
    "} \n\n"
    
    // create from_string method
    cText += "/** convert from a string */  \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str) \n" +
        "{ \n"
    
    cText += "    char* strings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "    const char s[3] = \", \";  /// delimeter \n" +
        "    const char e[2] = \"=\";   /// delimeter \n" +
        "    char* tokenS, *tokenE; \n" +
        "    char* saveptr = NULL; \n\n" +
        
        "    memset(strings, 0, sizeof(strings)); \n\n" +
        
        "    for (int i = 0; i < \(data.caps)_NUMBER_OF_VARIABLES; i++) \n" +
        "    { \n" +
        "        int j = i; \n" +
        "        tokenS = strtok_r(str, s, &saveptr); \n\n" +
        
        "        if (tokenS) \n" +
        "        { \n" +
        
        "            tokenE = strchr(tokenS, '='); \n\n" +
        
        "            if (tokenE == NULL) \n" +
        "            { \n " +
        "                tokenE = tokenS; \n" +
        "            } \n" +
        "            else \n" +
        "            { \n " +
        "                tokenE++; \n\n"
        
        for i in 0...inputData.count-1 {
            
            if ( i == 0 ) {
                cText += "                if "
            }
            else {
                cText += "                else if "
            }
            
            cText += "(strcmp(tokenS, \"\(inputData[i].varName)\") == 0) \n" +
                     "                { \n" +
                     "                    j = \(i); \n" +
                     "                } \n"
        }
    
            cText += "            } \n\n" +
    
        "            strings[j] = tokenE; \n" +
        "        } \n" +
        "    } \n\n"
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varType == "bool" {
            
            cText += "    if (strings[\(i)] != NULL) \n" +
            "        set_\(inputData[i].varName)(strings[\(i)]); \n\n"
        }
        // the variable is a number type
        else {
            cText += "    if (strings[\(i)] != NULL) \n" +
            "        set_\(inputData[i].varName)((\(inputData[i].varType))\(variables[inputData[i].varType]!.converter)(strings[\(i)])); \n\n"
        }
    }
    
    cText += "    return self \n" +
        
        "}; \n" +
    "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION \n"
    
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
        
            "    /** \n" +
            "     *  ADD YOUR COMMENT DESCRIBING THE CLASS \(data.cpp)\n" +
            "     * \n" +
            "     */ \n" +
        
            "    class \(data.cpp): public \(data.wb) \n" +
            "    { \n\n" +
        
            "        /** Default constructor */ \n" +
            "        \(data.cpp)() : "
    
    var memsetForArrays : [String] = []
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            let defaultValue = inputData[i].varDefault == "" ? setDefault(inputData[i].varType) : inputData[i].varDefault
            cppStruct += "_\(inputData[i].varName)(\(defaultValue))"
        }
        else {   // an array
            let defaultValue = inputData[i].varDefault == "" ? " " : String((inputData[i].varDefault).characters.dropFirst().dropLast())
            cppStruct += "_\(inputData[i].varName)(\(defaultValue))"
            
            if defaultValue == " " {
                memsetForArrays.append("            memset(\(inputData[i].varName), \(variables[inputData[i].varType]!.defaultValue), \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE)")
            }
        }
        
        if i < inputData.count-1 {
            cppStruct += ", "
        }
    }
    
    if memsetForArrays.count == 0 {
        cppStruct += "  {} \n\n"
    }
    else {
        cppStruct += "\n{ \n"
        
        for mem in memsetForArrays {
            cppStruct += "\(mem); \n"
        }
        cppStruct += "        } \n\n"
    }
    
    cppStruct += "        /** Copy Constructor */ \n" +
    "        \(data.cpp)(const \(data.wb) &other) : \n"
    
    
    for i in 0...inputData.count-1 {
        
        cppStruct += "            _\(inputData[i].varName)(other._\(inputData[i].varName))"
        
        if i < inputData.count-1 {
            cppStruct += ", \n"
        }
    }
    
    cppStruct += " {} \n\n" +
        
        "        /** Assignment Operator */ \n" +
        "        \(data.cpp) &operator= (const \(data.wb) &other) \n" +
        "        { \n"
    
    
    for i in 0...inputData.count-1 {
        
        cppStruct += "            _\(inputData[i].varName) = other._\(inputData[i].varName); \n"
    }
    
    cppStruct += "            return *this; \n" +
                "        } \n\n" +
        
                "        #ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
                "        std::string description() \n" +
                "        { \n" +
                "            #ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
                "            char buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
                "            \(data.wb)_description (this, buffer, sizeof(buffer)); \n" +
                "            std::string descr = buffer; \n" +
                "            return descr; \n" +
                "            #else \n" +
        
                "            std::string description() const \n" +
                "            { \n" +
                "                std::ostringstream ss; \n"
    
                var first = true
    
                for i in 0...inputData.count-1 {
                    
                    if !first {
                        cppStruct += " << \", \"; \n "
                    }
                    
                    cppStruct += "                ss << \"\(inputData[i].varName)=\" << \(inputData[i].varName)"
                    first = false
                }

                cppStruct += ";\n                return ss.str(); \n" +
                    
                "                } \n" +
    
                "                #endif \n" +
                "        } \n" +
                "        #endif \n" +
    
                "    } \n" +
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



