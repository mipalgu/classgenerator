/*
 * CHeaderCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 07/08/2017.
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

import Foundation

public final class CHeaderCreator: ErrorContainer {

    public fileprivate(set) var errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let helpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), helpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.helpers = helpers
    }

    public func createCHeader(forClass cls: Class, generatedFrom genfile: String) -> String? {
        let sanitisedClassName = "wb_" + self.helpers.toSnakeCase(String(cls.name.characters.lazy.map {
            self.helpers.isAlphaNumeric($0) ? $0 : "_"
        }))
        guard let strct = self.createStruct(forClass: cls, withSanitisedClassName: sanitisedClassName) else {
            return nil
        }
        let head = self.createHead(forFileNamed: sanitisedClassName + ".h", withClass: cls, andGenFile: genfile)
        let tail = self.createTail(withClassNamed: sanitisedClassName)
        return head + "\n" + strct + "\n" + tail
    }

    fileprivate func createHead(
        forFileNamed fileName: String,
        withClass cls: Class,
        andGenFile genfile: String
    ) -> String {
        let fileName = String(fileName.characters.lazy.map { $0 == "." ? "_" : $0 })
        let comment = self.createFileComment(forFile: fileName, withAuthor: cls.author, andGenFile: genfile)
        let head = """
            #ifndef \(fileName)
            #define \(fileName)

            #include "gu_util.h"
            """
        var defs = "#define \(cls.name.uppercased())_NUMBER_OF_VARIABLES \(cls.variables.count)\n\n"
        defs += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION\n"
        defs += "#define \(cls.name.uppercased())_DESC_BUFFER_SIZE 13046\n"
        defs += "#define \(cls.name.uppercased())_TO_STRING_BUFFER_SIZE 12742\n"
        defs += "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION\n\n"
        for v in cls.variables {
            switch v.type {
                case .array(_, let count):
                    defs += "#define \(cls.name.uppercased())_\(v.label.uppercased())_ARRAY_SIZE \(count)\n"
                default:
                    continue
            }
        }
        return comment + "\n\n\n" + head + "\n\n" + defs
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createFileComment(
        forFile file: String,
        withAuthor author: String,
        andGenFile genfile: String
    ) -> String {
        return """
            /**
             * file \(file)
             *
             * This file was generated by classgenerator from \(genfile).
             * DO NOT CHANGE MANUALLY!
             *
             * Created by \(author) as \(self.creatorHelpers.currentTime), \(self.creatorHelpers.currentDate)
             * Copyright © \(self.creatorHelpers.currentYear) \(author)
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
             *    This product includes software developed by \(author).
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
            """
    }

    fileprivate func createStruct(forClass cls: Class, withSanitisedClassName name: String) -> String? {
        let start = self.createComment(from: cls.comment) + "\n" + "struct \(name)\n{\n"
        var properties: String = ""
        for v in cls.variables {
            guard let p = self.createProperty(
                withLabel: v.label,
                forClassNamed: cls.name,
                fromType: v.type,
                andCType: v.cType
            ) else {
                return nil
            }
            let comment = self.createComment(from: v.comment ?? "", prepend: "    ")
            properties += comment + "\n    " + p + "\n\n"
        }
        return start + properties + "};"
    }

    fileprivate func createProperty(
        withLabel label: String,
        forClassNamed className: String,
        fromType type: VariableTypes,
        andCType cType: String,
        withLevel level: Int = 0
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                switch subtype {
                    case .array:
                        self.errors.append("Multi-Dimensional arrays (\(label)) are not currently supported.")
                        return nil
                    default:
                        break
                }
                return "ARRAY_PROPERTY("
                    + cType
                    + ", \(className.uppercased())_\(label.uppercased())_"
                    + "\(0 == level ? "" : "\(level)_")ARRAY_SIZE)"
            default:
                return "PROPERTY(" + cType + ", " + label + ")"
        }
    }

    fileprivate func createComment(from str: String, prepend: String = "") -> String {
        let lines = str.components(separatedBy: CharacterSet.newlines)
        let start = prepend + "/**\n"
        let end = prepend + " */"
        let temp = lines.reduce(start) { $0 + prepend + " *  " + $1 + "\n" }
        return temp + end
    }

    fileprivate func createTail(withClassNamed name: String) -> String {
        let name = String(name.characters.lazy.map { self.helpers.isAlphaNumeric($0) ? $0 : "_" })
        return """
            #ifdef WHITEBOARD_POSTER_STRING_CONVERSION
            /**
             * Convert to a description string.
             */
            const char* \(name)_description(const struct \(name)* self, char* descString, size_t bufferSize);

            /**
             * Convert to a string.
             */
            const char* \(name)_to_string(const struct \(name)* self, char* toString, size_t bufferSize);

            /**
             * Convert from a string.
             */
            struct \(name)* \(name)_from_string(struct \(name)* self, const char* str);
            #endif /// WHITEBOARD_POSTER_STRING_CONVERSION

            #endif /// \(name)_h
            """
    }

}
