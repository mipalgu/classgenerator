/*
 * VariableTypes.swift 
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

public enum VariableTypes {
    
    public var isRecursive: Bool {
        switch self {
        case .array:
            return true
        default:
            return false
        }
    }
    
    public var isFloat: Bool {
        switch self {
        case .numeric(let numericType):
            return numericType.isFloat
        default:
            return false
        }
    }
    
    public var arrayLevels: Int {
        switch self {
        case .array(let subtype, _):
            return subtype.arrayLevels + 1
        default:
            return 0
        }
    }
    
    public var arraySubType: VariableTypes? {
        switch self {
        case .array(let subtype, _):
            return subtype
        default:
            return nil
        }
    }
    
    public var terminalType: VariableTypes {
        switch self {
        case .array(let subtype, _):
            return subtype.terminalType
        case .pointer(let subtype):
            return subtype.terminalType
        default:
            return self
        }
    }
    
    public var className: String? {
        switch self {
        case .gen(_, _, let className):
            return className
        default:
            return nil
        }
    }

    indirect case array(VariableTypes, String)
    indirect case mixed(macOS: VariableTypes, linux: VariableTypes)
    case bit
    case bool
    case char(CharSigns)
    case enumerated(String)
    case gen(String, String, String) // gen name, struct name, class name
    case numeric(NumericTypes)
    indirect case pointer(VariableTypes)
    case string(String)
    case unknown


}

extension VariableTypes: Equatable {}

public func == (lhs: VariableTypes, rhs: VariableTypes) -> Bool {
    switch (lhs, rhs) {
        case (.bit, .bit), (.bool, .bool), (.char, .char), (.unknown, .unknown):
            return true
        case (.enumerated(let lname), .enumerated(let rname)):
            return lname == rname
        case (.gen(let lname, let lstructName, let lclassName), .gen(let rname, let rstructName, let rclassName)):
            return lname == rname && lstructName == rstructName && lclassName == rclassName
        case (.string(let llength), .string(let rlength)):
            return llength == rlength
        case (.array(let ltype, let llength), .array(let rtype, let rlength)):
            return ltype == rtype && llength == rlength
        case (.numeric(let ltype), .numeric(let rtype)):
            return ltype == rtype
        case (.pointer(let ltype), .pointer(let rtype)):
            return ltype == rtype
        case (.mixed(let lmac, let llinux), .mixed(let rmac, let rlinux)):
            return lmac == rmac && llinux == rlinux
        default:
            return false
    }
}
