/*
 * MixinParser.swift 
 * Parsers 
 *
 * Created by Callum McColl on 09/08/2019.
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

import Helpers
import Foundation

public final class MixinParser {

    public func parseCall(line: String) throws -> (FilePath, [String: String]) {
        let trimmedLine = line.trimmingCharacters(in: .whitespaces)
        let marker = "@include"
        if false == trimmedLine.hasPrefix(marker) {
            throw ParsingErrors.parsingError(0, "The mixin line must start with \(marker)")
        }
        let trimmed = trimmedLine.dropFirst(marker.count).trimmingCharacters(in: .whitespaces)
        let split = trimmed.components(separatedBy: "(")
        let filePathStr = split[0].trimmingCharacters(in: .whitespaces)
        if filePathStr.isEmpty {
            throw ParsingErrors.parsingError(0, "The file path cannot be empty.")
        }
        let filePath: FilePath
        if filePathStr.first == "\"" && filePathStr.last == "\"" {
            filePath = .path(filePath: String(filePathStr.dropFirst().dropLast()))
        } else if filePathStr.first == "<" && filePathStr.last == ">" {
            filePath = .searchPath(name: String(filePathStr.dropFirst().dropLast()))
        } else {
            let append = filePathStr.suffix(6) == ".mixin" ? "" : ".mixin"
            filePath = .searchPath(name: filePathStr + append)
        }
        let variables = try self.parseVariablesList(line: trimmedLine, delimiter: ":", allowEmpty: false)
        return (filePath, Dictionary(uniqueKeysWithValues: variables.map { ($0, $1!) }))
    }

    public func parseDeclaration(line: String) throws -> [String: String?] {
        let trimmedLine = line.trimmingCharacters(in: .whitespaces)
        let marker = "@mixin"
        if false == trimmedLine.hasPrefix(marker) {
            throw ParsingErrors.parsingError(0, "The mixin line must start with \(marker)")
        }
        return try self.parseVariablesList(line: trimmedLine, delimiter: "=", allowEmpty: true)
    }

    fileprivate func parseVariablesList(line: String, delimiter: String, allowEmpty: Bool) throws -> [String: String?] {
        let split = line.trimmingCharacters(in: .whitespaces).components(separatedBy: "(")
        if split.count > 2 {
            let index = line.firstIndex(of: "(").map { line.distance(from: line.startIndex, to: $0) } ?? 0
            throw ParsingErrors.parsingError(index, "You can only specify one variable list")
        }
        if split.count < 2 {
            return [:]
        }
        let varList = split[1].trimmingCharacters(in: .whitespaces).components(separatedBy: ")")[0]
        if varList.isEmpty {
            return [:]
        }
        let vars: [String] = varList.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var nameSet: Set<String> = []
        nameSet.reserveCapacity(vars.count)
        guard let allVars: [(String, String?)] = try vars.failMap({ (str: String) throws -> (String, String?)? in
            let components = str.components(separatedBy: delimiter)
            let name = components[0].trimmingCharacters(in: .whitespaces)
            if name.isEmpty {
                throw ParsingErrors.parsingError(0, "Malformed parameter list in mixin.")
            }
            if nameSet.contains(name) {
                throw ParsingErrors.parsingError(0, "Duplicate variable in parameter list for mixin.")
            }
            nameSet.insert(name)
            if components.count < 2 && allowEmpty {
                return (name, nil)
            }
            if components.count != 2 {
                throw ParsingErrors.parsingError(0, "Malformed parameter list in mixin.")
            }
            let value = components[1].trimmingCharacters(in: .whitespaces)
            if value.isEmpty {
                throw ParsingErrors.parsingError(0, "Malformed parameter list in mixin.")
            }
            return (name, value)
        }) else {
            throw ParsingErrors.parsingError(0, "Unable to parse \(line).")
        }
        return Dictionary<String, String?>(uniqueKeysWithValues: allVars)
    }

}
