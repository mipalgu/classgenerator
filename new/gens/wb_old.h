/*
 * file wb_old.h
 *
 * This file was generated by classgenerator from old.txt.
 * DO NOT CHANGE MANUALLY!
 *
 * Created by Callum McColl at %time%, %date%
 * Copyright © %year% Callum McColl
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
 *    This product includes software developed by Callum McColl.
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

#ifndef wb_old_h
#define wb_old_h

#include "gu_util.h"

#include <stdint.h>

#define OLD_NUMBER_OF_VARIABLES 90

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
#define OLD_DESC_BUFFER_SIZE 13046
#define OLD_TO_STRING_BUFFER_SIZE 12742
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION

#define OLD_ARRAY16_ARRAY_SIZE 4
#define OLD_BOOLS_ARRAY_SIZE 3

/**
 * This is a test of all of the supported types.
 */
struct wb_old
{
    /**
     * A string.
     */
    PROPERTY(string, str) 

    /**
     * A boolean.
     */ 
    PROPERTY(bool, b) 

    /**
     * A char.
     */ 
    PROPERTY(char, c) 

    /**
     * A signed char.
     */ 
    PROPERTY(signed char, sc) 

    /**
     * An unsigned char.
     */ 
    PROPERTY(unsigned char, uc) 

    /**
     * An int.
     */
    PROPERTY(int, i) 

    /**
     * A signed.
     */
    PROPERTY(signed, si) 

    /**
     * A signed int.
     */
    PROPERTY(signed int, sii) 

    /**
     * An unsigned.
     */
    PROPERTY(unsigned, u) 

    /**
     * An unsigned int.
     */
    PROPERTY(unsigned int, ui) 

    /**
     * A uint8.
     */
    PROPERTY(uint8_t, u8) 

    /**
     * A uint16.
     */
    PROPERTY(uint16_t, u16) 

    /**
     * A uint32.
     */
    PROPERTY(uint32_t, u32) 

    /**
     * A uint64.
     */
    PROPERTY(uint64_t, u64) 

    /**
     * An int8.
     */
    PROPERTY(int8_t, i8) 

    /**
     * An int16.
     */
    PROPERTY(int16_t, i16) 

    /**
     * An int32.
     */
    PROPERTY(int32_t, i32) 

    /**
     * An int64.
     */
    PROPERTY(int64_t, i64) 

    /**
     * A short.
     */
    PROPERTY(short, s) 

    /**
     * A short int.
     */
    PROPERTY(short int, si) 

    /**
     * A signed short.
     */
    PROPERTY(signed short, ss) 

    /** A signed short int. */ 
    PROPERTY(signed short int, ssi) 

    /** An unsigned short. */ 
    PROPERTY(unsigned short, us) 

    /**
     * An unsigned short int.
     */
    PROPERTY(unsigned short int, usi) 

    /**
     * A long.
     */
    PROPERTY(long, l) 

    /**
     * A long int.
     */
    PROPERTY(long int, li) 

    /**
     * A signed long.
     */
    PROPERTY(signed long, sl) 

    /**
     * A signed long int.
     */
    PROPERTY(signed long int, sli) 

    /**
     * An unsigned long.
     */
    PROPERTY(unsigned long, ul) 

    /**
     * An unsigned long int.
     */
    PROPERTY(unsigned long int, uli) 

    /**
     * A long long.
     */
    PROPERTY(long long, ll) 

    /**
     * A long long int.
     */
    PROPERTY(long long int, lli) 

    /**
     * A signed long long.
     */
    PROPERTY(signed long long, sll) 

    /**
     * A signed long longint.
     */
    PROPERTY(signed long long int, slli) 

    /**
     * An unsigned long long.
     */
    PROPERTY(unsigned long long, ull) 

    /**
     * An unsigned long long int.
     */
    PROPERTY(unsigned long long int, ulli) 

    /**
     * A long64.
     */
    PROPERTY(long64_t, l64) 

    /**
     * A float.
     */
    PROPERTY(float, f) 

    /**
     * A float_t.
     */
    PROPERTY(float_t, ft) 

    /**
     * A double.
     */
    PROPERTY(double, d) 

    /**
     * A double_t.
     */
    PROPERTY(double_t, dt) 

    /**
     * A long double.
     */
    PROPERTY(long double, ld) 

    /**
     * A double double.
     */
    PROPERTY(double double, dd) 

