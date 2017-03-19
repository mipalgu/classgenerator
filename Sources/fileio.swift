//
//  FileIO.swift
//  classgenerator
//
//  Created by Mick Hawkins on 15/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//  
//  Parses the input file to identify the variables.
//  Creates the generated files.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif



/// globals for use in file reading and output
let fileSize = 4096
var classAlias : String = ""
var structComment : [String] = []
var foundVariables : [String] = []



///
/// Return the length of the given file or `nil` if an error occurred
///
func file_len(_ fn: CInt) -> Int? {
    let offs = lseek(fn, 0, SEEK_CUR)
    guard offs >= 0 else { return nil }
    defer { lseek(fn, offs, SEEK_SET) }
    let len = lseek(fn, 0, SEEK_END)
    guard len >= 0 else { return nil }
    return Int(len)
}


/// memory map the given file with the given protection and flags,
/// then call the `process` function with the memory address of the
/// mapped file
///
/// - parameter file:       name of the file to read
/// - parameter protection: memory map protection (read/write)
/// - parameter flags:      map privately or publicly
/// - parameter process:    function/closure to process the data
///
/// - returns: an instance of T if successful or nil otherwise
func with_mmap<T>(_ file: String, protection: Int32 = PROT_READ, flags: Int32 = MAP_PRIVATE, process: (UnsafeMutableRawPointer, Int) -> T) -> T? {
    let fn = open(file, O_RDONLY)
    guard fn >= 0 else {
        if errno != ENOENT {
            perror("Cannot open '\(file)'")
        }
        return nil
    }
    defer { close(fn) }
    guard let len = file_len(fn) else {
        perror("Cannot get length of '\(file)'")
        return nil
    }
    guard let mem = mmap(nil, len, protection, flags, fn, 0),
        mem != UnsafeMutableRawPointer(bitPattern: -1) else {
            perror("Cannot mmap \(len) bytes for '\(file)'")
            return nil
    }
    defer { munmap(mem, len) }
    return process(mem, len)
}


extension String {
    /// Read the contents of a UTF-8 encoded file into a string
    ///
    /// - parameter file: name of the file to read
    ///
    /// - returns: file content as a string
    static func from(file: String) -> String? {
        return with_mmap(file) { (mem, len) -> String in
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: len+1)
            defer { buffer.deallocate(capacity: len+1) }
            let buf = mem.assumingMemoryBound(to: CChar.self)
            buffer.initialize(from: buf, count: len)
            buffer[len] = 0
            return String(cString: buffer)
        }
    }
}

/**
 * This function take the contents of a file as a single string
 * and parses to find the variables, comments, author and alias.
 * If an authour is not specified, the system's user name is returned.
 * @param inputText is the text of the input file
 * @return Returns the author's name
 */
