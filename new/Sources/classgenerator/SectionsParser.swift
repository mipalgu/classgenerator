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

public final class SectionsParser: ErrorContainer, WarningsContainer {

    public fileprivate(set) var errors: [String] = []

    public fileprivate(set) var warnings: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    public var lastWarning: String? {
        return self.warnings.last
    }

    public func parseSections(fromContents contents: String) -> Sections? {
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
        return self.createSections(fromGroups: trimmedGroup)
    }

    //swiftlint:disable opening_brace
    //swiftlint:disable:next function_body_length
    fileprivate func createSections<S: Sequence, C: Collection>(fromGroups seq: S) -> Sections? where
        S.Iterator.Element == C,
        C.Iterator.Element == String
    {
        var author: String?
        var prec: String?
        var vars: String?
        var comments: String?
        var postc: String?
        var precpp: String?
        var cpp: String?
        var postcpp: String?
        var preswift: String?
        var swift: String?
        var postswift: String?
        var usingOldFormat: Bool = false
        let assignIfValid: (inout String?, String, Bool) -> Bool = {
            if true == $2 { $0 = $1 }; return $2
        }
        seq.forEach {
            guard let first = $0.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else {
                return
            }
            let combined = $0.dropFirst().reduce("") { $0 + "\n" + $1 }.trimmingCharacters(in: CharacterSet.newlines)
            //swiftlint:disable opening_brace
            if true == (assignIfValid(&author, first, self.isAuthorLine(first))
                || assignIfValid(&prec, combined, self.isPreCMarker(first))
                || assignIfValid(&vars, combined, self.isPropertiesMarker(first))
                || assignIfValid(&comments, combined, self.isCommentMarker(first))
                || assignIfValid(&postc, combined, self.isPostCMarker(first))
                || assignIfValid(&precpp, combined, self.isPreCppMarker(first))
                || assignIfValid(&cpp, combined, self.isCppMarker(first))
                || assignIfValid(&postcpp, combined, self.isPostCppMarker(first))
                || assignIfValid(&preswift, combined, self.isPreSwiftMarker(first))
                || assignIfValid(&swift, combined, self.isSwiftMarker(first))
                || assignIfValid(&postswift, combined, self.isPostSwiftMarker(first))
            ) {
                return
            }
            guard let (tempVars, tempComments) = self.parseWithoutMarkers(section: $0) else {
                return
            }
            usingOldFormat = true
            vars = true == tempVars.isEmpty ? vars : tempVars
            comments = tempComments ?? comments
        }
        if true == usingOldFormat {
            self.warnings.append("The old format is depracated. Please convert this class to the new format.")
        }
        guard let variables = vars else {
            self.errors.append("Please specify a property list section (-properties).")
            return nil
        }
        guard let a = author else {
            self.errors.append("Please specify the author of the class.")
            return nil
        }
        return Sections(
            author: a,
            preC: prec,
            variables: variables,
            comments: comments,
            postC: postc,
            preCpp: precpp,
            embeddedCpp: cpp,
            postCpp: postcpp,
            preSwift: preswift,
            embeddedSwift: swift,
            postSwift: postswift
        )
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
            || self.isPreCMarker(str)
            || self.isPropertiesMarker(str)
            || self.isCommentMarker(str)
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

    fileprivate func isPreCMarker(_ str: String) -> Bool {
        return str == "-c"
    }

    fileprivate func isPropertiesMarker(_ str: String) -> Bool {
        return str == "-properties"
    }

    fileprivate func isCommentMarker(_ str: String) -> Bool {
        return str == "-comment"
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
