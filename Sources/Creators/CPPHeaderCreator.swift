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

//swiftlint:disable type_body_length
public final class CPPHeaderCreator: Creator {

    public let errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let namespaces: [CPPNamespace]
    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers
    fileprivate let stringFunctionsCreator: CPPStringFunctionsCreator
    fileprivate let fromStringCreator: CPPFromStringCreator

    public init(
        namespaces: [CPPNamespace] = [],
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        stringHelpers: StringHelpers = StringHelpers(),
        stringFunctionsCreator: CPPStringFunctionsCreator = CPPStringFunctionsCreator(),
        fromStringCreator: CPPFromStringCreator = CPPFromStringCreator()
    ) {
        self.namespaces = namespaces
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
        namespaces: [CNamespace]
    ) -> String? {
        let head = self.createHead(
            forFile: fileName,
            withStructNamed: structName,
            withClassNamed: className,
            withAuthor: cls.author,
            generatedFrom: genfile
        )
        let content = self.createClass(
            forClass: cls,
            named: className,
            extendingStruct: structName,
            withVariables: cls.variables,
            andEmbeddedCpp: cls.embeddedCpp,
            andPostCpp: cls.postCpp,
            namespaces: namespaces
        )
        let pre = nil == cls.preCpp ? "" : "\n\n" + cls.preCpp!
        return head + pre + "\n\n" + content + "\n\n" + "#endif /// \(className)_DEFINED\n"
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

            #include <gu_util.h>
            #include "\(structName).h"
            """
        return comment + "\n\n" + define
    }

    //swiftlint:disable:next function_parameter_count
    fileprivate func createClass(
        forClass cls: Class,
        named className: String,
        extendingStruct structName: String,
        withVariables variables: [Variable],
        andEmbeddedCpp embeddedCpp: String?,
        andPostCpp postCpp: String?,
        namespaces: [CNamespace]
    ) -> String {
        let namespacesDefs = ["guWhiteboard"] + self.namespaces
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
            namespaces: namespaces
        )
        let postCpp = nil == postCpp ? "" : "\n\n" + self.stringHelpers.cIndent(postCpp!)
        let allContent = content + postCpp + "\n\n"
        return startNamespace + "\n\n" + self.stringHelpers.cIndent(allContent, namespaces.count) + endNamespace
    }

    fileprivate func createClassContent(
        forClass cls: Class,
        forClassNamed name: String,
        extending extendName: String,
        withVariables variables: [Variable],
        andEmbeddedCpp cpp: String?,
        namespaces: [CNamespace]
    ) -> String {
        let def = self.createClassDefinition(forClassNamed: name, extending: extendName)
        let publicLabel = "public:"
        let constructor = self.createConstructor(forClass: cls, forClassNamed: name, forVariables: variables)
        let copyConstructor = self.createCopyConstructor(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: name
        )
        let structCopyConstructor = self.createCopyConstructor(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: "struct " + extendName
        )
        let copyAssignmentOperator = self.createCopyAssignmentOperator(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: name
        )
        let structCopyAssignmentOperator = self.createCopyAssignmentOperator(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            forVariables: variables,
            otherType: "struct " + extendName
        )
        let equalsOperators = self.createEqualityOperators(inClass: cls, forClassNamed: name, andStructNamed: extendName)
        let privateContent = self.createInit(forClass: cls, forVariables: variables, namespaces: namespaces)
        let privateSection = "private:\n\n" + self.stringHelpers.cIndent(privateContent)
        let publicContent = constructor + "\n\n"
            + copyConstructor + "\n\n"
            + structCopyConstructor + "\n\n"
            + copyAssignmentOperator + "\n\n"
            + structCopyAssignmentOperator + "\n\n"
            + equalsOperators
        let publicSection = publicLabel + "\n\n" + self.stringHelpers.cIndent(publicContent)
        let cpp = nil == cpp ? "" : "\n\n" + self.stringHelpers.cIndent(cpp!)
        let ifdef = "#ifdef WHITEBOARD_POSTER_STRING_CONVERSION"
        let endif = "#endif /// WHITEBOARD_POSTER_STRING_CONVERSION"
        let fromStringConstructor = self.createFromStringConstructor(inClass: cls, forClassNamed: name, andStructNamed: extendName)
        let description = self.stringFunctionsCreator.createDescriptionFunction(
            forClass: cls,
            forClassNamed: name,
            andStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces
        )
        let toString = self.stringFunctionsCreator.createToStringFunction(
            forClass: cls,
            forClassNamed: name,
            andStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces
        )
        let fromString = self.fromStringCreator.createFromStringFunction(
            forClass: cls,
            forClassNamed: name,
            withStructNamed: extendName,
            withVariables: variables,
            namespaces: namespaces
        )
        return self.stringHelpers.cIndent(def + "\n\n" + privateSection + "\n\n" + publicSection) + "\n\n"
            + ifdef + "\n"
            + self.stringHelpers.cIndent(fromStringConstructor, 2) + "\n\n"
            + description + "\n\n" + toString + "\n\n" + fromString
            + "\n" + endif + self.stringHelpers.cIndent(cpp) + "\n"
            + self.stringHelpers.cIndent("};")
    }

    fileprivate func createClassDefinition(forClassNamed name: String, extending extendName: String) -> String {
        let comment = self.creatorHelpers.createComment(from: "Provides a C++ wrapper around `\(extendName)`.")
        let def = "class \(name): public \(extendName) {"
        return comment + "\n" + def
    }
    
    fileprivate func createInit(forClass cls: Class, forVariables variables: [Variable], namespaces: [CNamespace]) -> String {
        let comment = self.creatorHelpers.createComment(from: "Set the members of the class.")
        let startdef = "void init("
        let list = self.createDefaultParameters(forVariables: variables)
        let def = startdef + list + ") {"
        let setters = self.createSetters(
            forVariables: variables,
            addConstOnPointers: true,
            assignDefaults: true,
            self.creatorHelpers.createArrayCountDef(inClass: cls.name, namespaces: namespaces)
        ) { switch $0.type { case .string: return "\($0.label).c_str()" default: return $0.label } }
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(setters) + "\n}"
    }
    
    fileprivate func createCallList(forVariables variables: [Variable], accessor: @escaping (String) -> String = { $0 }) -> String {
        return variables.lazy.map { accessor($0.label) }.combine("") { $0 + ", " + $1 }
    }
    
    fileprivate func createDefaultParameters(forVariables variables: [Variable]) -> String {
        return variables.map {
            let type = self.calculateCppType(forVariable: $0)
            let label = self.calculateCppLabel(forVariable: $0)
            switch $0.type {
            case .array:
                return "const \(type) \(label) = NULLPTR"
            case .enumerated:
                guard nil != Int($0.defaultValue) else {
                    return "\(type) \(label) = \($0.defaultValue)"
                }
                return "\(type) \(label) = static_cast<\(type)>(\($0.defaultValue))"
            default:
                return "\(type) \(label) = \($0.defaultValue)"
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
        otherType: String
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Constructor.")
        let def = "\(className)(const \(otherType) &other): \(structName)() {"
        let call = "this->init(" + self.createCallList(forVariables: variables) { "other." + $0 + "()" } + ");"
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(call) + "\n}"
    }

    fileprivate func createCopyAssignmentOperator(
        forClass cls: Class,
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariables variables: [Variable],
        otherType: String
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Copy Assignment Operator.")
        let def = "\(className) &operator = (const \(otherType) &other) {"
        let call = "this->init(" + self.createCallList(forVariables: variables) { "other." + $0 + "()" } + ");"
        let ret = "return *this;"
        let content = call + "\n" + ret
        return comment + "\n" + def + "\n" + self.stringHelpers.cIndent(content) + "\n}"
    }

    fileprivate func createSetters(
        forVariables variables: [Variable],
        addConstOnPointers: Bool,
        assignDefaults: Bool,
        _ arrayDefGetter: (String) -> (Int) -> String,
        _ transformGetter: (Variable) -> String = { "\($0.label)"}
    ) -> String {
        return variables.map {
            self.createSetter(
                forVariable: $0,
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
                        std::memcpy(this->_\(variable.label), \(label), \(def) * sizeof (\(variable.cType)));
                    }
                    """
                if false == assignDefaults {
                    return temp
                }
                //swiftlint:disable line_length
                return temp + """
                     else {
                        \(variable.cType) \(variable.label)_temp[\(def)] = \(variable.defaultValue);
                        std::memcpy(this->_\(variable.label), \(variable.label)_temp, \(def) * sizeof (\(variable.cType)));
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
            \(className)(const std::string &str) {
                this->init();
                this->from_string(str);
            }
            """
        return comment + "\n" + constructor
    }
    
