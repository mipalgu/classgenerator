//
//  ClassgeneratorCTests3.m
//  ClassgeneratorCTests3
//
//  Created by Mick Hawkins on 18/10/2015.
//  Copyright © 2015 Mick Hawkins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <string.h>
#import "gu_util.h"
#import "gusimplewhiteboard.h"
#import "wb_my_test.h"
#import "wb_array_test.h"

@interface ClassgeneratorCTests3 : XCTestCase

@end

@implementation ClassgeneratorCTests3

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// simple variables
- (void)testWBdescription {
    
    struct wb_my_test testStruct;
    testStruct.pressed = false;
    testStruct.pointX = 5;
    testStruct.pointY = 11;
    
    char* desiredDescString = "pressed=false, pointX=5, pointY=11";
    char descString[128];
    
    wb_my_test_description(&testStruct, descString, sizeof(descString));
    
    printf("descString: %s\n", descString);
    XCTAssertTrue(strcmp(descString, desiredDescString) == 0);
}


// simple variables
- (void)testWBtoString {
    
    struct wb_my_test testStruct;
    testStruct.pressed = false;
    testStruct.pointX = 5;
    testStruct.pointY = 11;
    
    char* desiredToString = "false, 5, 11";
    char toString[128];
    
    wb_my_test_to_string(&testStruct, toString, sizeof(toString));
    
    printf("toString: %s\n", toString);
    XCTAssertTrue(strcmp(toString, desiredToString) == 0);
}

// simple arrays
- (void)testWBtoStringArray {
    
    struct wb_array_test testStruct = {false, {5,6,7,8}, {false,true,true}};
    
    //testStruct.pressed = false;
    //testStruct.array16 = {5,6,7,8};
    //testStruct.bools = {false,true,true};
    
    char* desiredToString = "false, {5,6,7,8}, {false,true,true}";
    char toString[128];
    
    wb_array_test_to_string(&testStruct, toString, sizeof(toString));
    
    printf("toString: %s\n", toString);
  
    XCTAssertTrue(strcmp(toString, desiredToString) == 0);
}


// simple arrays
- (void)testWBdescStringArray {
    
    struct wb_array_test testStruct = {false, {5,6,7,8}, {false,true,true}};
    
    //testStruct.pressed = false;
    //testStruct.array16 = {5,6,7,8};
    //testStruct.bools = {false,true,true};
    
    char* desiredDescString = "pressed=false, array16={5,6,7,8}, bools={false,true,true}";
    char descString[128];
    
    wb_array_test_description(&testStruct, descString, sizeof(descString));
    
    printf("\n\ndescString: %s\n\n", descString);
    
    XCTAssertTrue(strcmp(descString, desiredDescString) == 0);
}

// simple variables
- (void)testWBFromString {
/*
    char* str = "false, 5, 11";
    const char * s = ",";  /// delimete
    char* tokenS;
    char* saveptr = NULL;

    tokenS = strtok_r(str, s, &saveptr);
    
    printf("tokenS: %s\n", tokenS);
*/
/*
    struct wb_my_test testStruct;
    char* descString = "pressed=false, pointX=5, pointY=11";
    
    wb_my_test_from_string(&testStruct, descString);
    
    XCTAssertEqual(testStruct.pressed, false, "pressed not set");
    XCTAssertEqual(testStruct.pointX, 5, "pointX not set");
    XCTAssertEqual(testStruct.pointY, 11, "pointY not set");
*/
}


- (void)testRemoveLeadingSpaces {
    
    
    char* strings[2] = {" 5 ", "{  77 "};
    
    char* c = strings[1]+1;
    while (isspace(*c)) c++;
    strings[1] = c;           // remove the {
    
    char* desired = "77 ";
    
    printf("desired:*%s*\n", desired);
    printf("c:*%s*\n", c);
    
    XCTAssertTrue(strcmp(c,desired) == 0);
}


- (void)testRemoveTrailingSpaces {
    
    
    char* strings[2] = {" 5 ", "77  "};
    char c[strlen(strings[1])];
    
    strcpy(c, strings[1]);
    
    size_t n = strlen(c);
    while (n > 0 && isspace((unsigned char)c[n-1]))
    {
        n--;
    }
    c[n] = '\0';

    
    //strings[1] = c;           // remove the {
    
    char* desired = "77";
    
    printf("desired:*%s*\n", desired);
    printf("c:*%s*\n", c);
    
    XCTAssertTrue(strcmp(c,desired) == 0);
}


@end

/*
 char *trimwhitespace(char *str)
 {
    char *end;
 
    // Trim leading space
    while(isspace(*str)) str++;
 
    if(*str == 0)  // All spaces?
    return str;
 
    // Trim trailing space
    end = str + strlen(str) - 1;
    while(end > str && isspace(*end)) end--;
 
    // Write new null terminator
    *(end+1) = 0;
 
    return str;
 }
 */


