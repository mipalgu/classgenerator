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
    
    
    let inputVar = inputVariable(varType: "bool", varName: "is_pressed", varDefault: "false", varArraySize: 0)
    
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
            arraySize = Int(bracketValues[1].substringToIndex(bracketValues[1].endIndex.predecessor()))!
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
    
}


