/*
 * CPPStringFunctionsCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 25/09/2017.
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

public final class CPPStringFunctionsCreator {

    fileprivate let stringHelpers: StringHelpers

    public init(stringHelpers: StringHelpers = StringHelpers()) {
        self.stringHelpers = stringHelpers
    }

    public func createDescriptionFunction(
        forClassNamed className: String,
        andStructNamed structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let startDescription = self.createDescriptionDef()
        let cConversionDescription = self.createCConversionDescription(
            forClassNamed: className,
            withStructNamed: structName
        )
        let body = self.createStringFunctionBody(
            forClassNamed: className,
            andStructNamed: structName,
            withVariables: variables,
            andCImplementation: cConversionDescription,
            andIncludeLabels: true
        )
        return self.stringHelpers.indent(startDescription, 2) + "\n"
            + body + "\n"
            + self.stringHelpers.indent("}", 2)
    }

    public func createToStringFunction(
        forClassNamed className: String,
        andStructNamed structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let startDescription = self.createToStringDef()
        let cConversionToString = self.createCConversionToString(
            forClassNamed: className,
            withStructNamed: structName
        )
        let body = self.createStringFunctionBody(
            forClassNamed: className,
            andStructNamed: structName,
            withVariables: variables,
            andCImplementation: cConversionToString,
            andIncludeLabels: false
        )
        return self.stringHelpers.indent(startDescription, 2) + "\n"
            + body + "\n"
            + self.stringHelpers.indent("}", 2)
    }

    fileprivate func createStringFunctionBody(
        forClassNamed className: String,
        andStructNamed structName: String,
        withVariables variables: [Variable],
        andCImplementation cImplementation: String,
        andIncludeLabels includeLabels: Bool
    ) -> String {
        let ifCConversion = "#ifdef USE_\(structName.uppercased())_C_CONVERSION"
        let elseDef = "#else"
        let endifCConversion = "#endif /// USE_\(structName.uppercased())_C_CONVERSION"
        let cppImplementation = self.createCPPVariableStringSetters(
            forClassNamed: className,
            withVariables: variables,
            andIncludeLabels: includeLabels
        )
        return ifCConversion + "\n"
            + self.stringHelpers.indent(cImplementation, 3) + "\n"
            + elseDef + "\n"
            + self.stringHelpers.indent(cppImplementation, 3) + "\n"
            + endifCConversion
    }

    fileprivate func createDescriptionDef() -> String {
        return "std::string description() {"
    }

    fileprivate func createToStringDef() -> String {
        return "std::string to_string() {"
    }

    fileprivate func createCConversionDescription(
        forClassNamed className: String,
        withStructNamed structName: String
    ) -> String {
        return """
            char buffer[\(className.uppercased())_DESC_BUFFER_SIZE];
            \(structName)_description(this, buffer, sizeof(buffer));
            std::string descr = buffer;
            return descr;
            """
    }

    fileprivate func createCConversionToString(
        forClassNamed className: String,
        withStructNamed structName: String
    ) -> String {
        return """
            char buffer[\(className.uppercased())_TO_STRING_BUFFER_SIZE];
            \(structName)_to_string(this, buffer, sizeof(buffer));
            std::string toString = buffer;
            return toString;
            """
    }

    fileprivate func createCPPVariableStringSetters(
        forClassNamed className: String,
        withVariables variables: [Variable],
        andIncludeLabels includeLabels: Bool
    ) -> String {
        let ssdef = "std::ostringstream ss;"
        let concat = self.createConcatString(
            forClassNamed: className,
            withVariables: variables,
            andIncludeLabels: includeLabels
        )
        let returnStatement = "return ss.str();"
        return ssdef + "\n" + concat + "\n" + returnStatement
    }

    fileprivate func createConcatString(
        forClassNamed className: String,
        withVariables variables: [Variable],
        andIncludeLabels includeLabels: Bool
    ) -> String {
        return variables.flatMap {
            self.createConcatString(
                forClassNamed: className,
                forType: $0.type,
                withLabel: $0.label,
                andIncludeLabel: includeLabels
            )
        }.combine("") { $0 + "\nss << \", \";\n" + $1 }
    }

    fileprivate func createConcatString(
        forClassNamed className: String,
        forType type: VariableTypes,
        withLabel label: String,
        andIncludeLabel includeLabel: Bool
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                switch subtype {
                    case .array:
                        return nil
                    default:
                        break
                }
                let createGetter: (String) -> String = { "this->" + $0 + "(i)" }
                guard let value = self.createStringValue(
                    forClassNamed: className,
                    forType: subtype,
                    withLabel: label,
                    includeLabel: includeLabel,
                    appendingTo: "ss << (\(label)_first ? \"\" : \",\") << ",
                    createGetter
                ) else {
                    return nil
                }
                return """
                    bool \(label)_first = true;
                    ss << \(true == includeLabel ? "\"\(label)={\";" : "\"{\";")
                    for (int i = 0; i < \(className.uppercased())_\(label.uppercased())_ARRAY_SIZE; i++) {
                    \(self.stringHelpers.indent(value))
                        \(label)_first = false;
                    }
                    ss << "}";
                    """
            default:
                let pre = "ss << \(true == includeLabel ? "\"\(label)=\" << " : "")"
                return self.createStringValue(
                    forClassNamed: className,
                    forType: type,
                    withLabel: label,
                    includeLabel: includeLabel,
                    appendingTo: pre
                )
        }
    }

    fileprivate func createStringValue(
        forClassNamed className: String,
        forType type: VariableTypes,
        withLabel label: String,
        includeLabel: Bool,
        appendingTo pre: String,
        _ createGetter: (String) -> String = { "this->" + $0 + "()" }
    ) -> String? {
        let getter = createGetter(label)
        switch type {
            case .array:
                return self.createConcatString(
                    forClassNamed: className,
                    forType: type,
                    withLabel: label,
                    andIncludeLabel: includeLabel
                )
            case .bool:
                return "\(pre)(\(getter) ? \"true\" : \"false\");"
            case .char:
                return """
                    if (\(getter) == 0) {
                        \(pre)"";
                    } else {
                        \(pre)\(getter);
                    }
                    """
            case .numeric(.signed):
                return "\(pre)signed(\(getter));"
            case .numeric(.unsigned):
                return "\(pre)unsigned(\(getter));"
            case .string:
                return """
                    if (0 == strncmp("", \(getter), 1)) {
                        \(pre)"";
                    } else {
                        \(pre)\(getter);
                    }
                    """
            case .unknown:
                return nil
            default:
                return "\(pre)\(getter);"
        }
    }

}
