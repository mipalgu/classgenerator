/*
 *  guwhiteboardposter.h
 *
 *  Created by Rene Hexel on 26/04/13.
 *  Copyright (c) 2013, 2014 Rene Hexel.
 *  All rights reserved.
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
 *    software must display the following acknowledgment:
 *
 *        This product includes software developed by Rene Hexel.
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
#ifndef gusimplewhiteboard_guwhiteboardposter_h
#define gusimplewhiteboard_guwhiteboardposter_h

#ifdef __cplusplus
#include <string>
#include <map>
#include <stdbool.h>

/*
 * Include your classes below if they have description methods and
 * string constructors!
 */
#ifdef WHITEBOARD_POSTER_STRING_CONVERSION
#include "NaoWalkCommand.h"
#include "NaoWalkStatus.h"
#include "MOTION_Interface.h"
#include "FSMControlStatus.h"
#include "FFTStatus.h"
#include "Vision_Control.h"
#include "FilteredOneDimSonar.h"
#include "FilteredVisionObject.h"
#include "FilteredOneDimObject.h"
#include "FilteredArrayOneDimSonar.h"
#include "FilteredArrayOneDimObjects.h"
#include "FilteredArrayBallSightings.h"
#include "SENSORSSonarSensors.h"
#include "SensorsFootSensors.h"
#include "SENSORSTorsoJointTemps.h"
#include "SENSORSLegJointTemps.h"
#include "NAO_State.h"
#include "HAL_HeadTarget.h"
#include "SENSORSTorsoJointSensors.h"
#include "SENSORSLegJointSensors.h"
//#include "PARTICLE_TopPositions.h"
#include "Point2D.h"
#include "ParticlePosition.h"
#include "TopParticles.h"
#include "SensorsBodySensors.h"
#include "WEBOTS_NXT_bridge.h"
#include "VisionBall.h"
#include "VisionGoals.h"
#include "WalkData.h"
#include "Giraff_MainSerialInterface.h"
#include "NXT_Interface.h"
#include "APM_Interface.h"
#include "Oculus_PrimeSerialInterface.h"
#include "IOPins.h"
#include "DifferentialRobotControlStatus.h"
#include "NXT_Two_Touch_Status.h"
#include "NXT_Sound_Control.h"
#include "NXT_Lights_Control.h"
#include "Clocks.h"
#include "Channels.h"
#include "SwitchSubsumption.h"
#include "SwitchSubsumptionTrafficLights.h"
#include "Input3D.h"
#include "HAL_ArmTarget.h"
#include "VisionLines.h"
#include "VisionRobots.h"
#include "FieldHorizon.h"
#include "FieldHorizons.h"
#include "TeleoperationControlStatus.h"

//#include "GazeboObjectPose.h"
#endif // WHITEBOARD_POSTER_STRING_CONVERSION

extern "C"
{
#else
#include <stdbool.h>
#endif // __cplusplus

#include "gusimplewhiteboard.h"
#include "guwhiteboardtypelist_c_generated.h"

/**
 * A generic C function that posts to the whiteboard.
 * Both the message type and the message content are strings.
 */
bool whiteboard_post(const char *message_type, const char *message_content);

/**
 * A generic C function that posts to a given whiteboard.
 * Both the message type and the message content are strings.
 */
bool whiteboard_post_to(gu_simple_whiteboard_descriptor *wbd, const char *message_type, const char *message_content);

/**
 * Generic C function that posts a message with a given message number
 * to the whiteboard.
 */
bool whiteboard_postmsg(int message_index, const char *message_content);

/**
 * Generic C function that posts a message with a given message number
 * to a given whiteboard.
 */
bool whiteboard_postmsg_to(gu_simple_whiteboard_descriptor *wbd, int message_index, const char *message_content);

/**
 * Generic C function that returns the type for a given message name
 */

#ifndef __cplusplus
int whiteboard_type_for_message_named(const char *message_type);
#else
guWhiteboard::WBTypes whiteboard_type_for_message_named(const char *message_type);
}

namespace guWhiteboard
{
        /**
         * A generic C++ function that posts to the whiteboard.
         * Both the message type and the message content are strings.
         * @param message_type the string version of the type
         * @param message_content the string data to pass to the types string constructor
         * @param wbd whiteboard descriptor (NULLPTR for the default whiteboard)
         * @return true if there is a string constructor for the passed in type
         */
        bool post(std::string message_type, std::string message_content, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

        /**
         * Generic C++ function that posts a message with a given message number
         * to the whiteboard.
         * @param message_index the offset or enum value of the type to post
         * @param message_content the string data to pass to the types string constructor
         * @param wbd whiteboard descriptor (NULLPTR for the default whiteboard)
         * @return true if there is a string constructor for the passed in type 
         */
        bool postmsg(guWhiteboard::WBTypes message_index, std::string message_content, gu_simple_whiteboard_descriptor *wbd = NULLPTR);

        /**
         * Map structure from strings to message types
         */
        struct whiteboard_types_map: public std::map<std::string, guWhiteboard::WBTypes>
        {
                whiteboard_types_map(); ///< default constructor
        };

        /**
         * Global map from names to message types
         */
        extern struct whiteboard_types_map types_map;
}
#endif // __cplusplus

#endif
