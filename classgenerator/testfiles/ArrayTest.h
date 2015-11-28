/** 
 * file ArrayTest.h 
 * 
 * This file was generated by classgenerator from array_test.txt. 
 * DO NOT CHANGE MANUALLY! 
 * 
 * Created by Mick Hawkins on 15:9, 28/11/2015 
 * Copyright (c) 2015 Mick Hawkins 
 * All rights reserved. 
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
#define WHITEBOARD_POSTER_STRING_CONVERSION
#define USE_WB_MY_TEST_C_CONVERSION 

#ifndef ArrayTest_DEFINED 
#define ArrayTest_DEFINED 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
#include <cstdlib> 
#include <string.h> 
#include <sstream> 
#endif 

#include "wb_array_test.h" 

namespace guWhiteboard 
{
    /** 
     * Struct comment goes here 
     */ 
    class ArrayTest: public wb_array_test 
    { 
    public:
        /** Designated Constructor */ 
        ArrayTest()
        { 
            set_pressed(false); 
            set_array16(1, 0); 
            set_array16(2, 1); 
            set_array16(3, 2); 
            set_array16(4, 3); 
            set_bools(false, 0); 
            set_bools(false, 1); 
            set_bools(false, 2); 
            set_bools(false, 3); 
        } 

        /** Copy Constructor */ 
        ArrayTest(const ArrayTest &other) : wb_array_test() 
        { 
            set_pressed(other.pressed()); 
            set_array16(other.array16(0), 0); 
            set_array16(other.array16(1), 1); 
            set_array16(other.array16(2), 2); 
            set_array16(other.array16(3), 3); 
            set_bools(other.bools(0), 0); 
            set_bools(other.bools(1), 1); 
            set_bools(other.bools(2), 2); 
        } 

        /** Copy Assignment Operator */ 
        ArrayTest &operator = (const ArrayTest &other) 
        { 
            set_pressed(other.pressed()); 
            set_array16(other.array16(0), 0); 
            set_array16(other.array16(1), 1); 
            set_array16(other.array16(2), 2); 
            set_array16(other.array16(3), 3); 
            set_bools(other.bools(0), 0); 
            set_bools(other.bools(1), 1); 
            set_bools(other.bools(2), 2); 
            return *this; 
        } 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
        std::string description() 
        { 
#ifdef USE_WB_ARRAY_TEST_C_CONVERSION 
            char buffer[ARRAY_TEST_DESC_BUFFER_SIZE]; 
            wb_array_test_description (this, buffer, sizeof(buffer)); 
            std::string descr = buffer; 
            return descr; 
#else 
                std::ostringstream ss; 
                ss << "pressed=" << pressed(); 
                ss << ", "; 

                bool array16_first = true; 
                ss << "array16={"; 
                for (size_t i = 0; i < ARRAY_TEST_ARRAY16_ARRAY_SIZE-1; i++) 
                { 
                    ss << (array16_first ? "" : ",") << array16(i); 
                    array16_first = false;  
                } 
                ss << "}"; 
                ss << ", "; 

                bool bools_first = true; 
                ss << "bools={"; 
                for (size_t i = 0; i < ARRAY_TEST_BOOLS_ARRAY_SIZE-1; i++) 
                { 
                    ss << (bools_first ? "" : ",") << bools(i); 
                    bools_first = false;  
                } 
                ss << "}"; 

                return ss.str(); 

#endif /// USE_WB_ARRAY_TEST_C_CONVERSION
        } 
#endif ///   WHITEBOARD_POSTER_STRING_CONVERSION
    }; 
} /// namespace guWhiteboard 
#endif /// ArrayTest_DEFINED 
