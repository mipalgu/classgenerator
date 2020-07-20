/*
 * SectionsParser.swift 
 * classgenerator 
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

import Containers
import Data
import Helpers
import swift_helpers

//swiftlint:disable opening_brace
public final class SectionsParser<Container: ParserWarningsContainer, Reader: FileReader>: SectionsParserType {

    public fileprivate(set) var errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    public fileprivate(set) var container: Container

    fileprivate let reader: Reader

    fileprivate let mixinParser = MixinParser()

    public init(container: Container, reader: Reader) {
        self.container = container
        self.reader = reader
    }

    public func parseSections(fromContents contents: String, withVariables variables: [String: String] = [:], searchPaths: [String]) -> Sections? {
        self.errors = []
        let lines = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .components(separatedBy: CharacterSet.newlines)
        guard let sanitisedLines = lines.failMap({ (line: String) -> String? in
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if "-" == trimmed.first && false == self.isMarker(trimmed) {
                    self.errors.append("Malformed marker detected: \(trimmed)")
                    return nil
                }
                return line
            })
        else {
            return nil
        }
        let grouped = sanitisedLines.lazy.grouped(by: { (last, str) in
            false == (self.isAuthorLine(last) || self.isMarker(str.trimmingCharacters(in: CharacterSet.whitespaces)))
        })
        let trimmedGroup = grouped.map { $0.trim("") }
        return self.createSections(fromGroups: trimmedGroup, searchPaths: searchPaths)
    }

    //swiftlint:disable opening_brace
    //swiftlint:disable:next function_body_length
    fileprivate func createSections<S: Sequence, C: Collection>(fromGroups seq: S, searchPaths: [String]) -> Sections? where
        S.Iterator.Element == C,
        C.Iterator.Element == String
    {
        var sections = Sections()
        var usingOldFormat: Bool = false
        func assignIfValid(_ variable: inout String?, _ value: String, _ valid: Bool) -> Bool {
            if true == valid {
                variable = variable.map { $0 + "\n" + value } ?? value
            }
            return valid
        }
        seq.forEach {
            guard let first = $0.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
                return
            }
            let combined = $0.dropFirst().reduce("") { $0 + "\n" + $1 }.trimmingCharacters(in: CharacterSet.newlines)
            //swiftlint:disable opening_brace
            if true == (assignIfValid(&sections.author, first, self.isAuthorLine(first))
                || assignIfValid(&sections.preC, combined, self.isPreCMarker(first))
                || assignIfValid(&sections.topCFile, combined, self.isTopCFileMarker(first))
                || assignIfValid(&sections.preCFile, combined, self.isPreCFileMarker(first))
                || assignIfValid(&sections.postCFile, combined, self.isPostCFileMarker(first))
                || assignIfValid(&sections.variables, combined, self.isPropertiesMarker(first))
                || assignIfValid(&sections.comments, combined, self.isCommentMarker(first))
                || assignIfValid(&sections.embeddedC, combined, self.isEmbeddedCMarker(first))
                || assignIfValid(&sections.postC, combined, self.isPostCMarker(first))
                || assignIfValid(&sections.preCpp, combined, self.isPreCppMarker(first))
                || assignIfValid(&sections.embeddedCpp, combined, self.isCppMarker(first))
                || assignIfValid(&sections.postCpp, combined, self.isPostCppMarker(first))
                || assignIfValid(&sections.preSwift, combined, self.isPreSwiftMarker(first))
                || assignIfValid(&sections.embeddedSwift, combined, self.isSwiftMarker(first))
                || assignIfValid(&sections.postSwift, combined, self.isPostSwiftMarker(first))
                || self.isMixinLine(first)
                || self.isMixinCallLine(first)
            ) {
                if self.isMixinCallLine(first) {
                    let filePath: FilePath
                    let variables: [String: String]
                    do {
                        let parsedData = try self.mixinParser.parseCall(line: first)
                        filePath = parsedData.0
                        variables = parsedData.1
                    } catch let e {
                        self.errors.append("\(e) for call: \(first)")
                        return
                    }
                    guard let contents = self.reader.read(filePath: filePath, searchPaths: searchPaths) else {
                        self.errors.append("Unable to read mixin: \(filePath)")
                        return
                    }
                    guard let firstLine = contents.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").first else {
                        self.errors.append("Unable to parse underlying mixin: \(filePath)")
                        return
                    }
                    let declaredVariables: [String: String?]
                    do {
                        declaredVariables = try self.mixinParser.parseDeclaration(line: firstLine)
                    } catch let e {
                        self.errors.append("\(e)")
                        self.errors.append("Unable to parse underlying mixin: \(filePath)")
                        return
                    }
                    guard let tempVars = Set(declaredVariables.keys).union(Set(variables.keys)).failMap({ (key: String) -> (String, String)? in
                        if nil == declaredVariables[key] {
                            self.errors.append("Using unknown parameter \(key) in mixin call.")
                            return nil
                        }
                        if let value = variables[key] {
                            return (key, value)
                        }
                        if let wrappedValue = declaredVariables[key], let value = wrappedValue {
                            return (key, value)
                        }
                        self.errors.append("Missing parameter \(key) in mixin call.")
                        return nil
                    }) else {
                        return
                    }
                    let passedVars = Dictionary(uniqueKeysWithValues: tempVars)
                    let parser = SectionsParser<WarningsContainerRef, Reader>(container: WarningsContainerRef([]), reader: self.reader)
                    guard let mixinSections = parser.parseSections(fromContents: contents, withVariables: passedVars, searchPaths: searchPaths) else {
                        self.errors.append(contentsOf: parser.errors.map { "\(filePath): \($0)" })
                        self.container.warnings.append(contentsOf: parser.warnings.map { "\(filePath): \($0)" })
                        return
                    }
                    self.merge(&sections, mixinSections, withVariables: passedVars)
                    return
                }
                return
            }
            guard let (tempVars, tempComments) = self.parseWithoutMarkers(section: $0) else {
                return
            }
            usingOldFormat = true
            sections.variables = true == tempVars.isEmpty ? sections.variables : tempVars
            sections.comments = tempComments ?? sections.comments
        }
        if false == self.errors.isEmpty {
            return nil
        }
        if true == usingOldFormat {
            self.container.warnings.append("The old format is depracated. Please convert this class to the new format.")
        }
        return sections
    }

    fileprivate func merge(_ sections: inout Sections, _ other: Sections, withVariables variables: [String: String]) {
        let sortedVariables = variables.sorted { $0.0.count > $1.0.count }
        func mergeProperty(_ lhs: inout String?, _ rhs: String?) {
            guard var rhs = rhs else {
                return
            }
            sortedVariables.forEach { (args: (key: String, value: String)) in
                rhs = rhs.replacingOccurrences(of: "{{" + args.key + "}}", with: args.value)
            }
            lhs = lhs.map { $0 + "\n" + rhs } ?? rhs
        }
        mergeProperty(&sections.author, other.author)
        mergeProperty(&sections.preC, other.preC)
        mergeProperty(&sections.variables, other.variables)
        mergeProperty(&sections.embeddedC, other.embeddedC)
        mergeProperty(&sections.topCFile, other.topCFile)
        mergeProperty(&sections.preCFile, other.preCFile)
        mergeProperty(&sections.postCFile, other.postCFile)
        mergeProperty(&sections.postC, other.postC)
        mergeProperty(&sections.preCpp, other.preCpp)
        mergeProperty(&sections.embeddedCpp, other.embeddedCpp)
        mergeProperty(&sections.postCpp, other.postCpp)
        mergeProperty(&sections.preSwift, other.preSwift)
        mergeProperty(&sections.embeddedSwift, other.embeddedSwift)
        mergeProperty(&sections.postSwift, other.postSwift)
    }

    fileprivate func parseWithoutMarkers<C: Collection>(
        section: C
    ) -> (String, String?)? where C.Iterator.Element == String {
        let varsGrouped = section.lazy.grouped { (first, _) in
            return first != ""
        }
        let varsCombined = varsGrouped.map { (group: [String]) -> String in
            guard let first = group.first else {
                return ""
            }
            return group.dropFirst().reduce(first) { $0 + "\n" + $1}
        }
        guard let vars = varsCombined.first(where: { _ in true })?.trimmingCharacters(in: CharacterSet.newlines) else {
            return nil
        }
        if true == vars.isEmpty {
            return nil
        }
        let comments = varsCombined.dropFirst().reduce("") { $0 + "\n" + $1 }
            .trimmingCharacters(in: CharacterSet.newlines)
        if true == comments.isEmpty {
            return (vars, nil)
        }
        return (vars, comments)
    }

    fileprivate func isMarker(_ str: String) -> Bool {
        return self.isAuthorLine(str)
            || self.isMixinLine(str)
            || self.isMixinCallLine(str)
            || self.isPreCMarker(str)
            || self.isTopCFileMarker(str)
            || self.isPreCFileMarker(str)
            || self.isPostCFileMarker(str)
            || self.isPropertiesMarker(str)
            || self.isCommentMarker(str)
            || self.isEmbeddedCMarker(str)
            || self.isPostCMarker(str)
            || self.isPreCppMarker(str)
            || self.isCppMarker(str)
            || self.isPostCppMarker(str)
            || self.isPreSwiftMarker(str)
            || self.isSwiftMarker(str)
            || self.isPostSwiftMarker(str)
    }

    fileprivate func isAuthorLine(_ str: String) -> Bool {
        return String(str.prefix(6)) == "author"
            || String(str.prefix(7)) == "-author"
    }

    fileprivate func isMixinLine(_ str: String) -> Bool {
        return str.hasPrefix("@mixin")
    }

    fileprivate func isMixinCallLine(_ str: String) -> Bool {
        return str.hasPrefix("@include")
    }

    fileprivate func isPreCMarker(_ str: String) -> Bool {
        return str == "-c"
    }
    
    fileprivate func isTopCFileMarker(_ str: String) -> Bool {
        return str == "^c"
    }

    fileprivate func isPreCFileMarker(_ str: String) -> Bool {
        return str == "%c"
    }

    fileprivate func isPostCFileMarker(_ str: String) -> Bool {
        return str == "#c"
    }

    fileprivate func isPropertiesMarker(_ str: String) -> Bool {
        return str == "-properties"
    }

    fileprivate func isCommentMarker(_ str: String) -> Bool {
        return str == "-comment"
    }
    
    fileprivate func isEmbeddedCMarker(_ str: String) -> Bool {
        return str == "$c"
    }

    fileprivate func isPostCMarker(_ str: String) -> Bool {
        return str == "+c"
    }

    fileprivate func isPreCppMarker(_ str: String) -> Bool {
        return str == "-c++"
    }

    fileprivate func isCppMarker(_ str: String) -> Bool {
        return str == "%c++"
    }

    fileprivate func isPostCppMarker(_ str: String) -> Bool {
        return str == "+c++"
    }

    fileprivate func isPreSwiftMarker(_ str: String) -> Bool {
        return str == "-swift"
    }

    fileprivate func isSwiftMarker(_ str: String) -> Bool {
        return str == "%swift"
    }

    fileprivate func isPostSwiftMarker(_ str: String) -> Bool {
        return str == "+swift"
    }

}
