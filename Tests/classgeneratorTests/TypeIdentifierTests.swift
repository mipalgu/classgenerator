/*
 * TypeIdentifierTests.swift 
 * classgeneratorTests 
 *
 * Created by Callum McColl on 01/11/2017.
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
@testable import Data
@testable import Parsers
@testable import classgenerator
import XCTest

//swiftlint:disable type_body_length
//swiftlint:disable file_length
public class TypeIdentifierTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (TypeIdentifierTests) -> () throws -> Void)] {
        return [
            ("test_identifiesPrimitiveTypes", test_identifiesPrimitiveTypes),
            ("test_identifiesSignedIntegerPointerWithSpace", test_identifiesSignedIntegerPointerWithSpace),
            ("test_identifiesSignedIntegerPointerWithoutSpace", test_identifiesSignedIntegerPointerWithoutSpace),
            ("test_identifiesAnArrayType", test_identifiesAnArrayType),
            ("test_identifiesMultiDimensionalArray", test_identifiesMultiDimensionalArray),
            ("test_doesNotIdentifyUnknownTypes", test_doesNotIdentifyUnknownTypes),
            ("test_identifiesEnumsAsSignedIntegers", test_identifiesEnumsAsSignedIntegers)
            ("test_identifiesBit", test_identifiesBit)
        ]
    }

    public var identifier: TypeIdentifier!

    public override func setUp() {
        self.identifier = TypeIdentifier()
    }

    //swiftlint:disable:next function_body_length
    public func test_identifiesPrimitiveTypes() {
        var types: [String: VariableTypes] = [
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
            "int8_t": .numeric(.signed),
            "int16_t": .numeric(.signed),
            "int32_t": .numeric(.signed),
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
        #if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
        types["uint64_t"] = .numeric(.long(.long(.unsigned)))
        types["int64_t"] = .numeric(.long(.long(.signed)))
        #else
        types["int64_t"] = .numeric(.long(.signed))
        types["uint64_t"] = .numeric(.long(.unsigned))
        #endif
        for (type, expected) in types {
            XCTAssertEqual(
                expected,
                self.identifier.identify(fromTypeSignature: type, andArrayCounts: [])
            )
        }
    }

    public func test_identifiesSignedIntegerPointerWithSpace() {
        let type = "int *"
        XCTAssertEqual(
            .pointer(.numeric(.signed)),
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: [])
        )
    }

    public func test_identifiesSignedIntegerPointerWithoutSpace() {
        let type = "int*"
        XCTAssertEqual(
            .pointer(.numeric(.signed)),
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: [])
        )
    }

    public func test_identifiesAnArrayType() {
        let type = "int"
        let length = "SOME_LENGTH_MACRO"
        XCTAssertEqual(
            .array(.numeric(.signed), length),
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: [length])
        )
    }

    public func test_identifiesMultiDimensionalArray() {
        let type = "int"
        let lengths = ["L1", "L2", "L3"]
        XCTAssertEqual(
            .array(.array(.array(.numeric(.signed), lengths[2]), lengths[1]), lengths[0]),
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: lengths)
        )
    }

    public func test_doesNotIdentifyUnknownTypes() {
        let type = "some unknown type"
        XCTAssertEqual(
            .unknown,
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: [])
        )
    }

    public func test_identifiesEnumsAsSignedIntegers() {
        let type = "enum myEnum"
        XCTAssertEqual(
            .numeric(.signed),
            self.identifier.identify(fromTypeSignature: type, andArrayCounts: [])
        )
    }

    public func test_identifiesBit() {
        let type = "bit"
        XCTAssertEqual(.bit, self.identifier.identify(fromTypeSignature: type, andArrayCounts: []))
    }

}
