/*
 * file Sections.h
 *
 * This file was generated by classgenerator from sections.gen.
 * DO NOT CHANGE MANUALLY!
 *
 * Created by Callum McColl at %time%, %date%.
 * Copyright © %year% Callum McColl. All rights reserved.
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
 *        This product includes software developed by Callum McColl.
 *
 * 4. Neither the name of the author nor the names of contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
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
 *
 */

#ifndef Sections_DEFINED
#define Sections_DEFINED

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
#include <cstdlib>
#include <string.h>
#include <sstream>
#endif

#include "gu_util.h"
#include "wb_sections.h"

#include <iostream>

namespace guWhiteboard {

    /**
     * Provides a C++ wrapper around `wb_sections`.
     */
    class Sections: public wb_sections {

    public:

        /**
         * Create a new `Sections`.
         */
        Sections(int c = 2) {
            set_c(c);
        }

        /**
         * Copy Constructor.
         */
        Sections(const Sections &other): wb_sections() {
            set_c(other.c());
        }

        /**
         * Copy Assignment Operator.
         */
        Sections &operator = (const Sections &other) {
            set_c(other.c());
            return *this;
        }

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
        /**
         * String Constructor.
         */
        Sections(const std::string &str) { wb_sections_from_string(this, str.c_str()); }

        std::string description() {
#ifdef USE_WB_SECTIONS_C_CONVERSION
            char buffer[SECTIONS_DESC_BUFFER_SIZE];
            wb_sections_description(this, buffer, sizeof(buffer));
            std::string descr = buffer;
            return descr;
#else
            std::ostringstream ss;
            ss << "c=" << this->c();
            return ss.str();
#endif /// USE_WB_SECTIONS_C_CONVERSION
        }

        std::string to_string() {
#ifdef USE_WB_SECTIONS_C_CONVERSION
            char buffer[SECTIONS_TO_STRING_BUFFER_SIZE];
            wb_sections_to_string(this, buffer, sizeof(buffer));
            std::string toString = buffer;
            return toString;
#else
            std::ostringstream ss;
            ss << this->c();
            return ss.str();
#endif /// USE_WB_SECTIONS_C_CONVERSION
        }

        void from_string(const std::string &str) {
#ifdef USE_WB_OLD_C_CONVERSION
            wb_sections_from_string(this, str);
#else
            char var[255];
            unsigned long c_index = str.find("c");
            if (c_index != std::string::npos) {
                memset(&var[0], 0, sizeof(var));
                if (sscanf(str.substr(c_index, str.length()).c_str(), "c = %[^,]", var) == 1) {
                    std::string value = std::string(var);
                    set_c((int) (atoi(value.c_str())));
                }
            }
#endif /// USE_WB_OLD_C_CONVERSION
        }
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION

        int g() {
            return c() + 2;
        }
    };

    int h() {
        return 3;
    }

} /// namespace guWhiteboard
#endif /// Sections_DEFINED