    /**
     * A string.
     */
    PROPERTY(string, str) 

    /**
     * A boolean.
     */
    PROPERTY(bool, b) 

    /**
     * A char.
     */
    PROPERTY(char, c) 

    /**
     * A signed char.
     */
    PROPERTY(signed char, sc) 

    /**
     * An unsigned char.
     */
    PROPERTY(unsigned char, uc) 

    /**
     * An int.
     */
    PROPERTY(int, i) 

    /**
     * A signed.
     */
    PROPERTY(signed, si) 

    /**
     * A signed int.
     */
    PROPERTY(signed int, sii) 

    /**
     * An unsigned.
     */
    PROPERTY(unsigned, u) 

    /**
     * An unsigned int.
     */
    PROPERTY(unsigned int, ui) 

    /**
     * A uint8.
     */
    PROPERTY(uint8_t, u8) 

    /**
     * A uint16.
     */
    PROPERTY(uint16_t, u16) 

    /**
     * A uint32.
     */
    PROPERTY(uint32_t, u32) 

    /**
     * A uint64.
     */
    PROPERTY(uint64_t, u64) 

    /**
     * An int8.
     */
    PROPERTY(int8_t, i8) 

    /**
     * An int16.
     */
    PROPERTY(int16_t, i16) 

    /**
     * An int32.
     */
    PROPERTY(int32_t, i32) 

    /**
     * An int64.
     */
    PROPERTY(int64_t, i64) 

    /**
     * A short.
     */
    PROPERTY(short, s) 

    /**
     * A short int.
     */
    PROPERTY(short int, si) 

    /**
     * A signed short.
     */
    PROPERTY(signed short, ss) 

    /**
     * A signed short int.
     */
    PROPERTY(signed short int, ssi) 

    /**
     * An unsigned short.
     */
    PROPERTY(unsigned short, us) 

    /**
     * An unsigned short int.
     */
    PROPERTY(unsigned short int, usi) 

    /**
     * A long.
     */
    PROPERTY(long, l) 

    /**
     * A long int.
     */
    PROPERTY(long int, li) 

    /**
     * A signed long.
     */
    PROPERTY(signed long, sl) 

    /** A signed long int. */ 
    PROPERTY(signed long int, sli) 

    /**
     * An unsigned long.
     */
    PROPERTY(unsigned long, ul) 

    /**
     * An unsigned long int.
     */
    PROPERTY(unsigned long int, uli) 

    /**
     * A long long.
     */
    PROPERTY(long long, ll) 

    /**
     * A long long int.
     */
    PROPERTY(long long int, lli) 

    /**
     * A signed long long.
     */
    PROPERTY(signed long long, sll) 

    /**
     * A signed long long int.
     */
    PROPERTY(signed long long int, slli) 

    /**
     * An unsigned long long.
     */
    PROPERTY(unsigned long long, ull) 

    /**
     * An unsigned long long int.
     */
    PROPERTY(unsigned long long int, ulli) 

    /**
     * A long64.
     */
    PROPERTY(long64_t, l64) 

    /**
     * A float.
     */
    PROPERTY(float, f) 

    /**
     * A float_t.
     */
    PROPERTY(float_t, ft)

    /**
     * A double.
     */
    PROPERTY(double, d)

    /**
     * A double_t.
     */
    PROPERTY(double_t, dt)

    /**
     * A long double.
     */
    PROPERTY(long double, ld)

    /**
     * A double double.
     */
    PROPERTY(double double, dd)

    /**
     * A pointer.
     */
    PROPERTY(int*, p) 

    /**
     * A struct.
     */
    PROPERTY(somestruct, strct) 

    /**
     * a comment about array16
     */
    ARRAY_PROPERTY(int16_t, array16, OLD_ARRAY16_ARRAY_SIZE)

    /**
     * a comment about bools
     */
    ARRAY_PROPERTY(bool, bools, OLD_BOOLS_ARRAY_SIZE)

}; 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
/** convert to a description string */  
const char* wb_old_description(const struct wb_old* self, char* descString, size_t bufferSize); 

/** convert to a string */  
const char* wb_old_to_string(const struct wb_old* self, char* toString, size_t bufferSize); 

/** convert from a string */  
struct wb_old* wb_old_from_string(struct wb_old* self, const char* str); 
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION 

#endif /// wb_old_h 
