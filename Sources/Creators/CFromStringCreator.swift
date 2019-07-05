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

import Data
import Helpers
import swift_helpers
import whiteboard_helpers

//swiftlint:disable:next type_body_length
public final class CFromStringCreator<ImplementationCreator: FromStringImplementationCreator> {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let implementationCreator: ImplementationCreator
    fileprivate let stringHelpers: StringHelpers

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        implementationCreator: ImplementationCreator,
        stringHelpers: StringHelpers = StringHelpers()
    ) {
        self.creatorHelpers = creatorHelpers
        self.implementationCreator = implementationCreator
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
        /*let head = self.createHead(forClassNamed: cls.name, forStrVariable: strLabel)
        let fillTokens = self.createFillTokens(forClassNamed: cls.name, withArrayVariables: cls.variables.filter {
            switch $0.type {
                case .array:
                    return true
                default:
                    return false
            }
        })
        let assignVarsSection = self.assignVars(cls.variables, forClassNamed: cls.name)
        let cleanup = "free(str_copy);\nreturn self;"
        let contents = head + "\n" + fillTokens + "\n" + assignVarsSection + "\n" + cleanup*/
        let contents = self.implementationCreator.createFromStringImplementation(
            forClass: cls,
            using: CFromStringImplementationDataSource(
                selfStr: "self",
                shouldReturnSelf: true,
                strLabel: "str",
                cast: { "((\($1))\($0))" },
                recurse: { (createVariable, structName, _, label, accessor) -> String in
                    let assign = structName + "_from_string(&\(createVariable ? label : "self->" + label), \(accessor));"
                    if false == createVariable {
                        return assign
                    }
                    return """
                        struct \(structName) \(label);
                        \(assign)
                        """
                },
                arrayGetter: { "self->" + $0 + "[" + $1 + "]" },
                arraySetter: { "self->" + $0 + "[" + $1 + "] = " + $2 + ";" },
                getter: { "self->" + $0 },
                setter: { "self->" + $0 + " = " + $1 + ";"}
            )
        )
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + self.stringHelpers.cIndent(contents) + "\n" + endDefinition
    }

}
