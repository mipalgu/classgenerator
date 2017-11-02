/*
 * DefaultValuesCalculatorTests.swift 
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
@testable import classgenerator
import XCTest

//swiftlint:disable type_body_length
//swiftlint:disable file_length
public class DefaultValuesCalculatorTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (DefaultValuesCalculatorTests) -> () throws -> Void)] {
        return [
            ("test_calculatesDefaultValuesForPrimitiveTypes", test_calculatesDefaultValuesForPrimitiveTypes),
            ("test_calculatesDefaultValueForPointers", test_calculatesDefaultValueForPointers),
            ("test_calculatesDefaultValueForMultiplePointerTypes", test_calculatesDefaultValueForMultiplePointerTypes),
            (
                "test_calculatesDefaultValueForArrayWithIntegerLength",
                test_calculatesDefaultValueForArrayWithIntegerLength
            ),
            (
                "test_calculatesDefaultValueForMultiDimensionalArrayWithIntegerLength",
                test_calculatesDefaultValueForMultiDimensionalArrayWithIntegerLength
            ),
            ("test_calculatesDefaultValueForArrayWithMacroLength", test_calculatesDefaultValueForArrayWithMacroLength)
        ]
    }

    public var calculator: DefaultValuesCalculator!

    public override func setUp() {
        self.calculator = DefaultValuesCalculator()
    }

    public func test_calculatesDefaultValuesForPrimitiveTypes() {
        let types: [(VariableTypes, (String, String))] = [
            (.bool, ("true", "true")),
            (.char(.signed), ("0", "UnicodeScalar(UInt8.min)")),
            (.char(.unsigned), ("0", "UnicodeScalar(UInt8.min)")),
            (.numeric(.double), ("0.0", "0.0")),
            (.numeric(.float), ("0.0f", "0.0")),
            (.numeric(.signed), ("0", "0")),
            (.numeric(.unsigned), ("0", "0")),
            (.string("5"), ("\"\"", "\"\""))
        ]
        for (type, expected) in types {
            guard let result = self.calculator.calculateDefaultValues(forType: type) else {
                XCTFail("Unable to calculate default value of: \(type)")
                return
            }
            self.assertEqual(expected, result)
        }
    }

    public func test_calculatesDefaultValueForPointers() {
        let type: VariableTypes = .pointer(.bool)
        guard let result = self.calculator.calculateDefaultValues(forType: type) else {
            XCTFail("Unable to calculate default value of: \(type)")
            return
        }
        self.assertEqual(("NULL", "nil"), result)
    }

    public func test_calculatesDefaultValueForMultiplePointerTypes() {
        let type: VariableTypes = .pointer(.pointer(.pointer(.bool)))
        guard let result = self.calculator.calculateDefaultValues(forType: type) else {
            XCTFail("Unable to calculate default value of: \(type)")
            return
        }
        self.assertEqual(("NULL", "nil"), result)
    }

    public func test_calculatesDefaultValueForArrayWithIntegerLength() {
        let type: VariableTypes = .array(.numeric(.float), "3")
        guard let result = self.calculator.calculateDefaultValues(forType: type) else {
            XCTFail("Unable to calculate default value of: \(type)")
            return
        }
        self.assertEqual(("{0.0f, 0.0f, 0.0f}", "[0.0, 0.0, 0.0]"), result)
    }

    public func test_calculatesDefaultValueForMultiDimensionalArrayWithIntegerLength() {
        let type: VariableTypes = .array(.array(.array(.numeric(.float), "3"), "1"), "1")
        guard let result = self.calculator.calculateDefaultValues(forType: type) else {
            XCTFail("Unable to calculate default value of: \(type)")
            return
        }
        self.assertEqual(("{{{0.0f, 0.0f, 0.0f}}}", "[[[0.0, 0.0, 0.0]]]"), result)
    }

    public func test_calculatesDefaultValueForArrayWithMacroLength() {
        let type: VariableTypes = .array(.numeric(.float), "SOME_LENGTH")
        guard let result = self.calculator.calculateDefaultValues(forType: type) else {
            XCTFail("Unable to calculate default value of: \(type)")
            return
        }
        self.assertEqual(("{}", "[]"), result)
    }

    fileprivate func assertEqual<T: Equatable, U: Equatable>(_ lhs: (T, U), _ rhs: (T, U)) {
        XCTAssertEqual(lhs.0, rhs.0)
        XCTAssertEqual(lhs.1, rhs.1)
    }

}
