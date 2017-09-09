/*
 * CPPHeaderCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 31/08/2017.
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

public final class CPPHeaderCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        stringHelpers: StringHelpers = StringHelpers()
    ) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    public func createCPPHeader(
        forClass cls: Class,
        forFileNamed fileName: String,
        withClassName className: String,
        withStructName structName: String,
        generatedFrom genfile: String
    ) -> String? {
        let head = self.createHead(
            forFile: fileName,
            withStructNamed: structName,
            withClassNamed: className,
            withAuthor: cls.author,
            generatedFrom: genfile
        )
        let content = self.createClass(named: className, extendingStruct: structName, withVariables: cls.variables)
        return head + "\n\n" + content
    }

    fileprivate func createHead(
        forFile fileName: String,
        withStructNamed structName: String,
        withClassNamed className: String,
        withAuthor author: String,
        generatedFrom genfile: String
    ) -> String {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: author,
            andGenFile: genfile
        )
        let define = """
            #ifndef \(className)_DEFINED
            #define \(className)_DEFINED

            #ifdef WHITEBOARD_POSTER_STRING_CONVERSION
            #include <cstdlib>
            #include <string.h>
            #include <sstream>
            #endif

            #include "\(structName).h"
            """
        return comment + "\n\n" + define
    }

    fileprivate func createClass(
        named className: String,
        extendingStruct structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let namespace = "namespace guWhiteboard {"
        let content = self.createClassContent(forClassNamed: className, extending: structName, withVariables: variables)
        let endNamespace = "};"
        return namespace + "\n\n" + self.stringHelpers.indent(content) + "\n\n" + endNamespace
    }

    fileprivate func createClassContent(
        forClassNamed name: String,
        extending extendName: String,
        withVariables variables: [Variable]
    ) -> String {
        let def = self.createClassDefinition(forClassNamed: name, extending: extendName)
        let publicLabel = "public:"
        let constructor = self.createConstructor(forClassNamed: name, forVariables: variables)
        let copyConstructor = self.createCopyConstructor(
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables
        )
        let copyAssignmentOperator = self.createCopyAssignmentOperator(
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables
        )
        let publicContent = constructor + "\n\n" + copyConstructor + "\n\n" + copyAssignmentOperator
        let publicSection = publicLabel + "\n\n" + self.stringHelpers.indent(publicContent)
        return def + "\n\n" + publicSection + "\n\n};"
    }

    fileprivate func createClassDefinition(forClassNamed name: String, extending extendName: String) -> String {
        let comment = self.creatorHelpers.createComment(from: "Provides a C++ wrapper around `\(extendName)`.")
        let def = "class \(name): public \(extendName) {"
        return comment + "\n" + def
    }

    fileprivate func createConstructor(forClassNamed name: String, forVariables variables: [Variable]) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a new `\(name)`.")
        let startdef = "\(name)("
        let list = variables.map {
            "\(self.calculateCppType(forVariable: $0)) \($0.label) = \($0.defaultValue)"
        }.combine("") { $0 + ", " + $1 }
        let def = startdef + list + ") {"
        let setters = self.createSetters(forVariables: variables)
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(setters) + "\n}"
    }

    fileprivate func calculateCppType(forVariable variable: Variable) -> String {
        switch variable.type {
            case .string:
                return "std::string"
            default:
                return variable.cType + self.calculateSignatureExtras(forType: variable.type)
        }
    }

    fileprivate func calculateSignatureExtras(forType type: VariableTypes) -> String {
        switch type {
            case .pointer:
                return " " + self._calculateSignatureExtras(forType: type)
            default:
                return self._calculateSignatureExtras(forType: type)
        }
    }

    fileprivate func _calculateSignatureExtras(forType type: VariableTypes) -> String {
        switch type {
            case .array(let subtype, let length):
                return "[\(length)]" + self._calculateSignatureExtras(forType: subtype)
            case .pointer(let subtype):
                return "*" + self._calculateSignatureExtras(forType: subtype)
            default:
                return ""
        }
    }

    fileprivate func createCopyConstructor(
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariables variables: [Variable]
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Constructor.")
        let def = "\(className)(const \(className) &other): \(structName)() {"
        let setters = self.createSetters(forVariables: variables) { "other.\($0.label)()" }
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(setters) + "\n}"
    }

    fileprivate func createCopyAssignmentOperator(
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariables variables: [Variable]
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Assignment Operator.")
        let def = "\(className) &operator = (const \(className) &other) {"
        let setters = self.createSetters(forVariables: variables) { "other.\($0.label)()" }
        let ret = "return *this;"
        let content = setters + "\n" + ret
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(content) + "\n}"
    }

    fileprivate func createSetters(
        forVariables variables: [Variable],
        _ transformGetter: (Variable) -> String = { "\($0.label)"}
    ) -> String {
        return variables.map {
            self.createSetter(forVariable: $0, transformGetter)
        }.combine("") {
            $0 + "\n" + $1
        }
    }

    fileprivate func createSetter(
        forVariable variable: Variable,
        _ transformGetter: (Variable) -> String = { "\($0.label)" }
    ) -> String {
        return "set_\(variable.label)(\(transformGetter(variable)));"
    }

}
