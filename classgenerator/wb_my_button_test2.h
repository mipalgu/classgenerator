/** 
 * file wb_my_button_test2.h 
 * 
 * Created by mick on Mon Sep 14 19:50:19 2015
 * Copyright (c) 2015 mick 
 * 
 * This file was generated from my_button_test2.txt 
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
 *    This product includes software developed by mick. 
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


#ifndef wb_my_button_test2_h 
#define wb_my_button_test2_h 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 

#include <gu_util.h> 
#include <stdio.h> 
#include <string.h> 
#include <stdlib.h> 

#define NUMBER_OF_VARIABLES 3 

/** 
 *  ADD YOUR COMMENT DESCRIBING THE STRUCT wb_my_button_test2
 * 
 */ 
struct wb_my_button_test2 
{ 
	/** is_pressed COMMENT ON PROPERTY */ 
	PROPERTY(bool, is_pressed)

	/** a_number COMMENT ON PROPERTY */ 
	PROPERTY(int16_t, a_number)

	/** another_number COMMENT ON PROPERTY */ 
	PROPERTY(uint32_t, another_number)

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 

	/** convert to a description string */  
	char* description() {
		char descString[0] = '\0'; 
		char buffer[20]; 

		strcat(descString, 'is_pressed='); 
		char is_pressedString[6] = is_pressed ? 'true' : 'false'; 
		strcat( descString, is_pressedString ); 
		strcat( descString, ',' ); 

		strcat(descString, 'a_number='); 
		itoa(a_number,buffer,10); 
		strcat(descString, buffer); 
		strcat( descString, ',' ); 

		strcat(descString, 'another_number='); 
		itoa(another_number,buffer,10); 
		strcat(descString, buffer); 
		return descString; 
	} 

	/** convert to a string */  
	char* to_string() {
		char toString[0] = '\0'; 
		char buffer[20]; 

		char is_pressedString[6] = is_pressed ? 'true' : 'false'; 
		strcat( toString, is_pressedString ); 

		strcat( toString, ',' ); 

		itoa(a_number,buffer,10); 
		strcat(toString, buffer); 

		strcat( toString, ',' ); 

		itoa(another_number,buffer,10); 
		strcat(toString, buffer); 

		return toString; 
	} 

	/** convert from a string */  
	void from_string(char* str) {

		char* strings[NUMBER_OF_VARIABLES]; 
		char* descStrings[NUMBER_OF_VARIABLES]; 
		const char s[2] = ",";  // delimeters 
		const char e[2] = "=";  // delimeters 
		char* tokenS, *tokenE, *token; 

		for ( int i = 0; i < NUMBER_OF_VARIABLES; i++ ) { 
			tokenS = strtok(str, s); 
			descStrings[i] = tokenS; 
		} 

		for ( int i = 0; i < NUMBER_OF_VARIABLES; i++ ) { 

			tokenE = strtok(descStrings[i], e); 

			// Remove the variable name and equals sign (if there) 
			while ( tokenE != NULL ) { 
				token = tokenE; 
				tokenE = strtok(NULL, e); 
			} 

			strings[i] = token; 
		} 

		set_is_pressed(strings[0]); 
		set_a_number((int16_t)atoi(strings[1])); 
		set_another_number((uint32_t)atoi(strings[2])); 
	} 
#endif // WHITEBOARD_POSTER_STRING_CONVERSION 

