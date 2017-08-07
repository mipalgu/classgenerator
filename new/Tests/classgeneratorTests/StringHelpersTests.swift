/*
 * StringHelpersTests.swift 
 * classgeneratorTests 
 *
 * Created by Callum McColl on 07/08/2017.
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

public class StringHelpersTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (StringHelpersTests) -> () throws -> Void)] {
        return [
            ("test_isLowerCaseSucceeds", test_isLowerCaseSucceeds),
            ("test_isLowerCaseFailsWithCapitalLetter", test_isLowerCaseFailsWithCapitalLetter),
            ("test_isUpperCaseSucceeds", test_isUpperCaseSucceeds),
            ("test_isUpperCaseFailsWithLowerCaseLetter", test_isUpperCaseFailsWithLowerCaseLetter),
            ("test_isLetterSucceeds", test_isLetterSucceeds),
            ("test_isLetterFailsWithNumber", test_isLetterFailsWithNumber),
            ("test_toLowerSucceeds", test_toLowerSucceeds),
            ("test_toLowerDoesNothingWithNumbersOrLowerLetters", test_toLowerDoesNothingWithNumbersOrLowerLetters),
            ("test_toUpperSucceeds", test_toUpperSucceeds),
            ("test_toUpperDoesNothingWithNumbersOrUpperLetters", test_toUpperDoesNothingWithNumbersOrUpperLetters),
            ("test_toCamelCaseWorksWithASentence", test_toCamelCaseWorksWithASentence),
            ("test_toCamelCaseWorksWithSnakeCase", test_toCamelCaseWorksWithSnakeCase),
            ("test_toCamelCaseDoesNotModifyCamelCase", test_toCamelCaseDoesNotModifyCamelCase),
            ("test_toSnakeCaseWorksWithASentence", test_toSnakeCaseWorksWithASentence),
            ("test_toSnakeCaseDoesNotModifySnakeCase", test_toSnakeCaseDoesNotModifySnakeCase),
            ("test_toSnakeCaseWorksWithCamelCase", test_toSnakeCaseWorksWithCamelCase)
        ]
    }

    var helpers: StringHelpers!

    public override func setUp() {
        self.helpers = StringHelpers()
    }

    public func test_isLowerCaseSucceeds() {
        let a: Character = "a"
        XCTAssertTrue(self.helpers.isLowerCase(a))
    }

    public func test_isLowerCaseFailsWithCapitalLetter() {
        let a: Character = "A"
        XCTAssertFalse(self.helpers.isLowerCase(a))
    }

    public func test_isUpperCaseSucceeds() {
        let a: Character = "A"
        XCTAssertTrue(self.helpers.isUpperCase(a))
    }

    public func test_isUpperCaseFailsWithLowerCaseLetter() {
        let a: Character = "a"
        XCTAssertFalse(self.helpers.isUpperCase(a))
    }

    public func test_isLetterSucceeds() {
        let a: Character = "a"
        let b: Character = "B"
        XCTAssertTrue(self.helpers.isLetter(a))
        XCTAssertTrue(self.helpers.isLetter(b))
    }

    public func test_isLetterFailsWithNumber() {
        let num: Character = "2"
        XCTAssertFalse(self.helpers.isLetter(num))
    }

    public func test_toLowerSucceeds() {
        let a: Character = "A"
        XCTAssertEqual("a", self.helpers.toLower(a))
    }

    public func test_toLowerDoesNothingWithNumbersOrLowerLetters() {
        let a: Character = "a"
        let num: Character = "2"
        XCTAssertEqual("a", self.helpers.toLower(a))
        XCTAssertEqual("2", self.helpers.toLower(num))
    }

    public func test_toUpperSucceeds() {
        let a: Character = "a"
        XCTAssertEqual("A", self.helpers.toUpper(a))
    }

    public func test_toUpperDoesNothingWithNumbersOrUpperLetters() {
        let a: Character = "A"
        let num: Character = "2"
        XCTAssertEqual("A", self.helpers.toUpper(a))
        XCTAssertEqual("2", self.helpers.toUpper(num))
    }

    public func test_toCamelCaseWorksWithASentence() {
        let sentence = "This is a sentence"
        XCTAssertEqual("ThisIsASentence", self.helpers.toCamelCase(sentence))
    }

    public func test_toCamelCaseWorksWithSnakeCase() {
        let snake = "this_is_1a_test123"
        XCTAssertEqual("ThisIs1aTest123", self.helpers.toCamelCase(snake))
    }

    public func test_toCamelCaseDoesNotModifyCamelCase() {
        let camelCase = "ThisIsATest"
        XCTAssertEqual("ThisIsATest", self.helpers.toCamelCase(camelCase))
    }

    public func test_toSnakeCaseWorksWithASentence() {
        let sentence = "This is 1a sentence"
        XCTAssertEqual("this_is_1a_sentence", self.helpers.toSnakeCase(sentence))
    }

    public func test_toSnakeCaseDoesNotModifySnakeCase() {
        let camelCase = "this_is_1a_test"
        XCTAssertEqual("this_is_1a_test", self.helpers.toSnakeCase(camelCase))
    }

    public func test_toSnakeCaseWorksWithCamelCase() {
        let snake = "ThisIs1ATest"
        XCTAssertEqual("this_is_1a_test", self.helpers.toSnakeCase(snake))
    }

}
