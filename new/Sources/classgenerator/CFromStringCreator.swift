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

public final class CFromStringCreator {

    fileprivate let stringHelpers: StringHelpers

    public init(stringHelpers: StringHelpers = StringHelpers()) {
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
        let assignVarsSection = self.assignVars(cls.variables)
        let contents = head + "\n" + fillTokens + "\n" + assignVarsSection
        let endDefinition = "\n}"
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

    fileprivate func assignVars(_ variables: [Variable]) -> String {
        return variables.enumerated().flatMap { (index: Int, variable: Variable) -> String? in
            let label = "strings[\(index)]"
            guard let value = self.createValue(forVariable: variable, accessedFrom: label) else {
                return nil
            }
            let assignment = "self->\(variable.label) = \(value)"
            return self.createGuard(accessing: label) + "\n" + self.stringHelpers.indent(assignment)
        }.combine("") { $0 + "\n" + $1}
    }

    fileprivate func createGuard(accessing label: String) -> String {
        return "if (\(label) != NULL)"
    }

    fileprivate func createValue(forVariable variable: Variable, accessedFrom label: String) -> String? {
        switch variable.type {
            case .array:
                return ""
            case .bool:
                return "strcmp(\(label), \"true\") == 0 || strcmp(\(label), \"1\") == 0 ? true : false;"
            case .char:
                return "(\(variable.cType))atoi(\(label));"
            case.numeric:
                return self.createNumericValue(forVariable: variable, accessedFrom: label)
            case.string:
                return "(string)(\(label));"
            default:
                return nil
        }
    }

    fileprivate func createNumericValue(forVariable variable: Variable, accessedFrom label: String) -> String? {
        switch variable.type {
            case .numeric(let numericType):
                switch numericType {
                    case .double, .float, .long(.double), .long(.float):
                        return "(\(variable.cType))atof(\(label));"
                    case .long(.long):
                        return "(\(variable.cType))atoll(\(label));"
                    case .long(.signed), .long(.unsigned):
                        return "(\(variable.cType))atol(\(label));"
                    case .signed, .unsigned:
                        return "(\(variable.cType))atoi(\(label));"
                    default:
                        return nil
                }
            default:
                return self.createValue(forVariable: variable, accessedFrom: label)
        }
    }

}