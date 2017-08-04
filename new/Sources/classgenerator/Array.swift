/*
 * Array.swift 
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

extension Array {

    /**
     *  Split an array int sub-arrays where each sub-array contains elements
     *  that conform to `shouldGroup`.
     *
     *  In this example, `grouped(by:)` is used to group an `Array` of `Int`s:
     *  ````
     *      let numbers = [1, 1, 2, 2, 3, 4, 1, 1, 5]
     *      let grouped = numbers.grouped { $0 == $1 }
     *          // [[1, 1], [2, 2], [3], [4], [1, 1], [5]]
     *  ````
     *
     *  - Parameter shouldGroup: A function that returns true when two
     *    elements should be grouped together into a sub-array.
     */
    func grouped(by shouldGroup: (Element, Element) -> Bool) -> [[Element]] {
        guard let first = self.first else {
            return []
        }
        var groups: [[Element]] = [[first]]
        let _: Element = self.dropFirst().reduce(first) {
            if false == shouldGroup($0, $1) {
                groups.append([$1])
                return $1
            }
            groups[groups.endIndex - 1].append($1)
            return $1
        }
        return groups
    }

}

extension Array where Element: Equatable {

    /**
     *  Split an array int sub-arrays where each sub-array contains elements
     *  that are equal.
     *
     *  In this example, `grouped()` is used to group an `Array` of `Int`s:
     *  ````
     *      let numbers = [1, 1, 2, 2, 3, 4, 1, 1, 5]
     *      let grouped = numbers.grouped()
     *          // [[1, 1], [2, 2], [3], [4], [1, 1], [5]]
     *  ````
     */
    func grouped() -> [[Element]] {
        return self.grouped(by: ==)
    }

}
