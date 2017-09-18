/*
 * file Old.swift
 *
 * This file was generated by classgenerator from old.txt.
 * DO NOT CHANGE MANUALLY!
 *
 * Created by Callum McColl at %time%, %date%.
 * Copyright © %year% Callum McColl. All rights reserved.
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

//swiftlint:disable function_body_length
//swiftlint:disable file_length
//swiftlint:disable line_length
//swiftlint:disable identifier_name

/**
 * This is a test of all of the supported types.
 */
extension wb_old {

    public var _str: String {
        get {
            var str = self.str
            return String(cString: withUnsafePointer(to: &str.0) { $0 })
        } set {
            _ = withUnsafeMutablePointer(to: &self.str.0) { str_p in
                let arr = newValue.utf8CString
                _ = arr.withUnsafeBufferPointer {
                    strncpy(str_p, $0.baseAddress, 6)
                }
            }
        }
    }

    public var _c: UnicodeScalar {
        get {
            return UnicodeScalar(UInt8(self.c))
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to c")
            }
            self.c = Int8(newValue.value)
        }
    }

    public var _sc: UnicodeScalar {
        get {
            return UnicodeScalar(UInt8(self.sc))
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to sc")
            }
            self.sc = Int8(newValue.value)
        }
    }

    public var _uc: UnicodeScalar {
        get {
            return UnicodeScalar(self.uc)
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to uc")
            }
            self.uc = UInt8(newValue.value)
        }
    }

    public var _str2: String {
        get {
            var str2 = self.str2
            return String(cString: withUnsafePointer(to: &str2.0) { $0 })
        } set {
            _ = withUnsafeMutablePointer(to: &self.str2.0) { str2_p in
                let arr = newValue.utf8CString
                _ = arr.withUnsafeBufferPointer {
                    strncpy(str2_p, $0.baseAddress, 6)
                }
            }
        }
    }

    public var _c2: UnicodeScalar {
        get {
            return UnicodeScalar(UInt8(self.c2))
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to c2")
            }
            self.c2 = Int8(newValue.value)
        }
    }

    public var _sc2: UnicodeScalar {
        get {
            return UnicodeScalar(UInt8(self.sc2))
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to sc2")
            }
            self.sc2 = Int8(newValue.value)
        }
    }

    public var _uc2: UnicodeScalar {
        get {
            return UnicodeScalar(self.uc2)
        } set {
            if false == newValue.isASCII {
                fatalError("You can only assign ASCII values to uc2")
            }
            self.uc2 = UInt8(newValue.value)
        }
    }

    public var _array16: [Int16] {
        get {
            var array16 = self.array16
            return withUnsafePointer(to: &array16.0) { array16_p in
                var array16: [Int16] = []
                array16.reserveCapacity(4)
                for array16_index in 0..<4 {
                    array16.append(array16_p[array16_index])
                }
                return array16
            }
        } set {
            _ = withUnsafeMutablePointer(to: &self.array16.0) { array16_p in
                for array16_index in 0..<4 {
                    array16_p[array16_index] = newValue[array16_index]
                }
            }
        }
    }

    public var _bools: [Bool] {
        get {
            var bools = self.bools
            return withUnsafePointer(to: &bools.0) { bools_p in
                var bools: [Bool] = []
                bools.reserveCapacity(3)
                for bools_index in 0..<3 {
                    bools.append(bools_p[bools_index])
                }
                return bools
            }
        } set {
            _ = withUnsafeMutablePointer(to: &self.bools.0) { bools_p in
                for bools_index in 0..<3 {
                    bools_p[bools_index] = newValue[bools_index]
                }
            }
        }
    }

    /**
     * Create a new `wb_old`.
     */
    public init(str: String = "hello", b: Bool = false, c: UnicodeScalar = "c", sc: UnicodeScalar = "c", uc: UnicodeScalar = "c", i: Int32 = 1, si: Int32 = 1, sii: Int32 = 1, u: UInt32 = 1, ui: UInt32 = 1, u8: UInt8 = 1, u16: UInt16 = 1, u32: UInt32 = 1, u64: UInt64 = 1, i8: Int8 = 1, i16: Int16 = 1, i32: Int32 = 1, i64: Int64 = 1, s: Int16 = 1, si_2: Int16 = 1, ss: Int16 = 1, ssi: Int16 = 1, us: UInt16 = 1, usi: UInt16 = 1, l: Int = 1, li: Int = 1, sl: Int = 1, sli: Int = 1, ul: UInt = 1, uli: UInt = 1, ll: Int64 = 1, lli: Int64 = 1, sll: Int64 = 1, slli: Int64 = 1, ull: UInt64 = 1, ulli: UInt64 = 1, l64: Int64 = 1, f: Float = 1.0, ft: Float = 1.0, d: Double = 1.0, dt: Double = 1.0, ld: Float80 = 1.0, dd: Float80 = 1.0, str2: String = "", b2: Bool = true, c2: UnicodeScalar = UnicodeScalar(UInt8.min), sc2: UnicodeScalar = UnicodeScalar(UInt8.min), uc2: UnicodeScalar = UnicodeScalar(UInt8.min), i2: Int32 = 0, si2: Int32 = 0, sii2: Int32 = 0, u2: UInt32 = 0, ui2: UInt32 = 0, u82: UInt8 = 0, u162: UInt16 = 0, u322: UInt32 = 0, u642: UInt64 = 0, i82: Int8 = 0, i162: Int16 = 0, i322: Int32 = 0, i642: Int64 = 0, s2: Int16 = 0, si_22: Int16 = 0, ss2: Int16 = 0, ssi2: Int16 = 0, us2: UInt16 = 0, usi2: UInt16 = 0, l2: Int = 0, li2: Int = 0, sl2: Int = 0, sli2: Int = 0, ul2: UInt = 0, uli2: UInt = 0, ll2: Int64 = 0, lli2: Int64 = 0, sll2: Int64 = 0, slli2: Int64 = 0, ull2: UInt64 = 0, ulli2: UInt64 = 0, l642: Int64 = 0, f2: Float = 0.0, ft2: Float = 0.0, d2: Double = 0.0, dt2: Double = 0.0, ld2: Float80 = 0.0, dd2: Float80 = 0.0, p: UnsafeMutablePointer<Int32>! = nil, strct: somestruct = somestruct(), array16: [Int16] = [1, 2, 3, 4], bools: [Bool] = [true, true, true]) {
        self = wb_old()
        self._str = str
        self.b = b
        self._c = c
        self._sc = sc
        self._uc = uc
        self.i = i
        self.si = si
        self.sii = sii
        self.u = u
        self.ui = ui
        self.u8 = u8
        self.u16 = u16
        self.u32 = u32
        self.u64 = u64
        self.i8 = i8
        self.i16 = i16
        self.i32 = i32
        self.i64 = i64
        self.s = s
        self.si_2 = si_2
        self.ss = ss
        self.ssi = ssi
        self.us = us
        self.usi = usi
        self.l = l
        self.li = li
        self.sl = sl
        self.sli = sli
        self.ul = ul
        self.uli = uli
        self.ll = ll
        self.lli = lli
        self.sll = sll
        self.slli = slli
        self.ull = ull
        self.ulli = ulli
        self.l64 = l64
        self.f = f
        self.ft = ft
        self.d = d
        self.dt = dt
        self.ld = ld
        self.dd = dd
        self._str2 = str2
        self.b2 = b2
        self._c2 = c2
        self._sc2 = sc2
        self._uc2 = uc2
        self.i2 = i2
        self.si2 = si2
        self.sii2 = sii2
        self.u2 = u2
        self.ui2 = ui2
        self.u82 = u82
        self.u162 = u162
        self.u322 = u322
        self.u642 = u642
        self.i82 = i82
        self.i162 = i162
        self.i322 = i322
        self.i642 = i642
        self.s2 = s2
        self.si_22 = si_22
        self.ss2 = ss2
        self.ssi2 = ssi2
        self.us2 = us2
        self.usi2 = usi2
        self.l2 = l2
        self.li2 = li2
        self.sl2 = sl2
        self.sli2 = sli2
        self.ul2 = ul2
        self.uli2 = uli2
        self.ll2 = ll2
        self.lli2 = lli2
        self.sll2 = sll2
        self.slli2 = slli2
        self.ull2 = ull2
        self.ulli2 = ulli2
        self.l642 = l642
        self.f2 = f2
        self.ft2 = ft2
        self.d2 = d2
        self.dt2 = dt2
        self.ld2 = ld2
        self.dd2 = dd2
        self.p = p
        self.strct = strct
        self._array16 = array16
        self._bools = bools
    }

    /**
     * Create a `wb_old` from a dictionary.
     */
    public init(fromDictionary dictionary: [String: Any]) {
        self = wb_old()
        guard
            var str = dictionary["str"],
            let b = dictionary["b"] as? Bool,
            let c = dictionary["c"] as? Int8,
            let sc = dictionary["sc"] as? Int8,
            let uc = dictionary["uc"] as? UInt8,
            let i = dictionary["i"] as? Int32,
            let si = dictionary["si"] as? Int32,
            let sii = dictionary["sii"] as? Int32,
            let u = dictionary["u"] as? UInt32,
            let ui = dictionary["ui"] as? UInt32,
            let u8 = dictionary["u8"] as? UInt8,
            let u16 = dictionary["u16"] as? UInt16,
            let u32 = dictionary["u32"] as? UInt32,
            let u64 = dictionary["u64"] as? UInt64,
            let i8 = dictionary["i8"] as? Int8,
            let i16 = dictionary["i16"] as? Int16,
            let i32 = dictionary["i32"] as? Int32,
            let i64 = dictionary["i64"] as? Int64,
            let s = dictionary["s"] as? Int16,
            let si_2 = dictionary["si_2"] as? Int16,
            let ss = dictionary["ss"] as? Int16,
            let ssi = dictionary["ssi"] as? Int16,
            let us = dictionary["us"] as? UInt16,
            let usi = dictionary["usi"] as? UInt16,
            let l = dictionary["l"] as? Int,
            let li = dictionary["li"] as? Int,
            let sl = dictionary["sl"] as? Int,
            let sli = dictionary["sli"] as? Int,
            let ul = dictionary["ul"] as? UInt,
            let uli = dictionary["uli"] as? UInt,
            let ll = dictionary["ll"] as? Int64,
            let lli = dictionary["lli"] as? Int64,
            let sll = dictionary["sll"] as? Int64,
            let slli = dictionary["slli"] as? Int64,
            let ull = dictionary["ull"] as? UInt64,
            let ulli = dictionary["ulli"] as? UInt64,
            let l64 = dictionary["l64"] as? Int64,
            let f = dictionary["f"] as? Float,
            let ft = dictionary["ft"] as? Float,
            let d = dictionary["d"] as? Double,
            let dt = dictionary["dt"] as? Double,
            let ld = dictionary["ld"] as? Float80,
            let dd = dictionary["dd"] as? Float80,
            var str2 = dictionary["str2"],
            let b2 = dictionary["b2"] as? Bool,
            let c2 = dictionary["c2"] as? Int8,
            let sc2 = dictionary["sc2"] as? Int8,
            let uc2 = dictionary["uc2"] as? UInt8,
            let i2 = dictionary["i2"] as? Int32,
            let si2 = dictionary["si2"] as? Int32,
            let sii2 = dictionary["sii2"] as? Int32,
            let u2 = dictionary["u2"] as? UInt32,
            let ui2 = dictionary["ui2"] as? UInt32,
            let u82 = dictionary["u82"] as? UInt8,
            let u162 = dictionary["u162"] as? UInt16,
            let u322 = dictionary["u322"] as? UInt32,
            let u642 = dictionary["u642"] as? UInt64,
            let i82 = dictionary["i82"] as? Int8,
            let i162 = dictionary["i162"] as? Int16,
            let i322 = dictionary["i322"] as? Int32,
            let i642 = dictionary["i642"] as? Int64,
            let s2 = dictionary["s2"] as? Int16,
            let si_22 = dictionary["si_22"] as? Int16,
            let ss2 = dictionary["ss2"] as? Int16,
            let ssi2 = dictionary["ssi2"] as? Int16,
            let us2 = dictionary["us2"] as? UInt16,
            let usi2 = dictionary["usi2"] as? UInt16,
            let l2 = dictionary["l2"] as? Int,
            let li2 = dictionary["li2"] as? Int,
            let sl2 = dictionary["sl2"] as? Int,
            let sli2 = dictionary["sli2"] as? Int,
            let ul2 = dictionary["ul2"] as? UInt,
            let uli2 = dictionary["uli2"] as? UInt,
            let ll2 = dictionary["ll2"] as? Int64,
            let lli2 = dictionary["lli2"] as? Int64,
            let sll2 = dictionary["sll2"] as? Int64,
            let slli2 = dictionary["slli2"] as? Int64,
            let ull2 = dictionary["ull2"] as? UInt64,
            let ulli2 = dictionary["ulli2"] as? UInt64,
            let l642 = dictionary["l642"] as? Int64,
            let f2 = dictionary["f2"] as? Float,
            let ft2 = dictionary["ft2"] as? Float,
            let d2 = dictionary["d2"] as? Double,
            let dt2 = dictionary["dt2"] as? Double,
            let ld2 = dictionary["ld2"] as? Float80,
            let dd2 = dictionary["dd2"] as? Float80,
            let p = dictionary["p"] as? UnsafeMutablePointer<Int32>!,
            let strct = dictionary["strct"] as? somestruct,
            var array16 = dictionary["array16"],
            var bools = dictionary["bools"]
        else {
            fatalError("Unable to convert \(dictionary) to wb_old.")
        }
        self.str = withUnsafePointer(to: &str) {
            $0.withMemoryRebound(to: type(of: wb_old().str), capacity: 1) {
                $0.pointee
            }
        }
        self.b = b
        self.c = c
        self.sc = sc
        self.uc = uc
        self.i = i
        self.si = si
        self.sii = sii
        self.u = u
        self.ui = ui
        self.u8 = u8
        self.u16 = u16
        self.u32 = u32
        self.u64 = u64
        self.i8 = i8
        self.i16 = i16
        self.i32 = i32
        self.i64 = i64
        self.s = s
        self.si_2 = si_2
        self.ss = ss
        self.ssi = ssi
        self.us = us
        self.usi = usi
        self.l = l
        self.li = li
        self.sl = sl
        self.sli = sli
        self.ul = ul
        self.uli = uli
        self.ll = ll
        self.lli = lli
        self.sll = sll
        self.slli = slli
        self.ull = ull
        self.ulli = ulli
        self.l64 = l64
        self.f = f
        self.ft = ft
        self.d = d
        self.dt = dt
        self.ld = ld
        self.dd = dd
        self.str2 = withUnsafePointer(to: &str2) {
            $0.withMemoryRebound(to: type(of: wb_old().str2), capacity: 1) {
                $0.pointee
            }
        }
        self.b2 = b2
        self.c2 = c2
        self.sc2 = sc2
        self.uc2 = uc2
        self.i2 = i2
        self.si2 = si2
        self.sii2 = sii2
        self.u2 = u2
        self.ui2 = ui2
        self.u82 = u82
        self.u162 = u162
        self.u322 = u322
        self.u642 = u642
        self.i82 = i82
        self.i162 = i162
        self.i322 = i322
        self.i642 = i642
        self.s2 = s2
        self.si_22 = si_22
        self.ss2 = ss2
        self.ssi2 = ssi2
        self.us2 = us2
        self.usi2 = usi2
        self.l2 = l2
        self.li2 = li2
        self.sl2 = sl2
        self.sli2 = sli2
        self.ul2 = ul2
        self.uli2 = uli2
        self.ll2 = ll2
        self.lli2 = lli2
        self.sll2 = sll2
        self.slli2 = slli2
        self.ull2 = ull2
        self.ulli2 = ulli2
        self.l642 = l642
        self.f2 = f2
        self.ft2 = ft2
        self.d2 = d2
        self.dt2 = dt2
        self.ld2 = ld2
        self.dd2 = dd2
        self.p = p
        self.strct = strct
        self.array16 = withUnsafePointer(to: &array16) {
            $0.withMemoryRebound(to: type(of: wb_old().array16), capacity: 1) {
                $0.pointee
            }
        }
        self.bools = withUnsafePointer(to: &bools) {
            $0.withMemoryRebound(to: type(of: wb_old().bools), capacity: 1) {
                $0.pointee
            }
        }
    }

}

