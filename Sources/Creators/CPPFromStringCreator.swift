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

import Data
import Helpers
import swift_helpers
import whiteboard_helpers

public final class CPPFromStringCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers
    fileprivate let implementationCreator: FromStringImplementationCreator

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        stringHelpers: StringHelpers = StringHelpers(),
        implementationCreator: FromStringImplementationCreator = FromStringImplementationCreator()
    ) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
        self.implementationCreator = implementationCreator
    }

    public func createFromStringFunction(
        forClass cls: Class,
        forClassNamed className: String,
        withStructNamed structName: String,
        withVariables variables: [Variable],
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let cConversionDef = WhiteboardHelpers().cConversionDefine(forStructNamed: structName)
        let containsSupportedTypes = nil != variables.first { self.creatorHelpers.isSupportedStringType($0.type) }
        let def = "void from_string(const std::string &t_str) {"
        let nodef = "void from_string(const std::string &t_str) {"
        let ifDef = "#ifdef \(cConversionDef)"
        let elseDef = "#else"
        let endifDef = "#endif /// \(cConversionDef)"
        let cImplementation = structName + "_from_string(this, t_str.c_str());"
        let begin = "char * str_cstr = const_cast<char *>(t_str.c_str());"
        let cppImplementation = self.implementationCreator.createFromStringImplementation(
            forClass: cls,
            using: CFromStringImplementationDataSource(
                selfStr: "this",
                shouldReturnSelf: false,
                strLabel: "str_cstr",
                cast: { "static_cast<\($1)>(\($0))" },
                recurse: { (createVariable, structName, className, label, accessor) -> String in
                    return """
                        \(className) \(label)_temp = \(className)();
                        \(label)_temp.from_string(\(accessor));
                        \(createVariable ? "struct \(structName) \(label) = \(label)_temp;" : "this->set_\(label)(\(label)_temp);")
                        """
                },
                arrayGetter: { "this->" + $0 + "(" + $1 + ")"},
                arraySetter: { "this->set_" + $0 + "(" + $2 + ", " + $1 + ");"},
                stringGetter: { structName + "::" + $0 },
                getter: { "this->" + $0 + "()" },
                setter: { "this->set_" + $0 + "(" + $1 + ");"}
            ),
            namespaces: namespaces,
            squashDefines: squashDefines
        )
        let endef = "}"
        return ifDef + "\n" + def + "\n"
            + self.stringHelpers.cIndent(cImplementation) + "\n"
            + elseDef + "\n"
            + (containsSupportedTypes ? def : nodef) + "\n"
            + self.stringHelpers.cIndent(begin) + "\n"
            + self.stringHelpers.cIndent(cppImplementation) + "\n"
            + endifDef + "\n"
            + endef
    }

}
