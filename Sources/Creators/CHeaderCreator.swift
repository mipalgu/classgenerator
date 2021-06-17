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

import Containers
import Data
import Helpers
import swift_helpers
import whiteboard_helpers

public final class CHeaderCreator: Creator {

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
    
    public func create(
        forClass cls: Class,
        forFileNamed fileName: String,
        withClassName className: String,
        withStructName structName: String,
        generatedFrom genfile: String,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String? {
        guard let strct = self.createStruct(forClass: cls, withStructName: structName, namespaces: namespaces, squashDefines: squashDefines) else {
            return nil
        }
        let head = self.createHead(
            forFileNamed: fileName,
            withClass: cls,
            withStructName: structName,
            andGenFile: genfile,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let postC = nil == cls.postC ? "" : "\n\n" + cls.postC!
        let tail = self.createTail(withClassNamed: structName, andPostC: postC)
        return head + "\n\n" + strct + "\n\n" + tail + "\n"
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createHead(
        forFileNamed fileName: String,
        withClass cls: Class,
        withStructName structName: String,
        andGenFile genfile: String,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: cls.author,
            andGenFile: genfile
        )
        let includeGuard = WhiteboardHelpers().cIncludeGuard(forClassNamed: cls.name, namespaces: namespaces)
        let head = """
            #ifndef \(includeGuard)
            #define \(includeGuard)

            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wreserved-id-macro"

            #ifdef __linux
            # ifndef _POSIX_SOURCE
            #  define _POSIX_SOURCE 200112L
            # endif
            #endif
            #ifndef _XOPEN_SOURCE
            # define _XOPEN_SOURCE 700
            #endif
            #ifdef __APPLE__
            # ifndef _DARWIN_C_SOURCE
            #  define _DARWIN_C_SOURCE 200112L
            # endif
            # ifndef __DARWIN_C_LEVEL
            #  define __DARWIN_C_LEVEL 200112L
            # endif
            #endif

            #pragma clang diagnostic pop

            #include <gu_util.h>
            #include <stdint.h>
            """
        let toStringSize = self.calculator.getToStringBufferSize(fromVariables: cls.variables)
        let descBufferSize = self.calculator.getDescriptionBufferSize(
            fromVariables: cls.variables,
            withToStringBufferSize: toStringSize
        )
        let defName = self.creatorHelpers.createDefName(fromGenName: cls.name, namespaces: squashDefines ? [] : namespaces)
        var defs = ""
        defs += "#define \(defName)_GENERATED \n"
        defs += "#define \(defName)_C_STRUCT \(structName) \n"
        defs += "#define \(defName)_NUMBER_OF_VARIABLES \(cls.variables.count)\n\n"
        defs += "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION\n"
        defs += "#define \(self.creatorHelpers.createDescriptionBufferSizeDef(fromGenName: cls.name, namespaces: squashDefines ? [] : namespaces)) \(descBufferSize)\n"
        defs += "#define \(self.creatorHelpers.createToStringBufferSizeDef(fromGenName: cls.name, namespaces: squashDefines ? [] : namespaces)) \(toStringSize)\n"
        defs += "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION\n"
        for v in cls.variables {
            switch v.type {
                case .array(_, let count):
                    let def = self.creatorHelpers.createArrayCountDef(inClass: cls.name, forVariable: v.label, level: 0, namespaces: squashDefines ? [] : namespaces)
                    defs += "\n#define \(def) \(count)"
                default:
                    continue
            }
        }
        let preC = nil == cls.preC ? "" : cls.preC! + "\n\n"
        let externC = """
            #ifdef __cplusplus
            extern "C" {
            #endif
            """
        return comment + "\n\n" + head + "\n\n" + preC + defs.trimmingCharacters(in: .newlines) + "\n\n" + externC
    }
//
//    fileprivate func indentC(_ str: String, _ level: Int = 1) -> String {
//        return str.components(separatedBy: .newlines).map {
//            let str = $0.trimmingCharacters(in: .whitespaces)
//            return str.first == "#" ? $0 : self.helpers.indent($0, level)
//        }.combine("") { $0 + "\n" + $1}
//    }

    fileprivate func createStruct(forClass cls: Class, withStructName name: String, namespaces: [CNamespace], squashDefines: Bool) -> String? {
        let pragma = cls.variables.count > 0 ? "" : "#pragma clang diagnostic push\n#pragma clang diagnostic ignored \"-Wc++-compat\"\n\n"
        let start = pragma + self.creatorHelpers.createComment(from: cls.comment) + "\n" + "struct \(name)\n{\n\n"
        var properties: String = ""
        for v in cls.variables {
            guard let p = self.createProperty(
                withLabel: v.label,
                forClassNamed: cls.name,
                fromType: v.type,
                andCType: v.cType,
                namespaces: namespaces,
                squashDefines: squashDefines
            ) else {
                return nil
            }
            let comment = self.creatorHelpers.createComment(from: v.comment ?? "", prepend: "    ")
            properties += comment + "\n    " + p + "\n\n"
        }
        let embeddedC = cls.embeddedC.map { self.helpers.cIndent($0) + "\n\n" } ?? ""
        let end = start + properties + embeddedC + "};"
        return cls.variables.count > 0 ? end : end + "\n#pragma clang diagnostic pop"
    }
    
    private func createArrayBrackets(inClass className: String, forVariable label: String, type: VariableTypes, level: Int, namespaces: [CNamespace], squashDefines: Bool) -> String? {
        switch type {
        case .array(let subtype, _):
            let count = self.creatorHelpers.createArrayCountDef(
                inClass: className,
                forVariable: label,
                level: level,
                namespaces: squashDefines ? [] : namespaces
            )
            return "[" + count + "]" + (self.createArrayBrackets(inClass: className, forVariable: label, type: subtype, level: level + 1, namespaces: namespaces, squashDefines: squashDefines) ?? "")
        default:
            return nil
        }
    }

    fileprivate func createProperty(
        withLabel label: String,
        forClassNamed className: String,
        fromType type: VariableTypes,
        andCType cType: String,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String? {
        switch type {
            case .array:
                guard let brackets = self.createArrayBrackets(inClass: className, forVariable: label, type: type, level: 0, namespaces: namespaces, squashDefines: squashDefines) else {
                    fatalError("Unable to create array brackets for type \(type)")
                }
                return cType + " " + label + brackets + ";"
            case .bit:
                return "unsigned int " + label + " : 1;"
            case .pointer:
                return cType + " " + self.createPointers(forType: type) + label + ";"
            case .string(let length):
                return "char " + label + "[" + length + "];"
            default:
                return cType + " " + label + ";"
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

    //swiftlint:disable:next function_body_length
    fileprivate func createTail(withClassNamed name: String, andPostC postC: String) -> String {
        let name = String(name.lazy.map { self.helpers.isAlphaNumeric($0) ? $0 : "_" })
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

            #endif /// WHITEBOARD_POSTER_STRING_CONVERSION\(postC)

            /*#ifdef WHITEBOARD_SERIALISATION*/

            /**
             * Network stream serialisation
             */
            size_t \(name)_to_network_serialised(const struct \(name) *self, char *dst);

            /**
             * Network stream deserialisation
             */
            size_t \(name)_from_network_serialised(const char *src, struct \(name) *dst);

            /*#endif /// WHITEBOARD_SERIALISATION*/
            
            #ifdef __cplusplus
            }
            #endif
            
            #endif /// \(name)_h
            """
    }

}