extension wb_old: CustomStringConvertible {

    /**
     * Convert to a description String.
     */
    public var description: String {
        var descString = ""
        descString += "str=\(self._str)"
        descString += ", "
        descString += "b=\(self.b)"
        descString += ", "
        descString += "c=\(self._c)"
        descString += ", "
        descString += "sc=\(self._sc)"
        descString += ", "
        descString += "uc=\(self._uc)"
        descString += ", "
        descString += "i=\(self.i)"
        descString += ", "
        descString += "si=\(self.si)"
        descString += ", "
        descString += "sii=\(self.sii)"
        descString += ", "
        descString += "u=\(self.u)"
        descString += ", "
        descString += "ui=\(self.ui)"
        descString += ", "
        descString += "u8=\(self.u8)"
        descString += ", "
        descString += "u16=\(self.u16)"
        descString += ", "
        descString += "u32=\(self.u32)"
        descString += ", "
        descString += "u64=\(self.u64)"
        descString += ", "
        descString += "i8=\(self.i8)"
        descString += ", "
        descString += "i16=\(self.i16)"
        descString += ", "
        descString += "i32=\(self.i32)"
        descString += ", "
        descString += "i64=\(self.i64)"
        descString += ", "
        descString += "s=\(self.s)"
        descString += ", "
        descString += "si_2=\(self.si_2)"
        descString += ", "
        descString += "ss=\(self.ss)"
        descString += ", "
        descString += "ssi=\(self.ssi)"
        descString += ", "
        descString += "us=\(self.us)"
        descString += ", "
        descString += "usi=\(self.usi)"
        descString += ", "
        descString += "l=\(self.l)"
        descString += ", "
        descString += "li=\(self.li)"
        descString += ", "
        descString += "sl=\(self.sl)"
        descString += ", "
        descString += "sli=\(self.sli)"
        descString += ", "
        descString += "ul=\(self.ul)"
        descString += ", "
        descString += "uli=\(self.uli)"
        descString += ", "
        descString += "ll=\(self.ll)"
        descString += ", "
        descString += "lli=\(self.lli)"
        descString += ", "
        descString += "sll=\(self.sll)"
        descString += ", "
        descString += "slli=\(self.slli)"
        descString += ", "
        descString += "ull=\(self.ull)"
        descString += ", "
        descString += "ulli=\(self.ulli)"
        descString += ", "
        descString += "l64=\(self.l64)"
        descString += ", "
        descString += "f=\(self.f)"
        descString += ", "
        descString += "ft=\(self.ft)"
        descString += ", "
        descString += "d=\(self.d)"
        descString += ", "
        descString += "dt=\(self.dt)"
        descString += ", "
        descString += "ld=\(self.ld)"
        descString += ", "
        descString += "dd=\(self.dd)"
        descString += ", "
        descString += "str2=\(self._str2)"
        descString += ", "
        descString += "b2=\(self.b2)"
        descString += ", "
        descString += "c2=\(self._c2)"
        descString += ", "
        descString += "sc2=\(self._sc2)"
        descString += ", "
        descString += "uc2=\(self._uc2)"
        descString += ", "
        descString += "i2=\(self.i2)"
        descString += ", "
        descString += "si2=\(self.si2)"
        descString += ", "
        descString += "sii2=\(self.sii2)"
        descString += ", "
        descString += "u2=\(self.u2)"
        descString += ", "
        descString += "ui2=\(self.ui2)"
        descString += ", "
        descString += "u82=\(self.u82)"
        descString += ", "
        descString += "u162=\(self.u162)"
        descString += ", "
        descString += "u322=\(self.u322)"
        descString += ", "
        descString += "u642=\(self.u642)"
        descString += ", "
        descString += "i82=\(self.i82)"
        descString += ", "
        descString += "i162=\(self.i162)"
        descString += ", "
        descString += "i322=\(self.i322)"
        descString += ", "
        descString += "i642=\(self.i642)"
        descString += ", "
        descString += "s2=\(self.s2)"
        descString += ", "
        descString += "si_22=\(self.si_22)"
        descString += ", "
        descString += "ss2=\(self.ss2)"
        descString += ", "
        descString += "ssi2=\(self.ssi2)"
        descString += ", "
        descString += "us2=\(self.us2)"
        descString += ", "
        descString += "usi2=\(self.usi2)"
        descString += ", "
        descString += "l2=\(self.l2)"
        descString += ", "
        descString += "li2=\(self.li2)"
        descString += ", "
        descString += "sl2=\(self.sl2)"
        descString += ", "
        descString += "sli2=\(self.sli2)"
        descString += ", "
        descString += "ul2=\(self.ul2)"
        descString += ", "
        descString += "uli2=\(self.uli2)"
        descString += ", "
        descString += "ll2=\(self.ll2)"
        descString += ", "
        descString += "lli2=\(self.lli2)"
        descString += ", "
        descString += "sll2=\(self.sll2)"
        descString += ", "
        descString += "slli2=\(self.slli2)"
        descString += ", "
        descString += "ull2=\(self.ull2)"
        descString += ", "
        descString += "ulli2=\(self.ulli2)"
        descString += ", "
        descString += "l642=\(self.l642)"
        descString += ", "
        descString += "f2=\(self.f2)"
        descString += ", "
        descString += "ft2=\(self.ft2)"
        descString += ", "
        descString += "d2=\(self.d2)"
        descString += ", "
        descString += "dt2=\(self.dt2)"
        descString += ", "
        descString += "ld2=\(self.ld2)"
        descString += ", "
        descString += "dd2=\(self.dd2)"
        descString += ", "
        descString += "p=\(self.p)"
        descString += ", "
        descString += "strct=\(self.strct)"
        descString += ", "
        if let first = self._array16.first {
            descString += "array16={"
            descString += self._array16.dropFirst().reduce("\(first)") { $0 + ",\($1)" }
            descString += "}"
        } else {
            descString += "array16={}"
        }
        descString += ", "
        if let first = self._bools.first {
            descString += "bools={"
            descString += self._bools.dropFirst().reduce("\(first)") { $0 + ",\($1)" }
            descString += "}"
        } else {
            descString += "bools={}"
        }
        return descString
    }

}

