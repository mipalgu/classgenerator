/*
 * ClassGenerator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 08/09/2017.
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

public final class ClassGenerator<Parser: ClassParserType, P: Printer> {

    fileprivate let argumentsParser: ClassGeneratorParser
    fileprivate let parser: Parser
    fileprivate let fileHelpers: FileHelpers
    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let cHeaderCreator: CHeaderCreator
    fileprivate let cFileCreator: CFileCreator
    fileprivate let cppHeaderCreator: CPPHeaderCreator
    fileprivate let swiftFileCreator: SwiftFileCreator
    fileprivate let printer: P

    public init(
        argumentsParser: ClassGeneratorParser = ClassGeneratorParser(),
        parser: Parser,
        fileHelpers: FileHelpers = FileHelpers(),
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        cHeaderCreator: CHeaderCreator = CHeaderCreator(),
        cFileCreator: CFileCreator = CFileCreator(),
        cppHeaderCreator: CPPHeaderCreator = CPPHeaderCreator(),
        swiftFileCreator: SwiftFileCreator = SwiftFileCreator(),
        printer: P
    ) {
        self.argumentsParser = argumentsParser
        self.parser = parser
        self.fileHelpers = fileHelpers
        self.creatorHelpers = creatorHelpers
        self.cHeaderCreator = cHeaderCreator
        self.cFileCreator = cFileCreator
        self.cppHeaderCreator = cppHeaderCreator
        self.swiftFileCreator = swiftFileCreator
        self.printer = printer
    }

    public func run(_ args: [String]) {
        let args = self.cleanArgs(args)
        let task: Task
        do {
            task = try self.argumentsParser.parse(words: args)
        } catch (let e) {
            switch e {
                case ClassGeneratorErrors.pathNotFound:
                    self.handleError("Path not found")
                case ClassGeneratorErrors.unknownFlag(let flag):
                    self.handleError("Unknown Flag: \(flag)")
                default:
                    self.handleError("Unknown Error")
            }
        }
        self.handleTask(task)
    }

    fileprivate func handleTask(_ task: Task) {
        if task.printHelpText {
            self.printer.message(str: "\n" + self.argumentsParser.helpText + "\n")
            if nil == task.path {
                return
            }
        }
        guard let path = task.path else {
            self.printer.message(str: "\n" + self.argumentsParser.helpText + "\n")
            self.handleError("Path not found")
        }
        let url = URL(fileURLWithPath: path)
        let genfile = url.lastPathComponent
        if "" == genfile {
            self.handleError("Path not found")
        }
        guard let contents = self.fileHelpers.read(url) else {
            self.handleError("Unable to open file: \(url.path)")
        }
        guard let cls = self.parser.parse(contents, withName: genfile) else {
            self.handleError(self.parser.lastError ?? "Unable to parse class")
        }
        self.parser.warnings.forEach(self.handleWarning)
        let className = self.creatorHelpers.createClassName(forClassNamed: cls.name)
        let structName = self.creatorHelpers.createStructName(forClassNamed: cls.name)
        self.generateFiles(
            fromClass: cls,
            cHeaderPath: self.create(task.cHeaderOutputPath, structName + ".h"),
            cFilePath: self.create(task.cFileOutputPath ?? task.cHeaderOutputPath, structName + ".c"),
            cppHeaderPath: self.create(task.cppHeaderOutputPath ?? task.cHeaderOutputPath, className + ".h"),
            swiftFilePath: self.create(task.swiftFileOutputPath ?? task.cHeaderOutputPath, className + ".swift"),
            className: className,
            structName: structName,
            generatedFrom: genfile,
            generateCppWrapper: task.generateCppWrapper,
            generateSwiftWrapper: task.generateSwiftWrapper
        )
    }

    fileprivate func create(_ path: String?, _ fileName: String) -> URL {
        guard let path = path else {
            return URL(fileURLWithPath: fileName)
        }
        if true == self.fileHelpers.directoryExists(path) {
            let url = URL(fileURLWithPath: path, isDirectory: true)
            return url.appendingPathComponent(fileName, isDirectory: false)
        }
        return URL(fileURLWithPath: path, isDirectory: false)
    }

    //swiftlint:disable:next function_parameter_count
    fileprivate func generateFiles(
        fromClass cls: Class,
        cHeaderPath: URL,
        cFilePath: URL,
        cppHeaderPath: URL,
        swiftFilePath: URL,
        className: String,
        structName: String,
        generatedFrom genfile: String,
        generateCppWrapper: Bool,
        generateSwiftWrapper: Bool
    ) {
        guard true == self.generate(cHeaderPath.path, {
            self.cHeaderCreator.createCHeader(
                forClass: cls,
                forFileNamed: cHeaderPath.lastPathComponent,
                withStructName: structName,
                generatedFrom: genfile
            )
        }) else {
            self.handleError(self.cHeaderCreator.lastError ?? "Unable to create C Header at path: \(cHeaderPath.path)")
        }
        guard true == self.generate(cFilePath.path, {
            self.cFileCreator.createCFile(
                forClass: cls,
                forFileNamed: cFilePath.lastPathComponent,
                withStructName: structName,
                generatedFrom: genfile
            )
        }) else {
            self.handleError(self.cFileCreator.lastError ?? "Unable to create C File")
        }
        if true == generateCppWrapper {
            guard true == self.generate(cppHeaderPath.path, {
                self.cppHeaderCreator.createCPPHeader(
                    forClass: cls,
                    forFileNamed: cppHeaderPath.lastPathComponent,
                    withClassName: className,
                    withStructName: structName,
                    generatedFrom: genfile
                )
            }) else {
                self.handleError(self.cppHeaderCreator.lastError ?? "Unable to create C++ Header")
            }
        }
        if true == generateSwiftWrapper {
            guard true == self.generate(swiftFilePath.path, {
                self.swiftFileCreator.createSwiftFile(
                    forClass: cls,
                    forFileNamed: swiftFilePath.lastPathComponent,
                    withStructName: structName,
                    generatedFrom: genfile
                )
            }) else {
                self.handleError(self.swiftFileCreator.lastError ?? "Unable to create Swift file.")
            }
        }
    }

    fileprivate func generate(_ file: String, _ generateContent: () -> String?) -> Bool {
        guard let content = generateContent() else {
            return false
        }
        return self.fileHelpers.createFile(atPath: URL(fileURLWithPath: file), withContents: content)
    }

    fileprivate func cleanArgs(_ args: [String]) -> [String] {
        return args[1 ..< args.count].flatMap { (str: String) -> [String] in
            let cs = Array(str)
            if cs.count < 2 || cs.first != "-" {
                return [str]
            }
            if cs[1] == "-" {
                return [str]
            }
            return cs.flatMap { $0 == "-" ? nil : "-\($0)" }
        }
    }

    fileprivate func handleWarning(_ warn: String) {
        self.printer.warning(str: warn + "\n")
    }

    fileprivate func handleError(_ msg: String) -> Never {
        self.printer.error(str: msg + "\n")
        exit(EXIT_FAILURE)
    }

}
