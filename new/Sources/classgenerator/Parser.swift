/*
 * Parser.swift 
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

public final class Parser: ErrorContainer, WarningsContainer {

    public fileprivate(set) var errors: [String] = []

    public fileprivate(set) var warnings: [String] = []

    public var lastError: String? {
        return self.errors.first
    }

    public var lastWarning: String? {
        return self.warnings.first
    }

    fileprivate let sectionsParser: SectionsParser
    fileprivate let variablesParser: VariablesParser

    public init(
        sectionsParser: SectionsParser = SectionsParser(),
        variablesParser: VariablesParser = VariablesParser()
    ) {
        self.sectionsParser = sectionsParser
        self.variablesParser = variablesParser
    }

    public func parse(file: URL) -> Class? {
        self.errors = []
        self.warnings = []
        //swiftlint:disable opening_brace
        guard let name = self.parseClassName(from: file) else {
            return nil
        }
        guard let contents = try? String(contentsOf: file) else {
            self.errors.append("Unable to read contents of file: \(file.path).")
            return nil
        }
        guard
            let sections = self.delegate(
                { self.sectionsParser.parseSections(fromContents: contents) },
                self.sectionsParser
            ),
            let variables = self.delegate(
                { self.variablesParser.parseVariables(fromSection: sections.variables) },
                self.variablesParser
            )
        else {
            self.errors.append("Unable to parse \(file.path)")
            return nil
        }
        guard let author: String? = sections.author.failMap({ self.parseAuthor(fromSection: $0) }) else {
            return nil
        }
        return Class(
            name: name,
            author: author,
            preamble: sections.preamble,
            variables: variables,
            cExtras: sections.cExtras,
            cppExtras: sections.cppExtras,
            swiftExtras: sections.swiftExtras
        )
    }

    fileprivate func parseClassName(from path: URL) -> String? {
        let components = path.lastPathComponent.components(separatedBy: ".")
        guard components.count <= 2 else {
            self.errors.append("You cannot have dots in your class.")
            return nil
        }
        guard let name = components.first, false == name.isEmpty else {
            self.errors.append("The class name is empty.")
            return nil
        }
        guard let first = name.characters.first, true == self.isLetter(first) else {
            self.errors.append("The class name should start with a letter.")
            return nil
        }
        if nil != name.characters.lazy.filter({ $0 == "_" }).first {
            self.warnings.append("Underscores are not recommended in the class name.")
        }
        guard nil == name.characters.lazy.filter({ false == self.isAlphaNumeric($0) && $0 != "_" }).first else {
            self.errors.append("The filename can only contain alphanumeric characters and underscores.")
            return nil
        }
        return name
    }

    fileprivate func isAlphaNumeric(_ char: Character) -> Bool {
        return isNumeric(char) || isLetter(char)
    }

    fileprivate func isNumeric(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }

    fileprivate func isLetter(_ char: Character) -> Bool {
        return (char >= "A" && char <= "Z") || (char >= "a" && char <= "z")
    }

    fileprivate func parseAuthor(fromSection section: String) -> String? {
        let words = section.components(separatedBy: CharacterSet.whitespaces)
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
    }

    fileprivate func delegate<T, EC: ErrorContainer>(_ parse: () -> T?, _ errorContainer: EC) -> T? {
        guard let result = parse() else {
            self.errors.append(contentsOf: errorContainer.errors)
            return nil
        }
        return result
    }

}
