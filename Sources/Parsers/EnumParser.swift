/*
 * EnumParser.swift
 * Parsers
 *
 * Created by Callum McColl on 3/3/19.
 * Copyright © 2019 Callum McColl. All rights reserved.
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

import Data
import Foundation
import swift_helpers

public final class EnumParser {
    
    fileprivate let stringHelpers: StringHelpers
    
    public init(stringHelpers: StringHelpers = StringHelpers()) {
        self.stringHelpers = stringHelpers
    }
    
    public func parseCStyleEnum(_ str: String) throws -> Enum {
        let words = str.components(separatedBy: .whitespacesAndNewlines)
        if words.isEmpty {
            throw ParsingErrors.parsingError(0, "Unable to parse enum from empty string.")
        }
        if words.first ?? "" != "enum" {
            throw ParsingErrors.parsingError(0, "Enum string must start with 'enum'.")
        }
        if words.last ?? "" != ";" {
            throw ParsingErrors.parsingError(words.count - 1, "Enum must be terminated with a semicolon.")
        }
        guard let unsanitisedIdentifier = words.dropFirst().first, false == unsanitisedIdentifier.isEmpty else {
            throw ParsingErrors.parsingError(1, "No identifier specified for enum.")
        }
        let identifier = try self.parseIdentifier(from: unsanitisedIdentifier)
        if words.dropFirst(2).first ?? "" != "{" || words.dropLast().last ?? "" != "}" {
            throw ParsingErrors.parsingError(3, "Malformed enumerator list detected.")
        }
        let caseList = words.dropFirst(3).dropLast(2).combine("") { $0 + $1 }.components(separatedBy: ",")
        guard false == caseList.isEmpty else {
            throw ParsingErrors.parsingError(4, "Enumerator list must not be empty.")
        }
        let cases = try self.parseCases(fromList: caseList)
        return Enum(name: identifier, cases: cases)
    }
    
    fileprivate func parseIdentifier(from identifier: String) throws -> String {
        guard
            identifier.first?.unicodeScalars.count ?? 0 < 2,
            true == CharacterSet.letters.contains(identifier.first?.unicodeScalars.first ?? UnicodeScalar(UInt8(0)))
        else {
            throw ParsingErrors.parsingError(1, "Enum identifier must start with an alphabetic character.")
        }
        guard nil == identifier.first(where: { !self.stringHelpers.isAlphaNumeric($0) }) else {
            throw ParsingErrors.parsingError(1, "Enum identifier must be alphanumeric.")
        }
        return identifier
    }
    
    fileprivate func parseCases(fromList cases: [String]) throws -> [String: Int] {
        throw ParsingErrors.parsingError(4, "Not Yet Implemented")
    }
    
}
