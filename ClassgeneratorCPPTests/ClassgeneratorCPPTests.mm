//
//  ClassgeneratorCPPTests.mm
//  ClassgeneratorCPPTests
//
//  Created by Mick Hawkins on 28/10/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "gu_util.h"
#import "gusimplewhiteboard.h"
#import "MYTest.h"
#import "ArrayTest.h"

@interface ClassgeneratorCPPTests : XCTestCase

@end

@implementation ClassgeneratorCPPTests

- (void)testSimpleConstructors {

    wb_my_test testStruct;         // pressed=true, pointX=2, pointY=0
    wb_my_test testStructCopy;
    
    testStruct.pressed() = false;
    testStruct.pointX() = 5;
    testStruct.pointY() = 7;
    
    testStructCopy = testStruct;

    XCTAssertEqual(testStructCopy.pressed(), false, @"pressednot set");
    XCTAssertEqual(testStructCopy.pointX(), 5, @"pointX not set");
    XCTAssertEqual(testStructCopy.pointY(), 7, @"pointY not set");
}


- (void)testArraysConstructors {
    
    
    wb_array_test testStruct;
    
    XCTAssertEqual(testStruct.pressed, false, "pressed not set");
    
    XCTAssertEqual(testStruct.array16[0], 1, "array16[0] not set");
    XCTAssertEqual(testStruct.array16[1], 2, "array16[1] not set");
    XCTAssertEqual(testStruct.array16[2], 3, "array16[2] not set");
    XCTAssertEqual(testStruct.array16[3], 4, "array16[3] not set");
    
    XCTAssertEqual(testStruct.bools[0], false, "bools[0] not set");
    XCTAssertEqual(testStruct.bools[1], false, "bools[1] not set");
    XCTAssertEqual(testStruct.bools[2], false, "bools[2] not set");
     
}


@end
