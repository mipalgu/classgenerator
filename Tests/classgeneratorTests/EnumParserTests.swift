/*
 * EnumParserTests.swift
 * classgeneratorTests
 *
 * Created by Callum McColl on 3/3/19.
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

public final class EnumParserTests: ClassGeneratorTestCase {
    
    public static var allTests: [(String, (EnumParserTests) -> () throws -> Void)] {
        return [
            ("test_canParseBasicCStyleEnum", test_canParseBasicCStyleEnum),
            ("test_canParseEnumWithTrailingComma", test_canParseEnumWithTrailingComma),
            ("test_canParseCStyleEnumWithNumericValues", test_canParseCStyleEnumWithNumericValues),
            ("test_cannotParseCStyleEnumWithoutATrailingSemicolon", test_cannotParseCStyleEnumWithoutATrailingSemicolon),
            ("test_cannotParseCStyleEnumWithANumericName", test_cannotParseCStyleEnumWithANumericName),
            ("test_canParseEnumWithMissingAssignments", test_canParseEnumWithMissingAssignments),
            ("test_canParseCStyleEnumWithInlineComments", test_canParseCStyleEnumWithInlineComments),
            ("test_canParseCStyleEnumWithMultilineComments", test_canParseCStyleEnumWithMultilineComments)
        ]
    }
    
    fileprivate var parser: EnumParser!
    
    public override func setUp() {
        self.parser = EnumParser()
    }
    
    public func test_canParseBasicCStyleEnum() {
        let str = """
            enum MyEnum {
                First,
                Second
            };
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 0, "Second": 1])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch ParsingErrors.parsingError(_, let message) {
            XCTFail("Unable to parse basic c style enum: \(message)")
        } catch {
            XCTFail("Unable to parse basic c style enum.")
        }
    }
    
    public func test_canParseEnumWithTrailingComma() {
        let str = """
            enum MyEnum {
                First,
                Second,
            };
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 0, "Second": 1])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch {
            XCTFail("Unable to parse basic c style enum.")
        }
    }
    
    public func test_canParseCStyleEnumWithNumericValues() {
        let str = """
            enum MyEnum {
                First = 1,
                Second = 2
            };
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 1, "Second": 2])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch {
            XCTFail("Unable to parse c style enum with numeric values on cases.")
        }
    }
    
    public func test_cannotParseCStyleEnumWithoutATrailingSemicolon() {
        let str = """
            enum MyEnum {
                First,
                Second
            }
            """
        do {
            _ = try self.parser.parseCStyleEnum(str)
        } catch {
            return
        }
        XCTFail("Successfully parsed malformed c style enum.")
    }
    
    public func test_cannotParseCStyleEnumWithANumericName() {
        let str = """
            enum 123 {
                First,
                Second
            };
            """
        do {
            _ = try self.parser.parseCStyleEnum(str)
        } catch {
            return
        }
        XCTFail("Successfully parsed malformed c style enum.")
    }
    
    public func test_canParseEnumWithMissingAssignments() {
        let str = """
            enum MyEnum {
                First = 1,
                Second = 4,
                Third,
                Fourth = 2,
                Fifth
            };
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 1, "Second": 4, "Third": 5, "Fourth": 2, "Fifth": 3])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch {
            XCTFail("Unable to parse c style enum with mixed assignments.")
        }
    }
    
    public func test_canParseCStyleEnumWithInlineComments() {
        let str = """
            enum MyEnum { // Block
                First, // The First Case
                Second, // The Second Case
                Third// The ThirdCase
            };
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 0, "Second": 1, "Third": 2])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch {
            XCTFail("Unable to parse c style enum with inline comments.")
        }
    }
    
    public func test_canParseCStyleEnumWithMultilineComments() {
        let str = """
            enum MyEnum /* Comment */ { /* Another Comment */
                First/* First Case */,
                Second, /* Second Case */
                Third
            }/* End */;
            """
        let expected = Enum(name: "MyEnum", cases: ["First": 0, "Second": 1, "Third": 2])
        do {
            let result = try self.parser.parseCStyleEnum(str)
            XCTAssertEqual(expected, result)
        } catch ParsingErrors.parsingError(_, let message) {
            XCTFail("Unable to parse c style enum with multiline comments: \(message)")
        } catch {
            XCTFail("Unable to parse c style enum with multiline comments.")
        }
    }
    
}
