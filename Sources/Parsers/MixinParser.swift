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

import swift_helpers
import Foundation

public final class MixinParser {

    public func parseCall(line: String) -> (String, [String: String])? {
        let line = line.trimmingCharacters(in: .whitespaces)
        let marker = "@include"
        if false == line.hasPrefix(marker) {
            return nil
        }
        let trimmed = line.dropFirst(marker.count).trimmingCharacters(in: .whitespaces)
        let split = trimmed.components(separatedBy: "(")
        if split.count > 2 {
            return nil
        }
        if split.count < 2 {
            return nil
        }
        let filePath = split[0].trimmingCharacters(in: .whitespaces)
        let varList = split[1].trimmingCharacters(in: .whitespaces).components(separatedBy: ")")[0]
        if varList.isEmpty {
            return nil
        }
        let vars = varList.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        var nameSet: Set<String> = []
        guard let allVars = vars.failMap({ (str: String) -> (String, String)? in
            let components = str.components(separatedBy: "=")
            if components.count > 2 {
                return nil
            }
            if components.count < 2 {
                return nil
            }
            let name = components[0].trimmingCharacters(in: .whitespaces)
            let value = components[1].trimmingCharacters(in: .whitespaces)
            if name.isEmpty || value.isEmpty {
                return nil
            }
            if nameSet.contains(name) {
                return nil
            }
            nameSet.insert(name)
            return (name, value)
        }) else {
            return nil
        }
        return (filePath, Dictionary<String, String>(uniqueKeysWithValues: allVars))
    }

    public func parseDeclaration(line: String) -> [String: String?]? {
        return nil
    }

}
