/*
 * CreatorHelpers.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 15/08/2017.
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

import Data
import whiteboard_helpers

public final class CreatorHelpers {

    fileprivate let backwardsCompatible: Bool
    fileprivate let date: Date
    fileprivate let helpers: WhiteboardHelpers

    public init(backwardsCompatible: Bool = false, date: Date = Date(), helpers: WhiteboardHelpers = WhiteboardHelpers()) {
        self.backwardsCompatible = backwardsCompatible
        self.date = date
        self.helpers = helpers
    }

    public lazy var currentDate: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self.date)
    }()

    public lazy var currentTime: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self.date)
    }()

    public lazy var currentYear: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self.date)
    }()

    public func calculateSignatureExtras(forType type: VariableTypes) -> String {
        switch type {
            case .pointer:
                return " " + self._calculateSignatureExtras(forType: type)
            default:
                return self._calculateSignatureExtras(forType: type)
        }
    }

    fileprivate func _calculateSignatureExtras(forType type: VariableTypes) -> String {
        switch type {
            case .pointer(let subtype):
                return "*" + self._calculateSignatureExtras(forType: subtype)
            default:
                return ""
        }
    }

    public func calculateLabelExtras(forType type: VariableTypes) -> String {
        switch type {
            case .array(let subtype, let length):
                return "[\(length)]" + self.calculateLabelExtras(forType: subtype)
            default:
                return ""
        }
    }

    public func createArrayCountDef(inClass className: String, forVariable label: String, level: Int) -> String {
        return self.helpers.createArrayCountDef(inClass: className, forVariable: label, level: level)
    }

    public func createArrayCountDef(inClass className: String) -> (String) -> (Int) -> String {
        return self.helpers.createArrayCountDef(inClass: className)
    }

    public func createClassName(forClassNamed className: String) -> String {
        if false == self.backwardsCompatible {
            return self.helpers.createClassName(forClassNamed: className)
        }
        let split = className.split(separator: "_").lazy.map { String($0) }
        return split.combine("") { $0 + ($1.first.map { String($0).capitalized } ?? "") + String($1.dropFirst()) }
    }

    public func createComment(from str: String, prepend: String = "") -> String {
        let lines = str.components(separatedBy: CharacterSet.newlines)
        let start = prepend + "/**\n"
        let end = prepend + " */"
        let temp = lines.reduce(start) { $0 + prepend + " * " + $1 + "\n" }
        return temp + end
    }

    //swiftlint:disable:next function_body_length
    public func createFileComment(
        forFile file: String,
        withAuthor author: String,
        andGenFile genfile: String
    ) -> String {
        return """
            /*
             * file \(file)
             *
             * This file was generated by classgenerator from \(genfile).
             * DO NOT CHANGE MANUALLY!
             *
             * Copyright © \(self.currentYear) \(author). All rights reserved.
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
             *        This product includes software developed by \(author).
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
            """
    }

    public func createStructName(forClassNamed className: String) -> String {
        if false == self.backwardsCompatible {
            return self.helpers.createStructName(forClassNamed: className)
        }
        return "wb_" + className.lowercased()
    }

    public func isSupportedStringType(_ type: VariableTypes) -> Bool {
        switch type {
        case .array(let subtype, _):
            return self.isSupportedStringType(subtype)
        case .unknown:
            return false
        default:
            return true
        }
    }

}
