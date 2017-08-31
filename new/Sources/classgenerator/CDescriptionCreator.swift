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

public final class CDescriptionCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    public func createDescriptionFunction(forClass cls: Class, withStructNamed structName: String) -> String {
        let comment = """
            /**
             * Convert to a description string.
             */
            """
        //swiftlint:disable:next line_length
        let definition = "const char* \(structName)_description(const struct \(structName)* self, char* descString, size_t bufferSize)\n{"
        let head = """
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-variable"
                size_t len = 0;
            """
        let descriptions = cls.variables.flatMap { self.createDescription(forVariable: $0, forClassNamed: cls.name) }
        let guardedDescriptions = descriptions.map {
            self.createGuard() + "\n" + $0
        }
        let vars = self.stringHelpers.indent(guardedDescriptions.combine("") {
            $0 + "\n" + self.createGuard() + "\n" + self.createComma() + "\n" + $1
        })
        let returnStatement = "    return descString;"
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + head + "\n" + vars + "\n" + returnStatement + "\n" + endDefinition
    }

    fileprivate func createGuard() -> String {
        return """
            if (len >= bufferSize) {
                return descString;
            }
            """
    }

    fileprivate func createComma() -> String {
        return "len = gu_strlcat(descString, \", \", bufferSize);"
    }

    fileprivate func createDescription(forVariable variable: Variable, forClassNamed className: String) -> String? {
        return self.createDescription(forType: variable.type, withLabel: variable.label, andClassName: className)
    }

    fileprivate func createArrayDescription(
        forType type: VariableTypes,
        withLabel label: String,
        andClassName className: String,
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
                            level + 1
                        )
                    default:
                        temp = self.createValue(
                            forType: subtype,
                            withLabel: self.createIndexes(forLabel: label, level),
                            andClassName: className
                        )
                }
                guard let value = temp else {
                    return nil
                }
                //swiftlint:disable line_length
                return """
                    len = gu_strlcat(descString, "\(arrLabel)={", bufferSize);
                    int \(arrLabel)_first = 0;
                    for (int \(arrLabel)_index = 0; \(arrLabel)_index < \(self.stringHelpers.toSnakeCase(className).uppercased())_\(arrLabel.uppercased())_ARRAY_SIZE; \(arrLabel)_index++) {
                    \(self.stringHelpers.indent(self.createGuard()))
                        if (1 == \(arrLabel)_first) {
                            \(self.createComma())
                        }
                    \(self.stringHelpers.indent(value))
                        \(arrLabel)_first = 1;
                    }
                    \(self.createGuard())
                    len = gu_strlcat(descString, "}", bufferSize);
                    """
            default:
                return self.createDescription(forType: type, withLabel: label, andClassName: className)
        }
    }

    fileprivate func createIndexes(forLabel label: String, _ level: Int) -> String {
        return Array(0...level).map { 0 == $0 ? "[\(label)_index]" : "[\(label)_\($0)_index]" }.reduce(label, +)
    }

    fileprivate func createDescription(forType type: VariableTypes, withLabel label: String, andClassName className: String) -> String? {
        switch type {
            case .array:
                return self.createArrayDescription(forType: type, withLabel: label, andClassName: className)
            case .bool:
                return """
                    len = gu_strlcat(descString, "\(label)=", bufferSize);
                    \(self.createGuard())
                    len = gu_strlcat(descString, self->\(label) ? "true" : "false", bufferSize);
                    """
            case .char:
                return self.createSNPrintf("\(label)=%c", "self->\(label)")
            case .numeric(let numericType):
                return self.createSNPrintf(
                    "\(label)=%\(self.createFormat(forNumericType: numericType))",
                    "self->\(label)"
                )
            case .string:
                return self.createSNPrintf("\(label)=%s", "self->\(label)")
            default:
                return nil
        }
    }

    fileprivate func createValue(forType type: VariableTypes, withLabel label: String, andClassName className: String) -> String? {
        switch type {
            case .array:
                return self.createArrayDescription(forType: type, withLabel: label, andClassName: className)
            case .bool:
                return "len = gu_strlcat(descString, self->\(label) ? \"true\" : \"false\", bufferSize);"
            case .char:
                return self.createSNPrintf("%c", "self->\(label)")
            case .numeric(let numericType):
                return self.createSNPrintf(
                    "%\(self.createFormat(forNumericType: numericType))",
                    "self->\(label)"
                )
            case .string:
                return self.createSNPrintf("%s", "self->\(label)")
            default:
                return nil
        }
    }

    fileprivate func createSNPrintf(_ str: String, _ args: String? = nil) -> String {
        guard let args = args else {
            return "len += snprintf(descString + len, bufferSize - len, \"\(str)\");"
        }
        return "len += snprintf(descString + len, bufferSize - len, \"\(str)\", \(args));"
    }

    fileprivate func createFormat(forNumericType type: NumericTypes) -> String {
        switch type {
            case .double:
                return "lf"
            case .float:
                return "f"
            case .long(let subtype):
                return "l" + self.createFormat(forNumericType: subtype)
            case .signed:
                return "d"
            case .unsigned:
                return "u"
        }
    }

}
