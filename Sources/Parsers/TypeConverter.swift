/*
 * TypeConverter.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 04/08/2017.
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

public final class TypeConverter {

    fileprivate let values: [String: String] = [
        "signed": "Int32",
        "signed int": "Int32",
        "unsigned": "UInt32",
        "unsigned int": "UInt32",
        "uint8_t": "UInt8",
        "uint16_t": "UInt16",
        "uint32_t": "UInt32",
        "uint64_t": "UInt64",
        "int8_t": "Int8",
        "int16_t": "Int16",
        "int32_t": "Int32",
        "int64_t": "Int64",
        "int": "Int32",
        "uint": "UInt32",
        "short": "Int16",
        "short int": "Int16",
        "signed short": "Int16",
        "signed short int": "Int16",
        "unsigned short": "UInt16",
        "unsigned short int": "UInt16",
        "long": "Int",
        "long int": "Int",
        "signed long": "Int",
        "signed long int": "Int",
        "unsigned long": "UInt",
        "unsigned long int": "UInt",
        "long long": "Int64",
        "long long int": "Int64",
        "signed long long": "Int64",
        "signed long long int": "Int64",
        "unsigned long long": "UInt64",
        "unsigned long long int": "UInt64",
        "long64_t": "Int64",
        "float": "Float",
        "float_t": "Float",
        "double": "Double",
        "double_t": "Double",
        "long double": "Float80",
        "double double": "Float80"
    ]

    public init() {}

    func convert(fromType type: VariableTypes, withSignature signature: String) throws -> String {
        switch type {
        case .array(let subtype, _):
            return try self.convert(fromType: subtype, withSignature: signature)
        case .bit:
            return "Bool"
        case .bool:
            return "Bool"
        case .char:
            return "UnicodeScalar"
        case .enumerated(let name):
            return name
        case .gen(_, let structName, _):
            return structName
        case .numeric:
            //swiftlint:disable:next line_length
            guard let v = self.values[signature] ?? signature.components(separatedBy: CharacterSet.whitespaces).last else {
                throw ParsingErrors.parsingError(0, "Unable to parse type.")
            }
            return v
        case .string:
            return "String"
        case .pointer(let subtype):
            let words = String(signature.dropLast()).trimmingCharacters(in: .whitespaces)
                .components(separatedBy: CharacterSet.whitespaces)
            guard let last = words.last else {
                throw ParsingErrors.parsingError(0, "Unable to parse type.")
            }
            let newType = try self.convert(fromType: subtype, withSignature: last)
            return "UnsafeMutablePointer<\(newType)>!"
        case .unknown:
            let words = signature.trimmingCharacters(in: .whitespaces)
                .components(separatedBy: CharacterSet.whitespaces)
            guard let last = words.last else {
                throw ParsingErrors.parsingError(0, "Unable to parse type.")
            }
            return last
        }
    }

}
