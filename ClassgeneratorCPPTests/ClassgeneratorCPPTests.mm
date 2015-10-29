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

@interface ClassgeneratorCPPTests : XCTestCase

@end

@implementation ClassgeneratorCPPTests

- (void)testSimpleDefaultConstructor {

    wb_my_test testStruct;
    
    XCTAssertEqual(testStruct.pressed, true, "pressed not set");
    XCTAssertEqual(testStruct.pointX, 2, "pointX not set");
    XCTAssertEqual(testStruct.pointY, 0, "pointY not set");
}


- (void)testArraysDefaultConstructor {
    
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
