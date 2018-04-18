/*
 * CFromStringCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 07/09/2017.
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

import Data
import Helpers
import swift_helpers
import whiteboard_helpers

//swiftlint:disable:next type_body_length
public final class CFromStringCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        stringHelpers: StringHelpers = StringHelpers()
    ) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    public func createFunction(
        creating fLabel: String,
        withComment comment: String,
        forClass cls: Class,
        withStructNamed structName: String,
        forStrVariable strLabel: String
    ) -> String {
        //swiftlint:disable:next line_length
        let definition = "struct \(structName)* \(structName)_\(fLabel)(struct \(structName)* self, const char* \(strLabel))\n{"
        let head = self.createHead(forClassNamed: cls.name, forStrVariable: strLabel)
        let fillTokens = self.createFillTokens(forClassNamed: cls.name, withArrayVariables: cls.variables.filter {
            switch $0.type {
                case .array:
                    return true
                default:
                    return false
            }
        })
        let assignVarsSection = self.assignVars(cls.variables, forClassNamed: cls.name)
        let cleanup = "free(str_copy);\nreturn self;"
        let contents = head + "\n" + fillTokens + "\n" + assignVarsSection + "\n" + cleanup
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + self.stringHelpers.indent(contents) + "\n" + endDefinition
    }

    fileprivate func createHead(forClassNamed className: String, forStrVariable strLabel: String) -> String {
        return """
            char* strings[\(className.uppercased())_NUMBER_OF_VARIABLES];
            memset(strings, 0, sizeof(strings));
            char* saveptr;
            int count = 0;
            char* \(strLabel)_copy = gu_strdup(str);
            int isArray = 0;
            const char s[2] = ","; // delimeter
            const char e = '=';    // delimeter
            const char b1 = '{';   // delimeter
            const char b2 = '}';   // delimeter
            char* tokenS, *tokenE, *tokenB1, *tokenB2;
            tokenS = strtok_r(str_copy, s, &saveptr);
            """
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createFillTokens(
        forClassNamed className: String,
        withArrayVariables arrayVars: [Variable]
    ) -> String {
        let upperClassName = className.uppercased()
        let head = arrayVars.flatMap {
            switch $0.type {
                case .array:
                    return """
                        char* \($0.label)_values[\(upperClassName)_\($0.label.uppercased())_ARRAY_SIZE];
                        int \($0.label)_count = 0;
                        int is_\($0.label) = 1;
                        """
                default:
                    return nil
            }
        }.combine("") { $0 + "\n" + $1 }
        let tokens = """
            while (tokenS != NULL) {
                tokenE = strchr(tokenS, e);
                if (tokenE == NULL) {
                    tokenE = tokenS;
                } else {
                    tokenE++;
                }
                tokenB1 = strchr(gu_strtrim(tokenE), b1);
                if (tokenB1 == NULL) {
                    tokenB1 = tokenE;
                } else {
                    // start of an array
                    tokenB1++;
                    isArray = 1;
                }
                if (isArray) {
                    tokenB2 = strchr(gu_strtrim(tokenB1), b2);
            """
            let arrs = arrayVars.flatMap {
                switch $0.type {
                    case .array:
                        return """
                            if (is_\($0.label) == 1) {
                                if (tokenB2 != NULL) {
                                    tokenB1[strlen(tokenB1)-1] = 0;
                                    is_\($0.label) = 0;
                                    isArray = 0;
                                    count++;
                                }
                                \($0.label)_values[\($0.label)_count] = gu_strtrim(tokenB1);
                                \($0.label)_count++;
                            }
                            """
                    default:
                        return nil
                }
            }.combine("") { $0 + " else " + $1 }
            let tail = """
                    } else {
                        strings[count] = gu_strtrim(tokenE);
                        count++;
                    }
                    tokenS = strtok_r(NULL, s, &saveptr);
                }
                """
            return head + "\n" + tokens + "\n" + self.stringHelpers.indent(arrs, 2) + "\n" + tail
    }

    fileprivate func assignVars(_ variables: [Variable], forClassNamed className: String) -> String {
        return variables.lazy.filter {
            switch $0.type {
                case .unknown:
                    return false
                default:
                    return true
            }
        }.enumerated().flatMap { (index: Int, variable: Variable) -> String? in
            let accessor = "strings[\(index)]"
            guard let value = self.createValue(
                forType: variable.type,
                withLabel: variable.label,
                andCType: variable.cType,
                accessedFrom: accessor,
                inClassNamed: className
            ) else {
                return nil
            }
            switch variable.type {
                case .array:
                    return value
                case .string:
                    return self.createGuard(accessing: accessor) + "\n" + self.stringHelpers.indent(value)
                case .char:
                    return self.createGuard(accessing: accessor) + " {\n" + self.stringHelpers.indent(value) + "\n}"
                default:
                    let assignment = "self->\(variable.label) = \(value)"
                    return self.createGuard(accessing: accessor) + "\n" + self.stringHelpers.indent(assignment)
            }
        }.combine("") { $0 + "\n" + $1}
    }

    fileprivate func createGuard(accessing label: String) -> String {
        return "if (\(label) != NULL)"
    }

    fileprivate func createValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClassNamed className: String
    ) -> String? {
        switch type {
            case .array:
                return self.createArrayValue(
                    forType: type,
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className
                )
            case .bool:
                return "strcmp(\(accessor), \"true\") == 0 || strcmp(\(accessor), \"1\") == 0 ? true : false;"
            case .char:
                let cast = "char" == cType ? "" : "(\(cType)) "
                return """
                    char \(label)_temp;
                    self->\(label) = \(cast)(*strncpy(&\(label)_temp, \(accessor), 1));
                    """
            case .bit, .numeric:
                return self.createNumericValue(
                    forType: type,
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className
                )
            case.string(let length):
                return "strncpy(&self->\(label)[0], \(accessor), \(length));"
            default:
                return nil
        }
    }

    fileprivate func createArrayValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClassNamed className: String,
        _ level: Int = 0
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                let levelStr = 0 == level ? "" : "_\(level)"
                let sizeLabel = label + levelStr + "_smallest"
                let countLabel = label + levelStr + "_count"
                let countDef = self.creatorHelpers.createArrayCountDef(
                    inClass: className,
                    forVariable: label,
                    level: level
                )
                let def = "size_t \(sizeLabel) = \(countLabel) < \(countDef) ? \(countLabel) : \(countDef);"
                let index = "\(label)\(levelStr)_index"
                let loopDef = "for (int \(index) = 0; \(index) < \(sizeLabel); \(index)++) {"
                let accessList = self.createArrayAccess(forVariable: label, level)
                let loopContent: String
                switch subtype {
                    case .array:
                        return nil
                    default:
                        guard let value = self.createValue(
                            forType: subtype,
                            withLabel: label,
                            andCType: cType,
                            accessedFrom: label + levelStr + "_values" + accessList,
                            inClassNamed: className
                        ) else {
                            return nil
                        }
                        loopContent = "self->\(label)\(accessList) = \(value)"
                }
                let endLoop = "}"
                return def + "\n" + loopDef + "\n" + self.stringHelpers.indent(loopContent) + "\n" + endLoop
            default:
                return self.createValue(
                    forType: type,
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className
                )
        }
    }

    fileprivate func createArrayAccess(forVariable label: String, _ level: Int) -> String {
        if level <= 0 {
            return "[\(label)_index]"
        }
        return self.createArrayAccess(forVariable: label, level - 1) + "[\(label)_\(level)_\(index)]"
    }

    fileprivate func createNumericValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClassNamed className: String
    ) -> String? {
        switch type {
            case .bit:
                return "(\(cType))atoi(\(accessor));"
            case .numeric(let numericType):
                switch numericType {
                    case .double, .float, .long(.double), .long(.float):
                        return "(\(cType))atof(\(accessor));"
                    case .long(.long):
                        return "(\(cType))atoll(\(accessor));"
                    case .long(.signed), .long(.unsigned):
                        return "(\(cType))atol(\(accessor));"
                    case .signed, .unsigned:
                        return "(\(cType))atoi(\(accessor));"
                }
            default:
                return self.createValue(
                    forType: type,
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className
                )
        }
    }

}
