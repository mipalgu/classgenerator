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

public final class DefaultValuesCalculator {

    fileprivate let values: [String: (String, String)] = [
        "string": ("\"\"", "\"\""),
        "bool": ("true", "true"),
        "char": ("0", "Character(UnicodeScalar(UInt8.min))"),
        "signed char": ("0", "Character(UnicodeScalar(UInt8.min))"),
        "unsigned char": ("0", "Character(UnicodeScalar(UInt8.min))"),
        "signed": ("0", "0"),
        "signed int": ("0", "0"),
        "unsigned": ("0", "0"),
        "unsigned int": ("0", "0"),
        "uint8_t": ("0", "0"),
        "uint16_t": ("0", "0"),
        "uint32_t": ("0", "0"),
        "uint64_t": ("0", "0"),
        "int8_t": ("0", "0"),
        "int16_t": ("0", "0"),
        "int32_t": ("0", "0"),
        "int64_t": ("0", "0"),
        "int": ("0", "0"),
        "uint": ("0", "0"),
        "short": ("0", "0"),
        "short int": ("0", "0"),
        "signed short": ("0", "0"),
        "signed short int": ("0", "0"),
        "unsigned short": ("0", "0"),
        "unsigned short int": ("0", "0"),
        "long": ("0", "0"),
        "long int": ("0", "0"),
        "signed long": ("0", "0"),
        "signed long int": ("0", "0"),
        "unsigned long": ("0", "0"),
        "unsigned long int": ("0", "0"),
        "long long": ("0", "0"),
        "long long int": ("0", "0"),
        "signed long long": ("0", "0"),
        "signed long long int": ("0", "0"),
        "unsigned long long": ("0", "0"),
        "unsigned long long int": ("0", "0"),
        "long64_t": ("0", "0"),
        "float": ("0.0f", "0.0"),
        "float_t": ("0.0f", "0.0"),
        "double": ("0.0", "0.0"),
        "double_t": ("0.0", "0.0"),
        "long double": ("0.0", "0.0"),
        "double double": ("0.0", "0.0")
    ]

    func calculateDefaultValues(forTypeSignature type: String, withArrayCounts counts: [String]) -> (String, String)? {
        if type != "string" && nil != counts.first(where: { _ in true }) {
            return self.calculateArrayDefaultValues(forType: type, withCounts: counts)
        }
        return self.values[type]
    }

    fileprivate func calculateArrayDefaultValues(
        forType type: String,
        withCounts counts: [String]
    ) -> (String, String)? {
        guard
            let c = counts.first(where: { _ in true }),
            let num = Int(c),
            num >= 1
        else {
            return ("{}", "[]")
        }
        guard
            let values = self.calculateDefaultValues(forTypeSignature: type, withArrayCounts: Array(counts.dropFirst()))
        else {
            return nil
        }
        let arr = Array(repeating: values, count: num)
        guard let first = arr.first else {
            return ("{}", "[]")
        }
        return (
            "{" + arr.dropFirst().reduce(first.0) { $0 + ", " + $1.0 } + "}",
            "[" + arr.dropFirst().reduce(first.1) { $0 + ", " + $1.1 } + "]"
        )
    }

}
