//
//  ClassgeneratorCPPTests.mm
//  ClassgeneratorCPPTests
//
//  Created by Mick Hawkins on 28/10/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <iostream>
#import "gu_util.h"
#import "gusimplewhiteboard.h"
#import "MYTest.h"
#import "ArrayTest.h"

@interface ClassgeneratorCPPTests : XCTestCase

@end

@implementation ClassgeneratorCPPTests


- (void)testSimpleDefaultConstructor {
    
   // wb_my_test testStruct;         // pressed=true, pointX=2, pointY=0
    
    guWhiteboard::MYTest testStruct;
    
    XCTAssertEqual(testStruct.pressed(), true, @"pressednot set");
    XCTAssertEqual(testStruct.pointX(), 2, @"pointX not set");
    XCTAssertEqual(testStruct.pointY(), 0, @"pointY not set");
}

/*
- (void)testSimpleAssignmentConstructor {

    guWhiteboard::MYTest testStruct;         // pressed=true, pointX=2, pointY=0
    guWhiteboard::MYTest testStructCopy;
    
    testStruct.pressed(false);
    testStruct.pointX(5);
    testStruct.pointY(7);
    
    testStructCopy = testStruct;

    XCTAssertEqual(testStructCopy.pressed(), false, @"pressednot set");
    XCTAssertEqual(testStructCopy.pointX(), 5, @"pointX not set");
    XCTAssertEqual(testStructCopy.pointY(), 7, @"pointY not set");
}
*/

- (void)testSimpleCopyConstructor {
    
    guWhiteboard::MYTest testStruct;         // pressed=true, pointX=2, pointY=0
    
    testStruct.pressed() = false;
    testStruct.pointX() = 5;
    testStruct.pointY() = 7;
    
    guWhiteboard::MYTest testStructCopy(testStruct);
    
    XCTAssertEqual(testStructCopy.pressed(), false, @"pressednot set");
    XCTAssertEqual(testStructCopy.pointX(), 5, @"pointX not set");
    XCTAssertEqual(testStructCopy.pointY(), 7, @"pointY not set");
}

- (void)testArraysDefaultConstructor {
    
    guWhiteboard::ArrayTest testStruct;
    
    XCTAssertEqual(testStruct.pressed(), false, @"pressed not set");
    
    XCTAssertEqual(testStruct.array16(0), 1, @"array16[0] not set");
    XCTAssertEqual(testStruct.array16(1), 2, @"array16[1] not set");
    XCTAssertEqual(testStruct.array16(2), 3, @"array16[2] not set");
    XCTAssertEqual(testStruct.array16(3), 4, @"array16[3] not set");
    
    XCTAssertEqual(testStruct.bools(0), false, @"bools[0] not set");
    XCTAssertEqual(testStruct.bools(1), false, @"bools[1] not set");
    XCTAssertEqual(testStruct.bools(2), false, @"bools[2] not set");
}


- (void)testArraysCopyConstructor {
    
    guWhiteboard::ArrayTest testStructFirst;
    
    guWhiteboard::ArrayTest testStruct(testStructFirst);
    
    XCTAssertEqual(testStruct.pressed(), false, @"pressed not set");
    
    XCTAssertEqual(testStruct.array16(0), 1, @"array16[0] not set");
    XCTAssertEqual(testStruct.array16(1), 2, @"array16[1] not set");
    XCTAssertEqual(testStruct.array16(2), 3, @"array16[2] not set");
    XCTAssertEqual(testStruct.array16(3), 4, @"array16[3] not set");
    
    XCTAssertEqual(testStruct.bools(0), false, @"bools[0] not set");
    XCTAssertEqual(testStruct.bools(1), false, @"bools[1] not set");
    XCTAssertEqual(testStruct.bools(2), false, @"bools[2] not set");
}

- (void)testArraysCopyConstructor2 {
    
    guWhiteboard::ArrayTest testStructFirst;
    
    testStructFirst.array16(1) = 666;
    testStructFirst.bools(0) = true;
    
    guWhiteboard::ArrayTest testStruct(testStructFirst);
    
    XCTAssertEqual(testStruct.pressed(), false, @"pressed not set");
    
    XCTAssertEqual(testStruct.array16(0), 1, @"array16[0] not set");
    XCTAssertEqual(testStruct.array16(1), 666, @"array16[1] not set");
    XCTAssertEqual(testStruct.array16(2), 3, @"array16[2] not set");
    XCTAssertEqual(testStruct.array16(3), 4, @"array16[3] not set");
    
    XCTAssertEqual(testStruct.bools(0), true, @"bools[0] not set");
    XCTAssertEqual(testStruct.bools(1), false, @"bools[1] not set");
    XCTAssertEqual(testStruct.bools(2), false, @"bools[2] not set");
}


- (void)testWBPosterStringConversion {
    
    guWhiteboard::MYTest testStruct;
    
    std::string desc = testStruct.description();
    
    std::cout << desc;
}


- (void)testArraysWBPosterStringConversion {
    
    guWhiteboard::ArrayTest testStruct;
    
    std::string desc = testStruct.description();
    
    std::cout << desc;
}



@end
