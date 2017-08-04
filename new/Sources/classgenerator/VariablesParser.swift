/*
 * VariablesParser.swift 
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

public final class VariablesParser: ErrorContainer {

    public fileprivate(set) var errors: [String] = []

    public var lastError: String? {
        return self.errors.first
    }

    public func parseVariables(fromSection section: String) -> [Variable]? {
        let lines = section.components(separatedBy: CharacterSet.newlines)
        return lines.failMap {
            guard let v = self.createVariable(fromLine: $0) else {
                return nil
            }
            return v
        }
    }

    fileprivate func createVariable(fromLine line: String) -> Variable? {
        let split = line.components(separatedBy: "//")
        guard split.count <= 2 else {
            self.errors.append("Found multiple comments for line: \(line)")
            return nil
        }
        guard let first = split.first else {
            self.errors.append("Line is empty")
            return nil
        }
        var tabbed = first.components(separatedBy: "\t").lazy.map {
            $0.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if 1 == split.count && tabbed.count < 3 {
            self.errors.append("You must supply a comment for line: \(line)")
            return nil
        }
        let comment: String
        let remaining: [String]
        if 2 == split.count {
            comment = split[1].trimmingCharacters(in: CharacterSet.whitespaces)
            remaining = Array(tabbed)
        } else {
            comment = tabbed[2]
            remaining = Array(tabbed.dropLast())
        }
        guard let (type, label, defaultValue) = self.parseVar(fromSegment: remaining[0] + " " + remaining[1]) else {
            return nil
        }
        return Variable(label: label, type: type, swiftType: type, defaultValue: "", comment: comment)
    }

    //swiftlint:disable large_tuple
    fileprivate func parseVar(fromSegment segment: String) -> (String, String, String?)? {
        let split = segment.components(separatedBy: "=")
        let defaultValue: String?
        if split.count > 1 {
            defaultValue = split[1].trimmingCharacters(in: CharacterSet.whitespaces)
        } else {
            defaultValue = nil
        }
        let words = split[0].components(separatedBy: CharacterSet.whitespaces)
        if words.count < 2 {
            self.errors.append("You must specify a label for the after: \(words[0])")
            return nil
        }
        return (words[0], words[1], defaultValue)
    }

}