func parseInput(_ inputText: String) -> String {
    
    var foundUserName = false
    var userName : String = ""
    var foundReturn = false
    var commentPosition : Int = 0
    
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
            commentPosition += 1
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
            
                let inputVar = inputVariable(varType: trim(varType), varName: trim(varName), varDefault: trim(varDefault), varComment: trim(varComment), varArraySize: varArraySize)
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

/**
 *  Remove newlines, tabs and spaces from a string.
 */
func trim(_ str: String) -> String {
    return String(str.characters.filter { $0 != "\n" && $0 != "\t" && $0 != " " })
}


/**
 * If a default value was not specified for the variable, this
 * function retrieves the default value from the dictionary.
 * @param varType is the type of variable
 * @return Returns the default value as a string
 */
func setDefault(_ varType: String) -> String {
    
    if let defaultValue = variables[varType]?.defaultValue {
        print ("Unspecified \(varType) set to default value of: \(defaultValue)")
        return defaultValue
    }
    else {
        print ("Unknown type \(varType) set to default value of: \"ADD DEFAULT\"")
        return "ADD DEFAULT"
    }
}

/// Reads the content of a text file.
///
/// - parameter inputFileName: filename (including path) of the file to read
///
/// - returns: contents of the file as a single string
func readVariables(_ inputFileName: String) -> String {
    guard let contents = String.from(file: inputFileName) else {
        exit(EXIT_FAILURE)
    }
    return contents
}



/**
 * This function generates the text to comprise a whiteboard C header file
 * @param data is an object containing information about the class to generate
 * @return A string which will become the C header file
 */
func generateWbHeader(_ data: ClassData) -> String {
    
    let toStringBufferSize = getToStringBufferSize()
    let descriptionBufferSize = getDescriptionBufferSize(toStringBufferSize)
    let preamble: String
    if let preambleContent = String.from(file: data.preambleFile) {
        preamble = preambleContent + "\n\n"
    } else {
        preamble = ""
    }

    var cStruct1 = "#ifndef \(data.wb)_h \n" +
        "#define \(data.wb)_h \n\n" +
        "#include \"gu_util.h\" \n\n"

    if let _ = inputData.lazy.filter({requiresStdInt($0.varType)}).first {
       cStruct1 += "#include <stdint.h> \n\n"
    }

    cStruct1 += preamble +
        "#define \(data.caps)_NUMBER_OF_VARIABLES \(inputData.count) \n\n" +
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#define \(data.caps)_DESC_BUFFER_SIZE \(descriptionBufferSize) \n" +
        "#define \(data.caps)_TO_STRING_BUFFER_SIZE \(toStringBufferSize) \n" +
        "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION \n\n"
    
    for i in 0...inputData.count-1 {
        if inputData[i].varArraySize > 0 {
            cStruct1 += "#define \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE \(inputData[i].varArraySize) \n"
        }
    }
    
    
    cStruct1 += "\n/** \n"
    
    for line in structComment {
        cStruct1 += " * \(line) \n"
    }
    
    cStruct1 += " */ \n" +
        
        "struct \(data.wb) \n" +
        "{ \n"
    
    for i in 0...inputData.count-1 {
        
        cStruct1 += "    /** \(inputData[i].varComment) */ \n"
        
        if inputData[i].varArraySize == 0 {  // not an array
            cStruct1 += "    PROPERTY(\(inputData[i].varType), \(inputData[i].varName)) \n\n"
        }
        else {
            cStruct1 += "    ARRAY_PROPERTY(\(inputData[i].varType), \(inputData[i].varName), \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE)\n\n"
        }
    }
    
    cStruct1 += "}; \n\n"
    
    cStruct1 += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description(const struct \(data.wb)* self, char* descString, size_t bufferSize); \n\n" +
        "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string(const struct \(data.wb)* self, char* toString, size_t bufferSize); \n\n" +
        "/** convert from a string */  \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str); \n" +
        "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION \n\n" +
    
    
        "#endif /// \(data.wb)_h \n"
    
    return cStruct1
}

func requiresStdInt(_ v: String) -> Bool {
    return v == "int8_t" || v == "uint8_t"
        || v == "int16_t" || v == "uint16_t"
        || v == "int32_t" || v == "uint32_t"
        || v == "int64_t" || v == "uint64_t"
}



/**
 * This function generates the text to comprise a whiteboard C .c file
 * @param data is an object containing information about the class to generate
 * @return A string which will become the C .c file
 */
func generateWbC(_ data: ClassData) -> String {
    
    var cText = "#define WHITEBOARD_POSTER_STRING_CONVERSION\n" +
    "#include \"\(data.wb).h\" \n" +
//    "#include <gu_util.h> \n" +
    "#include <stdio.h> \n" +
    "#include <string.h> \n" +
    "#include <stdlib.h> \n\n"
    
    
    // create description() method
    cText += "/** convert to a description string */  \n" +
        "const char* \(data.wb)_description(const struct \(data.wb)* self, char* descString, size_t bufferSize) \n" +
    "{\n"
    
    if inputData.count > 0 {
        cText += "#pragma clang diagnostic push\n"
        cText += "#pragma clang diagnostic ignored \"-Wunused-variable\"\n"
        cText += "    size_t len = 0; \n"
    }
    
    
    var first = true
    
    for i in 0...inputData.count-1 {
        
        /// if the variable is an array
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
                cText += "            gu_strlcat(descString, self->\(inputData[i].varName)[i] ? \"true\" : \"false\", bufferSize); \n"
            } else if let varInfo = variables[inputData[i].varType] {
                cText += "            snprintf(descString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(varInfo.format)\", self->\(inputData[i].varName)[i]); \n"
            } else { // FIXME: structs/classes need to use their description function
                cText += "            snprintf(descString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"%p\", self->\(inputData[i].varName)[i]); \n"
            }
            
            cText += "        } \n" +
                "        \(inputData[i].varName)_first = 1; \n" +
                "    } \n"  +
                "    gu_strlcat(descString, \"}\", bufferSize); \n\n"
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
            
            cText += "    gu_strlcat(descString, self->\(inputData[i].varName) ? \"true\" : \"false\", bufferSize); \n"
            
            if !first {
                cText += "    } \n\n"
            }
        } else if let varInfo = variables[inputData[i].varType] { // if the variable is a number type
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
                
                cText += "    snprintf(descString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(inputData[i].varName)=\(varInfo.format)\", self->\(inputData[i].varName)); \n"
                
                if !first {
                    cText += "    } \n\n"
                }
                
        } else if let varInfo = variables["int"],
                inputData[i].varType.substring(before: " ") == "enum" { // if the variable is an enum
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

            cText += "    snprintf(descString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(inputData[i].varName)=\(varInfo.format)\", self->\(inputData[i].varName)); \n"

            if !first {
                cText += "    } \n\n"
            }

        }

        first = false

    }


    cText += "\treturn descString; \n" +
    "} \n\n"
    
    
    // create to_string method
    cText += "/** convert to a string */  \n" +
        "const char* \(data.wb)_to_string(const struct \(data.wb)* self, char* toString, size_t bufferSize) \n" +
        "{ \n"
    
    if inputData.count > 0 {
        cText += "#pragma clang diagnostic push\n"
        cText += "#pragma clang diagnostic ignored \"-Wunused-variable\"\n"
        cText += "    size_t len = 0; \n"
    }
    
    first = true
    
    for i in 0...inputData.count-1 {
        
        /// if the variable is an array
        if inputData[i].varArraySize > 0 {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "    len = gu_strlcat(toString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                "    { \n"
            }
            
            
            if !first {
                cText += "    "
            }
            
            cText += "    len = gu_strlcat(toString, \"{\", bufferSize); \n"
            
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
                "                len = gu_strlcat(toString, \",\", bufferSize); \n" +
            "            } \n"
            
            if inputData[i].varType == "bool" {
                cText += "            gu_strlcat(toString, self->\(inputData[i].varName)[i] ? \"true\" : \"false\", bufferSize); \n"
            } else if let varInfo = variables[inputData[i].varType] {
                cText += "            snprintf(toString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(varInfo.format)\", self->\(inputData[i].varName)[i]); \n"
            } else { // FIXME: structs/classes need to use their description function
                cText += "            snprintf(toString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"%p\", self->\(inputData[i].varName)[i]); \n"
            }
            
            cText += "        } \n" +
                "        \(inputData[i].varName)_first = 1; \n" +
                "    } \n"  +
            "    gu_strlcat(toString, \"}\", bufferSize); \n\n"
            
            first = false
        }
        
        // if the variable is a bool
        else if inputData[i].varType == "bool" {
            
            if first {
                cText += "\n"
            }
            else {
                cText += "    gu_strlcat(toString, \", \", bufferSize); \n\n"
            }
            
            if !first {
                cText += "    if (len < bufferSize) \n" +
                         "    { \n    "
            }
            
            cText += "    gu_strlcat(toString, self->\(inputData[i].varName) ? \"true\" : \"false\", bufferSize); \n\n"
            
            if !first {
                cText += "    } \n\n"
            }
        } else if let varInfo = variables[inputData[i].varType] { // if the variable is a number type
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

            cText += "    snprintf(toString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(inputData[i].varName)=\(varInfo.format)\", self->\(inputData[i].varName)); \n"

            if !first {
                cText += "    } \n\n"
            }

        } else if let varInfo = variables["int"],
            inputData[i].varType.substring(before: " ") == "enum" { // if the variable is an enum
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

            cText += "    snprintf(toString\(first ? "" : "+len"), bufferSize\(first ? "" : "-len"), \"\(inputData[i].varName)=\(varInfo.format)\", self->\(inputData[i].varName)); \n"
            
            if !first {
                cText += "    } \n\n"
            }
        }
        first = false
    }
    cText += "    return toString; \n" +
    "} \n\n"

    // create from_string method
    cText += "/** convert from a string */  \n" +
        "struct \(data.wb)* \(data.wb)_from_string(struct \(data.wb)* self, const char* str) \n" +
        "{ \n"
    
    cText += "    char* strings[\(data.caps)_NUMBER_OF_VARIABLES]; \n" +
        "    memset(strings, 0, sizeof(strings)); \n" +
        "    char* saveptr; \n" +
        "    int count = 0; \n\n" +
        "    char* str_copy = gu_strdup(str); \n\n"
    
    
    var firstArray = true
    var thereAreArrays = false
    
    for i in 0...inputData.count-1 {
        
        /// if the variable is an array
        if inputData[i].varArraySize > 0 {
            
            thereAreArrays = true
            
            if firstArray {
                cText += "    int isArray = 0; \n\n"
                firstArray = false
            }
            
            cText += "    char* \(inputData[i].varName)_values[\(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE]; \n" +
            
            "    int \(inputData[i].varName)_count = 0; \n" +
            "    int is_\(inputData[i].varName) = 1; \n\n"
        }
    }

    cText += "    const char s[2] = \",\";   /// delimeter \n" +
        "    const char e = '=';      /// delimeter \n"
    
    if thereAreArrays {
        cText += "    const char b1 = '{';    /// delimeter \n" +
            "    const char b2 = '}';    /// delimeter \n" +
            "    char* tokenS, *tokenE, *tokenB1, *tokenB2; \n\n"
    }
    else {
        cText += "    char* tokenS, *tokenE; \n\n"
    }
        
    cText +=
        "    tokenS = strtok_r(str_copy, s, &saveptr); \n\n" +
    
        
        "    while (tokenS != NULL) \n" +
        "    { \n" +
        "        tokenE = strchr(tokenS, e); \n\n" +
        
        "        if (tokenE == NULL) \n" +
        "        { \n " +
        "            tokenE = tokenS; \n" +
        "        } \n" +
        "        else \n" +
        "        { \n " +
        "            tokenE++; \n" +
        "        } \n\n"
    
    firstArray = true
    
    if thereAreArrays {
        cText += "        tokenB1 = strchr(gu_strtrim(tokenE), b1); \n\n" +
    
        "        if (tokenB1 == NULL) \n" +
        "        { \n" +
        "            tokenB1 = tokenE; \n" +
        "        } \n" +
        "        else \n" +
        "        { \n" +
        "            // start of an array \n" +
        "            tokenB1++; \n" +
        "            isArray = 1; \n" +
        "        } \n\n" +
        
        "        if (isArray) \n" +
        "        { \n" +
        "            tokenB2 = strchr(gu_strtrim(tokenB1), b2); \n"
        
        for i in 0...inputData.count-1 {
            
            /// if the variable is an array
            if inputData[i].varArraySize > 0 {
                if !firstArray {
                    cText += "            else "
                }
                else {
                    cText += "            "
                }
                
                firstArray = false
                
                cText += "if (is_\(inputData[i].varName) == 1) \n" +
                        "            { \n" +
                        "                if (tokenB2 != NULL) \n" +
                        "                { \n" +
                        "                    tokenB1[strlen(tokenB1)-1] = 0; \n" +
                        "                    is_\(inputData[i].varName) = 0; \n" +
                        "                    isArray = 0; \n" +
                        "                    count++; \n" +
                        "                } \n\n" +
                    
                        "                \(inputData[i].varName)_values[\(inputData[i].varName)_count] = gu_strtrim(tokenB1); \n" +
                        "                \(inputData[i].varName)_count++; \n" +
                        "            } \n"
            }
        }
        
    
    cText += "        } \n" +
            "        else \n" +
            "        { \n" +
            "            strings[count] = gu_strtrim(tokenE); \n" +
            "            count++; \n" +
            "        } \n\n"
    }
    else {
        cText += "        strings[count] = gu_strtrim(tokenE); \n\n"
    }
    
    if !thereAreArrays {
        
        cText += "        count++; \n"
    }
    
    cText += "        tokenS = strtok_r(NULL, s, &saveptr); \n" +
            "    } \n\n"
    
    
    for i in 0...inputData.count-1 {
        
        /// if the variable is an array
        if inputData[i].varArraySize > 0 {
            
            cText += "    size_t \(inputData[i].varName)_smallest = \(inputData[i].varName)_count < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE ? \(inputData[i].varName)_count : \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; \n\n" +
            
            "    for (int i = 0; i < \(inputData[i].varName)_smallest; i++) \n" +
            "    { \n"
            
            if inputData[i].varType == "bool" {   /// array of bools... does not need a cast
                cText += "            self->\(inputData[i].varName)[i] = strcmp(\(inputData[i].varName)_values[i], \"true\") == 0  || strcmp(\(inputData[i].varName)_values[i], \"1\") == 0 ? true : false; \n"
            } else if let varInfo = variables[inputData[i].varType] {
                cText += "       self->\(inputData[i].varName)[i] = (\(inputData[i].varType))\(varInfo.converter)(\(inputData[i].varName)_values[i]); \n"
            } else if inputData[i].varType.substring(before: " ") == "struct" {
                guard let name_without_struct = inputData[i].varType.substring(after: " ") else {
                    cText += "/* \(inputData[i].varType) is funny, giving up */\n"
                    continue
                }
                cText += "       self->\(inputData[i].varName)[i] = (\(inputData[i].varType))*\(name_without_struct)_from_string(&self->\(inputData[i].varName)[i], \(inputData[i].varName)_values[i]); \n"
            } else {
                cText += "       self->\(inputData[i].varName)[i] = (\(inputData[i].varType))(\(inputData[i].varName)_values[i]); \n"
            }
            cText += "    } \n\n"
        } else if let varInfo = variables[inputData[i].varType] { // if the variable is a number type
            cText += "    if (strings[\(i)] != NULL) \n"

            if inputData[i].varType == "bool" {

                cText += "       self->\(inputData[i].varName) = strcmp(strings[\(i)], \"true\") == 0  || strcmp(strings[\(i)], \"1\") == 0 ? true : false; \n\n"
            }
            else {
                cText += "       self->\(inputData[i].varName) = (\(inputData[i].varType))\(varInfo.converter)(strings[\(i)]); \n\n"
            }
        } else if let varInfo = variables["int"],
            inputData[i].varType.substring(before: " ") == "enum" { // if the variable is an enum
            cText += "    if (strings[\(i)] != NULL) \n"

            if inputData[i].varType == "bool" {

                cText += "       self->\(inputData[i].varName) = strcmp(strings[\(i)], \"true\") == 0  || strcmp(strings[\(i)], \"1\") == 0 ? true : false; \n\n"
            }
            else {
                cText += "       self->\(inputData[i].varName) = (\(inputData[i].varType))\(varInfo.converter)(strings[\(i)]); \n\n"
            }
        }
    }
    
    cText += "    free(str_copy); \n\n" +
        "    return self; \n" +
        "}; \n"
    
    return cText
}



