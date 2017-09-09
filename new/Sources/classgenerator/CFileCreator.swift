/*
 * CFileCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 24/08/2017.
 * Copyright © 2017 Callum McColl. All rights reserved.
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

public final class CFileCreator: ErrorContainer {

    public let errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let descriptionCreator: CDescriptionCreator
    fileprivate let fromStringCreator: CFromStringCreator

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        descriptionCreator: CDescriptionCreator = CDescriptionCreator(),
        fromStringCreator: CFromStringCreator = CFromStringCreator()
    ) {
        self.creatorHelpers = creatorHelpers
        self.descriptionCreator = descriptionCreator
        self.fromStringCreator = fromStringCreator
    }

    public func createCFile(
        forClass cls: Class,
        forFileNamed fileName: String,
        withStructName structName: String,
        generatedFrom genFile: String
    ) -> String? {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: cls.author,
            andGenFile: genFile
        )
        let head = self.createHead(forStructNamed: structName)
        let descriptionFunc = self.descriptionCreator.createFunction(
            creating: "description",
            withComment: """
                /**
                 * Convert to a description string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "descString"
        )
        let toStringFunc = self.descriptionCreator.createFunction(
            creating: "to_string",
            withComment: """
                /**
                 * Convert to a string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "toString"
        )
        let fromStringFunc = self.fromStringCreator.createFunction(
            creating: "from_string",
            withComment: """
                /**
                 * Convert from a string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "str"
        )
        return comment + "\n\n" + head + "\n\n" + descriptionFunc + "\n\n" + toStringFunc + "\n\n" + fromStringFunc
    }

    fileprivate func createHead(forStructNamed structName: String) -> String {
        return """
            #define WHITEBOARD_POSTER_STRING_CONVERSION
            #include "\(structName).h"
            #include <stdio.h>
            #include <string.h>
            #include <stdlib.h>
            """
    }

}
