/*
 * DefaultValuesCalculator.swift 
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

import Data

public final class DefaultValuesCalculator {

    public init() {}

    func calculateDefaultValues(forType type: VariableTypes) -> (String, String)? {
        switch type {
            case .array(let subtype, let length):
                return self.calculateArrayDefaultValues(forType: subtype, withLength: length)
            case .bit:
                return ("0", "false")
            case .bool:
                return ("true", "true")
            case .char:
                return ("0", "UnicodeScalar(UInt8.min)")
            case .numeric(let subtype):
                return self.calculateNumericDefaultValue(forNumericType: subtype)
            case .pointer:
                return ("NULL", "nil")
            case .string:
                return ("\"\"", "\"\"")
            case .unknown:
                return nil
        }
    }

    fileprivate func calculateNumericDefaultValue(forNumericType type: NumericTypes) -> (String, String) {
        switch type {
            case .double:
                return ("0.0", "0.0")
            case .float:
                return ("0.0f", "0.0")
            case .long(let subtype):
                return self.calculateNumericDefaultValue(forNumericType: subtype)
            case .signed, .unsigned:
                return ("0", "0")
        }
    }

    fileprivate func calculateArrayDefaultValues(
        forType type: VariableTypes,
        withLength length: String
    ) -> (String, String)? {
        guard let count = Int(length) else {
            return ("{}", "[]")
        }
        guard let value = self.calculateDefaultValues(forType: type) else {
            return nil
        }
        let cValues = Array(repeating: value.0, count: count).combine("") { $0 + ", " + $1 }
        let swiftValues = Array(repeating: value.1, count: count).combine("") { $0 + ", " + $1 }
        return ("{" + cValues + "}", "[" + swiftValues + "]")
    }

}
