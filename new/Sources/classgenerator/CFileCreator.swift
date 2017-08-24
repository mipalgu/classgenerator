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

public final class CFileCreator {

    fileprivate let creatorHelpers: CreatorHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers()) {
        self.creatorHelpers = creatorHelpers
    }

    public func createCFile(forClass cls: Class, generatedFrom genFile: String) -> String? {
        let structName = self.creatorHelpers.createStructName(forClassNamed: cls.name)
        let comment = self.creatorHelpers.createFileComment(
            forFile: structName + ".c",
            withAuthor: cls.author,
            andGenFile: genFile
        )
        let head = self.createHead(forStructNamed: structName)
        let descriptionFunc = self.createDescriptionFunction(forClass: cls, withStructNamed: structName)
        return comment + "\n\n" + head + "\n\n" + descriptionFunc
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

    fileprivate func createDescriptionFunction(forClass cls: Class, withStructNamed structName: String) -> String {
        let comment = """
            /**
             * Convert to a description string.
             */
            """
        //swiftlint:disable:next line_length
        let definition = "const char* \(structName)_description(const struct \(structName)* self, char* descString, size_t bufferSize)\n{"
        let head = """
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-variable"
                size_t len = 0;
            """
        let vars = cls.variables.reduce("") {
            switch $1.type {
                case .array:
                    return $0
                default:
                    guard let format: String = nil else {
                        return $0
                    }
                    return $0 + "\n" + """
                        if (len < bufferSize)
                        {
                            \(format)
                        }
                        """
            }
        }
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + head + "\n" + vars + "\n" + endDefinition
    }

}
