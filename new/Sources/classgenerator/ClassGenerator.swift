/*
 * ClassGenerator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 08/09/2017.
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

public final class ClassGenerator {

    fileprivate let parser: ClassGeneratorParser
    fileprivate let cHeaderCreator: CHeaderCreator
    fileprivate let cFileCreator: CFileCreator
    fileprivate let cppHeaderCreator: CPPHeaderCreator

    public init(
        parser: ClassGeneratorParser = ClassGeneratorParser(),
        cHeaderCreator: CHeaderCreator = CHeaderCreator(),
        cFileCreator: CFileCreator = CFileCreator(),
        cppHeaderCreator: CPPHeaderCreator = CPPHeaderCreator()
    ) {
        self.parser = parser
        self.cHeaderCreator = cHeaderCreator
        self.cFileCreator = cFileCreator
        self.cppHeaderCreator = cppHeaderCreator
    }

    public func run(_ args: [String]) {
        let args = self.cleanArgs(args)
        let task: Task
        do {
            task = try self.parser.parse(words: args)
        } catch (let e) {
            switch e {
                case ClassGeneratorErrors.pathNotFound:
                    fatalError("Path not found")
                case ClassGeneratorErrors.unknownFlag(let flag):
                    fatalError("Unknown Flag: \(flag)")
                default:
                    fatalError("Unknown Error")
            }
        }
    }

    private func cleanArgs(_ args: [String]) -> [String] {
        return args[1 ..< args.count].flatMap { (str: String) -> [String] in
            let cs = Array(str.characters)
            if cs.count < 2 || cs.first != "-" {
                return [str]
            }
            if cs[1] == "-" {
                return [str]
            }
            return cs.flatMap { $0 == "-" ? nil : "-\($0)" }
        }
    }

}
