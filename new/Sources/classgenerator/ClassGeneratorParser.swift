/*
 * SwiftfsmParser.swift
 * swiftfsm
 *
 * Created by Callum McColl on 15/12/2015.
 * Copyright © 2015 Callum McColl. All rights reserved.
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

/**
 *  The standard `Parser`.
 */
public class ClassGeneratorParser {

    public var helpText: String {
        return """
            OVERVIEW: Generates gusimplewhiteboard classes.

            USAGE: classgenerator [options] <classname.gen>

            OPTIONS:
                    -c              Generate a C++ wrapper.
                    -s              Generate a Swift wrapper.
                    --c-header <directory=./>
                                    Place the generated C header into <directory>.
                    --c-file <directory=<c-header>>
                                    Place the generate C file into <directory>.
                    --cpp-header <directory=<c-header>>
                                    Place the C++ file into <directory>.
                    --swift <directory=<c-header>>
                                    Place the generated swift file into <directory>.
            """
    }

    public func parse(words: [String]) throws -> Task {
        var wds: [String] = words
        var task = Task()
        // Keep looping while we still have input
        while false == wds.isEmpty {
            task = try self.handleNextFlag(task, words: &wds)
            // Remove words that we are finished with
            wds.removeFirst()
        }
        return task
    }

    private func handleNextFlag(_ task: Task, words: inout [String]) throws -> Task {
        switch words.first! {
        case "-c":
            return self.handleCFlag(task, words: &words)
        case "-s":
            return self.handleSFlag(task, words: &words)
        case "--help":
            return self.handleHelpFlag(task, words: &words)
        default:
            return try self.handlePath(task, words: &words)
        }
    }

    private func handleCFlag(_ task: Task, words: inout [String]) -> Task {
        var temp = task
        temp.generateCppWrapper = true
        return temp
    }

    private func handleSFlag(_ task: Task, words: inout [String]) -> Task {
        var temp = task
        temp.generateSwiftWrapper = true
        return temp
    }

    private func handleHelpFlag(_ task: Task, words: inout [String]) -> Task {
        var temp = task
        temp.printHelpText = true
        return temp
    }

    private func handlePath(_ task: Task, words: inout [String]) throws -> Task {
        // Ignore empty strings
        if true == words.first!.isEmpty {
            return task
        }
        // Ignore unknown flags
        if "-" == words.first!.characters.first {
            throw ClassGeneratorErrors.unknownFlag(flag: words.first!)
        }
        var temp = task
        temp.path = words.first!
        return temp
    }

}
