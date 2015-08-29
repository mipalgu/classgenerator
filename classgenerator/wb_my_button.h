/** 
 * file wb_my_button.h 
 * 
 * Created by mick on Sat Aug 29 18:16:14 2015
 * Copyright (c) 2015 mick 
 * 
 * This file was generated from my_button.txt 
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


#ifndef wb_my_button_h 
#define wb_my_button_h 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 

#include <gu_util.h> 
#include <stdio.h> 
#include <string.h> 
#include <stdlib.h> 


/** 
 *  ADD YOUR COMMENT DESCRIBING THE STRUCT wb_my_button
 * 
 */ 
struct wb_my_button 
{ 
	/** is_pressed COMMENT ON PROPERTY */ 
	PROPERTY(bool, is_pressed)

	/** a_number COMMENT ON PROPERTY */ 
	PROPERTY(int16_t, a_number)

	/** another_number COMMENT ON PROPERTY */ 
	PROPERTY(uint32_t, another_number)

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 

	/** convert to a string */  
	char* description() {
		char descString[0] = '\0'; 
		char buffer[20]; 

		char is_pressedString[6] = is_pressed ? 'true' : 'false'; 
		strcat( descString, is_pressedString ); 

		strcat( descString, ',' ); 

		itoa(a_number,buffer,10); 
		strcat(descString, buffer); 

		strcat( descString, ',' ); 

		itoa(another_number,buffer,10); 
		strcat(descString, buffer); 

		return descString; 
	} 

	/** convert to a string */  
	char* to_string() {
		char*  toString = ""; 
		  //// TO DO 
		return toString; 
	} 

	/** convert from a string */  
	void from_string(char* str) {
		  //// TO DO 
	} 
#endif // WHITEBOARD_POSTER_STRING_CONVERSION 

#ifdef __cplusplus 

	/** Default constructor */ 
	wb_my_button() : _is_pressed(false), _a_number(0), _another_number(0)  {} 

	/** Copy Constructor */ 
	wb_my_button(const  wb_my_button &other) : 
		_is_pressed(other._is_pressed), 
		_a_number(other._a_number), 
		_another_number(other._another_number)  {} 

	/** Assignment Operator */ 
	wb_my_button &operator= (const wb_my_button &other) { 
		_is_pressed = other._is_pressed; 
		_a_number = other._a_number; 
		_another_number = other._another_number; 
		return *this; 
	} 
#endif 

};
#endif //wb_my_button_h 
