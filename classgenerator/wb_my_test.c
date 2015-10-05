/** 
 * file wb_my_test.c 
 * 
 * Created by Mick Hawkins at 15:4, 5/10/2015 
 * Copyright (c) 2015 Mick Hawkins 
 * 
 * This file was generated from MY_test.txt 
 * 
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met: 
 * 
 * 1. Redistributions of source code must retain the above copyright 
 *    notice, this list of conditions and the following disclaimer. 
 * 
 * 2. Redistributions in binary form must reproduce the above 
 *    copyright notice, this list of conditions and the following 
 *    disclaimer in the documentation and/or other materials 
 *    provided with the distribution. 
 * 
 * 3. All advertising materials mentioning features or use of this 
 *    software must display the following acknowledgement: 
 * 
 *    This product includes software developed by Mick Hawkins. 
 * 
 * 4. Neither the name of the author nor the names of contributors 
 *    may be used to endorse or promote products derived from this 
 *    software without specific prior written permission. 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER 
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 * 
 * ----------------------------------------------------------------------- 
 * This program is free software; you can redistribute it and/or 
 * modify it under the above terms or under the terms of the GNU 
 * General Public License as published by the Free Software Foundation; 
 * either version 2 of the License, or (at your option) any later version. 
 * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * GNU General Public License for more details. 
 * 
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, see http://www.gnu.org/licenses/ 
 * or write to the Free Software Foundation, Inc., 51 Franklin Street, 
 * Fifth Floor, Boston, MA  02110-1301, USA. 
 */ 


#include "wb_my_test.h" 
#include <stdio.h> 
#include <string.h> 
#include <stdlib.h> 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 

/** convert to a description string */  
const char* wb_my_test_description(const struct wb_my_test* self, char* descString, size_t bufferSize) 
{ 
    size_t len; 

    gu_strlcat(descString, "is_pressed=", bufferSize); 
    gu_strlcat(descString, is_pressed ? "true" : "false", bufferSize); 

    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "pointX=%d", pointX ); 
    } 

    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "pointY=%u", pointY ); 
    } 

    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "longNum=%ld", longNum ); 
    } 

    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "decimalNum=%lf", decimalNum ); 
    } 

	return descString; 
} 

/** convert to a string */  
const char* wb_my_test_to_string(const struct wb_my_test* self, char* toString, size_t bufferSize) 
{ 
    size_t len; 

    snprintf(toString+len, bufferSize-len, "is_pressed=", is_pressed); 
    len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "pointX=%d", pointX); 
    } 

     len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "pointY=%u", pointY); 
    } 

     len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "longNum=%ld", longNum); 
    } 

     len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "decimalNum=%lf", decimalNum); 
    } 

     return toString; 
} 

/** convert from a string */  
struct wb_my_test* wb_my_test_from_string(struct wb_my_test* self, const char* str) 
{ 
    char* strings[MY_TEST_NUMBER_OF_VARIABLES]; 
    const char s[3] = ", ";  /// delimeter 
    const char e[2] = "=";   /// delimeter 
    char* tokenS, *tokenE; 
    char* saveptr = NULL; 

    memset(strings, 0, sizeof(strings)); 

    for (int i = 0; i < MY_TEST_NUMBER_OF_VARIABLES; i++) 
    { 
        int j = i; 
        tokenS = strtok_r(str, s, &saveptr); 

        if (tokenS) 
        { 
            tokenE = strchr(tokenS, '='); 

            if (tokenE == NULL) 
            { 
                 tokenE = tokenS; 
            } 
            else 
            { 
                 tokenE++; 

                if (strcmp(tokenS, "is_pressed") == 0) 
                { 
                    j = 0; 
                } 
                else if (strcmp(tokenS, "pointX") == 0) 
                { 
                    j = 1; 
                } 
                else if (strcmp(tokenS, "pointY") == 0) 
                { 
                    j = 2; 
                } 
                else if (strcmp(tokenS, "longNum") == 0) 
                { 
                    j = 3; 
                } 
                else if (strcmp(tokenS, "decimalNum") == 0) 
                { 
                    j = 4; 
                } 
            } 

            strings[j] = tokenE; 
        } 
    } 

    if (strings[0] != NULL) 
        set_is_pressed(strings[0]); 

    if (strings[1] != NULL) 
        set_pointX((int16_t)atoi(strings[1])); 

    if (strings[2] != NULL) 
        set_pointY((uint32_t)atoi(strings[2])); 

    if (strings[3] != NULL) 
        set_longNum((long)atol(strings[3])); 

    if (strings[4] != NULL) 
        set_decimalNum((double)atof(strings[4])); 

    return self 
}; 
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION 
