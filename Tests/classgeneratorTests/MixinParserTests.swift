/*
 * MixinParserTests.swift 
 * classgeneratorTests 
 *
 * Created by Callum McColl on 09/08/2019.
 * Copyright © 2019 Callum McColl. All rights reserved.
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

@testable import Data
@testable import Parsers
import XCTest

public final class MixinParserTests: ClassGeneratorTestCase {
    
    public static var allTests: [(String, (MixinParserTests) -> () throws -> Void)] {
        return [
            ("test_canParseSimpleCall", test_canParseSimpleCall),
            ("test_canParseCallWithNoVariables", test_canParseCallWithNoVariables),
            ("test_canParseCallWithVariables", test_canParseCallWithVariables),
            ("test_canParseEmptyDeclaration", test_canParseEmptyDeclaration),
            ("test_canParseDeclarationWithNoVariables", test_canParseDeclarationWithNoVariables),
            ("test_canParseDeclarationWithVariables", test_canParseDeclarationWithVariables),
            ("test_canParseDeclarationWithDefaultValues", test_canParseDeclarationWithDefaultValues)
        ]
    }
    
    fileprivate var parser: MixinParser!
    
    public override func setUp() {
        self.parser = MixinParser()
    }

    public func test_canParseSimpleCall() {
        let line = "@include \"simple.mixer\""
        guard let (filePath, variables) = self.parser.parseCall(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        let (expectedFilePath, expectedVariables) = ("simple.mixer", [String: String]())
        XCTAssertEqual(expectedFilePath, filePath)
        XCTAssertEqual(expectedVariables, variables)
    }

    public func test_canParseCallWithNoVariables() {
        let line = "@include \"simple.mixer\"()"
        guard let (filePath, variables) = self.parser.parseCall(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        let (expectedFilePath, expectedVariables) = ("simple.mixer", [String: String]())
        XCTAssertEqual(expectedFilePath, filePath)
        XCTAssertEqual(expectedVariables, variables)
    }

    public func test_canParseCallWithVariables() {
        let line = "@include \"simple.mixer\"(firstVar: 1, secondVar: \"2\", thirdVar:3)"
        guard let (filePath, variables) = self.parser.parseCall(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        let (expectedFilePath, expectedVariables) = ("simple.mixer", ["firstVar": "1", "secondVar": "\"2\"", "thirdVar": "3"])
        XCTAssertEqual(expectedFilePath, filePath)
        XCTAssertEqual(expectedVariables, variables)
    }

    public func test_canParseEmptyDeclaration() {
        let line = "@mixin"
        let expected: [String: String?] = [:]
        guard let variables = self.parser.parseDeclaration(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        XCTAssertEqual(expected, variables)
    }

    public func test_canParseDeclarationWithNoVariables() {
        let line = "@mixin()"
        let expected: [String: String?] = [:]
        guard let variables = self.parser.parseDeclaration(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        XCTAssertEqual(expected, variables)
    }

    public func test_canParseDeclarationWithVariables() {
        let line = "@mixin(firstVar, secondVar, thirdVar)"
        let expected: [String: String?] = ["firstVar": .none, "secondVar": .none, "thirdVar": .none]
        guard let variables = self.parser.parseDeclaration(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        XCTAssertEqual(expected, variables)
    }

    public func test_canParseDeclarationWithDefaultValues() {
        let line = "@mixin(firstVar = 1, secondVar, thirdVar = \"3\")"
        let expected: [String: String?] = ["firstVar": "1", "secondVar": .none, "thirdVar": "\"3\""]
        guard let variables = self.parser.parseDeclaration(line: line) else {
            XCTFail("Unable to parse \(line)")
            return
        }
        XCTAssertEqual(expected, variables)
    }

}
