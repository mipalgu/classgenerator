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
- (void)test_strtok_r {

    const char* str = "false, 5, 11";
    const char * s = ",";  /// delimete
    char* tokenS;
    char* saveptr = NULL;
    
    char* str_copy = strdup(str);

    //tokenS = strtok_r(str_copy, s, &saveptr);
    
    //printf("tokenS: %s\n", tokenS);
    
    
    for (int i = 0; i < 3; i++)
    {
        tokenS = i == 0 ? strtok_r(str_copy, s, &saveptr) : strtok_r(NULL, s, &saveptr);
        printf("tokenS: %s\n", gu_strtrim(tokenS));
    }
    
    free(str_copy);
}


- (void)testOneAtATime {
    
    char* strings[80];
    const char s[2] = ",";  /// delimeter
    const char e = '=';     /// delimeter
    const char b1 = '{';
    const char b2 = '}';
    char* tokenS, *tokenE, *tokenB1, *tokenB2;
    char* saveptr;
    
    char* array16_values[4];
    int array16_count = 0;
    int isArray16 = 1;
    
    char* bools_values[3];
    int bools_count = 0;
    int isBools = 1;

     const char* str = "  pressed = false, pointX = 5 , pointY=11";
    // const char* str = "pressed=false, array16={5,6,7,8}, bools={false,true,true}";
    // const char* str = "false, {5,6,7,8}, {false,true,true}";
    //const char* str = "false, 5, 11";
    char* str_copy = gu_strdup(str);
    
    tokenS = strtok_r(str_copy, s, &saveptr);
    
    int j = 0;
    int isArray = 0;
    
    while (tokenS != NULL)
    {
            tokenE = strchr(tokenS, e);
            
            if (tokenE == NULL)
            {
                tokenE = tokenS;
            }
            else
            {
                tokenE++;
            }
        
        tokenB1 = strchr(gu_strtrim(tokenE), b1);
        
        if (tokenB1 == NULL)
        {
            tokenB1 = tokenE;
        }
        else
        {
            // start of an array
            tokenB1++;
            isArray = 1;
        }
        
        if (isArray)
        {
            if (isArray16 == 1)
            {
                tokenB2 = strchr(gu_strtrim(tokenB1), b2);
                
                if (tokenB2 != NULL)
                {
                    tokenB1[strlen(tokenB1)-1] = 0;
                    isArray16 == 0;
                }
                
                array16_values[array16_count] = tokenB1;
                puts(array16_values[array16_count]);
                array16_count++;
            }
            else if (isBools == 1)
            {
                tokenB2 = strchr(gu_strtrim(tokenB1), b2);
                
                if (tokenB2 != NULL)
                {
                    tokenB1[strlen(tokenB1)-1] = 0;
                    isBools == 0;
                }
                
                bools_values[bools_count] = tokenB1;
                puts(bools_values[bools_count]);
                bools_count++;
            }
        }
        else
        {
            strings[j] = gu_strtrim(tokenB1);
            puts(strings[j]);
        }
    
        j++;
        tokenS = strtok_r(NULL, s, &saveptr);
    }
    
}



// simple variables
- (void)testFromString {
    
     struct wb_my_test testStruct;
     const char* descString = "  pressed = false, pointX   = 5 , pointY=11";
     
     wb_my_test_from_string(&testStruct, descString);
     
     XCTAssertEqual(testStruct.pressed, false, "pressed not set");
     XCTAssertEqual(testStruct.pointX, 5, "pointX not set");
     XCTAssertEqual(testStruct.pointY, 11, "pointY not set");
}


// simple arrays
- (void)testWBFromStringArray {
    
    struct wb_array_test testStruct; // = {false, {5,6,7,8}, {false,true,true}};
    
    //char* descString = "pressed=true, array16={5,6,7,8}, bools={true,true,true}";
    char* descString = "true, {5 ,6,7,8}, {true, true,true }";
    
    wb_array_test_from_string(&testStruct, descString);
    
    XCTAssertEqual(testStruct.pressed, true, "pressed not set");
    
    XCTAssertEqual(testStruct.array16[0], 5, "array16[0] not set");
    XCTAssertEqual(testStruct.array16[1], 6, "array16[1] not set");
    XCTAssertEqual(testStruct.array16[2], 7, "array16[2] not set");
    XCTAssertEqual(testStruct.array16[3], 8, "array16[3] not set");
    
    XCTAssertEqual(testStruct.bools[0], true, "bools[0] not set");
    XCTAssertEqual(testStruct.bools[1], true, "bools[1] not set");
    XCTAssertEqual(testStruct.bools[2], true, "bools[2] not set");
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



