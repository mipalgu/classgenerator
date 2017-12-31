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

    fileprivate let calculator: BufferSizeCalculator
    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let helpers: StringHelpers

    public init(
        calculator: BufferSizeCalculator = BufferSizeCalculator(),
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        helpers: StringHelpers = StringHelpers()
    ) {
        self.calculator = calculator
        self.creatorHelpers = creatorHelpers
        self.helpers = helpers
    }

    public func createCHeader(
        forClass cls: Class,
        forFileNamed fileName: String,
        withStructName structName: String,
        generatedFrom genfile: String
    ) -> String? {
        guard let strct = self.createStruct(forClass: cls, withStructName: structName) else {
            return nil
        }
        let head = self.createHead(forFileNamed: fileName, withClass: cls, withStructName: structName, andGenFile: genfile)
        let postC = nil == cls.postC ? "" : "\n\n" + cls.postC!
        let tail = self.createTail(withClassNamed: structName, andPostC: postC)
        return head + "\n\n" + strct + "\n\n" + tail + "\n"
    }

    fileprivate func createHead(
        forFileNamed fileName: String,
        withClass cls: Class,
        withStructName structName: String,
        andGenFile genfile: String
    ) -> String {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: cls.author,
            andGenFile: genfile
        )
        let fileName = String(fileName.lazy.map { $0 == "." ? "_" : $0 })
        let head = """
            #ifndef \(fileName)
            #define \(fileName)

            #include "gu_util.h"
            #include <stdint.h>
            """
        let toStringSize = self.calculator.getToStringBufferSize(fromVariables: cls.variables)
        let descBufferSize = self.calculator.getDescriptionBufferSize(
            fromVariables: cls.variables,
            withToStringBufferSize: toStringSize
        )

        //Getting the whiteboard generator and the class generator to agree on a naming format is annoying... Using the ClassName for now.
        let className = self.creatorHelpers.createClassName(forClassNamed: cls.name)
        var defs = ""
        defs += "#define \(className.uppercased())_GENERATED \n"
        defs += "#define \(className.uppercased())_C_STRUCT \(structName) \n"
        defs += "#define \(cls.name.uppercased())_NUMBER_OF_VARIABLES \(cls.variables.count)\n\n"
        defs += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION\n"
        defs += "#define \(cls.name.uppercased())_DESC_BUFFER_SIZE \(descBufferSize)\n"
        defs += "#define \(cls.name.uppercased())_TO_STRING_BUFFER_SIZE \(toStringSize)\n"
        defs += "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION\n"
        for v in cls.variables {
            switch v.type {
                case .array(_, let count):
                    let def = self.creatorHelpers.createArrayCountDef(inClass: cls.name, forVariable: v.label, level: 0)
                    defs += "\n#define \(def) \(count)"
                default:
                    continue
            }
        }
        let preC = nil == cls.preC ? "" : cls.preC! + "\n\n"
        return comment + "\n\n" + head + "\n\n" + preC + defs.trimmingCharacters(in: .newlines)
    }

    fileprivate func createStruct(forClass cls: Class, withStructName name: String) -> String? {
        let start = self.creatorHelpers.createComment(from: cls.comment) + "\n" + "struct \(name)\n{\n\n"
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
            let comment = self.creatorHelpers.createComment(from: v.comment ?? "", prepend: "    ")
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
                    + ", \(label)"
                    + ", \(className.uppercased())_\(label.uppercased())_"
                    + "\(0 == level ? "" : "\(level)_")ARRAY_SIZE)"
            case .bit:
                return "BIT_PROPERTY(" + label + ")"
            case .pointer:
                return "PROPERTY(" + cType + self.createPointers(forType: type) + ", " + label + ")"
            case .string(let length):
                return "ARRAY_PROPERTY(char, \(label), \(length))"
            default:
                return "PROPERTY(" + cType + ", " + label + ")"
        }
    }

    fileprivate func createPointers(forType type: VariableTypes) -> String {
        switch type {
            case .pointer(let subtype):
                return self.createPointers(forType: subtype) + "*"
            default:
                return ""
        }
    }

    fileprivate func createTail(withClassNamed name: String, andPostC postC: String) -> String {
        let name = String(name.lazy.map { self.helpers.isAlphaNumeric($0) ? $0 : "_" })
        return """
            #ifdef __cplusplus
            extern "C" {
            #endif

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

            #endif /// WHITEBOARD_POSTER_STRING_CONVERSION\(postC)

            /**
             * Network stream serialisation
             */
            size_t \(name)_to_network_compressed(const struct \(name)* self, char *dst);

            #ifdef __cplusplus
            }
            #endif

            #endif /// \(name)_h
            """
    }

}
