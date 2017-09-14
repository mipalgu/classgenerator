/*
 * ClassGeneratorTestCase.swift 
 * classgeneratorTests
 *
 * Created by Callum McColl on 19/02/2017.
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

//swiftlint:disable file_length
//swiftlint:disable:next type_body_length
public class ClassGeneratorTestCase: XCTestCase {

    public override func setUp() {
        print("set up class generator")
    }

    public let oldClass = Class(
            name: "old",
            author: "Callum McColl",
            comment: "This is a test of all of the supported types.",
            variables: [
                Variable(
                    label: "str",
                    type: .string("6"),
                    cType: "string",
                    swiftType: "String",
                    defaultValue: "\"hello\"",
                    swiftDefaultValue: "\"hello\"",
                    comment: "A string."
                ),
                Variable(
                    label: "b",
                    type: .bool,
                    cType: "bool",
                    swiftType: "Bool",
                    defaultValue: "false",
                    swiftDefaultValue: "false",
                    comment: "A boolean."
                ),
                Variable(
                    label: "c",
                    type: .char(.signed),
                    cType: "char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "'c'",
                    swiftDefaultValue: "Character(\"c\")",
                    comment: "A char."
                ),
                Variable(
                    label: "sc",
                    type: .char(.signed),
                    cType: "signed char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "'c'",
                    swiftDefaultValue: "Character(\"c\")",
                    comment: "A signed char."
                ),
                Variable(
                    label: "uc",
                    type: .char(.unsigned),
                    cType: "unsigned char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "'c'",
                    swiftDefaultValue: "Character(\"c\")",
                    comment: "An unsigned char."
                ),
                Variable(
                    label: "i",
                    type: .numeric(.signed),
                    cType: "int",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int."
                ),
                Variable(
                    label: "si",
                    type: .numeric(.signed),
                    cType: "signed",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed."
                ),
                Variable(
                    label: "sii",
                    type: .numeric(.signed),
                    cType: "signed int",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed int."
                ),
                Variable(
                    label: "u",
                    type: .numeric(.unsigned),
                    cType: "unsigned",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned."
                ),
                Variable(
                    label: "ui",
                    type: .numeric(.unsigned),
                    cType: "unsigned int",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned int."
                ),
                Variable(
                    label: "u8",
                    type: .numeric(.unsigned),
                    cType: "uint8_t",
                    swiftType: "UInt8",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint8."
                ),
                Variable(
                    label: "u16",
                    type: .numeric(.unsigned),
                    cType: "uint16_t",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint16."
                ),
                Variable(
                    label: "u32",
                    type: .numeric(.unsigned),
                    cType: "uint32_t",
                    swiftType: "UInt32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint32."
                ),
                Variable(
                    label: "u64",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "uint64_t",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A uint64."
                ),
                Variable(
                    label: "i8",
                    type: .numeric(.signed),
                    cType: "int8_t",
                    swiftType: "Int8",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int8."
                ),
                Variable(
                    label: "i16",
                    type: .numeric(.signed),
                    cType: "int16_t",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int16."
                ),
                Variable(
                    label: "i32",
                    type: .numeric(.signed),
                    cType: "int32_t",
                    swiftType: "Int32",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int32."
                ),
                Variable(
                    label: "i64",
                    type: .numeric(.long(.long(.signed))),
                    cType: "int64_t",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An int64."
                ),
                Variable(
                    label: "s",
                    type: .numeric(.signed),
                    cType: "short",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A short."
                ),
                Variable(
                    label: "si_2",
                    type: .numeric(.signed),
                    cType: "short int",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A short int."
                ),
                Variable(
                    label: "ss",
                    type: .numeric(.signed),
                    cType: "signed short",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed short."
                ),
                Variable(
                    label: "ssi",
                    type: .numeric(.signed),
                    cType: "signed short int",
                    swiftType: "Int16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed short int."
                ),
                Variable(
                    label: "us",
                    type: .numeric(.unsigned),
                    cType: "unsigned short",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned short."
                ),
                Variable(
                    label: "usi",
                    type: .numeric(.unsigned),
                    cType: "unsigned short int",
                    swiftType: "UInt16",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned short int."
                ),
                Variable(
                    label: "l",
                    type: .numeric(.long(.signed)),
                    cType: "long",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long."
                ),
                Variable(
                    label: "li",
                    type: .numeric(.long(.signed)),
                    cType: "long int",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long int."
                ),
                Variable(
                    label: "sl",
                    type: .numeric(.long(.signed)),
                    cType: "signed long",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long."
                ),
                Variable(
                    label: "sli",
                    type: .numeric(.long(.signed)),
                    cType: "signed long int",
                    swiftType: "Int",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long int."
                ),
                Variable(
                    label: "ul",
                    type: .numeric(.long(.unsigned)),
                    cType: "unsigned long",
                    swiftType: "UInt",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long."
                ),
                Variable(
                    label: "uli",
                    type: .numeric(.long(.unsigned)),
                    cType: "unsigned long int",
                    swiftType: "UInt",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long int."
                ),
                Variable(
                    label: "ll",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long long",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long long."
                ),
                Variable(
                    label: "lli",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long long int",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long long int."
                ),
                Variable(
                    label: "sll",
                    type: .numeric(.long(.long(.signed))),
                    cType: "signed long long",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long long."
                ),
                Variable(
                    label: "slli",
                    type: .numeric(.long(.long(.signed))),
                    cType: "signed long long int",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A signed long long int."
                ),
                Variable(
                    label: "ull",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "unsigned long long",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "ulli",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "unsigned long long int",
                    swiftType: "UInt64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "An unsigned long long int."
                ),
                Variable(
                    label: "l64",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long64_t",
                    swiftType: "Int64",
                    defaultValue: "1",
                    swiftDefaultValue: "1",
                    comment: "A long64."
                ),
                Variable(
                    label: "f",
                    type: .numeric(.float),
                    cType: "float",
                    swiftType: "Float",
                    defaultValue: "1.0f",
                    swiftDefaultValue: "1.0",
                    comment: "A float."
                ),
                Variable(
                    label: "ft",
                    type: .numeric(.float),
                    cType: "float_t",
                    swiftType: "Float",
                    defaultValue: "1.0f",
                    swiftDefaultValue: "1.0",
                    comment: "A float_t."
                ),
                Variable(
                    label: "d",
                    type: .numeric(.double),
                    cType: "double",
                    swiftType: "Double",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double."
                ),
                Variable(
                    label: "dt",
                    type: .numeric(.double),
                    cType: "double_t",
                    swiftType: "Double",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double_t."
                ),
                Variable(
                    label: "ld",
                    type: .numeric(.long(.double)),
                    cType: "long double",
                    swiftType: "Float80",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A long double."
                ),
                Variable(
                    label: "dd",
                    type: .numeric(.double),
                    cType: "double double",
                    swiftType: "Float80",
                    defaultValue: "1.0",
                    swiftDefaultValue: "1.0",
                    comment: "A double double."
                ),
                Variable(
                    label: "str2",
                    type: .string("6"),
                    cType: "string",
                    swiftType: "String",
                    defaultValue: "\"\"",
                    swiftDefaultValue: "\"\"",
                    comment: "A string."
                ),
                Variable(
                    label: "b2",
                    type: .bool,
                    cType: "bool",
                    swiftType: "Bool",
                    defaultValue: "true",
                    swiftDefaultValue: "true",
                    comment: "A boolean."
                ),
                Variable(
                    label: "c2",
                    type: .char(.signed),
                    cType: "char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "0",
                    swiftDefaultValue: "UnicodeScalar(UInt8.min)",
                    comment: "A char."
                ),
                Variable(
                    label: "sc2",
                    type: .char(.signed),
                    cType: "signed char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "0",
                    swiftDefaultValue: "UnicodeScalar(UInt8.min)",
                    comment: "A signed char."
                ),
                Variable(
                    label: "uc2",
                    type: .char(.unsigned),
                    cType: "unsigned char",
                    swiftType: "UnicodeScalar",
                    defaultValue: "0",
                    swiftDefaultValue: "UnicodeScalar(UInt8.min)",
                    comment: "An unsigned char."
                ),
                Variable(
                    label: "i2",
                    type: .numeric(.signed),
                    cType: "int",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int."
                ),
                Variable(
                    label: "si2",
                    type: .numeric(.signed),
                    cType: "signed",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed."
                ),
                Variable(
                    label: "sii2",
                    type: .numeric(.signed),
                    cType: "signed int",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed int."
                ),
                Variable(
                    label: "u2",
                    type: .numeric(.unsigned),
                    cType: "unsigned",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned."
                ),
                Variable(
                    label: "ui2",
                    type: .numeric(.unsigned),
                    cType: "unsigned int",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned int."
                ),
                Variable(
                    label: "u82",
                    type: .numeric(.unsigned),
                    cType: "uint8_t",
                    swiftType: "UInt8",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint8."
                ),
                Variable(
                    label: "u162",
                    type: .numeric(.unsigned),
                    cType: "uint16_t",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint16."
                ),
                Variable(
                    label: "u322",
                    type: .numeric(.unsigned),
                    cType: "uint32_t",
                    swiftType: "UInt32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint32."
                ),
                Variable(
                    label: "u642",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "uint64_t",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A uint64."
                ),
                Variable(
                    label: "i82",
                    type: .numeric(.signed),
                    cType: "int8_t",
                    swiftType: "Int8",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int8."
                ),
                Variable(
                    label: "i162",
                    type: .numeric(.signed),
                    cType: "int16_t",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int16."
                ),
                Variable(
                    label: "i322",
                    type: .numeric(.signed),
                    cType: "int32_t",
                    swiftType: "Int32",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int32."
                ),
                Variable(
                    label: "i642",
                    type: .numeric(.long(.long(.signed))),
                    cType: "int64_t",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An int64."
                ),
                Variable(
                    label: "s2",
                    type: .numeric(.signed),
                    cType: "short",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A short."
                ),
                Variable(
                    label: "si_22",
                    type: .numeric(.signed),
                    cType: "short int",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A short int."
                ),
                Variable(
                    label: "ss2",
                    type: .numeric(.signed),
                    cType: "signed short",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed short."
                ),
                Variable(
                    label: "ssi2",
                    type: .numeric(.signed),
                    cType: "signed short int",
                    swiftType: "Int16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed short int."
                ),
                Variable(
                    label: "us2",
                    type: .numeric(.unsigned),
                    cType: "unsigned short",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned short."
                ),
                Variable(
                    label: "usi2",
                    type: .numeric(.unsigned),
                    cType: "unsigned short int",
                    swiftType: "UInt16",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned short int."
                ),
                Variable(
                    label: "l2",
                    type: .numeric(.long(.signed)),
                    cType: "long",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long."
                ),
                Variable(
                    label: "li2",
                    type: .numeric(.long(.signed)),
                    cType: "long int",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long int."
                ),
                Variable(
                    label: "sl2",
                    type: .numeric(.long(.signed)),
                    cType: "signed long",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long."
                ),
                Variable(
                    label: "sli2",
                    type: .numeric(.long(.signed)),
                    cType: "signed long int",
                    swiftType: "Int",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long int."
                ),
                Variable(
                    label: "ul2",
                    type: .numeric(.long(.unsigned)),
                    cType: "unsigned long",
                    swiftType: "UInt",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long."
                ),
                Variable(
                    label: "uli2",
                    type: .numeric(.long(.unsigned)),
                    cType: "unsigned long int",
                    swiftType: "UInt",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long int."
                ),
                Variable(
                    label: "ll2",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long long",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long long."
                ),
                Variable(
                    label: "lli2",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long long int",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long long int."
                ),
                Variable(
                    label: "sll2",
                    type: .numeric(.long(.long(.signed))),
                    cType: "signed long long",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long long."
                ),
                Variable(
                    label: "slli2",
                    type: .numeric(.long(.long(.signed))),
                    cType: "signed long long int",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A signed long long int."
                ),
                Variable(
                    label: "ull2",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "unsigned long long",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long long."
                ),
                Variable(
                    label: "ulli2",
                    type: .numeric(.long(.long(.unsigned))),
                    cType: "unsigned long long int",
                    swiftType: "UInt64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "An unsigned long long int."
                ),
                Variable(
                    label: "l642",
                    type: .numeric(.long(.long(.signed))),
                    cType: "long64_t",
                    swiftType: "Int64",
                    defaultValue: "0",
                    swiftDefaultValue: "0",
                    comment: "A long64."
                ),
                Variable(
                    label: "f2",
                    type: .numeric(.float),
                    cType: "float",
                    swiftType: "Float",
                    defaultValue: "0.0f",
                    swiftDefaultValue: "0.0",
                    comment: "A float."
                ),
                Variable(
                    label: "ft2",
                    type: .numeric(.float),
                    cType: "float_t",
                    swiftType: "Float",
                    defaultValue: "0.0f",
                    swiftDefaultValue: "0.0",
                    comment: "A float_t."
                ),
                Variable(
                    label: "d2",
                    type: .numeric(.double),
                    cType: "double",
                    swiftType: "Double",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double."
                ),
                Variable(
                    label: "dt2",
                    type: .numeric(.double),
                    cType: "double_t",
                    swiftType: "Double",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double_t."
                ),
                Variable(
                    label: "ld2",
                    type: .numeric(.long(.double)),
                    cType: "long double",
                    swiftType: "Float80",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A long double."
                ),
                Variable(
                    label: "dd2",
                    type: .numeric(.double),
                    cType: "double double",
                    swiftType: "Float80",
                    defaultValue: "0.0",
                    swiftDefaultValue: "0.0",
                    comment: "A double double."
                ),
                Variable(
                    label: "p",
                    type: .pointer(.numeric(.signed)),
                    cType: "int",
                    swiftType: "UnsafeMutablePointer<Int32>!",
                    defaultValue: "NULL",
                    swiftDefaultValue: "nil",
                    comment: "A pointer."
                ),
                Variable(
                    label: "strct",
                    type: .unknown,
                    cType: "struct somestruct",
                    swiftType: "somestruct",
                    defaultValue: "somestruct()",
                    swiftDefaultValue: "somestruct()",
                    comment: "A struct."
                ),
                Variable(
                    label: "array16",
                    type: .array(.numeric(.signed), "4"),
                    cType: "int16_t",
                    swiftType: "Int16",
                    defaultValue: "{1,2,3,4}",
                    swiftDefaultValue: "[1, 2, 3, 4]",
                    comment: "a comment about array16"
                ),
                Variable(
                    label: "bools",
                    type: .array(.bool, "3"),
                    cType: "bool",
                    swiftType: "Bool",
                    defaultValue: "{true, true, true}",
                    swiftDefaultValue: "[true, true, true]",
                    comment: "a comment about bools"
                )
            ],
            preC: nil,
            postC: nil,
            preCpp: nil,
            embeddedCpp: nil,
            postCpp: nil,
            preSwift: nil,
            embeddedSwift: nil,
            postSwift: nil
        )

        func createSectionsClass(_ name: String) -> Class {
            return Class(
                name: name,
                author: "Callum McColl",
                comment: "This is a global comment.",
                variables: [
                    Variable(
                        label: "c",
                        type: .numeric(.signed),
                        cType: "int",
                        swiftType: "Int32",
                        defaultValue: "2",
                        swiftDefaultValue: "2",
                        comment: "A counter."
                    )
                ],
                preC: "#include <stdint.h>",
                postC: "int f() {\n    return 1;\n}",
                preCpp: "#include <iostream>",
                embeddedCpp: "int g() {\n    return c() + 2;\n}",
                postCpp: "int h() {\n    return 3;\n}",
                preSwift: "import FSM",
                embeddedSwift: "var temp: String {\n    return \"c: \\(self.c)\"\n}",
                postSwift: "extension wb_sections: ExternalVariables {}"
            )
        }

        func replaceTokens(_ str: String, withDate date: Date = Date()) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let temp = str.replacingOccurrences(of: "%date%", with: formatter.string(from: date))
            formatter.dateFormat = "HH:mm"
            let temp2 = temp.replacingOccurrences(of: "%time%", with: formatter.string(from: date))
            formatter.dateFormat = "yyyy"
            let replaced = temp2.replacingOccurrences(of: "%year%", with: formatter.string(from: date))
            return replaced
        }

        func compareStrings(_ lhs: String, _ rhs: String) {
            if lhs == rhs {
                return
            }
            let llines = lhs.components(separatedBy: CharacterSet.newlines)
            let rlines = rhs.components(separatedBy: CharacterSet.newlines)
            guard let badLine = zip(llines, rlines).lazy.enumerated().filter({ $0.1.0 != $0.1.1 }).first else {
                XCTAssertEqual(lhs, rhs)
                return
            }
            XCTFail("\nline \(badLine.0):\n|" + badLine.1.0 + "| vs\n" + "|" + badLine.1.1 + "|")
        }

}
