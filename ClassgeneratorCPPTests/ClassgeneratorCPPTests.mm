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
#import "AllTest.h"
//#import "wb_array_test.c"

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

// simple arrays
- (void)testCPPdescStringArray {
    
    guWhiteboard::ArrayTest testStruct;
    
    std::string desiredDescString = "pressed=0, array16={1,2,3,4}, bools={0,0,0}";
    std::string descString = testStruct.description();
    
    std::cout << descString << std::endl;
    
    //printf("\n\ndescString: %s\n\n", descString.c_str());
    
    XCTAssertTrue(descString.compare(desiredDescString) == 0);
}


- (void)testCPPtoStringArray {
    
    guWhiteboard::ArrayTest testStruct;
    
    std::string desiredToString = "0, {1,2,3,4}, {0,0,0}";
    std::string tString = testStruct.to_string();
    
    std::cout << tString << std::endl;
    
    //printf("\n\ndescString: %s\n\n", descString.c_str());
    
    XCTAssertTrue(tString.compare(desiredToString) == 0);
}



// simple arrays
- (void)testCPPFromStringArray {
    
    guWhiteboard::ArrayTest testStruct; // = {false, {5,6,7,8}, {false,true,true}};
    
    //std::string descString = "pressed = true, array16={ 5,666,7,8 }, bools= { true ,true, true}";
    std::string descString = "true, {5 ,666, 7 ,8}, {true, true,true }";
    
    testStruct.from_string(descString);
    
    //wb_array_test_from_string(&testStruct, descString);
    
    XCTAssertEqual(testStruct.pressed(), true, "pressed not set");
    
    XCTAssertEqual(testStruct.array16(0), 5, @"array16[0] not set");
    XCTAssertEqual(testStruct.array16(1), 666, @"array16[1] not set");
    XCTAssertEqual(testStruct.array16(2), 7, @"array16[2] not set");
    XCTAssertEqual(testStruct.array16(3), 8, @"array16[3] not set");
    
    XCTAssertEqual(testStruct.bools(0), true, @"bools[0] not set");
    XCTAssertEqual(testStruct.bools(1), true, @"bools[1] not set");
    XCTAssertEqual(testStruct.bools(2), true, @"bools[2] not set");
}





// simple arrays
- (void)testCPPdescStringAll {
    
    guWhiteboard::AllTest testStruct;
    
    std::string desiredDescString = "pressed=1, array16={1,2,3,4}, number=0, bools={0,0,0}";
    std::string descString = testStruct.description();
    
    std::cout << descString << std::endl;
    
    //printf("\n\ndescString: %s\n\n", descString.c_str());
    
    XCTAssertTrue(descString.compare(desiredDescString) == 0);
}


// simple arrays
- (void)testCPPtoStringAll {
    
    guWhiteboard::AllTest testStruct;
    
    std::string desiredToString = "1, {1,2,3,4}, 0, {0,0,0}";
    std::string descString = testStruct.to_string();
    
    std::cout << descString << std::endl;
    
    //printf("\n\ndescString: %s\n\n", descString.c_str());
    
    XCTAssertTrue(descString.compare(desiredToString) == 0);
}


- (void)testCPPFromStringAll {
    
    guWhiteboard::AllTest testStruct; // = {false, {5,6,7,8}, {false,true,true}};
    
    //std::string descString = "pressed = true, array16={ 5,666,7,8 }, bools= { true ,true, true}";
    std::string descString = "true, {5 ,666, 7 ,8}, 5 , {true, true,true }";
    
    testStruct.from_string(descString);
    
    //wb_array_test_from_string(&testStruct, descString);
    
    XCTAssertEqual(testStruct.pressed(), true, "pressed not set");
    
    XCTAssertEqual(testStruct.array16(0), 5, @"array16[0] not set");
    XCTAssertEqual(testStruct.array16(1), 666, @"array16[1] not set");
    XCTAssertEqual(testStruct.array16(2), 7, @"array16[2] not set");
    XCTAssertEqual(testStruct.array16(3), 8, @"array16[3] not set");
    
    XCTAssertEqual(testStruct.number(), 5, "number not set");
    
    XCTAssertEqual(testStruct.bools(0), true, @"bools[0] not set");
    XCTAssertEqual(testStruct.bools(1), true, @"bools[1] not set");
    XCTAssertEqual(testStruct.bools(2), true, @"bools[2] not set");
}




/*
- (void)testWBPosterStringConversion {
    
    guWhiteboard::MYTest testStruct;
    
    std::string desc = testStruct.description();
    std::cout << desc;
}
*/

- (void)testArraysWBPosterStringConversion {
    
//    guWhiteboard::ArrayTest testStruct;
    
//    std::string desc = testStruct.description();
    
//    std::cout << desc;
}



@end