extension wb_old: Equatable {}

public func == (lhs: wb_old, rhs: wb_old) -> Bool {
    return lhs._str == rhs._str
        && lhs.b == rhs.b
        && lhs.c == rhs.c
        && lhs.sc == rhs.sc
        && lhs.uc == rhs.uc
        && lhs.i == rhs.i
        && lhs.si == rhs.si
        && lhs.sii == rhs.sii
        && lhs.u == rhs.u
        && lhs.ui == rhs.ui
        && lhs.u8 == rhs.u8
        && lhs.u16 == rhs.u16
        && lhs.u32 == rhs.u32
        && lhs.u64 == rhs.u64
        && lhs.i8 == rhs.i8
        && lhs.i16 == rhs.i16
        && lhs.i32 == rhs.i32
        && lhs.i64 == rhs.i64
        && lhs.s == rhs.s
        && lhs.si_2 == rhs.si_2
        && lhs.ss == rhs.ss
        && lhs.ssi == rhs.ssi
        && lhs.us == rhs.us
        && lhs.usi == rhs.usi
        && lhs.l == rhs.l
        && lhs.li == rhs.li
        && lhs.sl == rhs.sl
        && lhs.sli == rhs.sli
        && lhs.ul == rhs.ul
        && lhs.uli == rhs.uli
        && lhs.ll == rhs.ll
        && lhs.lli == rhs.lli
        && lhs.sll == rhs.sll
        && lhs.slli == rhs.slli
        && lhs.ull == rhs.ull
        && lhs.ulli == rhs.ulli
        && lhs.l64 == rhs.l64
        && lhs.f == rhs.f
        && lhs.ft == rhs.ft
        && lhs.d == rhs.d
        && lhs.dt == rhs.dt
        && lhs.ld == rhs.ld
        && lhs.dd == rhs.dd
        && lhs._str2 == rhs._str2
        && lhs.b2 == rhs.b2
        && lhs.c2 == rhs.c2
        && lhs.sc2 == rhs.sc2
        && lhs.uc2 == rhs.uc2
        && lhs.i2 == rhs.i2
        && lhs.si2 == rhs.si2
        && lhs.sii2 == rhs.sii2
        && lhs.u2 == rhs.u2
        && lhs.ui2 == rhs.ui2
        && lhs.u82 == rhs.u82
        && lhs.u162 == rhs.u162
        && lhs.u322 == rhs.u322
        && lhs.u642 == rhs.u642
        && lhs.i82 == rhs.i82
        && lhs.i162 == rhs.i162
        && lhs.i322 == rhs.i322
        && lhs.i642 == rhs.i642
        && lhs.s2 == rhs.s2
        && lhs.si_22 == rhs.si_22
        && lhs.ss2 == rhs.ss2
        && lhs.ssi2 == rhs.ssi2
        && lhs.us2 == rhs.us2
        && lhs.usi2 == rhs.usi2
        && lhs.l2 == rhs.l2
        && lhs.li2 == rhs.li2
        && lhs.sl2 == rhs.sl2
        && lhs.sli2 == rhs.sli2
        && lhs.ul2 == rhs.ul2
        && lhs.uli2 == rhs.uli2
        && lhs.ll2 == rhs.ll2
        && lhs.lli2 == rhs.lli2
        && lhs.sll2 == rhs.sll2
        && lhs.slli2 == rhs.slli2
        && lhs.ull2 == rhs.ull2
        && lhs.ulli2 == rhs.ulli2
        && lhs.l642 == rhs.l642
        && lhs.f2 == rhs.f2
        && lhs.ft2 == rhs.ft2
        && lhs.d2 == rhs.d2
        && lhs.dt2 == rhs.dt2
        && lhs.ld2 == rhs.ld2
        && lhs.dd2 == rhs.dd2
        && lhs.p == rhs.p
        && lhs._array16 == rhs._array16
        && lhs._bools == rhs._bools
}
