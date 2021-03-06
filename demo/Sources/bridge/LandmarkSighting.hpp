/*
 * file LandmarkSighting.hpp
 *
 * This file was generated by classgenerator from landmark_sighting.gen.
 * DO NOT CHANGE MANUALLY!
 *
 * Copyright © 2021 Callum McColl. All rights reserved.
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

#ifndef guWhiteboard_LandmarkSighting_h
#define guWhiteboard_LandmarkSighting_h

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
#include <cstdlib>
#include <string.h>
#include <sstream>
#endif

#include <gu_util.h>
#include "wb_landmark_sighting.h"

#undef guWhiteboard_LandmarkSighting_DEFINED
#define guWhiteboard_LandmarkSighting_DEFINED

#undef LandmarkSighting_DEFINED
#define LandmarkSighting_DEFINED

namespace guWhiteboard {

    /**
     * Provides a C++ wrapper around `wb_landmark_sighting`.
     */
    class LandmarkSighting: public wb_landmark_sighting {

    private:

        /**
         * Set the members of the class.
         */
        void init(int16_t t_direction = 0, uint16_t t_distance = 0, enum LandmarkSightingType t_sightingType = static_cast<enum LandmarkSightingType>(0)) {
            set_direction(t_direction);
            set_distance(t_distance);
            set_sightingType(t_sightingType);
        }

    public:

        /**
         * Create a new `LandmarkSighting`.
         */
        LandmarkSighting(int16_t t_direction = 0, uint16_t t_distance = 0, enum LandmarkSightingType t_sightingType = static_cast<enum LandmarkSightingType>(0)) {
            this->init(t_direction, t_distance, t_sightingType);
        }

        /**
         * Copy Constructor.
         */
        LandmarkSighting(const LandmarkSighting &t_other): wb_landmark_sighting() {
            this->init(t_other.direction(), t_other.distance(), t_other.sightingType());
        }

        /**
         * Copy Constructor.
         */
        LandmarkSighting(const struct wb_landmark_sighting &t_other): wb_landmark_sighting() {
            this->init(t_other.direction, t_other.distance, t_other.sightingType);
        }

        /**
         * Copy Assignment Operator.
         */
        LandmarkSighting &operator = (const LandmarkSighting &t_other) {
            this->init(t_other.direction(), t_other.distance(), t_other.sightingType());
            return *this;
        }

        /**
         * Copy Assignment Operator.
         */
        LandmarkSighting &operator = (const struct wb_landmark_sighting &t_other) {
            this->init(t_other.direction, t_other.distance, t_other.sightingType);
            return *this;
        }

        bool operator ==(const LandmarkSighting &t_other) const
        {
            return direction() == t_other.direction()
                && distance() == t_other.distance()
                && sightingType() == t_other.sightingType();
        }

        bool operator !=(const LandmarkSighting &t_other) const
        {
            return !(*this == t_other);
        }

        bool operator ==(const wb_landmark_sighting &t_other) const
        {
            return *this == LandmarkSighting(t_other);
        }

        bool operator !=(const wb_landmark_sighting &t_other) const
        {
            return !(*this == t_other);
        }

        int16_t & direction()
        {
            return wb_landmark_sighting::direction;
        }

        const int16_t & direction() const
        {
            return wb_landmark_sighting::direction;
        }

        void set_direction(const int16_t &t_newValue)
        {
            wb_landmark_sighting::direction = t_newValue;
        }

        uint16_t & distance()
        {
            return wb_landmark_sighting::distance;
        }

        const uint16_t & distance() const
        {
            return wb_landmark_sighting::distance;
        }

        void set_distance(const uint16_t &t_newValue)
        {
            wb_landmark_sighting::distance = t_newValue;
        }

        enum LandmarkSightingType & sightingType()
        {
            return wb_landmark_sighting::sightingType;
        }

        const enum LandmarkSightingType & sightingType() const
        {
            return wb_landmark_sighting::sightingType;
        }

        void set_sightingType(const enum LandmarkSightingType &t_newValue)
        {
            wb_landmark_sighting::sightingType = t_newValue;
        }

#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
        /**
         * String Constructor.
         */
        LandmarkSighting(const std::string &t_str) {
            this->init();
            this->from_string(t_str);
        }

        std::string description() {
#ifdef USE_WB_LANDMARK_SIGHTING_C_CONVERSION
            char buffer[LANDMARK_SIGHTING_DESC_BUFFER_SIZE];
            wb_landmark_sighting_description(this, buffer, sizeof(buffer));
            std::string descr = buffer;
            return descr;
#else
            std::ostringstream ss;
            ss << "direction=" << static_cast<signed>(this->direction());
            ss << ", ";
            ss << "distance=" << static_cast<unsigned>(this->distance());
            ss << ", ";
            switch (this->sightingType()) {
                case BallSightingType:
                {
                    ss << "sightingType=" << "BallSightingType";
                    break;
                }
                case CornerHorizonSightingType:
                {
                    ss << "sightingType=" << "CornerHorizonSightingType";
                    break;
                }
                case CornerLineSightingType:
                {
                    ss << "sightingType=" << "CornerLineSightingType";
                    break;
                }
                case CrossLineSightingType:
                {
                    ss << "sightingType=" << "CrossLineSightingType";
                    break;
                }
                case GenericGoalPostSightingType:
                {
                    ss << "sightingType=" << "GenericGoalPostSightingType";
                    break;
                }
                case GoalLandmarkSightingType:
                {
                    ss << "sightingType=" << "GoalLandmarkSightingType";
                    break;
                }
                case LeftGoalPostSightingType:
                {
                    ss << "sightingType=" << "LeftGoalPostSightingType";
                    break;
                }
                case LineHorizonSightingType:
                {
                    ss << "sightingType=" << "LineHorizonSightingType";
                    break;
                }
                case RightGoalPostSightingType:
                {
                    ss << "sightingType=" << "RightGoalPostSightingType";
                    break;
                }
                case StraightLineSightingType:
                {
                    ss << "sightingType=" << "StraightLineSightingType";
                    break;
                }
                case TIntersectionLineSightingType:
                {
                    ss << "sightingType=" << "TIntersectionLineSightingType";
                    break;
                }
            }
            return ss.str();
#endif /// USE_WB_LANDMARK_SIGHTING_C_CONVERSION
        }

        std::string to_string() {
#ifdef USE_WB_LANDMARK_SIGHTING_C_CONVERSION
            char buffer[LANDMARK_SIGHTING_TO_STRING_BUFFER_SIZE];
            wb_landmark_sighting_to_string(this, buffer, sizeof(buffer));
            std::string toString = buffer;
            return toString;
#else
            std::ostringstream ss;
            ss << static_cast<signed>(this->direction());
            ss << ", ";
            ss << static_cast<unsigned>(this->distance());
            ss << ", ";
            switch (this->sightingType()) {
                case BallSightingType:
                {
                    ss << "BallSightingType";
                    break;
                }
                case CornerHorizonSightingType:
                {
                    ss << "CornerHorizonSightingType";
                    break;
                }
                case CornerLineSightingType:
                {
                    ss << "CornerLineSightingType";
                    break;
                }
                case CrossLineSightingType:
                {
                    ss << "CrossLineSightingType";
                    break;
                }
                case GenericGoalPostSightingType:
                {
                    ss << "GenericGoalPostSightingType";
                    break;
                }
                case GoalLandmarkSightingType:
                {
                    ss << "GoalLandmarkSightingType";
                    break;
                }
                case LeftGoalPostSightingType:
                {
                    ss << "LeftGoalPostSightingType";
                    break;
                }
                case LineHorizonSightingType:
                {
                    ss << "LineHorizonSightingType";
                    break;
                }
                case RightGoalPostSightingType:
                {
                    ss << "RightGoalPostSightingType";
                    break;
                }
                case StraightLineSightingType:
                {
                    ss << "StraightLineSightingType";
                    break;
                }
                case TIntersectionLineSightingType:
                {
                    ss << "TIntersectionLineSightingType";
                    break;
                }
            }
            return ss.str();
#endif /// USE_WB_LANDMARK_SIGHTING_C_CONVERSION
        }

#ifdef USE_WB_LANDMARK_SIGHTING_C_CONVERSION
        void from_string(const std::string &t_str) {
            wb_landmark_sighting_from_string(this, t_str.c_str());
#else
        void from_string(const std::string &t_str) {
            char * str_cstr = const_cast<char *>(t_str.c_str());
            size_t temp_length = strlen(str_cstr);
            int length = (temp_length <= INT_MAX) ? static_cast<int>(static_cast<ssize_t>(temp_length)) : -1;
            if (length < 1 || length > LANDMARK_SIGHTING_DESC_BUFFER_SIZE) {
                return;
            }
            char var_str_buffer[LANDMARK_SIGHTING_DESC_BUFFER_SIZE + 1];
            char* var_str = &var_str_buffer[0];
            char key_buffer[13];
            char* key = &key_buffer[0];
            int bracecount = 0;
            int startVar = 0;
            int index = 0;
            int startKey = 0;
            int endKey = -1;
            int varIndex = 0;
            if (index == 0 && str_cstr[0] == '{') {
                index = 1;
            }
            startVar = index;
            startKey = startVar;
            do {
                for (int i = index; i < length; i++) {
                    index = i + 1;
                    if (bracecount == 0 && str_cstr[i] == '=') {
                        endKey = i - 1;
                        startVar = index;
                        continue;
                    }
                    if (bracecount == 0 && isspace(str_cstr[i])) {
                        startVar = index;
                        if (endKey == -1) {
                            startKey = index;
                        }
                        continue;
                    }
                    if (bracecount == 0 && str_cstr[i] == ',') {
                        index = i - 1;
                        break;
                    }
                    if (str_cstr[i] == '{') {
                        bracecount++;
                        continue;
                    }
                    if (str_cstr[i] == '}') {
                        bracecount--;
                        if (bracecount < 0) {
                            index = i - 1;
                            break;
                        }
                    }
                    if (i == length - 1) {
                        index = i;
                    }
                }
                if (endKey >= startKey && endKey - startKey < length) {
                    strncpy(key, str_cstr + startKey, static_cast<size_t>((endKey - startKey) + 1));
                    key[(endKey - startKey) + 1] = 0;
                } else {
                    key[0] = 0;
                }
                strncpy(var_str, str_cstr + startVar, static_cast<size_t>((index - startVar) + 1));
                var_str[(index - startVar) + 1] = 0;
                bracecount = 0;
                index += 2;
                startVar = index;
                startKey = startVar;
                endKey = -1;
                if (strlen(key) > 0) {
                    if (0 == strcmp("direction", key)) {
                        varIndex = 0;
                    } else if (0 == strcmp("distance", key)) {
                        varIndex = 1;
                    } else if (0 == strcmp("sightingType", key)) {
                        varIndex = 2;
                    } else {
                        varIndex = -1;
                    }
                }
                switch (varIndex) {
                    case -1: { break; }
                    case 0:
                    {
                        this->set_direction(static_cast<int16_t>(atoi(var_str)));
                        break;
                    }
                    case 1:
                    {
                        this->set_distance(static_cast<uint16_t>(atoi(var_str)));
                        break;
                    }
                    case 2:
                    {
                        if (strcmp("BallSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(BallSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("CornerHorizonSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(CornerHorizonSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("CornerLineSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(CornerLineSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("CrossLineSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(CrossLineSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("GenericGoalPostSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(GenericGoalPostSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("GoalLandmarkSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(GoalLandmarkSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("LeftGoalPostSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(LeftGoalPostSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("LineHorizonSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(LineHorizonSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("RightGoalPostSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(RightGoalPostSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("StraightLineSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(StraightLineSightingType);
#pragma clang diagnostic pop
                        } else if (strcmp("TIntersectionLineSightingType", var_str) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(TIntersectionLineSightingType);
#pragma clang diagnostic pop
                        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbad-function-cast"
                        this->set_sightingType(static_cast<enum LandmarkSightingType>(atoi(var_str)));
#pragma clang diagnostic pop
                        }
                        break;
                    }
                }
                if (varIndex >= 0) {
                    varIndex++;
                }
            } while(index < length);
#endif /// USE_WB_LANDMARK_SIGHTING_C_CONVERSION
        }
#endif /// WHITEBOARD_POSTER_STRING_CONVERSION
    };

} /// namespace guWhiteboard

#endif /// guWhiteboard_LandmarkSighting_h
