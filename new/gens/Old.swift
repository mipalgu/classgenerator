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

    public init(str: String = "hello", b: Bool = false, c: String = "c", sc: String = "c", uc: String = "c", i: Int = 1, si: Int = 1, sii: Int = 1, u: UInt = 1, ui: UInt = 1, u8: UInt8 = 1, u16: UInt16 = 1, u32: UInt32 = 1, u64: UInt64 = 1, i8: Int8 = 1, i16: Int16 = 1, i32: Int32 = 1, i64: Int64 = 1, s: Int16 = 1, si: Int16 = 1, ss: Int16 = 1, ssi: Int16 = 1, us: UInt16 = 1, usi: UInt16 = 1, l: Int32 = 1, li: Int32 = 1, sl: Int32 = 1, sli: Int32 = 1, ul: UInt32 = 1, uli: UInt32 = 1, ll: Int64 = 1, lli: Int64 = 1, sll: Int64 = 1, slli: Int64 = 1, ull: UInt64 = 1, ulli: UInt64 = 1, l64: Int64 = 1, f: Float = 1.0, ft: Float = 1.0, d: Double = 1.0, dt: Double = 1.0, ld: Float80 = 1.0, dd: Float80 = 1.0, str2: String = "", b2: Bool = true, c2: String = String(Character(UnicodeScalar(UInt8.min))), sc2: String = String(Character(UnicodeScalar(UInt8.min))), uc2: String = String(Character(UnicodeScalar(UInt8.min))), i2: Int = 0, si2: Int = 0, sii2: Int = 0, u2: UInt = 0, ui2: UInt = 0, u82: UInt8 = 0, u162: UInt16 = 0, u322: UInt32 = 0, u642: UInt64 = 0, i82: Int8 = 0, i162: Int16 = 0, i322: Int32 = 0, i642: Int64 = 0, s2: Int16 = 0, si2: Int16 = 0, ss2: Int16 = 0, ssi2: Int16 = 0, us2: UInt16 = 0, usi2: UInt16 = 0, l2: Int32 = 0, li2: Int32 = 0, sl2: Int32 = 0, sli2: Int32 = 0, ul2: UInt32 = 0, uli2: UInt32 = 0, ll2: Int64 = 0, lli2: Int64 = 0, sll2: Int64 = 0, slli2: Int64 = 0, ull2: UInt64 = 0, ulli2: UInt64 = 0, l642: Int64 = 0, f2: Float = 0.0, ft2: Float = 0.0, d2: Double = 0.0, dt2: Double = 0.0, ld2: Float80 = 0.0, dd2: Float80 = 0.0, p: UnsafeMutablePointer<Int>? = nil, strct: somestruct = somestruct(), array16: Int16 = [1, 2, 3, 4], bools: Bool = [true, true, true]) {
        self.str = str
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
        self.si = si
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
        self.str2 = str2
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
        self.si2 = si2
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
        self.array16 = array16
        self.bools = bools
    }

    /**
     * Create a `wb_old` from a dictionary.
     */
    public init(fromDictionary dictionary: [String: Any]) {
        guard
            let str = dictionary["str"] as? String,
            let b = dictionary["b"] as? Bool,
            let c = dictionary["c"] as? String,
            let sc = dictionary["sc"] as? String,
            let uc = dictionary["uc"] as? String,
            let i = dictionary["i"] as? Int,
            let si = dictionary["si"] as? Int,
            let sii = dictionary["sii"] as? Int,
            let u = dictionary["u"] as? UInt,
            let ui = dictionary["ui"] as? UInt,
            let u8 = dictionary["u8"] as? UInt8,
            let u16 = dictionary["u16"] as? UInt16,
            let u32 = dictionary["u32"] as? UInt32,
            let u64 = dictionary["u64"] as? UInt64,
            let i8 = dictionary["i8"] as? Int8,
            let i16 = dictionary["i16"] as? Int16,
            let i32 = dictionary["i32"] as? Int32,
            let i64 = dictionary["i64"] as? Int64,
            let s = dictionary["s"] as? Int16,
            let si = dictionary["si"] as? Int16,
            let ss = dictionary["ss"] as? Int16,
            let ssi = dictionary["ssi"] as? Int16,
            let us = dictionary["us"] as? UInt16,
            let usi = dictionary["usi"] as? UInt16,
            let l = dictionary["l"] as? Int32,
            let li = dictionary["li"] as? Int32,
            let sl = dictionary["sl"] as? Int32,
            let sli = dictionary["sli"] as? Int32,
            let ul = dictionary["ul"] as? UInt32,
            let uli = dictionary["uli"] as? UInt32,
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
            let str2 = dictionary["str2"] as? String,
            let b2 = dictionary["b2"] as? Bool,
            let c2 = dictionary["c2"] as? String,
            let sc2 = dictionary["sc2"] as? String,
            let uc2 = dictionary["uc2"] as? String,
            let i2 = dictionary["i2"] as? Int,
            let si2 = dictionary["si2"] as? Int,
            let sii2 = dictionary["sii2"] as? Int,
            let u2 = dictionary["u2"] as? UInt,
            let ui2 = dictionary["ui2"] as? UInt,
            let u82 = dictionary["u82"] as? UInt8,
            let u162 = dictionary["u162"] as? UInt16,
            let u322 = dictionary["u322"] as? UInt32,
            let u642 = dictionary["u642"] as? UInt64,
            let i82 = dictionary["i82"] as? Int8,
            let i162 = dictionary["i162"] as? Int16,
            let i322 = dictionary["i322"] as? Int32,
            let i642 = dictionary["i642"] as? Int64,
            let s2 = dictionary["s2"] as? Int16,
            let si2 = dictionary["si2"] as? Int16,
            let ss2 = dictionary["ss2"] as? Int16,
            let ssi2 = dictionary["ssi2"] as? Int16,
            let us2 = dictionary["us2"] as? UInt16,
            let usi2 = dictionary["usi2"] as? UInt16,
            let l2 = dictionary["l2"] as? Int32,
            let li2 = dictionary["li2"] as? Int32,
            let sl2 = dictionary["sl2"] as? Int32,
            let sli2 = dictionary["sli2"] as? Int32,
            let ul2 = dictionary["ul2"] as? UInt32,
            let uli2 = dictionary["uli2"] as? UInt32,
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
            let p = dictionary["p"] as? UnsafeMutablePointer<Int>?,
            let strct = dictionary["strct"] as? somestruct,
            let array16 = dictionary["array16"] as? [Int16],
            let bools = dictionary["bools"] as? [Bool]
        else {
            fatalError("Unable to convert \(dictionary) to wb_old.")
        }
        self.str = str
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
        self.si = si
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
        self.str2 = str2
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
        self.si2 = si2
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
        self.array16 = array16
        self.bools = bools
    }
}

