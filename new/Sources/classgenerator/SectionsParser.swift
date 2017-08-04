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

public final class SectionsParser {

    public func parseSections(fromContents contents: String) -> Sections? {
        let lines = contents.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            .components(separatedBy: CharacterSet.newlines)
        let grouped = lines.lazy.grouped(by: { (first, _) in
            let trimmed = first.trimmingCharacters(in: CharacterSet.whitespaces)
            return false == (
                self.isAuthorLine(trimmed) ||
                self.isPreambleMarker(trimmed) ||
                self.isPropertiesMarker(trimmed) ||
                self.isCMarker(trimmed) ||
                self.isCppMarker(trimmed) ||
                self.isSwiftMarker(trimmed)
            )
        })
        return self.createSections(fromGroups: grouped)
    }

    fileprivate func createSections<S: Sequence>(fromGroups seq: S) -> Sections? where S.Iterator.Element == [String] {
        var author: String?
        var preamble: String?
        var vars: String?
        var comments: String?
        var cExtras: String?
        var cppExtras: String?
        var swiftExtras: String?
        let assignIfValid: (inout String?, String, Bool) -> Bool = {
            if true == $2 { $0 = $1 }; return $2
        }
        seq.forEach {
            guard let first = $0.first else {
                return
            }
            let combined = $0.dropFirst().reduce("") { $0 + "\n" + $1 }.trimmingCharacters(in: CharacterSet.newlines)
            //swiftlint:disable opening_brace
            if true == (assignIfValid(&author, first, self.isAuthorLine(first))
                || assignIfValid(&preamble, combined, self.isPreambleMarker(first))
                || assignIfValid(&cExtras, combined, self.isCMarker(first))
                || assignIfValid(&cppExtras, combined, self.isCppMarker(first))
                || assignIfValid(&swiftExtras, combined, self.isSwiftMarker(first)))
            {
                return
            }
            let remaining = self.isPropertiesMarker(first) ? Array($0.dropFirst()) : $0
            let varsGrouped = remaining.lazy.grouped { (first, _) in
                return first != ""
            }
            let varsCombined = varsGrouped.map { (group: [String]) -> String in
                guard let first = group.first else {
                    return ""
                }
                return group.dropFirst().reduce(first) { $0 + "\n" + $1}
            }
            vars = varsCombined.first { _ in true }
            comments = varsCombined.dropFirst().reduce("") { $0 + "\n" + $1 }
                .trimmingCharacters(in: CharacterSet.newlines)
        }
        guard let variables = vars else {
            return nil
        }
        return Sections(
            author: author,
            preamble: preamble,
            variables: variables,
            comments: comments,
            cExtras: cExtras,
            cppExtras: cppExtras,
            swiftExtras: swiftExtras
        )
    }

    fileprivate func isAuthorLine(_ str: String) -> Bool {
        return String(str.characters.prefix(6)) == "author"
    }

    fileprivate func isPreambleMarker(_ str: String) -> Bool {
        return str == "-preamble"
    }

    fileprivate func isPropertiesMarker(_ str: String) -> Bool {
        return str == "-properties"
    }

    fileprivate func isCMarker(_ str: String) -> Bool {
        return str == "-c"
    }

    fileprivate func isCppMarker(_ str: String) -> Bool {
        return str == "-c++"
    }

    fileprivate func isSwiftMarker(_ str: String) -> Bool {
        return str == "-swift"
    }

}
