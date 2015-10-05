/** 
 * file MYTest.h 
 * 
 * Created by Mick Hawkins on 15:4, 5/10/2015 
 * Copyright (c) 2015 Mick Hawkins 
 * All rights reserved. 
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


#ifndef MYTest_DEFINED 
#define MYTest_DEFINED 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
#include <cstdlib> 
#include <string.h> 
#include <sstream> 
#endif 

#include <gu_util.h> 
#include "wb_my_test.h" 

namespace guWhiteboard 
{
    /** 
     *  ADD YOUR COMMENT DESCRIBING THE CLASS MYTest
     * 
     */ 
    class MYTest: public wb_my_test 
    { 

        /** Default constructor */ 
        MYTest() : _is_pressed(true), _pointX(0), _pointY(2), _longNum(0), _decimalNum(0.0)  {} 

        /** Copy Constructor */ 
        MYTest(const wb_my_test &other) : 
            _is_pressed(other._is_pressed), 
            _pointX(other._pointX), 
            _pointY(other._pointY), 
            _longNum(other._longNum), 
            _decimalNum(other._decimalNum) {} 

        /** Assignment Operator */ 
        MYTest &operator= (const wb_my_test &other) 
        { 
            _is_pressed = other._is_pressed; 
            _pointX = other._pointX; 
            _pointY = other._pointY; 
            _longNum = other._longNum; 
            _decimalNum = other._decimalNum; 
            return *this; 
        } 

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION 
        std::string description() 
        { 
#ifdef USE_WB_MY_TEST_C_CONVERSION 
            char buffer[MY_TEST_DESC_BUFFER_SIZE]; 
            wb_my_test_description (this, buffer, sizeof(buffer)); 
            std::string descr = buffer; 
            return descr; 
#else 
            std::string description() const 
            { 
                std::ostringstream ss; 
                ss << "is_pressed=" << is_pressed << ", "; 
                ss << "pointX=" << pointX << ", "; 
                ss << "pointY=" << pointY << ", "; 
                ss << "longNum=" << longNum << ", "; 
                ss << "decimalNum=" << decimalNum;
                return ss.str(); 
            } 
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