extension wb_old: CustomStringConvertible {

/** convert to a description string */
    public var description: String {

        var descString = ""

        descString += "str= \(str) "
        descString += ", "
        descString += "b= \(b) "
        descString += ", "
        descString += "c= \(c) "
        descString += ", "
        descString += "sc= \(sc) "
        descString += ", "
        descString += "uc= \(uc) "
        descString += ", "
        descString += "i= \(i) "
        descString += ", "
        descString += "si= \(si) "
        descString += ", "
        descString += "sii= \(sii) "
        descString += ", "
        descString += "u= \(u) "
        descString += ", "
        descString += "ui= \(ui) "
        descString += ", "
        descString += "u8= \(u8) "
        descString += ", "
        descString += "u16= \(u16) "
        descString += ", "
        descString += "u32= \(u32) "
        descString += ", "
        descString += "u64= \(u64) "
        descString += ", "
        descString += "i8= \(i8) "
        descString += ", "
        descString += "i16= \(i16) "
        descString += ", "
        descString += "i32= \(i32) "
        descString += ", "
        descString += "i64= \(i64) "
        descString += ", "
        descString += "s= \(s) "
        descString += ", "
        descString += "si= \(si) "
        descString += ", "
        descString += "ss= \(ss) "
        descString += ", "
        descString += "ssi= \(ssi) "
        descString += ", "
        descString += "us= \(us) "
        descString += ", "
        descString += "usi= \(usi) "
        descString += ", "
        descString += "l= \(l) "
        descString += ", "
        descString += "li= \(li) "
        descString += ", "
        descString += "sl= \(sl) "
        descString += ", "
        descString += "sli= \(sli) "
        descString += ", "
        descString += "ul= \(ul) "
        descString += ", "
        descString += "uli= \(uli) "
        descString += ", "
        descString += "ll= \(ll) "
        descString += ", "
        descString += "lli= \(lli) "
        descString += ", "
        descString += "sll= \(sll) "
        descString += ", "
        descString += "slli= \(slli) "
        descString += ", "
        descString += "ull= \(ull) "
        descString += ", "
        descString += "ulli= \(ulli) "
        descString += ", "
        descString += "l64= \(l64) "
        descString += ", "
        descString += "f= \(f) "
        descString += ", "
        descString += "ft= \(ft) "
        descString += ", "
        descString += "d= \(d) "
        descString += ", "
        descString += "dt= \(dt) "
        descString += ", "
        descString += "ld= \(ld) "
        descString += ", "
        descString += "dd= \(dd) "
        descString += ", "
        descString += "str2= \(str2) "
        descString += ", "
        descString += "b2= \(b2) "
        descString += ", "
        descString += "c2= \(c2) "
        descString += ", "
        descString += "sc2= \(sc2) "
        descString += ", "
        descString += "uc2= \(uc2) "
        descString += ", "
        descString += "i2= \(i2) "
        descString += ", "
        descString += "si2= \(si2) "
        descString += ", "
        descString += "sii2= \(sii2) "
        descString += ", "
        descString += "u2= \(u2) "
        descString += ", "
        descString += "ui2= \(ui2) "
        descString += ", "
        descString += "u82= \(u82) "
        descString += ", "
        descString += "u162= \(u162) "
        descString += ", "
        descString += "u322= \(u322) "
        descString += ", "
        descString += "u642= \(u642) "
        descString += ", "
        descString += "i82= \(i82) "
        descString += ", "
        descString += "i162= \(i162) "
        descString += ", "
        descString += "i322= \(i322) "
        descString += ", "
        descString += "i642= \(i642) "
        descString += ", "
        descString += "s2= \(s2) "
        descString += ", "
        descString += "si2= \(si2) "
        descString += ", "
        descString += "ss2= \(ss2) "
        descString += ", "
        descString += "ssi2= \(ssi2) "
        descString += ", "
        descString += "us2= \(us2) "
        descString += ", "
        descString += "usi2= \(usi2) "
        descString += ", "
        descString += "l2= \(l2) "
        descString += ", "
        descString += "li2= \(li2) "
        descString += ", "
        descString += "sl2= \(sl2) "
        descString += ", "
        descString += "sli2= \(sli2) "
        descString += ", "
        descString += "ul2= \(ul2) "
        descString += ", "
        descString += "uli2= \(uli2) "
        descString += ", "
        descString += "ll2= \(ll2) "
        descString += ", "
        descString += "lli2= \(lli2) "
        descString += ", "
        descString += "sll2= \(sll2) "
        descString += ", "
        descString += "slli2= \(slli2) "
        descString += ", "
        descString += "ull2= \(ull2) "
        descString += ", "
        descString += "ulli2= \(ulli2) "
        descString += ", "
        descString += "l642= \(l642) "
        descString += ", "
        descString += "f2= \(f2) "
        descString += ", "
        descString += "ft2= \(ft2) "
        descString += ", "
        descString += "d2= \(d2) "
        descString += ", "
        descString += "dt2= \(dt2) "
        descString += ", "
        descString += "ld2= \(ld2) "
        descString += ", "
        descString += "dd2= \(dd2) "
        descString += ", "
        descString += "p= \(p) "
        descString += ", "
        descString += "strct= \(strct) "
        descString += ", "

        var array16_first = true

        descString += "array16={"

        for i in 0...OLD_ARRAY16_ARRAY_SIZE-1 {

            descString += array16_first ? "" : ","
            descString += "\(array16[i])"

            array16_first = false
        }

        descString += "}"

        descString += ", "

        var bools_first = true

        descString += "bools={"

        for i in 0...OLD_BOOLS_ARRAY_SIZE-1 {

            descString += bools_first ? "" : ","
            descString += "\(bools[i])"

            bools_first = false
        }

        descString += "}"

        return descString
  }
}

extension wb_old: Equatable {}

public func == (lhs: wb_old, rhs: wb_old) -> Bool {
    return lhs.str == rhs.str
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
        && lhs.si == rhs.si
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
        && lhs.str2 == rhs.str2
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
        && lhs.si2 == rhs.si2
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
        && lhs.strct == rhs.strct
        && lhs.array16 == rhs.array16
        && lhs.bools == rhs.bools
}
