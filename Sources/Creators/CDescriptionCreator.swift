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
        includeLabels: Bool
    ) -> String {
        //swiftlint:disable:next line_length
        let definition = "const char* \(structName)_\(fLabel)(const struct \(structName)* self, char* \(strLabel), size_t bufferSize)\n{"
        let head = """
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-variable"
                size_t len = 0;
            """
        let descriptions = cls.variables.flatMap {
            self.createDescription(
                forVariable: $0,
                forClassNamed: cls.name,
                appendingTo: strLabel,
                includeLabels: includeLabels
            )
        }
        let guardedDescriptions = descriptions.map {
            self.createGuard(forStrVariable: strLabel) + "\n" + $0
        }
        let vars = self.stringHelpers.indent(guardedDescriptions.combine("") {
            $0 +
            "\n" +
            self.createGuard(forStrVariable: strLabel) + "\n" + self.createComma(appendingTo: strLabel) +
            "\n" +
            $1
        })
        let returnStatement = "    return \(strLabel);"
        let endDefinition = "}"
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
        forClassNamed className: String,
        appendingTo strLabel: String,
        includeLabels: Bool
    ) -> String? {
        return self.createDescription(
            forType: variable.type,
            withLabel: variable.label,
            andClassName: className,
            appendingTo: strLabel,
            includeLabels: includeLabels
        )
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createArrayDescription(
        forType type: VariableTypes,
        withLabel label: String,
        andClassName className: String,
        appendingTo strLabel: String,
        includeLabels: Bool,
        _ level: Int = 0
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                let arrLabel = 0 == level ? label : label + "_\(level)"
                let temp: String?
                switch subtype {
                    case .array:
                        temp = self.createArrayDescription(
                            forType: subtype,
                            withLabel: label,
                            andClassName: className,
                            appendingTo: strLabel,
                            includeLabels: includeLabels,
                            level + 1
                        )
                    default:
                        temp = self.createValue(
                            forType: subtype,
                            withLabel: self.createIndexes(forLabel: label, level),
                            andClassName: className,
                            appendingTo: strLabel,
                            includeLabels: includeLabels
                        )
                }
                guard let value = temp else {
                    return nil
                }
                //swiftlint:disable line_length
                return """
                    len = gu_strlcat(\(strLabel), "\(includeLabels ? arrLabel + "=" : ""){", bufferSize);
                    int \(arrLabel)_first = 0;
                    for (int \(arrLabel)_index = 0; \(arrLabel)_index < \(self.stringHelpers.toSnakeCase(className).uppercased())_\(arrLabel.uppercased())_ARRAY_SIZE; \(arrLabel)_index++) {
                    \(self.stringHelpers.indent(self.createGuard(forStrVariable: strLabel)))
                        if (1 == \(arrLabel)_first) {
                            \(self.createComma(appendingTo: strLabel))
                        }
                    \(self.stringHelpers.indent(value))
                        \(arrLabel)_first = 1;
                    }
                    \(self.createGuard(forStrVariable: strLabel))
                    len = gu_strlcat(\(strLabel), "}", bufferSize);
                    """
            default:
                return self.createDescription(
                    forType: type,
                    withLabel: label,
                    andClassName: className,
                    appendingTo: strLabel,
                    includeLabels: includeLabels
                )
        }
    }

    fileprivate func createIndexes(forLabel label: String, _ level: Int) -> String {
        return Array(0...level).map { 0 == $0 ? "[\(label)_index]" : "[\(label)_\($0)_index]" }.reduce(label, +)
    }

    fileprivate func createDescription(
        forType type: VariableTypes,
        withLabel label: String,
        andClassName className: String,
        appendingTo strLabel: String,
        includeLabels: Bool
    ) -> String? {
        let pre = includeLabels ? label + "=" : ""
        switch type {
            case .array:
                return self.createArrayDescription(
                    forType: type,
                    withLabel: label,
                    andClassName: className,
                    appendingTo: strLabel,
                    includeLabels: includeLabels
                )
            case .bit:
                return self.createSNPrintf("\(pre)%u", "self->\(label)", appendingTo: strLabel)
            case .bool:
                let value = "len = gu_strlcat(\(strLabel), self->\(label) ? \"true\" : \"false\", bufferSize);"
                if true == includeLabels {
                    return """
                        len = gu_strlcat(\(strLabel), "\(pre)", bufferSize);
                        \(self.createGuard(forStrVariable: strLabel))
                        \(value)
                        """
                }
                return value
            case .char:
                return self.createSNPrintf("\(pre)%c", "self->\(label)", appendingTo: strLabel)
            case .numeric(let numericType):
                return self.createSNPrintf(
                    "\(pre)%\(self.createFormat(forNumericType: numericType))",
                    "self->\(label)",
                    appendingTo: strLabel
                )
            case .string:
                return self.createSNPrintf("\(pre)%s", "self->\(label)", appendingTo: strLabel)
            default:
                return nil
        }
    }

    fileprivate func createValue(
        forType type: VariableTypes,
        withLabel label: String,
        andClassName className: String,
        appendingTo strLabel: String,
        includeLabels: Bool
    ) -> String? {
        switch type {
            case .array:
                return self.createArrayDescription(
                    forType: type,
                    withLabel: label,
                    andClassName: className,
                    appendingTo: strLabel,
                    includeLabels: includeLabels
                )
            case .bit:
                return self.createSNPrintf("%u", "self->\(label)", appendingTo: strLabel)
            case .bool:
                return "len = gu_strlcat(\(strLabel), self->\(label) ? \"true\" : \"false\", bufferSize);"
            case .char:
                return self.createSNPrintf("%c", "self->\(label)", appendingTo: strLabel)
            case .numeric(let numericType):
                return self.createSNPrintf(
                    "%\(self.createFormat(forNumericType: numericType))",
                    "self->\(label)",
                    appendingTo: strLabel
                )
            case .string:
                return self.createSNPrintf("%s", "self->\(label)", appendingTo: strLabel)
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
            case .double:
                return "lf"
            case .float:
                return "f"
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
