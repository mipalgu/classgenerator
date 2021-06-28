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

import Containers
import Data
import Helpers
import swift_helpers
import whiteboard_helpers

import Foundation

//swiftlint:disable type_body_length
public final class CPPHeaderCreator: Creator {

    public let errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let namespaces: [CPPNamespace]
    private let cHeaderPath: URL
    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers
    fileprivate let stringFunctionsCreator: CPPStringFunctionsCreator
    fileprivate let fromStringCreator: CPPFromStringCreator

    public init(
        namespaces: [CPPNamespace] = [],
        cHeaderPath: URL,
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        stringHelpers: StringHelpers = StringHelpers(),
        stringFunctionsCreator: CPPStringFunctionsCreator = CPPStringFunctionsCreator(),
        fromStringCreator: CPPFromStringCreator = CPPFromStringCreator()
    ) {
        self.namespaces = namespaces
        self.cHeaderPath = cHeaderPath
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
        self.stringFunctionsCreator = stringFunctionsCreator
        self.fromStringCreator = fromStringCreator
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
        let head = self.createHead(
            forClass: cls,
            forFile: fileName,
            withStructNamed: structName,
            withClassNamed: className,
            withAuthor: cls.author,
            generatedFrom: genfile,
            variables: cls.variables,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let content = self.createClass(
            forClass: cls,
            named: className,
            extendingStruct: structName,
            withVariables: cls.variables,
            andEmbeddedCpp: cls.embeddedCpp,
            andPostCpp: cls.postCpp,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let defName = WhiteboardHelpers().cppIncludeGuard(forClassNamed: cls.name, namespaces: self.namespaces)
        let pre = nil == cls.preCpp ? "" : "\n\n" + cls.preCpp!
        return head + pre + "\n\n" + content + "\n\n" + "#endif /// \(defName)\n"
    }

    fileprivate func createHead(
        forClass cls: Class,
        forFile fileName: String,
        withStructNamed structName: String,
        withClassNamed className: String,
        withAuthor author: String,
        generatedFrom genfile: String,
        variables: [Variable],
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: author,
            andGenFile: genfile
        )
        let includes = nil == variables.first { $0.type.isFloat } ? "" : "\n#include <float.h>"
        let defName = WhiteboardHelpers().cppIncludeGuard(forClassNamed: cls.name, namespaces: self.namespaces)
        let define = """
            #ifndef \(defName)
            #define \(defName)

            #ifdef WHITEBOARD_POSTER_STRING_CONVERSION
            #include <cstdlib>
            #include <string.h>
            #include <sstream>
            #endif

            #include <gu_util.h>
            #include "\(cHeaderPath.lastPathComponent)"\(includes)
            """
        let defined: String
        if namespaces.isEmpty {
            defined = WhiteboardHelpers().cppDefinedDef(forClassNamed: cls.name)
        } else {
            defined = WhiteboardHelpers().cppDefinedDef(forClassNamed: cls.name, namespaces: self.namespaces) + "\n" + WhiteboardHelpers().cppDefinedDef(forClassNamed: cls.name)
        }
        let definedDefs = defined.components(separatedBy: .newlines).map {
            "#undef " + $0 + "\n#define " + $0
        }.joined(separator: "\n\n")
        return comment + "\n\n" + define + "\n\n" + definedDefs
    }

    //swiftlint:disable:next function_parameter_count
    fileprivate func createClass(
        forClass cls: Class,
        named className: String,
        extendingStruct structName: String,
        withVariables variables: [Variable],
        andEmbeddedCpp embeddedCpp: String?,
        andPostCpp postCpp: String?,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let namespacesDefs = self.namespaces
        let startNamespace = namespacesDefs.enumerated().lazy.map {
            self.stringHelpers.indent("namespace " + $1 + " {", $0)
        }.combine("") { $0 + "\n\n" + $1 }
        let endNamespace = namespacesDefs.enumerated().reversed().lazy.map {
            self.stringHelpers.indent("} /// namespace " + $1, $0)
        }.combine("") { $0 + "\n\n" + $1 }
        let content = self.createClassContent(
            forClass: cls,
            forClassNamed: className,
            extending: structName,
            withVariables: variables,
            andEmbeddedCpp: embeddedCpp,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let postCpp = nil == postCpp ? "" : "\n\n" + postCpp!
        let allContent = content + postCpp + "\n\n"
        return startNamespace + "\n\n" + self.stringHelpers.cIndent(allContent, namespaces.count) + endNamespace
    }

    fileprivate func createClassContent(
        forClass cls: Class,
        forClassNamed name: String,
        extending extendName: String,
        withVariables variables: [Variable],
        andEmbeddedCpp cpp: String?,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let def = self.createClassDefinition(forClassNamed: name, extending: extendName)
        let publicLabel = "public:"
        let constructor = self.createConstructor(forClass: cls, forClassNamed: name, forVariables: variables)
        let copyConstructor = self.createCopyConstructor(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: name,
            includeBrackets: true
        )
        let structCopyConstructor = self.createCopyConstructor(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: "struct " + extendName,
            includeBrackets: false
        )
        let copyAssignmentOperator = self.createCopyAssignmentOperator(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: name,
            includeBrackets: true
        )
        let structCopyAssignmentOperator = self.createCopyAssignmentOperator(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: "struct " + extendName,
            includeBrackets: false
        )
        let equalsOperators = self.createEqualityOperators(inClass: cls, forClassNamed: name, andStructNamed: extendName)
        let gettersAndSetters = self.createGettersAndSetters(inClass: cls, andStructNamed: extendName, namespaces: namespaces, squashDefines: squashDefines)
        let privateContent = self.createInit(forClass: cls, structName: extendName, forVariables: variables, namespaces: namespaces, squashDefines: squashDefines)
        let privateSection = "private:\n\n" + self.stringHelpers.cIndent(privateContent)
        let publicContent = constructor + "\n\n"
            + copyConstructor + "\n\n"
            + structCopyConstructor + "\n\n"
            + copyAssignmentOperator + "\n\n"
            + structCopyAssignmentOperator + "\n\n"
            + equalsOperators + "\n\n"
            + gettersAndSetters
        let publicSection = publicLabel + "\n\n" + self.stringHelpers.cIndent(publicContent)
        let cpp = nil == cpp ? "" : "\n\n" + cpp!
        let ifdef = "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION"
        let endif = "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION"
        let fromStringConstructor = self.createFromStringConstructor(inClass: cls, forClassNamed: name, andStructNamed: extendName)
        let description = self.stringFunctionsCreator.createDescriptionFunction(
            forClass: cls,
            forClassNamed: name,
            andStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let toString = self.stringFunctionsCreator.createToStringFunction(
            forClass: cls,
            forClassNamed: name,
            andStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let fromString = self.fromStringCreator.createFromStringFunction(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        return def + "\n\n" + privateSection + "\n\n" + publicSection + "\n\n"
            + ifdef + "\n"
            + self.stringHelpers.cIndent(fromStringConstructor) + "\n\n"
            + self.stringHelpers.cIndent(description) + "\n\n"
            + self.stringHelpers.cIndent(toString) + "\n\n"
            + self.stringHelpers.cIndent(fromString)
            + "\n" + endif + self.stringHelpers.cIndent(cpp)
            + "\n};"
    }

    fileprivate func createClassDefinition(forClassNamed name: String, extending extendName: String) -> String {
        let comment = self.creatorHelpers.createComment(from: "Provides a C++ wrapper around `\(extendName)`.")
        let def = "class \(name): public \(extendName) {"
        return comment + "\n" + def
    }
    
    fileprivate func createInit(forClass cls: Class, structName: String, forVariables variables: [Variable], namespaces: [CNamespace], squashDefines: Bool) -> String {
        let comment = self.creatorHelpers.createComment(from: "Set the members of the class.")
        let startdef = "void init("
        let list = self.createDefaultParameters(forVariables: variables)
        let def = startdef + list + ") {"
        let setters = self.createSetters(
            forVariables: variables,
            structName: structName,
            addConstOnPointers: true,
            assignDefaults: true,
            self.creatorHelpers.createArrayCountDef(inClass: cls.name, namespaces: squashDefines ? [] : namespaces)
        ) { switch $0.type { case .string: return "t_\($0.label).c_str()" default: return "t_" + $0.label } }
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(setters) + "\n}"
    }
    
    fileprivate func createCallList(forVariables variables: [Variable], accessor: @escaping (String) -> String = { "t_" + $0 }) -> String {
        return variables.lazy.map { accessor($0.label) }.combine("") { $0 + ", " + $1 }
    }
    
    fileprivate func createDefaultParameters(forVariables variables: [Variable]) -> String {
        return variables.map {
            let type = self.calculateCppType(forVariable: $0)
            let label = self.calculateCppLabel(forVariable: $0)
            switch $0.type {
            case .array:
                return "const \(type) t_\(label) = NULLPTR"
            case .enumerated:
                guard nil != Int($0.defaultValue) else {
                    return "\(type) t_\(label) = \($0.defaultValue)"
                }
                return "\(type) t_\(label) = static_cast<\(type)>(\($0.defaultValue))"
            default:
                return "\(type) t_\(label) = \($0.defaultValue)"
            }
        }.combine("") { $0 + ", " + $1 }
    }

    fileprivate func createConstructor(
        forClass cls: Class,
        forClassNamed name: String,
        forVariables variables: [Variable]
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a new `\(name)`.")
        let startdef = "\(name)("
        let list = self.createDefaultParameters(forVariables: variables)
        let def = startdef + list + ") {"
        let call = "this->init(" + self.createCallList(forVariables: variables) + ");"
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(call) + "\n}"
    }

    fileprivate func calculateCppType(forVariable variable: Variable) -> String {
        switch variable.type {
            case .string:
                return "std::string"
            default:
                return variable.cType + self.creatorHelpers.calculateSignatureExtras(forType: variable.type)
        }
    }

    fileprivate func calculateCppLabel(forVariable variable: Variable) -> String {
        return variable.label + self.creatorHelpers.calculateLabelExtras(forType: variable.type)
    }

    fileprivate func createCopyConstructor(
        forClass cls: Class,
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariables variables: [Variable],
        otherType: String,
        includeBrackets: Bool
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Constructor.")
        let def = "\(className)(const \(otherType) &t_other): \(structName)() {"
        let call = "this->init(" + self.createCallList(forVariables: variables) { "t_other." + $0 + (includeBrackets ? "()" : "") } + ");"
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(call) + "\n}"
    }

    fileprivate func createCopyAssignmentOperator(
        forClass cls: Class,
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariables variables: [Variable],
        otherType: String,
        includeBrackets: Bool
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Assignment Operator.")
        let def = "\(className) &operator = (const \(otherType) &t_other) {"
        let call = "this->init(" + self.createCallList(forVariables: variables) { "t_other." + $0 + (includeBrackets ? "()" : "") } + ");"
        let ret = "return *this;"
        let content = call + "\n" + ret
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(content) + "\n}"
    }

    fileprivate func createSetters(
        forVariables variables: [Variable],
        structName: String,
        addConstOnPointers: Bool,
        assignDefaults: Bool,
        _ arrayDefGetter: (String) -> (Int) -> String,
        _ transformGetter: (Variable) -> String = { "t_\($0.label)"}
    ) -> String {
        return variables.map {
            self.createSetter(
                forVariable: $0,
                structName: structName,
                addConstOnPointers: addConstOnPointers,
                assignDefaults: assignDefaults,
                arrayDefGetter,
                transformGetter
            )
        }.combine("") {
            $0 + "\n" + $1
        }
    }

    fileprivate func createSetter(
        forVariable variable: Variable,
        structName: String,
        addConstOnPointers: Bool,
        assignDefaults: Bool,
        _ arrayDefGetter: (String) -> (Int) -> String,
        _ transformGetter: (Variable) -> String = { "\($0.label)" }
    ) -> String {
        let label = transformGetter(variable)
        switch variable.type {
            case .array:
                let def = arrayDefGetter(variable.label)(0)
                let temp = """
                    if (\(label) != NULLPTR) {
                        std::memcpy(\(structName)::\(variable.label), \(label), \(def) * sizeof (\(variable.cType)));
                    }
                    """
                if false == assignDefaults {
                    return temp
                }
                //swiftlint:disable line_length
                return temp + """
                     else {
                        \(variable.cType) \(variable.label)_temp[\(def)] = \(variable.defaultValue);
                        std::memcpy(\(structName)::\(variable.label), \(variable.label)_temp, \(def) * sizeof (\(variable.cType)));
                    }
                    """
            case .string(let length):
                return "gu_strlcpy(const_cast<char *>(this->\(variable.label)()), \(label), \(length));"
            case .pointer:
                if false == addConstOnPointers {
                    return "set_\(variable.label)(\(label));"
                }
                let type = "const " + variable.cType
                    + self.creatorHelpers.calculateSignatureExtras(forType: variable.type)
                return """
                    \(type) _\(variable.label) = \(label);
                    set_\(variable.label)(_\(variable.label));
                    """
            default:
                return "set_\(variable.label)(\(label));"
        }
    }

    fileprivate func createFromStringConstructor(
        inClass cls: Class,
        forClassNamed className: String,
        andStructNamed structName: String
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "String Constructor.")
        let constructor = """
            \(className)(const std::string &t_str) {
                this->init();
                this->from_string(t_str);
            }
            """
        return comment + "\n" + constructor
    }
    
    private func createGettersAndSetters(inClass cls: Class, andStructNamed structName: String, namespaces: [CNamespace], squashDefines: Bool) -> String {
        let gettersAndSetters: [String] = cls.variables.map {
            let getter = self.createGetter(forVariable: $0, inGenNamed: cls.name, andStructNamed: structName, namespaces: namespaces, squashDefines: squashDefines)
            let setter = self.createSetter(forVariable: $0, inGenNamed: cls.name, andStructNamed: structName, namespaces: namespaces, squashDefines: squashDefines)
            return getter + "\n\n" + setter
        }
        return gettersAndSetters.joined(separator: "\n\n")
    }
    
    fileprivate func createPointers(forType type: VariableTypes) -> String {
        switch type {
            case .pointer(let subtype):
                return self.createPointers(forType: subtype) + "*"
            default:
                return ""
        }
    }
    
    private func getters(forType type: VariableTypes, cType: String, getter: String, size: String) -> ([(String, String, (String) -> String)], [(String, String, (String) -> String)]) {
        switch type {
        case .array:
            let sizeReturnType = "size_t"
            let sizeContent = "return " + size + ";"
            let stars = Array(repeating: "*", count: type.arrayLevels).joined()
            let cType = type.terminalType.className ?? cType
            let constReturnType = "const " + cType + " " + stars
            let value: String
            if let terminalClass = type.terminalType.className {
                value = "static_cast<const " + terminalClass + " *>(&(" + getter + "[0]))"
            } else {
                value = "&(" + getter + "[0])"
            }
            let constContent = "return " + value + ";"
            return ([], [(constReturnType, constContent, { $0 }), (sizeReturnType, sizeContent, { $0 + "_size" })])
        case .pointer:
            let returnType = cType + " " + self.createPointers(forType: type)
            let constReturnType = "const " + cType + " " + self.createPointers(forType: type)
            let content = "return " + getter + ";"
            return ([(returnType, content, { $0 })], [(constReturnType, content, { $0 })])
        case .string(let length):
            return self.getters(forType: .array(.char(.signed), length), cType: "char", getter: getter, size: length)
        case .gen(_, _, let className):
            let returnType = className + " &"
            let constReturnType = "const " + className + " &"
            let content = "return const_cast<" + className + " &>(static_cast<const " + className + " &>(" + getter + "));"
            let constContent = "return static_cast<const " + className + " &>(" + getter + ");"
            return ([(returnType, content, { $0 })], [(constReturnType, constContent, { $0 })])
        case .bit:
            let returnType = cType
            let content = "return " + getter + ";"
            return ([], [(returnType, content, { $0 })])
        default:
            let returnType = cType + " &"
            let constReturnType = "const " + cType + " &"
            let content = "return " + getter + ";"
            return ([(returnType, content, { $0 })], [(constReturnType, content, { $0 })])
        }
    }
    
    private func createGetterContent(forVariable label: String, _ type: VariableTypes, getter: String, genName: String, structName: String, cType: String, parameters: [String] = [], level: Int, namespaces: [CNamespace], squashDefines: Bool) -> [(String, String, (String) -> String, Bool, [String])] {
        switch type {
        case .array(let subtype, _):
            let size = self.creatorHelpers.createArrayCountDef(inClass: genName, forVariable: label, level: level, namespaces: squashDefines ? [] : namespaces)
            let (getters, constGetters) = self.getters(forType: type, cType: cType, getter: getter, size: size)
            let arrGetters: [(String, String, (String) -> String, Bool, [String])] = getters.map { ($0, $1, $2, false, parameters) } + constGetters.map { ($0, $1, $2, true, parameters) }
            let currentIndex = level == 0 ? "t_i" : "t_i\(level)"
            let subParameters = parameters + ["int " + currentIndex]
            let subGetter = getter + "[" + currentIndex + "]"
            let subGetters = self.createGetterContent(
                forVariable: label,
                subtype,
                getter: subGetter,
                genName: genName,
                structName: structName,
                cType: cType,
                parameters: subParameters,
                level: level + 1,
                namespaces: namespaces,
                squashDefines: squashDefines
            )
            return arrGetters + subGetters
        case .string(let length):
            let (getters, constGetters) = self.getters(forType: type, cType: cType, getter: getter, size: length)
            let stringGetters: [(String, String, (String) -> String, Bool, [String])] = getters.map { ($0, $1, $2, false, parameters) } + constGetters.map { ($0, $1, $2, true, parameters) }
            let currentIndex = level == 0 ? "t_i" : "t_i\(level)"
            let subParameters = parameters + ["int " + currentIndex]
            let subGetter = getter + "[" + currentIndex + "]"
            let subGetters = self.createGetterContent(
                forVariable: label,
                .char(.signed),
                getter: subGetter,
                genName: genName,
                structName: structName,
                cType: "char",
                parameters: subParameters,
                level: level + 1,
                namespaces: namespaces,
                squashDefines: squashDefines
            )
            return stringGetters + subGetters
        default:
            let (getters, constGetters) = self.getters(forType: type, cType: cType, getter: getter, size: "")
            return getters.map { ($0, $1, $2, false, parameters) } + constGetters.map { ($0, $1, $2, true, parameters) }
        }
    }
    
    private func createGetter(forVariable variable: Variable, inGenNamed genName: String, andStructNamed structName: String, namespaces: [CNamespace], squashDefines: Bool) -> String {
        let startBracket = "{"
        let funcs = self.createGetterContent(
            forVariable: variable.label,
            variable.type,
            getter: structName + "::" + variable.label,
            genName: genName,
            structName: structName,
            cType: variable.cType,
            level: 0,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let endBracket = "}"
        return funcs.map { (returnType, content, name, isConst, parameters) in
            let post = isConst ? " const" : ""
            let definition: String = returnType + " " + name(variable.label) + "(" + parameters.joined(separator: ", ") + ")" + post
            return definition + "\n" + startBracket + "\n" + self.stringHelpers.indent(content) + "\n" + endBracket
        }.joined(separator: "\n\n")
    }
    
    private func createSetterContent(forVariable label: String, _ type: VariableTypes, cType: String, propertyLabel: String, genName: String, structName: String, level: Int = 0, namespaces: [CNamespace], squashDefines: Bool) -> String {
        switch type {
        case .array:
            let length = (level..<type.arrayLevels).map {
                self.creatorHelpers.createArrayCountDef(inClass: genName, forVariable: label, level: $0, namespaces: squashDefines ? [] : namespaces)
            }.joined(separator: " * ")
            return "memcpy(" + propertyLabel + ", t_newValue, " + length + " * (sizeof (" + cType + ")));"
        case .string(let length):
            return "strncpy(" + propertyLabel + ", t_newValue, " + length + ");"
        case .gen(_, let genStructName, _):
            return propertyLabel + " = static_cast<" + genStructName + ">(t_newValue);"
        default:
            return propertyLabel + " = t_newValue;"
        }
    }
    
    private func createSetter(forVariable variable: Variable, inGenNamed genName: String, andStructNamed structName: String, namespaces: [CNamespace], squashDefines: Bool) -> String {
        let startBracket = "{"
        let property = structName + "::" + variable.label
        let definition: String
        switch variable.type {
        case .array(let subtype, _):
            let length = (0..<variable.type.arrayLevels).map {
                self.creatorHelpers.createArrayCountDef(inClass: genName, forVariable: variable.label, level: $0, namespaces: squashDefines ? [] : namespaces)
            }.joined(separator: " * ")
            let size = length + " * (sizeof (" + variable.cType + "))"
            let arrDefinition = "void set_" + variable.label + "(const " + (variable.type.terminalType.className ?? variable.cType) + " *t_newValue)"
            let value = variable.type.terminalType.className == nil ? "t_newValue" : ("static_cast<const " + variable.cType + " *>(t_newValue)")
            let arrContent = "memcpy(" + structName + "::" + variable.label + ", " + value + ", " + size + ");"
            let indexDefinition = "void set_" + variable.label + "(const " + (variable.type.terminalType.className ?? variable.cType) + " &t_newValue, int t_i)"
            let indexContent = self.createSetterContent(
                forVariable: variable.label,
                subtype, cType: variable.type.terminalType.className ?? variable.cType,
                propertyLabel: structName + "::" + variable.label + "[t_i]",
                genName: genName,
                structName: structName,
                level: 0,
                namespaces: namespaces,
                squashDefines: squashDefines
            )
            let setter = arrDefinition + "\n{\n" + self.stringHelpers.indent(arrContent) + "\n}"
            let indexSetter = indexDefinition + "\n{\n" + self.stringHelpers.indent(indexContent) + "\n}"
            return setter + "\n\n" + indexSetter
        case .pointer:
            let pointerType = variable.cType + " " + self.createPointers(forType: variable.type)
            definition = "void set_" + variable.label + "(const " + pointerType + "t_newValue)"
        case .string:
            definition = "void set_" + variable.label + "(const char *t_newValue)"
        case .gen(_, _, let className):
            definition = "void set_" + variable.label + "(const " + className + " &t_newValue)"
        default:
            definition = "void set_" + variable.label + "(const " + variable.cType + " &t_newValue)"
        }
        let content = self.createSetterContent(forVariable: variable.label, variable.type, cType: variable.cType, propertyLabel: property, genName: genName, structName: structName, namespaces: namespaces, squashDefines: squashDefines)
        let endBracket = "}"
        return definition + "\n" + startBracket + "\n" + self.stringHelpers.indent(content) + "\n" + endBracket
    }
    
    private func createEqualityOperators(
        inClass cls: Class,
        forClassNamed className: String,
        andStructNamed structName: String
    ) -> String {
        let equalsOperator = self.createEqualsOperator(inClass: cls, forClassNamed: className, andStructNamed: structName)
        let notEqualsOperator = """
            bool operator !=(const \(className) &t_other) const
            {
            \(self.stringHelpers.cIndent("return !(*this == t_other);"))
            }
            """
        let equalsCOperator = """
            bool operator ==(const \(structName) &t_other) const
            {
            \(self.stringHelpers.cIndent("return *this == \(className)(t_other);"))
            }
            """
        let notEqualsCOperator = """
            bool operator !=(const \(structName) &t_other) const
            {
            \(self.stringHelpers.cIndent("return !(*this == t_other);"))
            }
            """
        return equalsOperator
            + "\n\n" + notEqualsOperator
            + "\n\n" + equalsCOperator
            + "\n\n" + notEqualsCOperator
    }
    
    private func createEqualsOperator(
        inClass cls: Class,
        forClassNamed className: String,
        andStructNamed structName: String
    ) -> String {
        let def = "bool operator ==(const " + className + " &t_other) const"
        let startBody = "{"
        let equalsChainCondition = self.createEqualsChain(for: cls.variables)
        let complexEquals = cls.variables.compactMap(self.createComplexEquals).combine("") { $0 + "\n" + $1 }
        let body: String
        if equalsChainCondition.isEmpty && complexEquals.isEmpty {
            body = "return true;"
        } else if complexEquals.isEmpty {
            body = "return " + equalsChainCondition + ";"
        } else if equalsChainCondition.isEmpty {
            body = complexEquals + "\nreturn true;"
        } else {
            body = """
                if (!(\(equalsChainCondition)))
                {
                    return false;
                }
                \(complexEquals)
                return true;
                """
        }
        let endBody = "}"
        return def + "\n" + startBody + "\n" + self.stringHelpers.cIndent(body) + "\n" + endBody
    }
    
    private func createEqualsChain(for variables: [Variable]) -> String {
        func isChainable(_ type: VariableTypes) -> Bool {
            switch type {
            case .array, .unknown:
                return false
            case .mixed(let subtype, _):
                return isChainable(subtype)
            default:
                return true
            }
        }
        return variables.lazy.filter {
            isChainable($0.type)
        }.compactMap {
            self.createEquals(for: $0.label, type: $0.type)
        }.combine("") {
            $0 + "\n" + self.stringHelpers.indent("&& " + $1)
        }
    }
    
    private func createEquals(for label: String, type: VariableTypes, post: String = "()") -> String {
        func createEquals(for type: NumericTypes) -> String {
            switch type {
            case .long(let subtype):
                return createEquals(for: subtype)
            case .double:
                return "fabs(" + label + post + " - t_other." + label + post + ") < DBL_EPSILON"
            case .float:
                return "fabsf(" + label + post + " - t_other." + label + post + ") < FLT_EPSILON"
            default:
                return label + post + " == t_other." + label + post
            }
        }
        switch type {
        case .numeric(let numericType):
            return createEquals(for: numericType)
        case .gen(_, _, let className):
            return className + "(" + label + post + ") == " + className + "(t_other." + label + post + ")"
        case .string(let length):
            return "0 == strncmp(" + label + post + ", " + "t_other." + label + post + ", " + length + ")"
        default:
            return label + post + " == t_other." + label + post
        }
    }
    
    private func createComplexEquals(for variable: Variable) -> String? {
        func create(for label: String, type: VariableTypes, level: Int) -> String? {
            switch type {
            case .array(let elementType, let length):
                let index = label + "_\(level)_index"
                let getterList: [String] = (0...level).map { label + "_\($0)_index" }
                let getter = label + "(" + getterList.joined(separator: ", ") + ")"
                guard let recurse = create(for: getter, type: elementType, level: level + 1) else {
                    return nil
                }
                let compare = """
                    for (int \(index) = 0; \(index) < \(length); \(index)++)
                    {
                    \(self.stringHelpers.cIndent(recurse))
                    }
                    """
                return compare
            case .mixed(let type, _):
                return create(for: label, type: type, level: level)
            case .unknown:
                return nil
            default:
                if level == 0 {
                    return nil
                }
                let condition = self.createEquals(for: label, type: type, post: "")
                return "if (!(\(condition))) return false;"
            }
        }
        return create(for: variable.label, type: variable.type, level: 0)
    }

}
