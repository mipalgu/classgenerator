/*
 * SectionsParserTests.swift 
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
@testable import Data
@testable import Containers
@testable import Parsers
@testable import classgenerator
import XCTest

public class SectionsParserTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (SectionsParserTests) -> () throws -> Void)] {
        return [
            ("test_sectionsInAnyOrder", test_sectionsInAnyOrder)
        ]
    }

    public var parser: SectionsParser<WarningsContainerRef>!

    public override func setUp() {
        self.parser = SectionsParser(container: WarningsContainerRef())
    }

    public func test_sectionsInAnyOrder() {
        let sections = [
            "-author Callum McColl",
            "-properties\nint count = 2 // A simple counter.",
            "-comment\nsome comments.",
            "-c\nsome prepended c code",
            "+c\nsome appended c code",
            "-c++\nsome prepended c++ code",
            "%c++\nsome embedded c++ code",
            "+c++\nsome appended c++ code",
            "-swift\nsome prepended swift code",
            "%swift\nsome embedded swift code",
            "+swift\nsome appended swift code"
        ]
        let expected = Sections(
            author: "-author Callum McColl",
            preC: "some prepended c code",
            variables: "int count = 2 // A simple counter.",
            comments: "some comments.",
            postC: "some appended c code",
            preCpp: "some prepended c++ code",
            embeddedCpp: "some embedded c++ code",
            postCpp: "some appended c++ code",
            preSwift: "some prepended swift code",
            embeddedSwift: "some embedded swift code",
            postSwift: "some appended swift code"
        )
        for i in 0..<sections.count {
            var str: String = ""
            for j in 0..<sections.count {
                str += "\n\n" + sections[(j + i) % sections.count]
            }
            let contents = str.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let result = self.parser.parseSections(fromContents: contents) else {
                XCTFail("\(self.parser.lastError ?? "Unable to parse sections from"):\n\n\(contents)\n")
                return
            }
            XCTAssertEqual(expected, result)
        }
    }
}
