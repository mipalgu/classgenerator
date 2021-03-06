/*
 * FromStringImplementationCreator.swift 
 * Creators 
 *
 * Created by Callum McColl on 18/05/2018.
 * Copyright © 2018 Callum McColl. All rights reserved.
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
import Helpers
import swift_helpers
import whiteboard_helpers

public final class FromStringImplementationCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    func createFromStringImplementation<DataSource: FromStringImplementationDataSource>(
        forClass cls: Class,
        using dataSource: DataSource,
        namespaces: [CNamespace],
        squashDefines: Bool
    ) -> String {
        let setup = dataSource.createSetup(forClass: cls, namespaces: namespaces, squashDefines: squashDefines)
        let vars = cls.variables.lazy.filter {
            switch $0.type {
            case .pointer, .unknown:
                return false
            default:
                return true
            }
        }.enumerated().compactMap { (t: (offset: Int, element: Variable)) -> String? in
            self.createSetter(
                atOffset: t.offset,
                using: dataSource,
                forVariable: t.element,
                withLabel: t.element.label,
                accessedFrom: dataSource.accessor,
                inClass: cls,
                namespaces: namespaces,
                squashDefines: squashDefines,
                level: 0,
                setter: dataSource.setter(forVariable: t.element)
            )
        }.combine("") { $0 + "\n" + $1 }
        let tearDown = dataSource.createTearDown(forClass: cls)
        return setup + "\n" + vars + "\n" + tearDown
    }

    fileprivate func createSetter<DataSource: FromStringImplementationDataSource>(
        atOffset offset: Int,
        using dataSource: DataSource,
        forVariable variable: Variable,
        withLabel label: String,
        accessedFrom accessor: String,
        inClass cls: Class,
        namespaces: [CNamespace],
        squashDefines: Bool,
        level: Int,
        setter: (String) -> String
    ) -> String? {
        switch variable.type {
        case .array(let subtype, _):
            let index = label + "_\(level)_index"
            let length = self.creatorHelpers.createArrayCountDef(
                inClass: cls.name,
                forVariable: label,
                level: level,
                namespaces: squashDefines ? [] : namespaces
            )
            let head = dataSource.createSetupArrayLoop(atOffset: offset, withIndexName: index, andLength: length, recursive: subtype.isRecursive)
            let end = dataSource.createTearDownArrayLoop(atOffset: offset, withIndexName: index, andLength: length)
            let assignment: String
            switch subtype {
                case .array:
                    return nil
                default:
                    guard let value = dataSource.createArrayValue(
                        forType: subtype,
                        withLabel: "\(label)_\(level)",
                        andCType: variable.cType,
                        accessedFrom: accessor,
                        inClass: cls,
                        level: level + 1,
                        setter: { "\(dataSource.arraySetter(label, index, $0))" }
                    ) else {
                        return nil
                    }
                    assignment = value
            }
            return head + "\n" + self.stringHelpers.indent(assignment) + "\n" + end
        default:
            return dataSource.createValue(
                atOffset: offset,
                forType: variable.type,
                withLabel: variable.label,
                andCType: variable.cType,
                accessedFrom: accessor,
                inClass: cls,
                setter: setter
            )
        }
    }

}
