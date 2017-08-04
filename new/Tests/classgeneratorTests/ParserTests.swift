/*
 * ParserTests.swift 
 * classgeneratorTests 
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
@testable import classgenerator
import XCTest

//swiftlint:disable type_body_length
//swiftlint:disable file_length
public class ParserTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (ParserTests) -> () throws -> Void)] {
        return [
            ("test_doesntParseNonExistingFile", test_doesntParseNonExistingFile),
            ("test_isBackwardsCompatible", test_isBackwardsCompatible)
        ]
    }

    public var parser: Parser!

    public override func setUp() {
        self.parser = Parser()
    }

    public func test_doesntParseNonExistingFile() {
        XCTAssertNil(self.parser.parse(file: URL(fileURLWithPath: "this/does/not/exist")))
    }

    //swiftlint:disable function_body_length
    public func test_isBackwardsCompatible() {
        let expected = Class(
            name: "old",
            preamble: nil,
            variables: [
                Variable(
                    label: "str",
                    type: "string",
                    swiftType: "String",
                    defaultValue: "\"hello\"",
                    swiftDefaultValue: "\"hello\"",
                    comment: "A string."
                ),
                Variable(
                    label: "b",
                    type: "bool",
                    swiftType: "Bool",
                    defaultValue: "false",
                    swiftDefaultValue: "false",
                    comment: "A boolean."
                ),
                Variable(
                    label: "c",
                    type: "char",
                    swiftType: "String",
                    defaultValue: "'c'",
                    swiftDefaultValue: "\"c\"",
                    comment: "A char."
                ),
                Variable(
                    label: "sc",
                    type: "signed char",
                    swiftType: "String",
                    defaultValue: "'c'",
                    swiftDefaultValue: "\"c\"",
                    comment: "A signed char."
                ),
                Variable(
                    label: "uc",
                    type: "unsigned char",
                    swiftType: "String",
                    defaultValue: "'c'",
                    swiftDefaultValue: "\"c\"",
                    comment: "An unsigned char."
                ),
                Variable(
                    label: "i",
                    type: "int",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int."
                ),
                Variable(
                    label: "si",
                    type: "signed",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed."
                ),
                Variable(
                    label: "sii",
                    type: "signed int",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed int."
                ),
                Variable(
                    label: "u",
                    type: "unsigned",
                    swiftType: "UInt",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned."
                ),
                Variable(
                    label: "ui",
                    type: "unsigned int",
                    swiftType: "UInt",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned int"
                ),
                Variable(
                    label: "ui8",
                    type: "uint8_t",
                    swiftType: "UInt8",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint8."
                ),
                Variable(
                    label: "ui16",
                    type: "uint16_t",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint16"
                ),
                Variable(
                    label: "ui32",
                    type: "uint32_t",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint32."
                ),
                Variable(
                    label: "ui64",
                    type: "uint64_t",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint64."
                ),
                Variable(
                    label: "i8",
                    type: "int8_t",
                    swiftType: "Int8",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int8."
                ),
                Variable(
                    label: "i16",
                    type: "int16_t",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A int16."
                ),
                Variable(
                    label: "i32",
                    type: "int32_t",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A int32."
                ),
                Variable(
                    label: "i64",
                    type: "int64_t",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A int64."
                ),
                Variable(
                    label: "s",
                    type: "short",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A short."
                ),
                Variable(
                    label: "si",
                    type: "short int",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A short int."
                ),
                Variable(
                    label: "ss",
                    type: "signed short",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed short."
                ),
                Variable(
                    label: "ssi",
                    type: "signed short int",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed short int."
                ),
                Variable(
                    label: "us",
                    type: "unsigned short",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned short."
                ),
                Variable(
                    label: "usi",
                    type: "unsigned short int",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned short int."
                ),
                Variable(
                    label: "l",
                    type: "long",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long."
                ),
                Variable(
                    label: "li",
                    type: "long int",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long int."
                ),
                Variable(
                    label: "sl",
                    type: "signed long",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long."
                ),
                Variable(
                    label: "sli",
                    type: "signed long int",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long int."
                ),
                Variable(
                    label: "ul",
                    type: "unsigned long",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long."
                ),
                Variable(
                    label: "uli",
                    type: "unsigned long int",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long int"
                ),
                Variable(
                    label: "ll",
                    type: "long long",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "lli",
                    type: "long long int",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long long int."
                ),
                Variable(
                    label: "sll",
                    type: "signed long long",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long long."
                ),
                Variable(
                    label: "slli",
                    type: "signed long long int",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long long int."
                ),
                Variable(
                    label: "ull",
                    type: "unsigned long long",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "ulli",
                    type: "unsigned long long int",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long long int."
                ),
                Variable(
                    label: "l64",
                    type: "long64_t",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long64."
                ),
                Variable(
                    label: "f",
                    type: "float",
                    swiftType: "Float",
                    defaultValue: "1.0f",
                    swiftDefaultValue: "1.0",
                    comment: "A float."
                ),
                Variable(
                    label: "ft",
                    type: "float_t",
                    swiftType: "Float",
                    defaultValue: "1.0f",
                    swiftDefaultValue: "1.0",
                    comment: "A float_t."
                ),
                Variable(
                    label: "d",
                    type: "double",
                    swiftType: "Double",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double."
                ),
                Variable(
                    label: "dt",
                    type: "double_t",
                    swiftType: "Double",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double_t."
                ),
                Variable(
                    label: "ld",
                    type: "long double",
                    swiftType: "Float80",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A long double."
                ),
                Variable(
                    label: "dd",
                    type: "double double",
                    swiftType: "Float80",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double double."
                ),
                Variable(
                    label: "str",
                    type: "string",
                    swiftType: "String",
                    defaultValue: "\"\"",
                    swiftDefaultValue: "\"\"",
                    comment: "A string."
                ),
                Variable(
                    label: "b",
                    type: "bool",
                    swiftType: "Bool",
                    defaultValue: "true",
                    swiftDefaultValue: "true",
                    comment: "A boolean."
                ),
                Variable(
                    label: "c",
                    type: "char",
                    swiftType: "String",
                    defaultValue: "0",
                    swiftDefaultValue: "String(Character(UnicodeScalar(UInt8.min)))",
                    comment: "A char."
                ),
                Variable(
                    label: "sc",
                    type: "signed char",
                    swiftType: "String",
                    defaultValue: "0",
                    swiftDefaultValue: "String(Character(UnicodeScalar(UInt8.min)))",
                    comment: "A signed char"
                ),
                Variable(
                    label: "uc",
                    type: "unsigned char",
                    swiftType: "String",
                    defaultValue: "0",
                    swiftDefaultValue: "String(Character(UnicodeScalar(UInt8.min)))",
                    comment: "An unsigned char."
                ),
                Variable(
                    label: "i",
                    type: "int",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int."
                ),
                Variable(
                    label: "si",
                    type: "signed",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed."
                ),
                Variable(
                    label: "sii",
                    type: "signed int",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed int."
                ),
                Variable(
                    label: "u",
                    type: "unsigned",
                    swiftType: "UInt",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned."
                ),
                Variable(
                    label: "ui",
                    type: "unsigned int",
                    swiftType: "UInt",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned int"
                ),
                Variable(
                    label: "ui8",
                    type: "uint8_t",
                    swiftType: "UInt8",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint8."
                ),
                Variable(
                    label: "ui16",
                    type: "uint16_t",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint16"
                ),
                Variable(
                    label: "ui32",
                    type: "uint32_t",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint32."
                ),
                Variable(
                    label: "ui64",
                    type: "uint64_t",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint64."
                ),
                Variable(
                    label: "i8",
                    type: "int8_t",
                    swiftType: "Int8",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int8."
                ),
                Variable(
                    label: "i16",
                    type: "int16_t",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A int16."
                ),
                Variable(
                    label: "i32",
                    type: "int32_t",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A int32."
                ),
                Variable(
                    label: "i64",
                    type: "int64_t",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A int64."
                ),
                Variable(
                    label: "s",
                    type: "short",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A short."
                ),
                Variable(
                    label: "si",
                    type: "short int",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A short int."
                ),
                Variable(
                    label: "ss",
                    type: "signed short",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed short."
                ),
                Variable(
                    label: "ssi",
                    type: "signed short int",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed short int."
                ),
                Variable(
                    label: "us",
                    type: "unsigned short",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned short."
                ),
                Variable(
                    label: "usi",
                    type: "unsigned short int",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned short int."
                ),
                Variable(
                    label: "l",
                    type: "long",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long."
                ),
                Variable(
                    label: "li",
                    type: "long int",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long int."
                ),
                Variable(
                    label: "sl",
                    type: "signed long",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long."
                ),
                Variable(
                    label: "sli",
                    type: "signed long int",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long int."
                ),
                Variable(
                    label: "ul",
                    type: "unsigned long",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long."
                ),
                Variable(
                    label: "uli",
                    type: "unsigned long int",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long int"
                ),
                Variable(
                    label: "ll",
                    type: "long long",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "lli",
                    type: "long long int",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long long int."
                ),
                Variable(
                    label: "sll",
                    type: "signed long long",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long long."
                ),
                Variable(
                    label: "slli",
                    type: "signed long long int",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long long int."
                ),
                Variable(
                    label: "ull",
                    type: "unsigned long long",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "ulli",
                    type: "unsigned long long int",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long long int."
                ),
                Variable(
                    label: "l64",
                    type: "long64_t",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long64."
                ),
                Variable(
                    label: "f",
                    type: "float",
                    swiftType: "Float",
                    defaultValue: "0.0f",
                    swiftDefaultValue: "0.0",
                    comment: "A float."
                ),
                Variable(
                    label: "ft",
                    type: "float_t",
                    swiftType: "Float",
                    defaultValue: "0.0f",
                    swiftDefaultValue: "0.0",
                    comment: "A float_t."
                ),
                Variable(
                    label: "d",
                    type: "double",
                    swiftType: "Double",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double."
                ),
                Variable(
                    label: "dt",
                    type: "double_t",
                    swiftType: "Double",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double_t."
                ),
                Variable(
                    label: "ld",
                    type: "long double",
                    swiftType: "Float80",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A long double."
                ),
                Variable(
                    label: "dd",
                    type: "double double",
                    swiftType: "Float80",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double double."
                ),
                Variable(
                    label: "p",
                    type: "int *",
                    swiftType: "UnsafeMutablePointer<Int>",
                    defaultValue: "NULL",
                    swiftDefaultValue: "NULL",
                    comment: "A pointer."
                ),
                Variable(
                    label: "strct",
                    type: "somestruct",
                    swiftType: "somestruct",
                    defaultValue: "somestruct()",
                    swiftDefaultValue: "somestruct()",
                    comment: "A struct."
                )
            ],
            cExtras: nil,
            cppExtras: nil,
            swiftExtras: nil
        )
        XCTAssertEqual(expected, self.parser.parse(file: URL(fileURLWithPath: "gens/old.txt")))
    }

}
