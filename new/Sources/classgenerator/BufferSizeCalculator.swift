/*
 * BufferSizeCalculator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 22/08/2017.
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

public final class BufferSizeCalculator {

    fileprivate let lengths: [String: Int] = [
        "bool": 5,
        "char": 1,
        "signed char": 2,
        "unsigned char": 1,
        "signed": 11,
        "signed int": 11,
        "unsigned": 11,
        "unsigned int": 11,
        "uint8_t": 3,
        "uint16_t": 5,
        "uint32_t": 10,
        "uint64_t": 20,
        "int8_t": 4,
        "int16_t": 6,
        "int32_t": 11,
        "int64_t": 20,
        "int": 11,
        "uint": 10,
        "short": 6,
        "short int": 6,
        "signed short": 6,
        "signed short int": 6,
        "unsigned short": 6,
        "unsigned short int": 6,
        "long": 11,
        "long int": 11,
        "signed long": 11,
        "signed long int": 11,
        "unsigned long": 10,
        "unsigned long int": 10,
        "long long": 20,
        "long long int": 20,
        "signed long long": 20,
        "signed long long int": 20,
        "unsigned long long": 20,
        "unsigned long long int": 20,
        "long64_t": 20,
        "float": 64,
        "float_t": 64,
        "double": 64,
        "double_t": 64,
        "long double": 80,
        "double double": 80
    ]

    /**
     * This determines the description string buffer size which will be declared
     * as a constant in the generated files.
     *
     * - Paramter vars: The array of variables that the `Class` contains.
     *
     * - Parameter buffer: The size of the toString buffer.
     *
     * - Returns: The size of the buffer.
     */
    func getDescriptionBufferSize(fromVariables vars: [Variable], withToStringBufferSize buffer: Int) -> Int {
        return vars.count + vars.reduce(buffer) { $0 + $1.label.count }
    }

    /**
     * This determines the tostring buffer size which will be declared as a
     * constant in the generated files. It uses information about the variables
     * as stored in the dictionary.
     *
     * - Paramter vars: The array of variables that the `Class` contains.
     *
     * - Returns: The size of the buffer.
     */
    func getToStringBufferSize(fromVariables vars: [Variable]) -> Int {
        if true == vars.isEmpty {
            return 0
        }
        return (vars.count - 1) * 2 + vars.reduce(1) {
            switch $1.type {
                case .array, .pointer, .unknown:
                    return $0 + 255
                case .string(let length):
                    if let num = Int(length) {
                        return $0 + num
                    }
                    return $0 + 255
                default:
                    return $0 + (self.lengths[$1.cType] ?? 255)
            }
        }
    }
}
