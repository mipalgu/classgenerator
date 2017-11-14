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
            ("test_isBackwardsCompatible", test_isBackwardsCompatible),
            ("test_parsesSections", test_parsesSections),
            ("test_warnsAboutUnderscores", test_warnsAboutUnderscores)
        ]
    }

    public var parser: Parser<WarningsContainerRef, WarningsContainerRef, WarningsContainerRef, WarningsContainerRef>!

    public override func setUp() {
        let container = WarningsContainerRef()
        self.parser = Parser(
            container: container,
            parser: ClassParser(
                container: container,
                sectionsParser: SectionsParser(container: container),
                variablesParser: VariablesTableParser(container: container)
            )
        )
    }

    public func test_doesntParseNonExistingFile() {
        XCTAssertNil(self.parser.parse(file: URL(fileURLWithPath: "this/does/not/exist")))
    }

    //swiftlint:disable function_body_length
    public func test_isBackwardsCompatible() {
        guard let result = self.parser.parse(file: URL(fileURLWithPath: "gens/old.txt")) else {
            XCTFail("Unable to parse old.txt: \(self.parser.lastError ?? "")")
            return
        }
        let zipped = zip(super.oldClass.variables, result.variables)
        for (l, r) in zipped where l != r {
            XCTAssertEqual(l, r, "result variable: \(r) is not equal to expected variable: \(l)")
            return
        }
        XCTAssertEqual(super.oldClass, result, "result: \(result) is not equal to expected: \(super.oldClass)")
    }

    public func test_parsesSections() {
        guard let result1 = self.parser.parse(file: URL(fileURLWithPath: "gens/sections.gen")) else {
            XCTFail(self.parser.lastError ?? "Unable to parse sections.gen")
            return
        }
        guard let result2 = self.parser.parse(file: URL(fileURLWithPath: "gens/sections2.gen")) else {
            XCTFail(self.parser.lastError ?? "Unable to parse sections2.gen")
            return
        }
        guard let result3 = self.parser.parse(file: URL(fileURLWithPath: "gens/sections3.gen")) else {
            XCTFail(self.parser.lastError ?? "Unable to parse sections3.gen")
            return
        }
        XCTAssertEqual(super.createSectionsClass("sections"), result1)
        XCTAssertEqual(super.createSectionsClass("sections2"), result2)
        XCTAssertEqual(super.createSectionsClass("sections3"), result3)
    }

    public func test_warnsAboutUnderscores() {
        _ = self.parser.parse(file: URL(fileURLWithPath: "gens/underscore_S.gen"))
        XCTAssertTrue(self.parser.warnings.count > 0)
    }

}
