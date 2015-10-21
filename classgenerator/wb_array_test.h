/** 
 * file wb_array_test.h 
 * 
 * This file was generated by classgenerator from array_test.txt. 
 * DO NOT CHANGE MANUALLY! 
 * 
 * Created by Mick Hawkins at 18:56, 21/10/2015 
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


#ifndef wb_array_test_h 
#define wb_array_test_h 

#include "gu_util.h" 

#define ARRAY_TEST_NUMBER_OF_VARIABLES 3 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
#define ARRAY_TEST_DESC_BUFFER_SIZE 43 
#define ARRAY_TEST_TO_STRING_BUFFER_SIZE 21 
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION 

#define ARRAY_TEST_ARRAY16_ARRAY_SIZE 4 
#define ARRAY_TEST_BOOLS_ARRAY_SIZE 3 
/** 
 * Struct comment goes here 
 */ 
struct wb_array_test 
{ 
    /** A comment about pressed */ 
    PROPERTY(bool, pressed); 

    /** a comment about array16 */ 
    ARRAY_PROPERTY(int16_t, array16, ARRAY_TEST_ARRAY16_ARRAY_SIZE);

    /** a comment about bools */ 
    ARRAY_PROPERTY(bool, bools, ARRAY_TEST_BOOLS_ARRAY_SIZE);

}; 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
/** convert to a description string */  
const char* wb_array_test_description(const struct wb_array_test* self, char* descString, size_t bufferSize); 

/** convert to a string */  
const char* wb_array_test_to_string(const struct wb_array_test* self, char* toString, size_t bufferSize); 

/** convert from a string */  
struct wb_array_test* wb_array_test_from_string(struct wb_array_test* self, const char* str); 
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION 

#endif /// wb_array_test_h 
