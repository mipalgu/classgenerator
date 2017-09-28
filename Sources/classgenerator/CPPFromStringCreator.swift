/*
 * CPPFromStringCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 27/09/2017.
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

public final class CPPFromStringCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    public func createFromStringFunction(
        forClassNamed className: String,
        withStructNamed structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let def = "void from_string(const std::string &str) {"
        let ifDef = "#ifdef USE_WB_OLD_C_CONVERSION"
        let elseDef = "#else"
        let endifDef = "#endif"
        let cImplementation = structName + "_from_string(this, str);"
        let cppImplementation = self.createCPPImplementation(
            forClassNamed: className,
            withStructNamed: structName,
            withVariables: variables
        )
        let endef = "}"
        return self.stringHelpers.indent(def, 2) + "\n"
            + ifDef + "\n"
            + self.stringHelpers.indent(cImplementation, 3) + "\n"
            + elseDef + "\n"
            + self.stringHelpers.indent(cppImplementation, 3) + "\n"
            + endifDef + "\n"
            + self.stringHelpers.indent(endef, 2)
    }

    fileprivate func createCPPImplementation(
        forClassNamed className: String,
        withStructNamed structName: String,
        withVariables variables: [Variable]
    ) -> String {
        let varDef = "char var[255];"
        let conversionList = variables.flatMap {
            self.createCPPImplementation(
                forClassNamed: className,
                withStructNamed: structName,
                forVariable: $0
            )
        }.combine("") { $0 + "\n" + $1 }
        return varDef + "\n" + conversionList
    }

    fileprivate func createCPPImplementation(
        forClassNamed className: String,
        withStructNamed structName: String,
        forVariable variable: Variable
    ) -> String? {
        let index = "\(variable.label)_index"
        let setup = """
            unsigned long \(index) = str.find("\(variable.label)");
            if (\(index) != std::string::npos) {
                memset(&var[0], 0, sizeof(var));
                if (sscanf(str.substr(\(index), str.length()).c_str(), "\(variable.label) = %[^,]", var) == 1) {
            """
        guard let setter = self.calculateSetter(
            forVariable: variable.label,
            withType: variable.type,
            andCType: variable.cType
        ) else {
            return nil
        }
        let finish = """
                }
            }
            """
        return setup + "\n" + self.stringHelpers.indent(setter, 2) + "\n" + finish
    }

    fileprivate func calculateSetter(
        forVariable label: String,
        withType type: VariableTypes,
        andCType cType: String
    ) -> String? {
        let getValue = "std::string value = std::string(var);"
        switch type {
            case .array:
                return nil
            case .bool:
                return getValue + "\n"
                    + "set_\(label)(value.compare(\"true\") == 0 || value.compare(\"1\") == 0 ? true : false);"
            case .char:
                return getValue + "\n" + "set_\(label)((\(cType)) (atoi(value.c_str())));"
            case .numeric(let numericType):
                let conversionFunction = self.calculateConversionFunction(forNumericType: numericType)
                return getValue + "\n" + "set_\(label)((\(cType)) (\(conversionFunction)(value.c_str())));"
            case .string(let length):
                return getValue + "\n" + "gu_strlcpy((char *) this->\(label)(), value.c_str(), \(length));"
            case .pointer:
                let typeExtras = self.creatorHelpers.calculateSignatureExtras(forType: type)
                //swiftlint:disable:next line_length
                let cast = "const \(cType)\(typeExtras) \(label)_cast = (\(cType)\(typeExtras)) (atol(value.c_str()));"
                return getValue + "\n" + cast + "\n" + "set_\(label)(\(label)_cast);"
            case .unknown:
                return nil
        }
    }

    fileprivate func calculateConversionFunction(forNumericType type: NumericTypes) -> String {
        switch type {
            case .float, .double:
                return "atof"
            case .signed, .unsigned:
                return "atoi"
            case .long(let subtype):
                switch subtype {
                    case .float, .double:
                        return "atof"
                    case .long:
                        return "atoll"
                    default:
                        return "atol"
                }
        }
    }

}
