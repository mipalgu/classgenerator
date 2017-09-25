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
            + endifCConversion + "\n"

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
            \(structName)_description(this, buffer, sizeof(buffer));
            std::string descr = buffer;
            return descr;
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
        andIncludeLabels includeLabel: Bool
    ) -> String {
        return variables.flatMap {
            switch $0.type {
                case .array(let subtype, _):
                    switch subtype {
                        case .array:
                            return nil
                        default:
                            break
                    }
                    return """
                        bool \($0.label)_first = true;
                        ss << \(true == includeLabel ? "\"\($0.label)={\";" : "{;")
                        for (int i = 0; i < \(className.uppercased())_\($0.label.uppercased())_ARRAY_SIZE; i++) {
                            ss << (\($0.label)_first ? "" : ",") << \($0.label)(i);
                            \($0.label)_first = false;
                        }
                        ss << "}";
                        """
                default:
                    return "ss << \(true == includeLabel ? "\"\($0.label)=\" << " : "")\($0.label)();"
            }
        }.combine("") { $0 + "\nss << \", \";\n" + $1 }
    }

}
