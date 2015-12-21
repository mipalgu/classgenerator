/** 
 * file MYTest.h 
 * 
 * This file was generated by classgenerator from MY_test.txt. 
 * DO NOT CHANGE MANUALLY! 
 * 
 * Created by Mick Hawkins on 17:49, 18/12/2015 
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


#ifndef MYTest_DEFINED 
#define MYTest_DEFINED 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
#include <cstdlib> 
#include <string.h> 
#include <sstream> 
#endif 

#include "wb_my_test.h" 

namespace guWhiteboard 
{
    /** 
     * This is a comment 
     * This is the second line of a comment 
     */ 
    class MYTest: public wb_my_test 
    { 
    public:
        /** Constructor */ 
        MYTest(bool pressed = true, int16_t pointX = 2, int16_t pointY = 0)
        { 
            set_pressed(pressed); 
            set_pointX(pointX); 
            set_pointY(pointY); 
        } 

        /** Copy Constructor */ 
        MYTest(const MYTest &other) : wb_my_test() 
        { 
            set_pressed(other.pressed()); 
            set_pointX(other.pointX()); 
            set_pointY(other.pointY()); 
        } 

        /** Copy Assignment Operator */ 
        MYTest &operator = (const MYTest &other) 
        { 
            set_pressed(other.pressed()); 
            set_pointX(other.pointX()); 
            set_pointY(other.pointY()); 
            return *this; 
        } 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
        /** String Constructor */ 
        MYTest(const std::string &str) { from_string(str.c_str()); }  

        std::string description() 
        { 
#ifdef USE_WB_MY_TEST_C_CONVERSION 
            char buffer[MY_TEST_DESC_BUFFER_SIZE]; 
            wb_my_test_description(this, buffer, sizeof(buffer)); 
            std::string descr = buffer; 
            return descr; 
#else 
            std::ostringstream ss; 
            ss << "pressed=" << pressed(); 
            ss << ", "; 
            ss << "pointX=" << pointX(); 
            ss << ", "; 
            ss << "pointY=" << pointY(); 

            return ss.str(); 

#endif /// USE_WB_MY_TEST_C_CONVERSION
        } 

        std::string to_string() 
        { 
#ifdef USE_WB_MY_TEST_C_CONVERSION 
            char buffer[MY_TEST_DESC_BUFFER_SIZE]; 
            wb_my_test_to_string(this, buffer, sizeof(buffer)); 
            std::string toString = buffer; 
            return toString; 
#else 
            std::ostringstream ss; 
            ss << pressed(); 
            ss << ", "; 
            ss << pointX(); 
            ss << ", "; 
            ss << pointY(); 

            return ss.str(); 

#endif /// USE_WB_MY_TEST_C_CONVERSION
        } 

        void from_string(const std::string &str) 
        { 
#ifdef USE_WB_MY_TEST_C_CONVERSION 
            wb_my_test_from_string(this, str); 
#else 
            std::istringstream iss(str); 
            std::string strings[MY_TEST_NUMBER_OF_VARIABLES]; 
            memset(strings, 0, sizeof(strings)); 
            std::string token; 
            int count = 0; 
            while (getline(iss, token, ',')) 
            { 
                token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                token.erase(0, token.find_first_not_of(' '));   // trim left 

                size_t pos = token.find('='); 

                if (pos != std::string::npos) 
                { 
                     token.erase(0, pos+1); 
                } 

                token.erase(token.find_last_not_of(' ') + 1);   // trim right 
                token.erase(0, token.find_first_not_of(' '));   // trim left 
                strings[count] = token; 
                count++; 
            } 

            if (!strings[0].empty()) 
                set_pressed(strings[0].compare("true") == 0  || strings[0].compare("1") == 0 ? true : false); 

            if (!strings[1].empty()) 
                set_pointX(int16_t(atoi(strings[1].c_str()))); 

            if (!strings[2].empty()) 
                set_pointY(int16_t(atoi(strings[2].c_str()))); 

#endif /// USE_WB_MY_TEST_C_CONVERSION
        } 
#endif ///   WHITEBOARD_POSTER_STRING_CONVERSION
    }; 
/// 
/// Alias for compatibility with old code. 
/// Do not use for new code. 
/// 
class ALIAS_TesT : public MYTest {}; 
} /// namespace guWhiteboard 
#endif /// MYTest_DEFINED 
