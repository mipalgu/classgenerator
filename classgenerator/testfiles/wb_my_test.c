/** 
 * file wb_my_test.c 
 * 
 * This file was generated by classgenerator from MY_test.txt. 
 * DO NOT CHANGE MANUALLY! 
 * 
 * Created by Mick Hawkins at 14:31, 28/11/2015 
 * Copyright (c) 2015 Mick Hawkins 
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

/** convert to a description string */  
const char* wb_my_test_description(const struct wb_my_test* self, char* descString, size_t bufferSize) 
{ 
    size_t len; 

    gu_strlcat(descString, "pressed=", bufferSize); 
    gu_strlcat(descString, self->pressed ? "true" : "false", bufferSize); 
    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "pointX=%d", self->pointX); 
    } 

    len = gu_strlcat(descString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(descString+len, bufferSize-len, "pointY=%d", self->pointY); 
    } 

	return descString; 
} 

/** convert to a string */  
const char* wb_my_test_to_string(const struct wb_my_test* self, char* toString, size_t bufferSize) 
{ 
    size_t len; 

    gu_strlcat(toString, self->pressed ? "true" : "false", bufferSize); 

    len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "%d", self->pointX); 
    } 

     len = gu_strlcat(toString, ", ", bufferSize); 

    if (len < bufferSize) 
    { 
        snprintf(toString+len, bufferSize-len, "%d", self->pointY); 
    } 

     return toString; 
} 

/** convert from a string */  
struct wb_my_test* wb_my_test_from_string(struct wb_my_test* self, const char* str) 
{ 
    char* strings[MY_TEST_NUMBER_OF_VARIABLES]; 
    memset(strings, 0, sizeof(strings)); 
    char* saveptr; 
    int count = 0; 

    char* str_copy = gu_strdup(str); 

    const char s[2] = ",";   /// delimeter 
    const char e = '=';      /// delimeter 
    char* tokenS, *tokenE; 

    tokenS = strtok_r(str_copy, s, &saveptr); 

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

        strings[count] = gu_strtrim(tokenE); 

        count++; 
        tokenS = strtok_r(NULL, s, &saveptr); 
    } 

    if (strings[0] != NULL) 
       self->pressed = strcmp(strings[0], "true") == 0  || strcmp(strings[0], "1") == 0 ? true : false; 

    if (strings[1] != NULL) 
       self->pointX = (int16_t)atoi(strings[1]); 

    if (strings[2] != NULL) 
       self->pointY = (int16_t)atoi(strings[2]); 

    free(str_copy); 

    return self; 
}; 
