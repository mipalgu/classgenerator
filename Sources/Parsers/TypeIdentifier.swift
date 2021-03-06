/*
 * TypeIdentifier.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 06/08/2017.
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
import whiteboard_helpers

public final class TypeIdentifier {

    fileprivate let helpers: CreatorHelpers

    fileprivate let values: [String: VariableTypes] = [
        "bool": .bool,
        "char": .char(.signed),
        "signed char": .char(.signed),
        "unsigned char": .char(.unsigned),
        "signed": .numeric(.signed),
        "signed int": .numeric(.signed),
        "unsigned": .numeric(.unsigned),
        "unsigned int": .numeric(.unsigned),
        "uint8_t": .numeric(.unsigned),
        "uint16_t": .numeric(.unsigned),
        "uint32_t": .numeric(.unsigned),
        "uint64_t": .mixed(macOS: .numeric(.long(.long(.unsigned))), linux: .numeric(.long(.unsigned))),
        "int8_t": .numeric(.signed),
        "int16_t": .numeric(.signed),
        "int32_t": .numeric(.signed),
        "int64_t": .mixed(macOS: .numeric(.long(.long(.signed))), linux: .numeric(.long(.signed))),
        "int": .numeric(.signed),
        "uint": .numeric(.unsigned),
        "short": .numeric(.signed),
        "short int": .numeric(.signed),
        "signed short": .numeric(.signed),
        "signed short int": .numeric(.signed),
        "unsigned short": .numeric(.unsigned),
        "unsigned short int": .numeric(.unsigned),
        "long": .numeric(.long(.signed)),
        "long int": .numeric(.long(.signed)),
        "signed long": .numeric(.long(.signed)),
        "signed long int": .numeric(.long(.signed)),
        "unsigned long": .numeric(.long(.unsigned)),
        "unsigned long int": .numeric(.long(.unsigned)),
        "long long": .numeric(.long(.long(.signed))),
        "long long int": .numeric(.long(.long(.signed))),
        "signed long long": .numeric(.long(.long(.signed))),
        "signed long long int": .numeric(.long(.long(.signed))),
        "unsigned long long": .numeric(.long(.long(.unsigned))),
        "unsigned long long int": .numeric(.long(.long(.unsigned))),
        "long64_t": .numeric(.long(.long(.signed))),
        "float": .numeric(.float),
        "float_t": .numeric(.float),
        "double": .numeric(.double),
        "double_t": .numeric(.double),
        "long double": .numeric(.long(.double)),
        "double double": .numeric(.double)
    ]

    public init(helpers: CreatorHelpers = CreatorHelpers()) {
        self.helpers = helpers
    }

    public func identify(fromTypeSignature type: String, andArrayCounts arrCounts: [String], namespaces: [CNamespace]) -> VariableTypes {
        if nil != arrCounts.first {
            return self.identifyArray(fromType: type, andCounts: arrCounts, namespaces: namespaces)
        }
        if type.last == "*" {
            return self.identifyPointer(fromType: type, namespaces: namespaces)
        }
        let words = type.components(separatedBy:.whitespaces)
        if nil != words.first(where: { $0 == "enum" }) {
            return self.identifyEnum(fromType: type)
        }
        if nil != words.first(where: { $0 == "gen" }) {
            return self.identifyGen(fromType: type, namespaces: namespaces)
        }
        if "string" == type {
            return .string("0")
        }
        if "bit" == type {
            return .bit
        }
        return self.values[type] ?? .unknown
    }

    fileprivate func identifyGen(fromType type: String, namespaces: [CNamespace]) -> VariableTypes {
        let words = type.components(separatedBy:.whitespaces)
        guard
            let index = words.enumerated().first(where: { $1 == "gen" })?.0,
            let name = words.dropFirst(index + 1).first
        else {
            return .unknown
        }
        return .gen(
            name,
            self.helpers.createStructName(forClassNamed: name, namespaces: namespaces),
            self.helpers.createClassName(forClassNamed: name)
        )
    }

    fileprivate func identifyEnum(fromType type: String) -> VariableTypes {
        let words = type.components(separatedBy:.whitespaces)
        guard let (index, _) = words.enumerated().first(where: { $1 == "enum"}) else {
            return .unknown
        }
        if words.count <= index + 1 {
            return .unknown
        }
        return .enumerated(words[index + 1])
    }

    fileprivate func identifyPointer(fromType type: String, namespaces: [CNamespace]) -> VariableTypes {
        return .pointer(
            self.identify(
                fromTypeSignature: String(type.dropLast()).trimmingCharacters(in: .whitespaces),
                andArrayCounts: [],
                namespaces: namespaces
            )
        )
    }

    fileprivate func identifyArray(fromType type: String, andCounts arrCounts: [String], namespaces: [CNamespace]) -> VariableTypes {
        let vtype = self.identify(fromTypeSignature: type, andArrayCounts: Array(arrCounts.dropFirst()), namespaces: namespaces)
        switch vtype {
            case .string:
                return .string(arrCounts[0])
            default:
                break
        }
        return .array(
            self.identify(fromTypeSignature: type, andArrayCounts: Array(arrCounts.dropFirst()), namespaces: namespaces),
            arrCounts[0]
        )
    }

}
