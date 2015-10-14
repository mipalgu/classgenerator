//
//  fileio.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//

import Darwin



let fileSize = 4096                /// find a way to get EOF to work so I dont need to do this
var classAlias : String = ""
var structComment : [String] = []
var foundVariables : [String] = []

func parseInput(inputText: String) -> String {
    
    /*
    // check for case where the file had a return/s at the end or between lines
    // counting backwards so not to change indexes
    let numberOfLines = lines.count
    for var i = numberOfLines-1; i >= 0; i-- {
        if lines[i] == "" {
            lines.removeAtIndex(i)
        }
    }
    */
    
    var foundUserName = false
    var userName : String = ""
    var foundReturn = false
    var commentPosition : Int = 0
    
    
    /// count to the line that has the struct comment
    /// by finding 2 successive end of lines
    for ch in inputText.characters {
        
        if ch == "\n" {
            
            if foundReturn {
                break
            }
            else {
                foundReturn = true
            }
            commentPosition++
        }
        else {
            foundReturn = false
        }
    }
    
    /// split the input into lines
    /// as separated by an end-of-line
    var lines = inputText.characters.split {$0 == "\n"}.map {String($0)}
    
    if lines.count > commentPosition {
        
        /// get the lines of the struct comment
        for i in commentPosition...lines.count-1 {
            structComment.append(lines[i])
        }
        
        /// get the lines that have the variables
        for i in 0...commentPosition-1 {
            foundVariables.append(lines[i])
        }
    }
    else {
        print("Struct comment needs to be specified. Please see the user manual.")
        exit(EXIT_FAILURE)
    }
    
    
    /// parse the lines containing variables
    for v in foundVariables {
        
        /*
        var varComment : String = ""
        
        // split on the comment separator ';'
        var foundComment = v.characters.split {$0 == "*"}.map {String($0)}
        
        // exit if there isn;t a comment for this variable
        if foundComment.count == 1 {
            print("A comment needs to be specified for each variable. Please see the user manual.")
            exit(EXIT_FAILURE)
        }
        
        varComment = foundComment[1]
        */
        
        // split the line where there are tabs
        var variable = v.characters.split {$0 == "\t"}.map {String($0)}
        
        if variable.count == 3 {  // is a variable
            
                var varDefault = ""
                var varName = ""
                let varType = variable[0]
                let varComment = removeCommentNotation(variable[2])
                var varArraySize : Int = 0
            
                var nameAndDefault = variable[1].characters.split {$0 == "="}.map {String($0)}
            
                // check if this name is an array
                // check for [] notation
                let bracketValues = nameAndDefault[0].characters.split {$0 == "["}.map {String($0)}
                varName = bracketValues[0]
            
                // found bracket therefore array
                if bracketValues.count == 2 {
                    let size : String = bracketValues[1]
                    varArraySize = Int(String(size.characters.dropLast()))!   // remove the ]
                }
            
            /*
                // check if this name is an array
                // check for : notation
                let colonValues = variable[0].characters.split {$0 == ":"}.map {String($0)}
                varType = colonValues[0]
                
                if colonValues.count == 2 {  // found colon therefore array
                    inputArraySize = Int(colonValues[1])!
                }
            */
            
                // if a default was specified, use it
                if nameAndDefault.count == 2 {
                    varDefault = nameAndDefault[1]
                }
            
                let inputVar = inputVariable(varType: varType, varName: varName, varDefault: varDefault, varComment: varComment, varArraySize: varArraySize)
                inputData.append(inputVar)
        }
        else if variable.count == 2 { // not a variable
            
            // if an author was included in the input, use it
            if variable[0] == "author" {
                userName = variable[1]
                foundUserName = true
            }
                
                // if an alias was included in the input, use it
            else if variable[0] == "alias" {
                classAlias = variable[1]
            }
            else {
                print("Input text file contains too many or not enough values for a variable.")
                exit(EXIT_FAILURE)
            }
        }
        else {
            print("Input text file contains too many or not enough values for a variable.")
            exit(EXIT_FAILURE)
        }
    }

    /// if an author wasn't specified, use the system's username
    if !foundUserName {
        userName = getUserName()
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
        print("\(inputFileName) : No such file or directory\n")
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
    
    
    cStruct1 += "/** \n"
    
    for line in structComment {
        cStruct1 += " * \(line) \n"
    }
    
    cStruct1 += " */ \n" +
        
        "struct \(data.wb) \n" +
        "{ \n"
    
    for i in 0...inputData.count-1 {
        
        cStruct1 += "    /** \(inputData[i].varComment) */ \n"
        
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
    "#include \"gusimplewhiteboard.h\" \n" +
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
        
        /// if the variable is an array                    // ****** tidy up all the !first  ************
        if inputData[i].varArraySize > 0 {
        
            if first {
                cText += "\n"
            }
            else {
                cText += "    len = gu_strlcat(descString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                "    { \n"
            }
            
            
            if !first {
                cText += "    "
            }
            
            cText += "    len = gu_strlcat(descString, \"\(inputData[i].varName)={\", bufferSize); \n"
            
            if !first {
                cText += "    } \n\n"
            }
                
            cText += "    int \(inputData[i].varName)_first = 0; \n\n" +
                "    for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                "    { \n"  +
                "        if (len < bufferSize) \n" +
                "        { \n" +
                "            if (\(inputData[i].varName)_first == 1) \n" +
                "            { \n" +
                "                len = gu_strlcat(descString, \",\", bufferSize); \n" +
                "            } \n"
            
            if inputData[i].varType == "bool" {
                cText += "            gu_strlcat(descString, \(inputData[i].varName)[i] ? \"true\" : \"false\", bufferSize); \n"
            }
            else {
                cText += "            snprintf(descString+len, bufferSize-len, \"\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName)[i]); \n"
            }
            
            cText += "        } \n" +
                "        \(inputData[i].varName)_first = 1; \n" +
                "    } \n"  +
                "    gu_strlcat(descString, \"}\", bufferSize); \n\n"
            
            first = false
        }
        
        
        
        // if the variable is a bool
        else if inputData[i].varType == "bool" {
            
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
            
            cText += "    gu_strlcat(descString, \(inputData[i].varName) ? \"true\" : \"false\", bufferSize); \n"
            
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
                    cText += "    len = gu_strlcat(descString, \", \", bufferSize); \n\n"
                }
                
                if !first {
                    cText += "    if (len < bufferSize) \n" +
                             "    { \n    "
                }
                
                cText += "    snprintf(descString+len, bufferSize-len, \"\(inputData[i].varName)=\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName)); \n"
                
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
        
        /// if the variable is an array                    // ****** tidy up all the !first  ************
        if inputData[i].varArraySize > 0 {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "    len = gu_strlcat(descString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                "    { \n"
            }
            
            
            if !first {
                cText += "    "
            }
            
            cText += "    len = gu_strlcat(descString, \"{\", bufferSize); \n"
            
            if !first {
                cText += "    } \n\n"
            }
            
            cText += "    int \(inputData[i].varName)_first = 0; \n\n" +
                "    for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                "    { \n"  +
                "        if (len < bufferSize) \n" +
                "        { \n" +
                "            if (\(inputData[i].varName)_first == 1) \n" +
                "            { \n" +
                "                len = gu_strlcat(descString, \",\", bufferSize); \n" +
            "            } \n"
            
            if inputData[i].varType == "bool" {
                cText += "            gu_strlcat(descString, \(inputData[i].varName)[i] ? \"true\" : \"false\", bufferSize); \n"
            }
            else {
                cText += "            snprintf(descString+len, bufferSize-len, \"\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName)[i]); \n"
            }
            
            cText += "        } \n" +
                "        \(inputData[i].varName)_first = 1; \n" +
                "    } \n"  +
            "    gu_strlcat(descString, \"}\", bufferSize); \n\n"
            
            first = false
        }
        
        // if the variable is a bool
        else if inputData[i].varType == "bool" {
            
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
            
            cText += "    snprintf(toString+len, bufferSize-len, \"\(variables[inputData[i].varType]!.format)\", \(inputData[i].varName)); \n"
            
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
        
        "            tokenE = strchr(tokenS, e); \n\n" +
        
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
    
    var firstArray = true
    
    for i in 0...inputData.count-1 {
        
        /// if the variable is an array
        if inputData[i].varArraySize > 0 {
        
            if firstArray {
                cText += "    const char a[2] = \",\"; \n\n"
                firstArray = false
            }
            
            cText += "    char \(inputData[i].varName)_output[GU_SIMPLE_WHITEBOARD_BUFSIZE];\n" +
                     "    memset(\(inputData[i].varName)_output, 0, sizeof(\(inputData[i].varName)_output)); \n\n" +
            
                     "    size_t \(inputData[i].varName)_input_length = strlen(strings[\(i)]); \n\n" +
            
                     "    if (\(inputData[i].varName)_input_length > 0) \n" +
                     "        strcpy(\(inputData[i].varName)_output, ++strings[\(i)]]);          // remove the { \n\n" +
                     "    if (\(inputData[i].varName)_input_length > 1) \n" +
                     "        array16_output[\(inputData[i].varName)_input_length-2] = \"/0\";  // remove the } \n\n"
            
            cText += "    size_t \(inputData[i].varName)_smallest = (strlen(\(inputData[i].varName)_output)+1)/2 < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE ? (strlen(array16_output)+1)/2 : \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; \n\n" +
            
                     "    for (int i = 0; i < \(inputData[i].varName)_smallest; i++) \n" +
                     "    { \n" +
                     "        char* token = strchr(\(inputData[i].varName)_output, a); \n" +
                     "        if (token != NULL) \n" +
                     "            set_\(inputData[i].varName)((\(inputData[i].varType))\(variables[inputData[i].varType]!.converter)(token, i); \n" +
                     "    } \n\n"
        
        }
        else if inputData[i].varType == "bool" {
            
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
        "#endif \n\n" +
        "#include <gu_util.h> \n" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard \n" +
        "{\n" +
        
        "    /** \n"
    
    for line in structComment {
        cppStruct += "     * \(line) \n"
    }
    
    cppStruct += "     */ \n" +
        
            "    class \(data.cpp): public \(data.wb) \n" +
            "    { \n\n" +
        
            "        /** Default constructor */ \n" +
            "        \(data.cpp)() : "
    
    var memsetForArrays : [String] = []
    var memcpyForArrays : [String] = []
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            let defaultValue = inputData[i].varDefault == "" ? setDefault(inputData[i].varType) : inputData[i].varDefault
            cppStruct += "_\(inputData[i].varName)(\(defaultValue))"
        }
        else {   // an array
 
            let defaultValue = inputData[i].varDefault == "" ? " " : inputData[i].varDefault  // String((inputData[i].varDefault).characters.dropFirst().dropLast())
            cppStruct += "_\(inputData[i].varName)(\(defaultValue))"
            
            if defaultValue == " " {
                
                print("Unspecified array of type \(inputData[i].varType) set to all: \(variables[inputData[i].varType]!.defaultValue).")
                memsetForArrays.append("memset(\(inputData[i].varName), \(variables[inputData[i].varType]!.defaultValue), \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE)")
            }
            
            memcpyForArrays.append("memcpy(\(inputData[i].varName), &other, sizeof(\(data.wb)))")
        }
        
        if i < inputData.count-1 {
            cppStruct += ", "
        }
    }
    
    if memsetForArrays.count == 0 {
        cppStruct += " {} \n\n"
    }
    else {
        cppStruct += "\n        { \n"
        
        for mem in memsetForArrays {
            cppStruct += "            \(mem); \n"
        }
        cppStruct += "        } \n\n"
    }
    
    cppStruct += "        /** Copy Constructor */ \n" +
    "        \(data.cpp)(const \(data.wb) &other) : \n"
    
    var first = true
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            
            if !first {
                cppStruct += ", \n"
            }
            
            cppStruct += "            _\(inputData[i].varName)(other._\(inputData[i].varName))"
            first = false
        }
    }
    
    if memcpyForArrays.count == 0 {
        cppStruct += " {} \n\n"
    }
    else {
        
        cppStruct += "\n        { \n"
        
        for mem in memcpyForArrays {
            cppStruct += "            \(mem); \n"
        }
    }

    cppStruct += "        } \n\n" +
        
        "        /** Assignment Operator */ \n" +
        "        \(data.cpp) &operator= (const \(data.wb) &other) \n" +
        "        { \n"
    
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            cppStruct += "            _\(inputData[i].varName) = other._\(inputData[i].varName); \n"
        }
    }
    
    for mem in memcpyForArrays {
        cppStruct += "            \(mem); \n"
    }
    
    cppStruct += "            return *this; \n" +
                "        } \n\n" +
        
                "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
                "        std::string description() \n" +
                "        { \n" +
                "#ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
                "            char buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
                "            \(data.wb)_description (this, buffer, sizeof(buffer)); \n" +
                "            std::string descr = buffer; \n" +
                "            return descr; \n" +
                "#else \n" +
        
                "            std::string description() const \n" +
                "            { \n" +
                "                std::ostringstream ss; \n"
    
                first = true
    
                for i in 0...inputData.count-1 {
                    
                    if !first {
                        cppStruct += "                ss << \", \"; \n"
                    }
                    
                    if inputData[i].varArraySize == 0 {
                    
                        cppStruct += "                ss << \"\(inputData[i].varName)=\" << \(inputData[i].varName); \n"
                    }
                    else {
                        
                        cppStruct += "\n                bool \(inputData[i].varName)_first = true; \n"
                            
                        cppStruct += "                ss << \"\(inputData[i].varName)=\"; \n" +
                        
                            "                for (size_t i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE-1; i++) \n" +
                            "                { \n" +
                        
                            "                    ss << (\(inputData[i].varName)_first ? \"\" : \",\") << \(inputData[i].varName)[i]; \n" +
                            "                    \(inputData[i].varName)_first = false;  \n" +
                            "                } \n"

                    }
                    first = false
                }

                cppStruct += "\n                return ss.str(); \n" +
                    
                "            } \n" +
    
                "#endif /// USE_WB_\(data.caps)_C_CONVERSION\n" +
                "        } \n" +
                "#endif ///   WHITEBOARD_POSTER_STRING_CONVERSION\n" +
    
                "    }; \n"
                    
    if classAlias != "" {
        cppStruct += "/// \n" +
            "/// Alias for compatibility with old code. \n" +
            "/// Do not use for new code. \n" +
            "/// \n" +
            "class \(classAlias) : public \(data.cpp) {}; \n"
    }
    
    cppStruct += "} /// namespace guWhiteboard \n"

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
    return size + 1
}



