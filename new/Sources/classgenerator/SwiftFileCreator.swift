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

public final class SwiftFileCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    public func createSwiftFile(
        forClass cls: Class,
        forFileNamed fileName: String,
        withStructName structName: String,
        generatedFrom genfile: String
    ) -> String? {
        let head = self.createHead(forFile: fileName, withAuthor: cls.author, andGenFile: genfile)
        let ext = self.createExtension(on: structName, withComment: cls.comment, andVariables: cls.variables)
        let stringExt = self.createStringExtension(on: structName, withVariables: cls.variables)
        let eqExt = self.createEquatableExtension(on: structName)
        let eqOp = self.createEqualsOperator(comparing: structName, withVariables: cls.variables)
        return [head, ext, stringExt, eqExt, eqOp].combine("") { $0 + "\n\n" + $1 } + "\n"
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

    fileprivate func createExtension(
        on base: String,
        withComment comment: String,
        andVariables variables: [Variable]
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: comment)
        let def = self.createExtensionDef(on: base)
        let constructor = self.createConstructor(on: base, withVariables: variables)
        let fromDictionary = self.createFromDictionaryConstructor(on: base, withVariables: variables)
        let content = constructor + "\n\n" + fromDictionary
        return comment + "\n" + def + "\n\n" + self.stringHelpers.indent(content) + "\n\n" + "}"
    }

    fileprivate func createConstructor(on structName: String, withVariables variables: [Variable]) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a new `\(structName)`.")
        let startDef = "public init("
        let params = variables.map {
            let type = self.createSwiftType(forType: $0.type, withSwiftType: $0.swiftType)
            return "\($0.label): \(type) = \($0.swiftDefaultValue)"
        }.combine("") { $0 + ", " + $1 }
        let endDef = ") {"
        let def = startDef + params + endDef
        let setters = variables.map {
            "self.\($0.label) = \($0.label)"
        }.combine("") { $0 + "\n" + $1 }
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(setters) + "\n" + "}"
    }

    fileprivate func createFromDictionaryConstructor(
        on structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let comment = self.creatorHelpers.createComment(from: "Create a `\(structName)` from a dictionary.")
        let def = "public init(fromDictionary dictionary: [String: Any]) {"
        let guardDef = "guard"
        let casts = variables.map {
            let type = self.createSwiftType(forType: $0.type, withSwiftType: $0.swiftType)
            return "let \($0.label) = dictionary[\"\($0.label)\"] as? \(type)"
        }.combine("") { $0 + ",\n" + $1 }
        let elseDef = "else {"
        let fatal = "fatalError(\"Unable to convert \\(dictionary) to \(structName).\")"
        let endGuard = "}"
        let g = guardDef + "\n"
            + self.stringHelpers.indent(casts) + "\n"
            + elseDef + "\n"
            + self.stringHelpers.indent(fatal) + "\n"
            + endGuard
        let setters = variables.map {
            "self.\($0.label) = \($0.label)"
        }.combine("") { $0 + "\n" + $1 }
        return comment + "\n" + def + "\n" + self.stringHelpers.indent(g + "\n" + setters) + "\n" + "}"
    }

    fileprivate func createStringExtension(on structName: String, withVariables variables: [Variable]) -> String {
        let def = self.createExtensionDef(on: structName, extending: ["CustomStringConvertible"])
        let descriptionVarComment = self.creatorHelpers.createComment(from: "Convert to a description String.")
        let descriptionVar = "public var description: String {"
        let descDef = "var descString = \"\""
        let descReturn = "return descString"
        let setters = variables.flatMap {
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
            "lhs.\($0.label) == rhs.\($0.label)"
        }.combine("") { $0 + "\n" + self.stringHelpers.indent("&& " + $1) }
        let endDef = "}"
        return def + "\n" + self.stringHelpers.indent(content) + "\n" + endDef
    }

    fileprivate func createString(fromVariable variable: Variable) -> String? {
        switch variable.type {
            case .array:
                return self.createArrayStringValue(fromType: variable.type, andLabel: variable.label)
            default:
                guard let value = self.createStringValue(fromType: variable.type, andLabel: variable.label) else {
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
                        //swiftlint:disable line_length
                        return """
                            if let first = self.\(label).first {
                                descString += \"\(label)={\" + self.\(label).dropFirst().reduce(\"\\(first)\") { $0 + "," + $1 } + \"}\"
                            } else {
                                descString += \"\(label)={}\"
                            }
                            """
                }
            default:
                return self.createStringValue(fromType: type, andLabel: label)
        }
    }

    fileprivate func createStringValue(fromType type: VariableTypes, andLabel label: String) -> String? {
        switch type {
            case .array:
                return self.createArrayStringValue(fromType: type, andLabel: label)
            default:
                return "\"\(label)=\\(self.\(label))\""
        }
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

}
