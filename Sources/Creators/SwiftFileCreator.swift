/*
 * SwiftFileCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 10/09/2017.
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

//swiftlint:disable file_length
//swiftlint:disable:next type_body_length
public final class SwiftFileCreator: Creator {

    public let errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }
    
    public func create(
        forClass cls: Class,
        forFileNamed fileName: String,
        withClassName className: String,
        withStructName structName: String,
        generatedFrom genfile: String
    ) -> String? {
        let head = self.createHead(forFile: fileName, withAuthor: cls.author, andGenFile: genfile)
        let preSwift = nil == cls.preSwift ? "" : "\n\n" + cls.preSwift!
        let ext = self.createStructWrapper(for: structName, named: className, withComment: cls.comment, andVariables: cls.variables)
        let stringExt = self.createStringExtension(on: className, withVariables: cls.variables)
        let eqExt = self.createEquatableExtension(on: className)
        let wrapperEqOp = self.createEqualsOperator(comparing: className, withVariables: cls.variables)
        return [head + preSwift, ext, stringExt, eqExt, wrapperEqOp].combine("") { $0 + "\n\n" + $1 } + "\n"
    }

    fileprivate func createHead(
        forFile fileName: String,
        withAuthor author: String,
        andGenFile genfile: String
    ) -> String {
        let comment = self.creatorHelpers.createFileComment(forFile: fileName, withAuthor: author, andGenFile: genfile)
        let swiftLintComments = """
            //swiftlint:disable function_body_length
            //swiftlint:disable file_length
            //swiftlint:disable line_length
            //swiftlint:disable identifier_name
            """
        return comment + "\n\n" + swiftLintComments
    }

    fileprivate func createStructWrapper(
        for base: String,
        named wrapperName: String,
        withComment comment: String,
        andVariables variables: [Variable]
    ) -> String {
        let rawVariable = "_raw"
        let comment = self.creatorHelpers.createComment(from: comment)
        let def = self.createStructDef(on: wrapperName)
        let rawDefinition = "var \(rawVariable): \(base)"
        let wrappers = self.createWrappers(forVariables: variables, referencing: rawVariable).map { $0 + "\n\n" } ?? ""
        let constructor = self.createConstructor(on: base, withRawVariable: rawVariable, withVariables: variables)
        let copyConstructor = self.createCopyConstructor(on: base, withRawVariable: rawVariable)
        let fromDictionary = self.createFromDictionaryConstructor(on: base, withVariables: variables, referencing: rawVariable)
        let content = rawDefinition + "\n\n" + wrappers + "\n\n" + constructor + "\n\n" + copyConstructor + "\n\n" + fromDictionary
        return comment + "\n" + def + "\n\n" + self.stringHelpers.indent(content) + "\n\n" + "}"
    }

    fileprivate func createWrappers(forVariables variables: [Variable], referencing base: String) -> String? {
        let wrappers: [String] = variables.compactMap {
            let getterSetup: String
            let getterAssign: String
            switch $0.type {
                case .array, .string:
                    getterSetup = "var \($0.label) = self.\(base).\($0.label)\n"
                    getterAssign = self.createArrayGetter(
                        forType: $0.type,
                        withLabel: $0.label,
                        andSwiftType: $0.swiftType
                    )
                case .bit:
                    getterSetup = ""
                    getterAssign = self.createBitGetter(withLabel: $0.label, referencing: base)
                case .char(let sign):
                    getterSetup = ""
                    getterAssign = self.createCharGetter(withLabel: $0.label, andSign: sign, referencing: base)
                default:
                    getterSetup = ""
                    getterAssign = "self.\(base).\($0.label)"
            }
            let type = self.createWrapperType(forType: $0.type, withSwiftType: $0.swiftType)
            let def = "public var \($0.label): \(type) {"
            let getterDef = "get {"
            let getterContent = getterSetup + "return " + getterAssign
            let endGetterDef = "}"
            let setterDef = "set {"
            let setterContent = self.createSetter(forVariable: $0, accessedBy: "newValue", referencing: base)
            let endSetterDef = "}"
            let endDef = "}"
            let getter = getterDef + "\n" + self.stringHelpers.indent(getterContent) + "\n" + endGetterDef
            let setter = setterDef + "\n" + self.stringHelpers.indent(setterContent) + "\n" + endSetterDef
            return def + "\n" + self.stringHelpers.indent(getter + " " + setter) + "\n" + endDef
        }
        if wrappers.isEmpty {
            return nil
        }
        return wrappers.combine("") { $0 + "\n\n" + $1 }
    }

    fileprivate func createBitGetter(withLabel label: String, referencing base: String) -> String {
        return "self.\(base).\(label) == 1"
    }

    fileprivate func createCharGetter(withLabel label: String, andSign sign: CharSigns, referencing base: String) -> String {
        switch sign {
            case .signed:
                return "UnicodeScalar(UInt8(self.\(base).\(label)))"
            case .unsigned:
                return "UnicodeScalar(self.\(base).\(label))"
        }
    }

    fileprivate func createArrayGetter(
        forType type: VariableTypes,
        withLabel label: String,
        andSwiftType swiftType: String,
        _ level: Int = 0
    ) -> String {
        switch type {
            case .array(let subtype, let length):
                let defaultLabel = label + (0 == level ? "" : "_\(level)")
                let index = "\(defaultLabel)_index"
                let p = "\(defaultLabel)_p"
                let value = self.createArrayGetter(
                    forType: subtype,
                    withLabel: "\(p)[\(index)]",
                    andSwiftType: swiftType,
                    level + 1
                )
                return """
                    withUnsafePointer(to: &\(label).0) { \(p) in
                        var \(defaultLabel): \(self.createSwiftType(forType: type, withSwiftType: swiftType)) = []
                        \(defaultLabel).reserveCapacity(\(length))
                        for \(index) in 0..<\(length) {
                            \(defaultLabel).append(\(value))
                        }
                        return \(defaultLabel)
                    }
                    """
            case .string:
                return "String(cString: withUnsafePointer(to: &\(label).0) { $0 })"
            case .gen(_, _, let className):
                return "\(className)(\(label))"
            default:
                return label
        }
    }

    fileprivate func createConstructor(on structName: String, withRawVariable rawVariable: String, withVariables variables: [Variable]) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a new `\(structName)`.")
        let startDef = "public init("
        let copy = "self.\(rawVariable) = \(structName)()\n"
        let params = variables.enumerated().map {
            let type = self.createWrapperType(forType: $1.type, withSwiftType: $1.swiftType)
            let label = $1.label
            return "\(label): \(type) = \($1.swiftDefaultValue)"
        }.combine("") { $0 + ", " + $1 }
        let endDef = ") {"
        let def = startDef + params + endDef
        let setters = copy + variables.map {
            return "self.\($0.label) = \($0.label)"
        }.combine("") { $0 + "\n" + $1 }
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(setters) + "\n" + "}"
    }
    
    fileprivate func createCopyConstructor(on structName: String, withRawVariable rawVariable: String) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a new `\(structName)`.")
        let startDef = "public init(_ rawValue: \(structName)) {"
        let content = "self.\(rawVariable) = rawValue"
        return comment + "\n" + startDef + "\n" + self.stringHelpers.indent(content) + "\n" + "}"
    }

    fileprivate func createSetter(forVariable variable: Variable, accessedBy accessor: String, referencing base: String) -> String {
        let value = self.createSetterValue(forType: variable.type, withLabel: variable.label, accessedBy: accessor, referencing: base)
        switch variable.type {
            case .array:
                return "_ = \(value)"
            case .bit, .char:
                return value
            case .string(let length):
                return self.createSetString(withLabel: variable.label, with: accessor, andLength: length, referencing: base)
            default:
                return "self.\(base).\(variable.label) = \(value)"
        }
    }

    fileprivate func createSetterValue(
        forType type: VariableTypes,
        withLabel label: String,
        accessedBy accessor: String,
        referencing base: String,
        _ level: Int = 0
    ) -> String {
        switch type {
            case .array(let subtype, let length):
                let uniqueLabel = label + (0 == level ? "" : "_\(level)")
                let index = uniqueLabel + "_index"
                let p = uniqueLabel + "_p"
                let nextLabel = label + ".0"
                let nextAccessor = accessor + "[\(index)]"
                let sub = self.createSetterValue(
                    forType: subtype,
                    withLabel: nextLabel,
                    accessedBy: nextAccessor,
                    referencing: base,
                    level + 1
                )
                let start = "withUnsafeMutablePointer(to: &self.\(base).\(label).0) { \(p) in"
                let content = """
                        for \(index) in 0..<\(length) {
                            \(p)[\(index)] = \(sub)
                        }
                    }
                    """
                return start + "\n" + self.stringHelpers.indent(content, level)
            case .bit:
                return "self.\(base).\(label) = true == \(accessor) ? 1 : 0"
            case .char(let sign):
                let intType: String
                switch sign {
                    case .signed:
                        intType = "Int8"
                    case .unsigned:
                        intType = "UInt8"
                }
                return """
                    if false == \(accessor).isASCII {
                        fatalError("You can only assign ASCII values to \(label)")
                    }
                    self.\(base).\(label) = \(intType)(newValue.value)
                    """
            default:
                return accessor
        }
    }

    fileprivate func createSetString(
        withLabel label: String,
        with otherLabel: String,
        andLength length: String,
        referencing base: String
    ) -> String {
        let p = "\(label)_p"
        return """
            _ = withUnsafeMutablePointer(to: &self.\(base).\(label).0) { \(p) in
                let arr = \(otherLabel).utf8CString
                _ = arr.withUnsafeBufferPointer {
                    strncpy(\(p), $0.baseAddress!, \(length))
                }
            }
            """
    }

    //swiftlint:disable:next function_body_length swiftlint:disable:next cyclomatic_complexity
    fileprivate func createFromDictionaryConstructor(
        on structName: String,
        withVariables variables: [Variable],
        referencing base: String
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a `\(structName)` from a dictionary.")
        let def = "public init(fromDictionary dictionary: [String: Any]) {"
        let copy = "self.init()\n"
        let guardDef = "guard"
        let casts = variables.compactMap {
            switch $0.type {
                case .array, .string:
                    return "var \($0.label) = dictionary[\"\($0.label)\"]"
                case .bit:
                    return "let \($0.label) = dictionary[\"\($0.label)\"] as? UInt32"
                case .char(let sign):
                    switch sign {
                        case .signed:
                            return "let \($0.label) = dictionary[\"\($0.label)\"] as? Int8"
                        case .unsigned:
                            return "let \($0.label) = dictionary[\"\($0.label)\"] as? UInt8"
                    }
                case .gen(_, let structName, _):
                    return "let \($0.label) = (dictionary[\"\($0.label)\"] as? [String: Any]).flatMap({ \(structName)(fromDictionary: $0)  })"
                case .pointer:
                    return nil
                default:
                    let type = self.createSwiftType(forType: $0.type, withSwiftType: $0.swiftType)
                    return "let \($0.label) = dictionary[\"\($0.label)\"] as? \(type)"
            }
        }.combine("") { $0 + ",\n" + $1 }
        let elseDef = "else {"
        let fatal = "fatalError(\"Unable to convert \\(dictionary) to \(structName).\")"
        let endGuard = "}"
        let g = copy + guardDef + "\n"
            + self.stringHelpers.indent(casts) + "\n"
            + elseDef + "\n"
            + self.stringHelpers.indent(fatal) + "\n"
            + endGuard
        let setters = variables.map {
            switch $0.type {
                case .array, .string:
                    return """
                        self.\(base).\($0.label) = withUnsafePointer(to: &\($0.label)) {
                            $0.withMemoryRebound(to: type(of: \(structName)().\($0.label)), capacity: 1) {
                                $0.pointee
                            }
                        }
                        """
                case .pointer:
                    let type = self.createSwiftType(forType: $0.type, withSwiftType: $0.swiftType)
                    return "self.\($0.label) = dictionary[\"\($0.label)\"] as? \(type)"
                default:
                    return "self.\($0.label) = \($0.label)"
            }
        }.combine("") { $0 + "\n" + $1 }
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(g + "\n" + setters) + "\n" + "}"
    }

    fileprivate func createStringExtension(on structName: String, withVariables variables: [Variable]) -> String {
        let def = self.createExtensionDef(on: structName, extending: ["CustomStringConvertible"])
        let descriptionVarComment = self.creatorHelpers.createComment(from: "Convert to a description String.")
        let descriptionVar = "public var description: String {"
        if nil == variables.first(where: { self.creatorHelpers.isSupportedStringType($0.type) }) {
            return def + "\n\n" + self.stringHelpers.indent(descriptionVar + "\n" + self.stringHelpers.indent("return \"\"") + "\n}") + "\n\n}"
        }
        let descDef = "var descString = \"\""
        let descReturn = "return descString"
        let setters = variables.compactMap {
            self.createString(fromVariable: $0)
        }.combine("") { $0 + "\ndescString += \", \"\n" + $1 }
        let descriptionVarContent = descDef + "\n" + setters + "\n" + descReturn
        let content = descriptionVarComment + "\n"
            + descriptionVar + "\n"
            + self.stringHelpers.indent(descriptionVarContent) + "\n"
            + "}"
        return def + "\n\n" + self.stringHelpers.indent(content) + "\n\n" + "}"
    }

    fileprivate func createEquatableExtension(on structName: String) -> String {
        return self.createExtensionDef(on: structName, extending: ["Equatable"]) + "}"
    }

    fileprivate func createEqualsOperator(comparing structName: String, withVariables variables: [Variable]) -> String {
        let def = "public func == (lhs: \(structName), rhs: \(structName)) -> Bool {"
        let content = "return " + variables.map {
            return "lhs.\($0.label) == rhs.\($0.label)"
        }.combine("") { $0 + "\n" + self.stringHelpers.indent("&& " + $1) }
        let endDef = "}"
        return def + "\n" + self.stringHelpers.indent(content) + "\n" + endDef
    }

    fileprivate func createString(fromVariable variable: Variable) -> String? {
        switch variable.type {
            case .array:
                return self.createArrayStringValue(fromType: variable.type, andLabel: variable.label)
            default:
                guard let value = self.createStringValue(
                    fromType: variable.type,
                    andLabel: variable.label,
                    appendingTo: variable.label + "=",
                    getter: "self.\(variable.label)",
                    computedGetter: "self._\(variable.label)"
                ) else {
                    return nil
                }
                return "descString += " + value
        }
    }

    fileprivate func createArrayStringValue(fromType type: VariableTypes, andLabel label: String) -> String? {
        switch type {
            case .array(let subtype, _):
                switch subtype {
                    case .array:
                        return nil
                    default:
                        guard
                            let firstValue = self.createStringValue(
                                fromType: subtype,
                                andLabel: label,
                                appendingTo: "",
                                getter: "self." + label + ".0",
                                computedGetter: "self._" + label + "[0]"
                            ),
                            let value = self.createStringValue(
                            fromType: subtype,
                            andLabel: label,
                            appendingTo: "",
                            getter: "$1",
                            computedGetter: "$1"
                        ) else {
                            return nil
                        }
                        //swiftlint:disable line_length
                        return """
                            if self._\(label).isEmpty {
                                descString += \"\(label)={}\"
                            } else {
                                let first = \(firstValue)
                                descString += \"\(label)={\"
                                descString += self._\(label).dropFirst().reduce(\"\\(first)\") { $0 + ", " + \(value) }
                                descString += \"}\"
                            }
                            """
                }
            default:
                return self.createStringValue(
                    fromType: type,
                    andLabel: label,
                    appendingTo: label + "=",
                    getter: "self.\(label)",
                    computedGetter: "self._\(label)"
                )
        }
    }

    fileprivate func createStringValue(
        fromType type: VariableTypes,
        andLabel label: String,
        appendingTo pre: String,
        getter: String,
        computedGetter: String
    ) -> String? {
        switch type {
            case .array:
                return self.createArrayStringValue(fromType: type, andLabel: label)
            case .string:
                return "\"\(pre)\\(\(computedGetter))\""
            case .char:
                return "\"\(pre)\\(0 == \(getter) ? \"\" : String(Character(\(computedGetter))))\""
            case .enumerated:
                return "\"\(pre)\\(\(getter).rawValue)\""
            case .gen:
                return "\"\(pre){\" + \(getter).description + \"}\""
            case .unknown, .pointer:
                return nil
            default:
                return "\"\(pre)\\(\(getter))\""
        }
    }
    
    fileprivate func createStructDef(on base: String, extending: [String] = []) -> String {
        let def = "public struct \(base)"
        if true == extending.isEmpty {
            return def + " {"
        }
        return def + ": " + extending.combine("") { $0 + ", " + $1 } + " {"
    }

    fileprivate func createExtensionDef(on base: String, extending: [String] = []) -> String {
        let def = "extension \(base)"
        if true == extending.isEmpty {
            return def + " {"
        }
        return def + ": " + extending.combine("") { $0 + ", " + $1 } + " {"
    }

    fileprivate func createSwiftType(forType type: VariableTypes, withSwiftType swiftType: String) -> String {
        switch type {
            case .array(let subtype, _):
                return "[" + self.createSwiftType(forType: subtype, withSwiftType: swiftType) + "]"
            default:
                return swiftType
        }
    }
    
    fileprivate func createWrapperType(forType type: VariableTypes, withSwiftType swiftType: String) -> String {
        switch type {
        case .array(let subtype, _):
            return "[" + self.createWrapperType(forType: subtype, withSwiftType: swiftType) + "]"
        case .gen(_, _, let className):
            return className
        default:
            return self.createSwiftType(forType: type, withSwiftType: swiftType)
        }
    }

}
