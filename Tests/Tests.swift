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
    var varDefaults = ["true", "1", "3"]
    let doubleDefault = "0.0"
    
    
    func setDefault(){
            
        varDefaults[3] = variables[varNames[3]]!.defaultValue
    
        XCTAssertNotNil(varDefaults[3], "the default is nil")
        XCTAssertEqual(doubleDefault, varDefaults[3], "default not set correctly")
    }
    
    
    func formatSpecifier(){
        
        let intFormat = "\(varNames[1])=\(variables[varTypes[1]]!.format)"
        let desired = "pointX=%d"
        
        XCTAssertEqual(intFormat, desired, "format not set correctly")
    }
    
    
    func typeConverter(){
        
        let conversion = "(\(varTypes[2]))\(variables[varTypes[2]]!.converter)(\(varNames[2]))"
        let desired = "(long)atol(bigNum)"
        
        XCTAssertEqual(conversion, desired, "conversion not set correctly")
    }
    
    
    func testInputStruct(){
        
        let inputVar = inputVariable(varType: "bool", varName: "is_pressed", varDefault: "false")
        
        let inputType = "bool"
        let inputName = "is_pressed"
        let inputDefault = "false"
        
        XCTAssertEqual(inputType, inputVar.varType, "varType not set correctly")
        XCTAssertEqual(inputType, inputVar.varType, "varType not set correctly")
        XCTAssertEqual(inputType, inputVar.varType, "varType not set correctly")
    }
    
    
}


