/*
 * CFileCreatorFactory.swift
 * Creators
 *
 * Created by Callum McColl on 15/3/19.
 * Copyright © 2019 Callum McColl. All rights reserved.
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

import Foundation
import Helpers
import swift_helpers
import whiteboard_helpers

public final class CFileCreatorFactory: CreatorFactory {
    
    fileprivate let date: Date
    fileprivate let stringHelpers: StringHelpers
    fileprivate let whiteboardHelpers: WhiteboardHelpers
    
    public init(date: Date = Date(), stringHelpers: StringHelpers = StringHelpers(), whiteboardHelpers: WhiteboardHelpers = WhiteboardHelpers()) {
        self.date = date
        self.stringHelpers = stringHelpers
        self.whiteboardHelpers = whiteboardHelpers
    }
    
    public func make(backwardCompatible: Bool) -> CFileCreator {
        let creatorHelpers = CreatorHelpers(backwardsCompatible: backwardCompatible, date: self.date, helpers: self.whiteboardHelpers)
        let descriptionCreator = CDescriptionCreator(creatorHelpers: creatorHelpers, stringHelpers: stringHelpers)
        let networkSerialiserCreator = CNetworkSerialiserCreator(creatorHelpers: creatorHelpers, stringHelpers: self.stringHelpers)
        let networkDeserialiserCreator = CNetworkDeserialiserCreator(creatorHelpers: creatorHelpers, stringHelpers: self.stringHelpers)
        let fromStringCreator = CFromStringCreator<FromStringImplementationCreator>(
            creatorHelpers: creatorHelpers,
            implementationCreator: FromStringImplementationCreator(creatorHelpers: creatorHelpers, stringHelpers: self.stringHelpers),
            stringHelpers: self.stringHelpers
        )
        return CFileCreator(
            creatorHelpers: creatorHelpers,
            descriptionCreator: descriptionCreator,
            networkSerialiserCreator: networkSerialiserCreator,
            networkDeserialiserCreator: networkDeserialiserCreator,
            fromStringCreator: fromStringCreator
        )
    }
    
}