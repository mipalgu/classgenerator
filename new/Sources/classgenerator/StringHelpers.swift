/*
 * StringHelpers.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 06/08/2017.
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

public final class StringHelpers {

    public func isAlphaNumeric(_ char: Character) -> Bool {
        return isNumeric(char) || isLetter(char)
    }

    public func isNumeric(_ char: Character) -> Bool {
        return char >= "0" && char <= "9"
    }

    public func isLetter(_ char: Character) -> Bool {
        return self.isUpperCase(char) || self.isLowerCase(char)
    }

    public func isLowerCase(_ char: Character) -> Bool {
        return char >= "a" && char <= "z"
    }

    public func isUpperCase(_ char: Character) -> Bool {
        return char >= "A" && char <= "Z"
    }

    public func toCamelCase(_ str: String) -> String {
        if true == str.isEmpty {
            return str
        }
        var chars = String.CharacterView("_")
        chars.reserveCapacity(str.characters.count)
        var index = chars.startIndex
        let _: Character = str.characters.reduce("_") {
            if $0 != "_" {
                index = chars.index(after: index)
                return $1
            }
            chars.insert(self.toUpper($1), at: chars.index(before: chars.endIndex))
            _ = chars.removeLast()
            return $1
        }
        return String(chars)
    }

    public func toSnakeCase(_ str: String) -> String {
        var chars = String.CharacterView()
        chars.reserveCapacity(str.characters.count)
        let _: Character = str.characters.reduce("a") {
            guard true == self.isUpperCase($0) else {
                chars.append($1)
                return $1
            }
            chars.append("_")
            chars.append(self.toLower($1))
            return $1
        }
        return String(chars)
    }

    public func toLower(_ char: Character) -> Character {
        return String(char).lowercased().characters.first!
    }

    public func toUpper(_ char: Character) -> Character {
        return String(char).uppercased().characters.first!
    }

}