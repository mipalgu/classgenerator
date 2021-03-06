/*
 * CDescriptionCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 29/08/2017.
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

import Data
import Helpers
import swift_helpers
import whiteboard_helpers

public final class CDescriptionCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    //swiftlint:disable function_parameter_count
    public func createFunction(
        creating fLabel: String,
        withComment comment: String,
        forClass cls: Class,
        withStructNamed structName: String,
        forStrVariable strLabel: String,
        includeLabels: Bool,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        //swiftlint:disable:next line_length
        let definition = "const char* \(structName)_\(fLabel)(const struct \(structName)* self, char* \(strLabel), size_t bufferSize)\n{"
        if cls.variables.isEmpty {
            return """
            \(definition)
                (void) self;
                (void) bufferSize;
                return \(strLabel);
            }
            """
        }
        
        let head = """
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-variable"
                size_t len = 0;
            """
        let descriptions = cls.variables.compactMap {
            self.createDescription(
                forVariable: $0,
                inClass: cls,
                forClassNamed: cls.name,
                appendingTo: strLabel,
                includeLabels: includeLabels,
                namespaces: namespaces,
                squashDefines: squashDefines
            )
        }
        let guardedDescriptions = descriptions.map {
            self.createGuard(forStrVariable: strLabel) + "\n" + $0
        }
        let vars = self.stringHelpers.cIndent(guardedDescriptions.combine("") {
            $0 +
            "\n" +
            self.createGuard(forStrVariable: strLabel) + "\n" + self.createComma(appendingTo: strLabel) +
            "\n" +
            $1
        })
        let returnStatement = "    return \(strLabel);"
        let endDefinition = "#pragma clang diagnostic pop\n}"
        return comment + "\n" + definition + "\n" + head + "\n" + vars + "\n" + returnStatement + "\n" + endDefinition
    }

    fileprivate func createGuard(forStrVariable strLabel: String) -> String {
        return """
            if (len >= bufferSize) {
                return \(strLabel);
            }
            """
    }

    fileprivate func createComma(appendingTo strLabel: String) -> String {
        return "len = gu_strlcat(\(strLabel), \", \", bufferSize);"
    }

    fileprivate func createDescription(
        forVariable variable: Variable,
        inClass cls: Class,
        forClassNamed className: String,
        appendingTo strLabel: String,
        includeLabels: Bool,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String? {
        return self.createValue(
            forType: variable.type,
            withLabel: variable.label,
            inClass: cls,
            andClassName: className,
            includeLabel: includeLabels,
            appendingTo: strLabel,
            namespaces: namespaces,
            squashDefines: squashDefines
        )
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createArrayDescription(
        forType type: VariableTypes,
        withLabel label: String,
        inClass cls: Class,
        andClassName className: String,
        includeLabel: Bool,
        appendingTo strLabel: String,
        namespaces: [CNamespace],
        squashDefines: Bool,
        _ createGetter: (String) -> String = { "self->" + $0 },
        _ level: Int = 0
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                let arrLabel = 0 == level ? label : label + "_\(level)"
                let temp: String?
                switch subtype {
                    case .array:
                        return nil
                    default:
                        temp = self.createValue(
                            forType: subtype,
                            withLabel: arrLabel,
                            inClass: cls,
                            andClassName: className,
                            includeLabel: includeLabel,
                            appendingTo: strLabel,
                            namespaces: namespaces,
                            squashDefines: squashDefines,
                            { _ in "self->" + self.createIndexes(forLabel: label, level) },
                            level + 1
                        )
                }
                guard let value = temp else {
                    return nil
                }
                let arrDef = self.creatorHelpers.createArrayCountDef(inClass: cls.name, forVariable: label, level: level, namespaces: squashDefines ? [] : namespaces)
                //swiftlint:disable line_length
                return """
                    len = gu_strlcat(\(strLabel), "\(includeLabel ? arrLabel + "=" : ""){", bufferSize);
                    for (int \(arrLabel)_index = 0; \(arrLabel)_index < \(arrDef); \(arrLabel)_index++) {
                    \(self.stringHelpers.cIndent(self.createGuard(forStrVariable: strLabel)))
                        if (\(arrLabel)_index > 0) {
                            \(self.createComma(appendingTo: strLabel))
                        }
                    \(self.stringHelpers.cIndent(value))
                    }
                    \(self.createGuard(forStrVariable: strLabel))
                    len = gu_strlcat(\(strLabel), "}", bufferSize);
                    """
            default:
                return self.createValue(
                    forType: type,
                    withLabel: label,
                    inClass: cls,
                    andClassName: className,
                    includeLabel: includeLabel,
                    appendingTo: strLabel,
                    namespaces: namespaces,
                    squashDefines: squashDefines
                )
        }
    }

    fileprivate func createIndexes(forLabel label: String, _ level: Int) -> String {
        return Array(0...level).map { 0 == $0 ? "[\(label)_index]" : "[\(label)_\($0)_index]" }.reduce(label, +)
    }

    fileprivate func createValue(
        forType type: VariableTypes,
        withLabel label: String,
        inClass cls: Class,
        andClassName className: String,
        includeLabel: Bool,
        appendingTo strLabel: String,
        namespaces: [CNamespace],
        squashDefines: Bool,
        _ createGetter: (String) -> String = { "self->" + $0 },
        _ level: Int = 0
    ) -> String? {
        let pre = true == includeLabel && 0 == level ? label + "=" : ""
        let getter = createGetter(label)
        switch type {
            case .array:
                return self.createArrayDescription(
                    forType: type,
                    withLabel: label,
                    inClass: cls,
                    andClassName: className,
                    includeLabel: includeLabel,
                    appendingTo: strLabel,
                    namespaces: namespaces,
                    squashDefines: squashDefines
                )
            case .bit:
                return self.createSNPrintf("\(pre)%u", getter, appendingTo: strLabel)
            case .bool:
                return "len = gu_strlcat(\(strLabel), \(getter) ? \"\(pre)true\" : \"\(pre)false\", bufferSize);"
            case .char:
                return self.createSNPrintf("\(pre)%c", getter, appendingTo: strLabel)
            case .enumerated(let name):
                let numericValue = self.createSNPrintf(
                    "\(pre)%\(self.createFormat(forNumericType: .signed))",
                    getter,
                    appendingTo: strLabel
                )
                guard let enm = cls.enums.first(where: { $0.name == name }) else {
                    return numericValue
                }
                let setter: (String) -> String = { self.createSNPrintf("\(pre)\($0)", appendingTo: strLabel) }
                let cases = enm.cases.sorted { $0.key < $1.key }.map {
                    return """
                            case \($0.0):
                            {
                                \(setter($0.0))
                                break;
                            }
                        """
                }
                let combinedCases = cases.combine("") { $0 + "\n" + $1 }
                return "switch (" + getter + ") {\n" + combinedCases + "\n" + "}"
            case .gen(let genName, let structName, _):
                let fun = true == includeLabel ? "description" : "to_string"
                let localLabel = 0 == level ? label : label + "_\(level)"
                let size = true == includeLabel ? self.creatorHelpers.createDescriptionBufferSizeDef(fromGenName: genName, namespaces: squashDefines ? [] : namespaces) : self.creatorHelpers.createToStringBufferSizeDef(fromGenName: genName, namespaces: squashDefines ? [] : namespaces)
                return """
                    len = gu_strlcat(\(strLabel), "\(pre){", bufferSize);
                    \(self.createGuard(forStrVariable: strLabel))
                    char \(localLabel)_buffer[\(size)];
                    char* \(localLabel)_p = \(localLabel)_buffer;
                    const char* \(localLabel)_\(fun) = \(structName)_\(fun)(&\(getter), \(localLabel)_p, \(size));
                    len = gu_strlcat(\(strLabel), \(localLabel)_p, bufferSize);
                    \(self.createGuard(forStrVariable: strLabel))
                    len = gu_strlcat(\(strLabel), "}", bufferSize);
                    """
            case .numeric(let numericType):
                let cast = numericType == .float ? "(double) " : ""
                return self.createSNPrintf(
                    "\(pre)%\(self.createFormat(forNumericType: numericType))",
                    cast + getter,
                    appendingTo: strLabel
                )
            case .mixed(let macOS, let linux):
                guard
                    let macValue = self.createValue(forType: macOS, withLabel: label, inClass: cls, andClassName: className, includeLabel: includeLabel, appendingTo: strLabel, namespaces: namespaces, squashDefines: squashDefines, createGetter, level),
                    let linuxValue = self.createValue(forType: linux, withLabel: label, inClass: cls, andClassName: className, includeLabel: includeLabel, appendingTo: strLabel, namespaces: namespaces, squashDefines: squashDefines, createGetter, level)
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
            case .string:
                return self.createSNPrintf("\(pre)%s", getter, appendingTo: strLabel)
            default:
                return nil
        }
    }

    fileprivate func createSNPrintf(_ str: String, _ args: String? = nil, appendingTo strLabel: String) -> String {
        guard let args = args else {
            return "len += snprintf(\(strLabel) + len, bufferSize - len, \"\(str)\");"
        }
        return "len += snprintf(\(strLabel) + len, bufferSize - len, \"\(str)\", \(args));"
    }

    fileprivate func createFormat(forNumericType type: NumericTypes) -> String {
        switch type {
        case .float, .double:
                return "lf"
            case .long(let subtype):
                switch subtype {
                    case .float:
                        return "f"
                    case .double:
                        return "Lf"
                    default:
                        return "l" + self.createFormat(forNumericType: subtype)
                }
            case .signed:
                return "d"
            case .unsigned:
                return "u"
        }
    }

}
