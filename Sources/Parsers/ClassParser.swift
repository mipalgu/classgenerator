/*
 * ClassParser.swift 
 * Sources 
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
import swift_helpers
import whiteboard_helpers

public final class ClassParser<
    Container: ParserWarningsContainer,
    SectionsParser: SectionsParserType,
    VariablesTableParser: VariablesTableParserType
>: ClassParserType {

    public fileprivate(set) var errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    public fileprivate(set) var container: Container
    
    fileprivate let enumParser: EnumParser

    fileprivate let helpers: StringHelpers

    fileprivate let sectionsParser: SectionsParser

    fileprivate let variablesParser: VariablesTableParser

    public init(
        container: Container,
        enumParser: EnumParser = EnumParser(),
        sectionsParser: SectionsParser,
        variablesParser: VariablesTableParser,
        helpers: StringHelpers = StringHelpers()
    ) {
        self.container = container
        self.enumParser = enumParser
        self.helpers = helpers
        self.sectionsParser = sectionsParser
        self.variablesParser = variablesParser
    }

    public func parse(_ contents: String, withName file: String, namespaces: [CNamespace], searchPaths: [String]) -> Class? {
        self.errors = []
        do {
            //swiftlint:disable opening_brace
            guard
                let name = self.parseClassName(from: file),
                let sections = self.delegate(
                { self.sectionsParser.parseSections(forGen: name, namespaces: namespaces, fromContents: contents, withVariables: [:], searchPaths: searchPaths) },
                    self.sectionsParser
                )
            else {
                return nil
            }
            guard let authorSection = sections.author else {
                self.errors.append("you must specify an author section in your class.")
                return nil
            }
            guard let variablesSection = sections.variables else {
                self.errors.append("You must specify a properties section in your class.")
                return nil
            }
            let variables = try self.variablesParser.parseVariables(fromSection: variablesSection, namespaces: namespaces)
            let enums = [sections.preC ?? "", sections.postC ?? ""].flatMap(self.parseEnums)
            guard let author: String = self.parseAuthor(fromSection: authorSection) else {
                self.errors.append("You must specify the author of the class.")
                return nil
            }
            guard let comment = sections.comments else {
                self.errors.append("You must specify a comment for the class.")
                return nil
            }
            guard !variables.isEmpty else {
                self.errors.append("The class must not contain an empty property list.")
                return nil
            }
            return Class(
                name: name,
                author: author,
                comment: comment,
                variables: variables,
                enums: enums,
                preC: sections.preC,
                embeddedC: sections.embeddedC,
                topCFile: sections.topCFile,
                preCFile: sections.preCFile,
                postCFile: sections.postCFile,
                postC: sections.postC,
                preCpp: sections.preCpp,
                embeddedCpp: sections.embeddedCpp,
                postCpp: sections.postCpp,
                preSwift: sections.preSwift,
                embeddedSwift: sections.embeddedSwift,
                postSwift: sections.postSwift
            )
        } catch ParsingErrors.sectionError(let line, let offset, let message) {
            self.errors.append("\(line + 1), \(offset): \(message)")
            return nil
        } catch {
            self.errors.append("Unable to parse \(file)")
            return nil
        }
    }
    
    fileprivate func parseEnums(fromSection section: String) -> [Enum] {
        guard
            let range = section.range(of: "enum"),
            let endRange = section[range.upperBound..<section.endIndex].range(of: ";")
        else {
            return []
        }
        let firstIndex = range.lowerBound
        let endIndex = endRange.lowerBound
        let enumSection = String(section[firstIndex ... endIndex])
        let remaining = String(section[section.index(after: endIndex)..<section.endIndex])
        guard let cStyleEnum = try? self.enumParser.parseCStyleEnum(enumSection) else {
            return self.parseEnums(fromSection: remaining)
        }
        return [cStyleEnum] + self.parseEnums(fromSection: remaining)
    }

    fileprivate func parseClassName(from str: String) -> String? {
        let components = str.components(separatedBy: ".")
        guard components.count <= 2 else {
            self.errors.append("You cannot have dots in your class name.")
            return nil
        }
        guard let name = components.first, false == name.isEmpty else {
            self.errors.append("The class name is empty.")
            return nil
        }
        guard let first = name.first, true == self.helpers.isLetter(first) else {
            self.errors.append("The class name should start with a letter.")
            return nil
        }
        if false == str.hasSuffix(".gen") {
            self.container.warnings.append("\(str) should have a '.gen' extension.")
        }
        if  nil != name.lazy.filter({ $0 == "_" }).first &&
            nil != name.lazy.filter({ self.helpers.isUpperCase($0) }).first
        {
            //swiftlint:disable:next line_length
            self.container.warnings.append("Detected using underscores with capital letters in the class name.  This may result in undesirable names of the generated files.")
        }
        guard nil == name.lazy.filter({ false == self.helpers.isAlphaNumeric($0) && $0 != "_" }).first else {
            self.errors.append("The filename can only contain alphanumeric characters and underscores.")
            return nil
        }
        return name
    }

    fileprivate func parseAuthor(fromSection section: String) -> String? {
        guard let authors = section.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).failMap({ (str: String) -> String? in
            let words = str.components(separatedBy: CharacterSet.whitespaces)
            guard "author" == words.first || "-author" == words.first else {
                self.errors.append("Unable to parse authors name.")
                return nil
            }
            let name = words.dropFirst().reduce("") { $0 + " " + $1 }.trimmingCharacters(in: CharacterSet.whitespaces)
            guard false == name.isEmpty else {
                self.errors.append("Unable to find authors name.")
                return nil
            }
            return name
        }) else {
            return nil
        }
        return Set(authors).sorted().combine("") { $0 + "," + $1 }
    }

    fileprivate func delegate<T, C: ErrorContainer>(_ parse: () -> T?, _ cont: C) -> T? {
        guard let result = parse() else {
            self.errors.append(contentsOf: cont.errors)
            return nil
        }
        return result
    }

}
