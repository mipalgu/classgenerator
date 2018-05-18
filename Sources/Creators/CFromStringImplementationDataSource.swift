/*
 * CFromStringImplementationDataSource.swift 
 * Creators 
 *
 * Created by Callum McColl on 18/05/2018.
 * Copyright © 2018 Callum McColl. All rights reserved.
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

import Data
import swift_helpers

public final class CFromStringImplementationDataSource: FromStringImplementationDataSource {

    public let accessor: String = "var_str"

    public let selfStr: String

    public let shouldReturnSelf: Bool

    public let strLabel: String

    fileprivate let stringHelpers: StringHelpers

    fileprivate let cast: (String, String) -> String

    fileprivate let recurse: (Bool, String, String, String, String) -> String

    public let arrayGetter: (String, String) -> String

    public let arraySetter: (String, String, String) -> String

    public let getter: (String) -> String

    public let setter: (String, String) -> String

    public init(
        selfStr: String,
        shouldReturnSelf: Bool,
        strLabel: String,
        stringHelpers: StringHelpers = StringHelpers(),
        cast: @escaping (String, String) -> String,
        recurse: @escaping (Bool, String, String, String, String) -> String,
        arrayGetter: @escaping (String, String) -> String,
        arraySetter: @escaping (String, String, String) -> String,
        getter: @escaping (String) -> String,
        setter: @escaping (String, String) -> String
    ) {
        self.selfStr = selfStr
        self.shouldReturnSelf = shouldReturnSelf
        self.strLabel = strLabel
        self.stringHelpers = stringHelpers
        self.cast = cast
        self.recurse = recurse
        self.arrayGetter = arrayGetter
        self.arraySetter = arraySetter
        self.getter = getter
        self.setter = setter
    }

    public func createSetup(forClass cls: Class) -> String {
        return """
            size_t temp_length = strlen(\(self.strLabel));
            int length = (temp_length <= INT_MAX) ? (int)((ssize_t)temp_length) : -1;
            if (length < 1) {
                \(self.shouldReturnSelf ? "return \(self.selfStr);" : "return;")
            }
            char \(self.accessor)_buffer[\(cls.name.uppercased())_TO_STRING_BUFFER_SIZE + 1];
            char* \(self.accessor) = &\(self.accessor)_buffer[0];
            int bracecount = 0;
            int lastBrace = -1;
            int startVar = 0;
            int index = 0;
            if (index == 0 && \(self.strLabel)[0] == '{') {
                index = 1;
            }
            """
    }

    public func createTearDown(forClass cls: Class) -> String {
        if true == self.shouldReturnSelf {
            return "return " + self.selfStr + ";"
        }
        return "return;"
    }

    public func createSetupArrayLoop(withIndexName index: String, andLength length: String) -> String {
        return """
            while(\(self.strLabel)[index++] != '{');
            for (int \(index) = 0; \(index) < \(length); \(index)++) {
            """
    }

    public func createTearDownArrayLoop(withIndexName index: String, andLength length: String) -> String {
        return "}"
    }

    public func createValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        _ level: Int,
        setter: (String) -> String
    ) -> String? {
        guard let value = self.createVariablesValue(
            forType: type,
            withLabel: label,
            andCType: cType,
            accessedFrom: accessor,
            inClass: cls,
            level,
            setter
        ) else {
            return nil
        }
        let forStart = """
            startVar = index;
            for (int i = index; i < length; i++) {
            """
        let forContent = """
            index = i + 1;
            if (bracecount == 0 && \(strLabel)[i] == '=') {
                startVar = index;
                continue;
            }
            if (bracecount == 0 && isspace(\(strLabel)[i])) {
                startVar = index;
                continue;
            }
            if (bracecount == 0 && \(strLabel)[i] == ',') {
                index = i;
                break;
            }
            if (bracecount == 0 && \(strLabel)[i] == '}') {
                index = i;
                break;
            }
            """
        let createVarStr: String
        let forEnd = """
            if (bracecount == 0 && \(strLabel)[index] == '}') {
                index++;
            }
            index++;
            """
        switch type {
        case .array:
            createVarStr = """
                strncpy(\(accessor), \(strLabel) + startVar, index - startVar);
                \(accessor)[index - startVar] = 0;
                index++;
                """
            break
        case .gen:
            createVarStr = """
                strncpy(\(accessor), \(strLabel) + startVar, (index - startVar) + 1);
                \(accessor)[(index - startVar) + 1] = 0;
                """
            break;
        default:
            createVarStr = """
                strncpy(\(accessor), \(strLabel) + startVar, index - startVar);
                \(accessor)[index - startVar] = 0;
                """
            return forStart + "\n" + self.stringHelpers.indent(forContent) + "\n}\n" + createVarStr + "\n" + forEnd + "\n" + value
        }
        let braceContent = """
            if (\(strLabel)[i] == '{') {
                bracecount++;
                if (bracecount == 1) {
                    lastBrace = i;
                }
                continue;
            }
            if (\(strLabel)[i] == '}') {
                bracecount--;
                if (bracecount < 0) {
                    \(true == self.shouldReturnSelf ? "return self;" : "return;")
                }
                if (bracecount != 0) {
                    continue;
                }
                break;
            }
            """
        let braceEnd = """
            bracecount = 0;
            """
        return forStart + "\n"
            + self.stringHelpers.indent(forContent + "\n" + braceContent) + "\n}\n"
            + createVarStr + "\n"
            + forEnd + "\n"
            + braceEnd + "\n"
            + value
    }

    public func setter(forVariable variable: Variable) -> (String) -> String {
        switch variable.type {
        case .array:
            return { $0 }
        case .string, .gen:
            return { $0 + ";" }
        default:
            return { self.setter(variable.label, $0) }
        }
    }

    public func createVariablesValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        _ level: Int,
        _ setter: (String) -> String
    ) -> String? {
        let className = cls.name
        switch type {
            case .array:
                return nil
            case .bool:
                return setter("strcmp(\(accessor), \"true\") == 0 || strcmp(\(accessor), \"1\") == 0")
            case .char:
                let assign: String
                let value = "(*strncpy(&\(label)_temp, \(accessor), 1))"
                if "char" == cType {
                    assign = setter(value)
                } else {
                    assign = setter(self.cast(value, cType))
                }
                return """
                    char \(label)_temp;
                    \(assign)
                    """
            case .enumerated:
                return self.createNumericValue(
                    forType: .numeric(.signed),
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className,
                    level,
                    setter
                )
            case .gen(_, let structName, let className):
                let assign = self.recurse(0 != level, structName, className, label, accessor)
                let end = 0 == level ? "" : "\n" + setter(label)
                return assign + end
            case .bit, .numeric:
                return self.createNumericValue(
                    forType: type,
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className,
                    level,
                    setter
                )
            case.string(let length):
                return setter("strncpy(\(self.getter(label)), \(accessor), \(length))")
            default:
                return nil
        }
    }

    fileprivate func createNumericValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClassNamed className: String,
        _ level: Int = 0,
        _ setter: (String) -> String
    ) -> String? {
        switch type {
            case .bit:
                return setter(self.cast("atoi(\(accessor))", cType))
            case .numeric(let numericType):
                switch numericType {
                    case .double, .float, .long(.double), .long(.float):
                        return setter(self.cast("atof(\(accessor))", cType))
                    case .long(.long):
                        return setter(self.cast("atoll(\(accessor))", cType))
                    case .long(.signed), .long(.unsigned):
                        return setter(self.cast("atol(\(accessor))", cType))
                    case .signed, .unsigned:
                        return setter(self.cast("atoi(\(accessor))", cType))
                }
            default:
                return nil
        }
    }

}
