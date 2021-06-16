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
import whiteboard_helpers

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
    
    public let stringGetter: (String) -> String

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
        stringGetter: @escaping (String) -> String,
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
        self.stringGetter = stringGetter
        self.getter = getter
        self.setter = setter
    }

    public func createSetup(forClass cls: Class, namespaces: [CNamespace]) -> String {
        let keyAssignsIfs = cls.variables.lazy.filter{
            switch $0.type {
            case .pointer, .unknown:
                return false
            default:
                return true
            }
        }.enumerated().map {
            return """
                if (0 == strcmp(\"\($1.label)\", key)) {
                    varIndex = \($0);
                }
                """
        }.combine("") { $0 + " else " + $1 }
        let keyAssigns = keyAssignsIfs.isEmpty ? "varIndex = -1;" : keyAssignsIfs + " else {\n    varIndex = -1;\n}"
        let keyBufferSize = (cls.variables.sorted() { $0.label.count > $1.label.count }.first?.label.count).map { $0 + 1 } ?? 0
        let recursive = nil != cls.variables.first { $0.type.isRecursive }
        let lastBrace = recursive ? "\nint lastBrace = -1;" : ""
        let bufferDef = "\(cls.name.uppercased())_DESC_BUFFER_SIZE"
        return """
            size_t temp_length = strlen(\(self.strLabel));
            int length = (temp_length <= INT_MAX) ? \(self.cast(self.cast("temp_length", "ssize_t"), "int")) : -1;
            if (length < 1 || length > \(bufferDef)) {
                \(self.shouldReturnSelf ? "return \(self.selfStr);" : "return;")
            }
            char \(self.accessor)_buffer[\(bufferDef) + 1];
            char* \(self.accessor) = &\(self.accessor)_buffer[0];
            char key_buffer[\(keyBufferSize)];
            char* key = &key_buffer[0];
            int bracecount = 0;\(lastBrace)
            int startVar = 0;
            int index = 0;
            int startKey = 0;
            int endKey = -1;
            int varIndex = 0;
            if (index == 0 && \(self.strLabel)[0] == '{') {
                index = 1;
            }
            startVar = index;
            startKey = startVar;
            do {
            \(self.stringHelpers.cIndent(self.createParseLoop(accessedFrom: self.accessor, recursive: recursive)))
                if (strlen(key) > 0) {
            \(self.stringHelpers.cIndent(keyAssigns, 2))
                }
                switch (varIndex) {
                    case -1: { break; }
            """
    }

    public func createTearDown(forClass cls: Class) -> String {
        let end = """
                }
                if (varIndex >= 0) {
                    varIndex++;
                }
            } while(index < length);
            """
        if false == self.shouldReturnSelf {
            return end
        }
        return end + "\n" + "return \(self.selfStr);"
    }

    public func createSetupArrayLoop(
        atOffset offset: Int,
        withIndexName index: String,
        andLength length: String,
        recursive: Bool
    ) -> String {
        let start = """
            case \(offset):
            {
                int restartIndex = index;
                index = lastBrace + 1;
                startVar = index;
                startKey = startVar;
                endKey = -1;
                bracecount = 0;
                for (int \(index) = 0; \(index) < \(length); \(index)++) {
            """
        let loop = self.stringHelpers.cIndent(self.createParseLoop(accessedFrom: self.accessor, recursive: recursive), 2)
        return self.stringHelpers.cIndent(start + "\n" + loop, 2)
    }

    public func createTearDownArrayLoop(
        atOffset offset: Int,
        withIndexName index: String,
        andLength length: String
    ) -> String {
        return self.stringHelpers.cIndent("""
                }
                index = restartIndex;
                break;
            }
            """, 2)
    }

    public func createArrayValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        level: Int,
        setter: (String) -> String
    ) -> String? {
        guard let value = self.createVariablesValue(
            forType: type,
            withLabel: label,
            andCType: cType,
            accessedFrom: accessor,
            inClass: cls,
            level: level,
            setter: setter
        ) else {
            return nil
        }
        return self.stringHelpers.cIndent(value, 3)
    }

    public func createValue(
        atOffset offset: Int,
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        setter: (String) -> String
    ) -> String? {
        guard let value = self.createVariablesValue(
            forType: type,
            withLabel: label,
            andCType: cType,
            accessedFrom: accessor,
            inClass: cls,
            level: 0,
            setter: setter
        ) else {
            return nil
        }
        return self.stringHelpers.cIndent(self.createCase("\(offset)", containing: value), 2)
    }

    public func setter(forVariable variable: Variable) -> (String) -> String {
        switch variable.type {
        case .array:
            return { $0 }
        case .string, .gen:
            return { $0 + ";" }
        case .enumerated:
            return {
                """
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Wbad-function-cast"
                \(self.setter(variable.label, $0))
                #pragma clang diagnostic pop
                """
            }
        default:
            return { self.setter(variable.label, $0) }
        }
    }

    fileprivate func createCase(_ condition: String, containing contents: String) -> String {
        return """
        case \(condition):
        {
        \(self.stringHelpers.cIndent(contents))
            break;
        }
        """
    }

    fileprivate func createParseLoop(accessedFrom accessor: String, recursive: Bool) -> String {
        let lastBrace = !recursive ? "" : ("\n" + """
                    if (bracecount == 1) {
                        lastBrace = i;
                    }
            """)
        return """
            for (int i = index; i < length; i++) {
                index = i + 1;
                if (bracecount == 0 && \(strLabel)[i] == '=') {
                    endKey = i - 1;
                    startVar = index;
                    continue;
                }
                if (bracecount == 0 && isspace(\(strLabel)[i])) {
                    startVar = index;
                    if (endKey == -1) {
                        startKey = index;
                    }
                    continue;
                }
                if (bracecount == 0 && \(strLabel)[i] == ',') {
                    index = i - 1;
                    break;
                }
                if (\(strLabel)[i] == '{') {
                    bracecount++;\(lastBrace)
                    continue;
                }
                if (\(strLabel)[i] == '}') {
                    bracecount--;
                    if (bracecount < 0) {
                        index = i - 1;
                        break;
                    }
                }
                if (i == length - 1) {
                    index = i;
                }
            }
            if (endKey >= startKey && endKey - startKey < length) {
                strncpy(key, \(strLabel) + startKey, \(self.cast("(endKey - startKey) + 1", "size_t")));
                key[(endKey - startKey) + 1] = 0;
            } else {
                key[0] = 0;
            }
            strncpy(\(accessor), \(strLabel) + startVar, \(self.cast("(index - startVar) + 1", "size_t")));
            \(accessor)[(index - startVar) + 1] = 0;
            bracecount = 0;
            index += 2;
            startVar = index;
            startKey = startVar;
            endKey = -1;
            """
    }

    fileprivate func createVariablesValue(
        forType type: VariableTypes,
        withLabel label: String,
        andCType cType: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        level: Int,
        setter: (String) -> String
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
            case .enumerated(let name):
                let numericSetter = self.createNumericValue(
                    forType: .numeric(.signed),
                    withLabel: label,
                    andCType: cType,
                    accessedFrom: accessor,
                    inClassNamed: className,
                    level,
                    setter
                )
                guard let enm = cls.enums.first(where: { $0.name == name }) else {
                    return numericSetter
                }
                let cases = enm.cases.sorted { $0.key < $1.key }.map {
                    return """
                        if (strcmp(\"\($0.0)\", \(accessor)) == 0) {
                            \(setter($0.0))
                        }
                        """
                }
                let handleCases = cases.combine("") { $0 + " else " + $1 }
                return handleCases + " else {\n" + "    " + (numericSetter ?? "") + "\n}"
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
                return setter("strncpy(\(self.stringGetter(label)), \(accessor), \(length))")
            case .mixed(let macOS, let linux):
                guard
                    let macValue = self.createVariablesValue(forType: macOS, withLabel: label, andCType: cType, accessedFrom: accessor, inClass: cls, level: level, setter: setter),
                    let linuxValue = self.createVariablesValue(forType: linux, withLabel: label, andCType: cType, accessedFrom: accessor, inClass: cls, level: level, setter: setter)
                else {
                    return nil
                }
                if macValue == linuxValue {
                    return macValue
                }
                return """
                    #ifdef __APPLE__
                    \(macValue)
                    #else
                    \(linuxValue)
                    #endif
                    """
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
