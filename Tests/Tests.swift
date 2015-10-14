//
//  Tests.swift
//  Tests
//
//  Created by Mick Hawkins on 3/09/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

import XCTest

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    let varTypes = ["bool", "int32_t", "long", "double"]
    let varNames = ["button_pressed", "pointX", "bigNum", "decimal"]
    var varDefaults = ["true", "1", "3", ""]
    let doubleDefault = "0.0"
    
    
    func testSetDefault(){
            
        varDefaults[3] = variables[varTypes[3]]!.defaultValue
    
        XCTAssertEqual(doubleDefault, varDefaults[3], "default not set correctly")
    }
    
    
    func testFormatSpecifier(){
        
        let intFormat = "\(varNames[1])=\(variables[varTypes[1]]!.format)"
        let desired = "pointX=%d"
        
        XCTAssertEqual(intFormat, desired, "format not set correctly")
    }
    
    
    func testTypeConverter(){
        
        let conversion = "(\(varTypes[2]))\(variables[varTypes[2]]!.converter)(\(varNames[2]))"
        let desired = "(long)atol(bigNum)"
        
        XCTAssertEqual(conversion, desired, "conversion not set correctly")
    }
    
    
    let inputVar = inputVariable(varType: "bool", varName: "is_pressed", varDefault: "false", varComment: "a comment here", varArraySize: 0)
    
    let inputType = "bool"
    let inputName = "is_pressed"
    let inputDefault = "false"
    
    var arrayTest : [inputVariable] = []
    
    func testInputStruct(){
    
        XCTAssertEqual(inputType, inputVar.varType, "varType not set correctly")
        XCTAssertEqual(inputName, inputVar.varName, "varName not set correctly")
        XCTAssertEqual(inputDefault, inputVar.varDefault, "varDefault not set correctly")
    }
    
    func testVariablesArray(){
        
        arrayTest.append(inputVar)
        
        XCTAssertEqual(inputType, arrayTest[0].varType, "array varType not set correctly")
        XCTAssertEqual(inputName, arrayTest[0].varName, "array varName not set correctly")
        XCTAssertEqual(inputDefault, arrayTest[0].varDefault, "array varDefault not set correctly")
        
    }
    
    
    func testForArrayUsingBrackets(){
        
        var arrayName : String = ""
        var arraySize : Int = 0
        let inputArray = "colour[8]"
        let bracketValues = inputArray.characters.split {$0 == "["}.map { String($0) }
        
        if bracketValues.count == 2 {  // found bracket therefore array
            arrayName = bracketValues[0]
            arraySize = Int(String(bracketValues[1].characters.dropLast()))!
        }
        else if bracketValues.count == 1 {  // not an array
            arrayName = bracketValues[0]
            arraySize = 0
        }
        else {
            /// error
        }
        
        XCTAssertEqual(arrayName, "colour", "arrayName not set correctly")
        XCTAssertEqual(arraySize, 8, "arraySize not set correctly")
    }
    
    
    func testForArrayUsingColon(){
        
        var arrayType : String = ""
        var arraySize : Int = 0
        let inputArray = "int:8"
        let colonValues = inputArray.characters.split {$0 == ":"}.map { String($0) }
        
        if colonValues.count == 2 {  // found colon therefore array
            arrayType = colonValues[0]
            arraySize = Int(colonValues[1])!
        }
        else if colonValues.count == 1 {  // not an array
            arrayType = colonValues[0]
            arraySize = 0
        }
        else {
            /// error
        }
        
        XCTAssertEqual(arrayType, "int", "arrayType not set correctly")
        XCTAssertEqual(arraySize, 8, "arraySize not set correctly")
    }
    
    
    
    func lc (ch: Character) -> Character {
        
        if ( ch >= "A" ) && ( ch <= "Z" ){
            
            let scalars = String(ch).unicodeScalars      // unicode scalar(s) of the character
            let val = scalars[scalars.startIndex].value  // value of the unicode scalar
            
            return Character(UnicodeScalar(val + 32))    // return the lowercase
        }
        else {
            
            return ch                                    // return the character since it's not a lowercase letter
        }
    }
    
    func lcWord (word: String) -> String {
        
        var lcWord = ""
        
        for ch in word.characters {
            lcWord += String(lc(ch))
        }
        
        return lcWord
    }
    
    func testLowerCaseWord(){
        
        let inputWord = "my_TEST_word"
        let lowercase = lcWord(inputWord)
        print("\(lowercase)")
        
        let desiredWord = "my_test_word"
        
        XCTAssertEqual(desiredWord, lowercase, "did not convert")
    }
    
    
    func testFindComment(){
        
        var structComment : [String] = []
        var variables : [String] = []
        var foundReturn = false
        
        let inputText = "int\tnumber\nbool\tpressed\n\nthis is a comment\nso is this\n"
        let comment1 = "this is a comment"
        let comment2 = "so is this"
        let var1 = "int\tnumber"
        let var2 = "bool\tpressed"
        
        var commentPosition : Int = 0
        
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
        
        print("\(commentPosition)")
        var lines = inputText.characters.split {$0 == "\n"}.map {String($0)}
        
        for i in commentPosition...lines.count-1 {
            structComment.append(lines[i])
        }
        
        for i in 0...commentPosition-1 {
            variables.append(lines[i])
        }
        
        XCTAssertEqual(comment1, structComment[0], "did not find comment1")
        XCTAssertEqual(comment2, structComment[1], "did not find comment2")
        
        XCTAssertEqual(var1, variables[0], "did not find var1")
        XCTAssertEqual(var2, variables[1], "did not find var2")
        
    }
    
    func testRemoveLeadingCommentCharacters(){
        
        let inputText = "// 7This is a comment"
        let comment = "7This is a comment"
        
        var firstLetterFound = false
        var returnedString = ""
        
        for ch in inputText.characters {
            
            if firstLetterFound {
                returnedString += String(ch)
            }
            else if  ch != "/" && ch != " " {
                firstLetterFound = true
                returnedString += String(ch)
            }
        }
        
        XCTAssertEqual(comment, returnedString, "did not find comment")
    }
    
/*
    func testMyTestExample() {
        
        var testStruct : wb_my_test
        
        var toStringResult = wb_my_test_to_string
        
        
    }
*/    
    
}


