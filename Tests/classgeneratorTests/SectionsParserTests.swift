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
            ("test_sectionsInAnyOrder", test_sectionsInAnyOrder),
            ("test_canParseSimpleMixin", test_canParseSimpleMixin),
            ("test_canParseSimpleMixinWithVariable", test_canParseSimpleMixinWithVariable),
            ("test_canParseMultipleMixins", test_canParseMultipleMixins)
        ]
    }

    public var parser: SectionsParser<WarningsContainerRef, MockedFileReader>!

    fileprivate func createParser(mixins: [String: String] = [:]) -> SectionsParser<WarningsContainerRef, MockedFileReader> {
        let reader = MockedFileReader { mixins[$0] }
        return SectionsParser(container: WarningsContainerRef(), reader: reader)
    }

    public override func setUp() {
        self.parser = self.createParser()
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

    func test_canParseSimpleMixin() {
        let simpleContents = """
            @mixin
            -c
            prec
            """
        let parser = self.createParser(mixins: ["simple.mixin": simpleContents])
        let contents = """
            -author Callum McColl

            @include "simple.mixin"

            -properties
            int i // An integer

            -comment
            A comment
            """
        let expected = Sections(
            author: "-author Callum McColl",
            preC: "prec",
            variables: "int i // An integer",
            comments: "A comment"
        )
        guard let result = parser.parseSections(fromContents: contents) else {
            XCTFail("\(parser.lastError ?? "Unable to parse sections from"):\n\n\(contents)\n")
            parser.errors.forEach { XCTFail($0) }
            return
        }
        XCTAssertEqual(expected, result)
    }

    func test_canParseSimpleMixinWithVariable() {
        let simpleContents = """
            @mixin
            -c
            $myVar
            """
        let parser = self.createParser(mixins: ["simple.mixin": simpleContents])
        let contents = """
            -author Callum McColl

            @include "simple.mixin"(myVar: parsedVar)

            -properties
            int i // An integer

            -comment
            A comment
            """
        let expected = Sections(
            author: "-author Callum McColl",
            preC: "parsedVar",
            variables: "int i // An integer",
            comments: "A comment"
        )
        guard let result = parser.parseSections(fromContents: contents) else {
            XCTFail("\(parser.lastError ?? "Unable to parse sections from"):\n\n\(contents)\n")
            return
        }
        XCTAssertEqual(expected, result)
    }

    func test_canParseMultipleMixins() {
        let firstContents = """
            @mixin
            -c
            1
            """
        let secondContents = """
            @mixin
            -c
            2
            """
        let parser = self.createParser(mixins: ["first.mixin": firstContents, "second.mixin": secondContents])
        let contents = """
            -author Callum McColl

            @include "first.mixin"

            -properties
            int i // An integer

            -comment
            A comment

            @include "second.mixin"
            """
        let expected = Sections(
            author: "-author Callum McColl",
            preC: "1\n2",
            variables: "int i // An integer",
            comments: "A comment"
        )
        guard let result = parser.parseSections(fromContents: contents) else {
            XCTFail("\(parser.lastError ?? "Unable to parse sections from"):\n\n\(contents)\n")
            return
        }
        XCTAssertEqual(expected, result)
    }

    public func test_allMixinFields() {
        let preC = "preC"
        let embeddedC = "embeddedC"
        let postC = "postC"
        let topCFile = "topCFile"
        let preCFile = "preCFile"
        let postCFile = "postCFile"
        let preCpp = "preCpp"
        let embeddedCpp = "embeddedCpp"
        let postCpp = "postCpp"
        let preSwift = "preSwift"
        let embeddedSwift = "embeddedSwift"
        let postSwift = "postSwift"
        let sharedContent = """
            -c
            \(preC)

            $c
            \(embeddedC)

            +c
            \(postC)

            ^c
            \(topCFile)

            %c
            \(preCFile)

            #c
            \(postCFile)

            -c++
            \(preCpp)

            %c++
            \(embeddedCpp)

            +c++
            \(postCpp)

            -swift
            \(preSwift)

            %swift
            \(embeddedSwift)

            +swift
            \(postSwift)
            """
        let mixinContent = """
            @mixin
            
            -author Someone

            \(sharedContent)

            -properties
            int i // An integer.

            -comment
            Second comment.
            """
        let parser = self.createParser(mixins: ["test.mixin": mixinContent])
        let contents = """
            -author Callum McColl

            @include "test.mixin"

            -properties
            bool b // A boolean.

            -comment
            First comment.

            \(sharedContent)
            """
        guard let result = parser.parseSections(fromContents: contents) else {
            XCTFail("\(parser.lastError ?? "Unable to parse sections from"):\n\n\(contents)\n")
            return
        }
        let expected = Sections(
            author: "-author Callum McColl\n-author Someone",
            preC: preC + "\n" + preC,
            variables: "int i // An integer.\nbool b // A boolean.",
            comments: "First comment.",
            embeddedC: embeddedC + "\n" + embeddedC,
            topCFile: topCFile + "\n" + topCFile,
            preCFile: preCFile + "\n" + preCFile,
            postCFile: postCFile + "\n" + postCFile,
            postC: postC + "\n" + postC,
            preCpp: preCpp + "\n" + preCpp,
            embeddedCpp: embeddedCpp + "\n" + embeddedCpp,
            postCpp: postCpp + "\n" + postCpp,
            preSwift: preSwift + "\n" + preSwift,
            embeddedSwift: embeddedSwift + "\n" + embeddedSwift,
            postSwift: postSwift + "\n" + postSwift
        )
        XCTAssertEqual(expected, result)
    }


}
