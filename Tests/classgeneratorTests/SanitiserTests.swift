/*
 * SanitiserTests.swift 
 * classgeneratorTests 
 *
 * Created by Callum McColl on 02/11/2017.
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
@testable import Parsers
@testable import classgenerator
import XCTest

//swiftlint:disable type_body_length
//swiftlint:disable file_length
public class SanitiserTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (SanitiserTests) -> () throws -> Void)] {
        return [
            ("test_sanitisesCharIntoStringLiteralForSignedChar", test_sanitisesCharIntoStringLiteralForSignedChar),
            ("test_sanitisesCharIntoStringLiteralForUnSignedChar", test_sanitisesCharIntoStringLiteralForUnSignedChar),
            (
                "test_sanitisesCharIntegerLiteralIntoUnicodeScalarForSignedChar",
                test_sanitisesCharIntegerLiteralIntoUnicodeScalarForSignedChar
            ),
            (
                "test_sanitisesCharIntegerLiteralIntoUnicodeScalarForUnSignedChar",
                test_sanitisesCharIntegerLiteralIntoUnicodeScalarForUnSignedChar
            ),
            ("test_sanitisesFloatsWithFLiteral", test_sanitisesFloatsWithFLiteral),
            ("test_doesNotModifyFloatWithoutFLiteral", test_doesNotModifyFloatWithoutFLiteral),
            ("test_sanitisesLongFloats", test_sanitisesLongFloats),
            ("test_sanitisesPointersWithNullValues", test_sanitisesPointersWithNullValues),
            ("test_sanitisesArrayLiterals", test_sanitisesArrayLiterals),
            ("test_sanitisesMultiDimensionalArrayLiterals", test_sanitisesMultiDimensionalArrayLiterals)
        ]
    }

    public var sanitiser: Sanitiser!

    public override func setUp() {
        self.sanitiser = Sanitiser()
    }

    public func test_sanitisesCharIntoStringLiteralForSignedChar() {
        let value = "'c'"
        XCTAssertEqual("\"c\"", self.sanitiser.sanitise(value: value, forType: .char(.signed)))
    }

    public func test_sanitisesCharIntoStringLiteralForUnSignedChar() {
        let value = "'c'"
        XCTAssertEqual("\"c\"", self.sanitiser.sanitise(value: value, forType: .char(.unsigned)))
    }

    public func test_sanitisesCharIntegerLiteralIntoUnicodeScalarForSignedChar() {
        let value = "50"
        XCTAssertEqual("UnicodeScalar(50)", self.sanitiser.sanitise(value: value, forType: .char(.signed)))
    }

    public func test_sanitisesCharIntegerLiteralIntoUnicodeScalarForUnSignedChar() {
        let value = "50"
        XCTAssertEqual("UnicodeScalar(50)", self.sanitiser.sanitise(value: value, forType: .char(.unsigned)))
    }

    public func test_sanitisesFloatsWithFLiteral() {
        let value = "0.1f"
        XCTAssertEqual("0.1", self.sanitiser.sanitise(value: value, forType: .numeric(.float)))
    }

    public func test_doesNotModifyFloatWithoutFLiteral() {
        let value = "0.1"
        XCTAssertEqual("0.1", self.sanitiser.sanitise(value: value, forType: .numeric(.float)))
    }

    public func test_sanitisesLongFloats() {
        let value = "0.1f"
        XCTAssertEqual("0.1", self.sanitiser.sanitise(value: value, forType: .numeric(.long(.long(.long(.float))))))
    }

    public func test_sanitisesPointersWithNullValues() {
        let value = "NULL"
        XCTAssertEqual("nil", self.sanitiser.sanitise(value: value, forType: .pointer(.bool)))
    }

    public func test_sanitisesArrayLiterals() {
        let value = "{1, 2, 3, 4}"
        XCTAssertEqual("[1, 2, 3, 4]", self.sanitiser.sanitise(value: value, forType: .array(.numeric(.signed), "4")))
    }

    public func test_sanitisesMultiDimensionalArrayLiterals() {
        let value = "{{1, 2}, {3, 4}}"
        XCTAssertEqual(
            "[[1, 2], [3, 4]]",
            self.sanitiser.sanitise(value: value, forType: .array(.array(.numeric(.signed), "2"), "2"))
        )
        let value2 = "{{{1, 2}, {3, 4}}, {{5, 6}, {7, 8}}}"
        XCTAssertEqual(
            "[[[1, 2], [3, 4]], [[5, 6], [7, 8]]]",
            self.sanitiser.sanitise(value: value2, forType: .array(.array(.array(.numeric(.signed), "2"), "2"), "2"))
        )
    }

}