    private func createEqualityOperators(
        inClass cls: Class,
        forClassNamed className: String,
        andStructNamed structName: String
    ) -> String {
        let equalsOperator = self.createEqualsOperator(inClass: cls, forClassNamed: className, andStructNamed: structName)
        let notEqualsOperator = """
            bool operator !=(const \(className) &other) const
            {
            \(self.stringHelpers.cIndent("return !(*this == other);"))
            }
            """
        let equalsCOperator = """
            bool operator ==(const \(structName) &other) const
            {
            \(self.stringHelpers.cIndent("return *this == \(className)(other);"))
            }
            """
        let notEqualsCOperator = """
            bool operator !=(const \(structName) &other) const
            {
            \(self.stringHelpers.cIndent("return !(*this == other);"))
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
        let def = "bool operator ==(const " + className + " &other) const"
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
    
    private func createEquals(for label: String, type: VariableTypes) -> String {
        func createEquals(for type: NumericTypes) -> String {
            switch type {
            case .long(let subtype):
                return createEquals(for: subtype)
            case .double:
                return "absf(" + label + "() - other." + label + "()) < DBL_EPSILON"
            case .float:
                return "fabsf(" + label + "() - other." + label + "()) < FLT_EPSILON"
            default:
                return label + "() == other." + label + "()"
            }
        }
        switch type {
        case .numeric(let numericType):
            return createEquals(for: numericType)
        case .gen(_, _, let className):
            return className + "(_" + label + ") == " + className + "(other._" + label + ")"
        case .string(let length):
            return "0 == strncmp(_" + label + ", " + "other._" + label + ", " + length + ")"
        default:
            return label + "() == other." + label + "()"
        }
    }
    
    private func createComplexEquals(for variable: Variable) -> String? {
        func create(for label: String, type: VariableTypes, level: Int) -> String? {
            switch type {
            case .array(let elementType, let length):
                let index = label + "_\(level)_index"
                let getterList: [String] = (0...level).map { "[" + label + "_\($0)_index" + "]" }
                let getter = label + getterList.combine("") { $0 + $1 }
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
                let condition = self.createEquals(for: label, type: type)
                return "if (!(\(condition))) return false;"
            }
        }
        return create(for: variable.label, type: variable.type, level: 0)
    }

}
