/*
 * DemoTests.swift 
 * classgeneratorTests 
 *
 * Created by Callum McColl on 15/09/2017.
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

public class DemoTests: ClassGeneratorTestCase {

    public static var allTests: [(String, (DemoTests) -> () throws -> Void)] {
        return [
            ("test_demo", test_demo),
            ("test_demoWithCConversion", test_demoWithCConversion)
        ]
    }

    public var startingDirectory: String!

    public var filemanager: FileManager!

    public var generator: ClassGenerator<
        ClassParser<
            WarningsContainerRef,
            WarningsContainerRef,
            WarningsContainerRef
        >,
        CommandLinePrinter<
            StderrOutputStream,
            StdoutOutputStream,
            StdoutOutputStream
        >
    >!

    public override func setUp() {
        self.filemanager = FileManager.default
        self.startingDirectory = self.filemanager.currentDirectoryPath
        let container = WarningsContainerRef()
        self.generator = ClassGenerator(
            parser: ClassParser(
                container: container,
                sectionsParser: SectionsParser(container: container),
                variablesParser: VariablesTableParser(container: container)
            ),
            printer: CommandLinePrinter(
                errorStream: StderrOutputStream(),
                messageStream: StdoutOutputStream(),
                warningStream: StdoutOutputStream()
            )
        )
        _ = try? self.filemanager.removeItem(atPath: "demo/Sources/bridge/wb_demo.h")
        _ = try? self.filemanager.removeItem(atPath: "demo/Sources/bridge/wb_demo.c")
        _ = try? self.filemanager.removeItem(atPath: "demo/Sources/bridge/Demo.h")
        _ = try? self.filemanager.removeItem(atPath: "demo/Sources/demo/Demo.swift")
    }

    public override func tearDown() {
        self.filemanager.changeCurrentDirectoryPath(self.startingDirectory)
    }

    public func test_demo() {
        guard true == self.filemanager.changeCurrentDirectoryPath("demo") else {
            XCTFail("Unable to change into demo directory.")
            return
        }
        self.generator.run([
            "classgenerator",
            "--c-header",
            "./Sources/bridge",
            "--swift-file",
            "./Sources/demo",
            "./demo.gen"
        ])
        let p = Process()
        p.currentDirectoryPath = self.filemanager.currentDirectoryPath
        p.launchPath = "/usr/bin/env"
        p.arguments = [
            "swift",
            "test",
            "-Xcc",
            "-DWHITEBOARD_POSTER_STRING_CONVERSION=1",
            "-Xcc",
            "-I\(self.filemanager.currentDirectoryPath)/Sources/bridge"
            ]
        p.launch()
        p.waitUntilExit()
        XCTAssertEqual(EXIT_SUCCESS, p.terminationStatus, "Demo tests failed")
    }

    public func test_demoWithCConversion() {
        guard true == self.filemanager.changeCurrentDirectoryPath("demo") else {
            XCTFail("Unable to change into demo directory.")
            return
        }
        self.generator.run([
            "classgenerator",
            "--c-header",
            "./Sources/bridge",
            "--swift-file",
            "./Sources/demo",
            "./demo.gen"
        ])
        let p = Process()
        p.currentDirectoryPath = self.filemanager.currentDirectoryPath
        p.launchPath = "/usr/bin/env"
        p.arguments = [
            "swift",
            "test",
            "-Xcc",
            "-DWHITEBOARD_POSTER_STRING_CONVERSION=1",
            "-Xcc",
            "-DUSE_WB_DEMO_C_CONVERSION=1",
            "-Xcc",
            "-I\(self.filemanager.currentDirectoryPath)/Sources/bridge"
        ]
        p.launch()
        p.waitUntilExit()
        XCTAssertEqual(EXIT_SUCCESS, p.terminationStatus, "Demo tests failed")
    }

}
