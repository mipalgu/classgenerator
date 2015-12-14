/** 
 * file ArrayTest.h 
 * 
 * This file was generated by classgenerator from array_test.txt. 
 * DO NOT CHANGE MANUALLY! 
 * 
 * Created by Mick Hawkins on 21:29, 14/12/2015 
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
        /** Constructor */ 
        ArrayTest(bool pressed = false)
        { 
            set_pressed(pressed); 
            set_array16(1, 0); 
            set_array16(2, 1); 
            set_array16(3, 2); 
            set_array16(4, 3); 
            set_bools(false, 0); 
            set_bools(false, 1); 
            set_bools(false, 2); 
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
        /** String Constructor -- is this needed? */ 
        // ArrayTest(const std::string &str) { wb_array_test_from_string(this, str.c_str()); }  

        std::string description() 
        { 
#ifdef USE_WB_ARRAY_TEST_C_CONVERSION 
            char buffer[ARRAY_TEST_DESC_BUFFER_SIZE]; 
            wb_array_test_description(this, buffer, sizeof(buffer)); 
            std::string descr = buffer; 
            return descr; 
#else 
            std::ostringstream ss; 
            ss << "pressed=" << pressed(); 
            ss << ", "; 

            bool array16_first = true; 
            ss << "array16={"; 
            for (int i = 0; i < ARRAY_TEST_ARRAY16_ARRAY_SIZE; i++) 
            { 
                ss << (array16_first ? "" : ",") << array16(i); 
                array16_first = false;  
            } 
            ss << "}"; 
            ss << ", "; 

            bool bools_first = true; 
            ss << "bools={"; 
            for (int i = 0; i < ARRAY_TEST_BOOLS_ARRAY_SIZE; i++) 
            { 
                ss << (bools_first ? "" : ",") << bools(i); 
                bools_first = false;  
            } 
            ss << "}"; 

            return ss.str(); 

#endif /// USE_WB_ARRAY_TEST_C_CONVERSION
        } 

        std::string to_string() 
        { 
#ifdef USE_WB_ARRAY_TEST_C_CONVERSION 
            char buffer[ARRAY_TEST_DESC_BUFFER_SIZE]; 
            wb_array_test_to_string(this, buffer, sizeof(buffer)); 
            std::string toString = buffer; 
            return toString; 
#else 
            std::ostringstream ss; 
            ss << pressed(); 
            ss << ", "; 

            bool array16_first = true; 
            ss << "{"; 
            for (int i = 0; i < ARRAY_TEST_ARRAY16_ARRAY_SIZE; i++) 
            { 
                ss << (array16_first ? "" : ",") << array16(i); 
                array16_first = false;  
            } 
            ss << "}"; 
            ss << ", "; 

            bool bools_first = true; 
            ss << "{"; 
            for (int i = 0; i < ARRAY_TEST_BOOLS_ARRAY_SIZE; i++) 
            { 
                ss << (bools_first ? "" : ",") << bools(i); 
                bools_first = false;  
            } 
            ss << "}"; 

            return ss.str(); 

#endif /// USE_WB_ARRAY_TEST_C_CONVERSION
        } 

        void from_string(const std::string &str) 
        { 
#ifdef USE_WB_ARRAY_TEST_C_CONVERSION 
            wb_array_test_from_string(this, str); 
#else 
            std::istringstream iss(str); 
            std::string strings[ARRAY_TEST_NUMBER_OF_VARIABLES]; 
            memset(strings, 0, sizeof(strings)); 
            std::string token; 
            int count = 0; 

            int isArray = 0; 
            std::string array16_values[ARRAY_TEST_ARRAY16_ARRAY_SIZE]; 
            int array16_count = 0; 
            int is_array16 = 1; 

            std::string bools_values[ARRAY_TEST_BOOLS_ARRAY_SIZE]; 
            int bools_count = 0; 
            int is_bools = 1; 

            while (getline(iss, token, ',')) 
            { 
                token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                token.erase(0, token.find_first_not_of(' '));   // trim left 

                size_t pos = token.find('='); 

                if (pos != std::string::npos) 
                { 
                     token.erase(0, pos+1); 
                } 

                pos = token.find('{'); 

                if (pos != std::string::npos) 
                { 
                    // start of an array 
                    token.erase(0,pos+1); 
                    isArray = 1; 
                } 

                if (isArray) 
                { 
                     pos = token.find('}'); 

                    if (is_array16 == 1) 
                    { 
                        if (pos != std::string::npos) 
                        { 
                            token.erase(pos,token.length()-pos); 
                            is_array16 = 0; 
                            isArray = 0; 
                            count++; 
                        } 

                        token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                        token.erase(0, token.find_first_not_of(' '));   // trim left 
                        array16_values[array16_count] = token; 
                        array16_count++; 
                    } 
                    else if (is_bools == 1) 
                    { 
                        if (pos != std::string::npos) 
                        { 
                            token.erase(pos,token.length()-pos); 
                            is_bools = 0; 
                            isArray = 0; 
                            count++; 
                        } 

                        token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                        token.erase(0, token.find_first_not_of(' '));   // trim left 
                        bools_values[bools_count] = token; 
                        bools_count++; 
                    } 
                } 
                else 
                { 
                    token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                    token.erase(0, token.find_first_not_of(' '));   // trim left 
                    strings[count] = token; 
                    count++; 
                } 
            } 

            if (!strings[0].empty()) 
                set_pressed(strings[0].compare("true") == 0  || strings[0].compare("1") == 0 ? true : false); 

            int array16_smallest = array16_count < ARRAY_TEST_ARRAY16_ARRAY_SIZE ? array16_count : ARRAY_TEST_ARRAY16_ARRAY_SIZE; 

            for (int i = 0; i < array16_smallest; i++) 
            { 
                set_array16(int16_t(atoi(array16_values[i].c_str())), i); 
            } 

            int bools_smallest = bools_count < ARRAY_TEST_BOOLS_ARRAY_SIZE ? bools_count : ARRAY_TEST_BOOLS_ARRAY_SIZE; 

            for (int i = 0; i < bools_smallest; i++) 
            { 
                set_bools(bools_values[i].compare("true") == 0  || bools_values[i].compare("1") == 0 ? true : false, i); 
            } 

#endif /// USE_WB_ARRAY_TEST_C_CONVERSION
        } 
#endif ///   WHITEBOARD_POSTER_STRING_CONVERSION
    }; 
} /// namespace guWhiteboard 
#endif /// ArrayTest_DEFINED 
