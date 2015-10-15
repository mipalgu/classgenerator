//
//  CTest.m
//  CTest
//
//  Created by Mick Hawkins on 15/10/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../classgenerator/wb_my_test.h"
#import "../../../Common/gu_util.h"
#import <string.h>


@interface CTest : XCTestCase

@end

@implementation CTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExample {
    
    const struct wb_my_test testStruct;
    testStruct.pressed = false;
    testStruct.pointX = 5;
    testStruct.pointY = 11;
    
    char* desiredDescString = "pressed=false, pointX=5, pointY=11";
    char* descString;
    
    wb_my_test_description(testStruct, descString, 128);
    
    XCTAssertEqual(descString, desiredDescString);
}





@end