/**
* This function generates the text to comprise a whiteboard C++ wrapper file
* @param data is an object containing information about the class to generate
* @return A string which will become the C++ wrapper file
*/
func generateCPPStruct(_ data: ClassData) -> String {
    
    var cppStruct = "#ifndef \(data.cpp)_DEFINED \n" +
        
        "#define \(data.cpp)_DEFINED \n\n" +
        
        "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n" +
        "#include <cstdlib> \n" +
        "#include <string.h> \n" +
        "#include <sstream> \n" +
        "#endif \n\n" +
        "#include \"\(data.wb).h\" \n\n" +
        
        "namespace guWhiteboard \n" +
        "{\n" +
        
        "    /** \n"
    
    for line in structComment {
        cppStruct += "     * \(line) \n"
    }
    
    cppStruct += "     */ \n" +
        
            "    class \(data.cpp): public \(data.wb) \n" +
            "    { \n" +
            "    public:\n" +
            "        /** Constructor */ \n" +
            "        \(data.cpp)("
            
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {   // not an array
            
            let defaultValue = inputData[i].varDefault == "" ? setDefault(inputData[i].varType) : inputData[i].varDefault
            if i > 0 {
                cppStruct += ", "
            }
            cppStruct += "\(inputData[i].varType) \(inputData[i].varName) = \(defaultValue)"
            
        }
        else {   // an array
           
           //  do nothing, not including arrays as parameters... yet
        }
        
    }
            cppStruct += ")\n" +
            "        { \n"
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {  // not an array

            cppStruct += "            set_\(inputData[i].varName)(\(inputData[i].varName)); \n"
            
        }
        else {   // an array
            
            // no defaults for arrays
            if inputData[i].varDefault == "" {
                if let arrayDefault = variables[inputData[i].varType]?.defaultValue {
                    print("Unspecified array of type \(inputData[i].varType) set to all: \(arrayDefault)")
                    for j in 0...inputData[i].varArraySize-1 {
                        cppStruct += "            set_\(inputData[i].varName)(\(arrayDefault), \(j)); \n"
                    }
                }
            }
            // use defaults specified for arrays
            else {
                
                let defaultString = String((inputData[i].varDefault).characters.dropFirst().dropLast())  // remove braces
                let defaults = defaultString.characters.split {$0 == ","}.map { String($0) }

                for j in 0...inputData[i].varArraySize-1 {
                    cppStruct += "            set_\(inputData[i].varName)(\(defaults[j]), \(j)); \n"
                }
                
            }

        }
        
    }
    

    cppStruct += "        } \n\n"
    

    cppStruct += "        /** Copy Constructor */ \n" +
    "        \(data.cpp)(const \(data.cpp) &other) : \(data.wb)() \n" +
    "        { \n"

    for i in 0...inputData.count-1 {
    
        if inputData[i].varArraySize == 0 {
            
            cppStruct += "            set_\(inputData[i].varName)(other.\(inputData[i].varName)()); \n"
        }
        else {   // an array
        
            for j in 0...inputData[i].varArraySize-1 {
                
                cppStruct += "            set_\(inputData[i].varName)(other.\(inputData[i].varName)(\(j)), \(j)); \n"
            }
        }
    }
    
    
    cppStruct += "        } \n\n"
    
    
    cppStruct += "        /** Copy Assignment Operator */ \n" +
        "        \(data.cpp) &operator = (const \(data.cpp) &other) \n" +
        "        { \n"
    
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            
            cppStruct += "            set_\(inputData[i].varName)(other.\(inputData[i].varName)()); \n"
        }
        else {   // an array
            
            for j in 0...inputData[i].varArraySize-1 {
                
                cppStruct += "            set_\(inputData[i].varName)(other.\(inputData[i].varName)(\(j)), \(j)); \n"
            }
        }
    }
    
    cppStruct += "            return *this; \n" +
                "        } \n\n" +
                "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION \n"

    cppStruct += "        /** String Constructor */ \n" +
    "        \(data.cpp)(const std::string &str) { from_string(str.c_str()); }  \n\n"

     cppStruct += "        std::string description() \n" +
                "        { \n" +
                "#ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
                "            char buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
                "            \(data.wb)_description(this, buffer, sizeof(buffer)); \n" +
                "            std::string descr = buffer; \n" +
                "            return descr; \n" +
                "#else \n" +
        
                "            std::ostringstream ss; \n"
    
                var first = true
    
                for i in 0...inputData.count-1 {
                    
                    if !first {
                        cppStruct += "            ss << \", \"; \n"
                    }
                    
                    // not an array
                    if inputData[i].varArraySize == 0 {
                    
                        cppStruct += "            ss << \"\(inputData[i].varName)=\" << \(inputData[i].varName)(); \n"
                    }
                    // an array
                    else if let _ = variables[inputData[i].varType] {

                        cppStruct += "\n            bool \(inputData[i].varName)_first = true; \n"
                        
                        cppStruct += "            ss << \"\(inputData[i].varName)={\"; \n" +
                        
                            "            for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                            "            { \n" +
                        
                            "                ss << (\(inputData[i].varName)_first ? \"\" : \",\") << \(inputData[i].varName)(i); \n" +
                            "                \(inputData[i].varName)_first = false;  \n" +
                            "            } \n"
                        cppStruct += "            ss << \"}\"; \n"

                    } else { do {
                        let type = inputData[i].varType
                        guard let cppType = type.substring(after: "_")?.cpp else { break }

                        cppStruct += "\n            bool \(inputData[i].varName)_first = true; \n"
                        
                        cppStruct += "            ss << \"\(inputData[i].varName)={\"; \n" +
                            
                            "            for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                            "            { \n" +
                            
                            "                ss << (\(inputData[i].varName)_first ? \"\" : \",\") << static_cast<\(cppType) *>(&\(inputData[i].varName)(i))->description(); \n" +
                            "                \(inputData[i].varName)_first = false;  \n" +
                        "            } \n"
                        cppStruct += "            ss << \"}\"; \n"
                        
                        } }
                    first = false
                }

                cppStruct += "\n            return ss.str(); \n\n" +
    
                "#endif /// USE_WB_\(data.caps)_C_CONVERSION\n" +
                "        } \n\n"
    
    
    cppStruct += "        std::string to_string() \n" +
        "        { \n" +
        "#ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
        "            char buffer[\(data.caps)_DESC_BUFFER_SIZE]; \n" +
        "            \(data.wb)_to_string(this, buffer, sizeof(buffer)); \n" +
        "            std::string toString = buffer; \n" +
        "            return toString; \n" +
        "#else \n" +
   "            std::ostringstream ss; \n"
   // "var = [^,]" 
    first = true
    
    for i in 0...inputData.count-1 {
        
        if !first {
            cppStruct += "            ss << \", \"; \n"
        }
        
        // not an array
        if inputData[i].varArraySize == 0 {
            
            cppStruct += "            ss << \(inputData[i].varName)(); \n"
        }
            // an array
        else if let _ = variables[inputData[i].varType] {

            cppStruct += "\n            bool \(inputData[i].varName)_first = true; \n"
            
            cppStruct += "            ss << \"{\"; \n" +
                
                "            for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                "            { \n" +
                
                "                ss << (\(inputData[i].varName)_first ? \"\" : \",\") << \(inputData[i].varName)(i); \n" +
                "                \(inputData[i].varName)_first = false;  \n" +
                "            } \n"
            cppStruct += "            ss << \"}\"; \n"
            
        } else { do {
            let type = inputData[i].varType
            guard let cppType = type.substring(after: "_")?.cpp else { break }

            cppStruct += "\n            bool \(inputData[i].varName)_first = true; \n"

            cppStruct += "            ss << \"\(inputData[i].varName)={\"; \n" +

                "            for (int i = 0; i < \(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE; i++) \n" +
                "            { \n" +

                "                ss << (\(inputData[i].varName)_first ? \"\" : \",\") << static_cast<\(cppType) *>(&\(inputData[i].varName)(i))->to_string(); \n" +
                "                \(inputData[i].varName)_first = false;  \n" +
            "            } \n"
            cppStruct += "            ss << \"}\"; \n"

            } }
        first = false
    }

    cppStruct += "\n            return ss.str(); \n\n" +

        "#endif /// USE_WB_\(data.caps)_C_CONVERSION\n" +
        "        } \n\n"



    cppStruct += "        void from_string(const std::string &str) \n" +
        "        { \n" +
        "#ifdef USE_WB_\(data.caps)_C_CONVERSION \n" +
        "            \(data.wb)_from_string(this, str); \n" +
        
        "#else \n" +
    
////
    "            char var[100]; \n"
    for i in 0...inputData.count-1 {
        
            cppStruct += "" +
    "            unsigned long \(inputData[i].varName)_index = str.find(\"\(inputData[i].varName)\");\n" +
    "            if(\(inputData[i].varName)_index != std::string::npos)\n" +
    "            {\n" +
    "                memset(&var[0], 0, sizeof(var));\n" +
    "                if(sscanf(str.substr(\(inputData[i].varName)_index, str.length()).c_str(), \"\(inputData[i].varName) = %[^,]\", var) == 1)\n" +
    "                {\n" +
    "                    std::string value = std::string(var);\n" 
            if inputData[i].varType == "bool" {
                
                cppStruct += "                    set_\(inputData[i].varName)(value.compare(\"true\") == 0  || value.compare(\"1\") == 0 ? true : false); \n"
            } else if let varInfo = variables[inputData[i].varType] { // if the variable is a number type
                cppStruct += "                    set_\(inputData[i].varName)(\(inputData[i].varType)(\(varInfo.converter)(value.c_str()))); \n"
            } else if let varInfo = variables["int"],
                inputData[i].varType.substring(before: " ") == "enum" { // if the variable is an enum
                cppStruct += "                    set_\(inputData[i].varName)(static_cast<\(inputData[i].varType)>(\(varInfo.converter)(value.c_str()))); \n"
            }
            cppStruct += "                } \n" 
            cppStruct += "            } \n\n" 
        }

    
    
    
/////
    
    
    cppStruct +=
        
        "#endif /// USE_WB_\(data.caps)_C_CONVERSION\n" +
    "        } \n"
    
    
    
    
    
    cppStruct += "#endif ///   WHITEBOARD_POSTER_STRING_CONVERSION\n" +
    
                "    }; \n"
    
    if classAlias != "" {
        cppStruct += "/// \n" +
            "/// Alias for compatibility with old code. \n" +
            "/// Do not use for new code. \n" +
            "/// \n" +
            "class \(classAlias) : public \(data.cpp) {}; \n"
    }
    
    cppStruct += "} /// namespace guWhiteboard \n" +
        "#endif /// \(data.cpp)_DEFINED \n"

    return cppStruct
}

func formatFloat(_ str: String) -> String {
    return String(str.characters.filter { $0 != "f" })
}



/**
* This function generates the text to comprise a whiteboard Swiftwrapper file
* @param data is an object containing information about the class to generate
* @return A string which will become the Swift wrapper file
*/
func generateSwiftExtension(_ data: ClassData) -> String {
    
    
    // Add the struct comment
    var swiftExt = "/** \n"
    
    for line in structComment {
        swiftExt += " * \(line) \n"
    }
    
    swiftExt += " */ \n"
    
    
    // Convenience constructor
    swiftExt += "extension \(data.wb) { \n\n" +
    
        "    public init () { \n"
    
    for i in 0...inputData.count-1 {
        
        if inputData[i].varArraySize == 0 {
            var defaultValue = inputData[i].varDefault == "" ? setDefault(inputData[i].varType) : inputData[i].varDefault
            if ("float" == inputData[i].varType || "float_t" == inputData[i].varType) {
                defaultValue = formatFloat(defaultValue)
            }
            swiftExt += "        self.\(inputData[i].varName) = \(defaultValue) \n"
        }
        else {   // an array

            if inputData[i].varDefault == "" {
                if let varInfo = variables[inputData[i].varType] {
                    print("Unspecified array of type \(inputData[i].varType) set to all: \(varInfo.defaultValue)")
                    swiftExt += "        self.\(inputData[i].varName) = \(makeArrayDefault(i)) \n"
                } else {
                    // FIXME: call string constructor for default default values
                }
            }
            else {
                swiftExt += "        self.\(inputData[i].varName) = \(inputData[i].varDefault) \n"
            }
        }
    }
    
    // extension
    swiftExt += "    }\n\n"
    swiftExt += "    public init(fromDictionary dictionary: [String: Any]) {\n"
    for data in inputData {
        swiftExt += "        self.\(data.varName) = dictionary[\"\(data.varName)\"] as! \(variables[data.varType]!.swift)\n"
    }
    swiftExt += "    }\n"
    swiftExt += "}\n\n"
    swiftExt +=
        "extension \(data.wb): CustomStringConvertible { \n\n" +
    
        "/** convert to a description string */  \n" +
        "    public var description: String { \n\n" +
        "        var descString = \"\" \n\n"
    
    // description
    var first = true
    
    for i in 0...inputData.count-1 {
        
        if !first {
            swiftExt += "        descString += \", \" \n"
        }
        
        if inputData[i].varArraySize == 0 {
            
            swiftExt += "        descString += \"\(inputData[i].varName)= \\(\(inputData[i].varName)) \" \n"
        }
        else {
            
            swiftExt += "\n        var \(inputData[i].varName)_first = true \n\n"
            
            swiftExt += "        descString += \"\(inputData[i].varName)={\" \n\n" +
                
                "        for i in 0...\(data.caps)_\(uppercaseWord(inputData[i].varName))_ARRAY_SIZE-1 { \n\n" +
            
                "            descString += \(inputData[i].varName)_first ? \"\" : \",\"\n" +
                "            descString += \"\\(\(inputData[i].varName)[i])\" \n\n" +
                "            \(inputData[i].varName)_first = false  \n" +
                "        } \n\n" +
            
                "        descString += \"}\" \n\n"
        }
        first = false
    }
    
    swiftExt += "        return descString \n" +
        
    "  } \n" +
    "} \n"
    swiftExt += "extension \(data.wb): Equatable {}\n\n"
    swiftExt += "public func ==(lhs: \(data.wb), rhs: \(data.wb)) -> Bool {\n"
    if let first = inputData.first {
        swiftExt += inputData.dropFirst().reduce("    return lhs.\(first.varName) == rhs.\(first.varName)\n") {
            $0 + "        && lhs.\($1.varName) == rhs.\($1.varName)\n"
        }
    } else {
        swiftExt += "    return true\n"
    }
    swiftExt += "}\n"
    
    return swiftExt
}



/**
* This function generates the text to comprise default string for an array
* @param ind is the index of the inputData[] array
* @return A string which is the literal array default
*/
func makeArrayDefault(_ ind: Int) -> String {
    
    var defaultString = "{"
    let data = inputData[ind]
    if let varInfo = variables[data.varType] {
        defaultString += Array(repeating: varInfo.defaultValue, count: data.varArraySize).joined(separator: ",")
    }
    defaultString += "}"

    return defaultString
}



/**
 * Closes an open filestream.
 * @param fileStream is a pointer to an open file stream
 */
func closeFileStream(_ fileStream: UnsafeMutablePointer<FILE>) -> Void {

    if (fclose(fileStream) != 0) {
        perror("Unable to close file\n")
        exit(EXIT_FAILURE)
    }
}





/**
 * This function opens the file streams and writes the whiteboard C files
 * It uses helper functions to generate the content, including the license information
 * @param data is an object containing information about the class to generate
 */
func generateWBFiles(_ data: ClassData) -> Void {

    // make header file
    let headerFilePath = data.workingDirectory + "/" + data.wb + ".h"
    
    // open a filestream for reading
    guard let fsh = fopen( headerFilePath, "w" ) else {
        // file did not open
        print("\(data.wb).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    defer { closeFileStream(fsh) }

    var commentText = getCreatorDetailsCommentWB(data, fileType: ".h")
    let licenseText = getLicense(data)
    
    let headerText =  commentText + licenseText + generateWbHeader(data)   // generate the header file content
    
    guard fputs(headerText, fsh) != EOF else {
        perror(headerFilePath)
        exit(EXIT_FAILURE)
    }
    
    
    // make c file
    let cFilePath = data.workingDirectory + "/" + data.wb + ".c"
    
    // open a filestream for reading
    guard let fsc = fopen(cFilePath, "w") else {
        // file did not open
        print("\(data.wb).c : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    defer { closeFileStream(fsc) }

    commentText = getCreatorDetailsCommentWB(data, fileType: ".c")
    
    let cText =  commentText + licenseText + generateWbC(data)   // generate the .c file content
    
    guard fputs(cText, fsc) != EOF else {
        perror(cFilePath)
        exit(EXIT_FAILURE)
    }

}


/**
 * This function opens a file stream and writes the C++ wrapper
 * It uses helper functions to generate the content, including the license information
 * @param data is an object containing information about the class to generate
 */
func generateCPPFile(_ data: ClassData) -> Void {
    
    let filePath = data.workingDirectory + "/" + data.cpp + ".h"
    
    // open a filestream for reading
    guard let fs = fopen(filePath, "w") else {
        // file did not open
        print("\(data.cpp).h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    defer { closeFileStream(fs) }

    let text = getCreatorDetailsCommentCPP(data) + getLicense(data) + generateCPPStruct(data)
    
    guard fputs(text, fs) != EOF else {
        perror(filePath)
        exit(EXIT_FAILURE)
    }
}



/**
* This function opens a file stream and writes the C++ wrapper
* It uses helper functions to generate the content, including the license information
* @param data is an object containing information about the class to generate
*/
func generateSwiftFiles(_ data: ClassData) -> Void {
    
    let filePath = data.workingDirectory + "/" + data.cpp + ".swift"
    
    // open a filestream for reading
    guard let fs = fopen(filePath, "w" ) else {
        // file did not open
        print("\(data.cpp).swift : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    defer { closeFileStream(fs) }

    let text = getCreatorDetailsCommentSwift(data) + getLicense(data) + generateSwiftExtension(data)
    
    guard fputs(text, fs) != EOF else {
        perror(filePath)
        exit(EXIT_FAILURE)
    }

    // make a bridging header
    // \(data.cpp)-Bridging-Header.h
    let filePathBH = data.workingDirectory + "/" + data.cpp + "-Bridging-Header.h"
    
    // open a filestream for reading
    guard let fsbh = fopen( filePathBH, "w" ) else {
        // file did not open
        print("\(data.cpp)-Bridging-Header.h : Could not create file\n")
        exit(EXIT_FAILURE)
    }
    defer { closeFileStream(fsbh) }

    let textbh = getCreatorDetailsCommentSwiftBH(data) + getLicense(data) + "#import \"\(data.wb).h\" \n"
    
    guard fputs(textbh, fsbh) != EOF else {
        perror(filePath)
        exit(EXIT_FAILURE)
    }
}



/**
 * This determines the description string buffer size
 * which will be declared as a constant in the generated files
 * @param toStringbufferSize the size of the toString buffer
 * @return the size of the buffer
 */
func getDescriptionBufferSize(_ toStringbufferSize: size_t) -> size_t {
    
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



/**
 * This determines the tostring buffer size
 * which will be declared as a constant in the generated files.
 * It uses information about the variables as stored in the dictionary.
 * @return the size of the buffer
 */
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



