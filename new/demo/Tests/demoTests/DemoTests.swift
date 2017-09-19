/*
 * DemoTests.swift 
 * demoTests 
 *
 * Created by Callum McColl on 20/09/2017.
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

import bridge
@testable import demo

import CGUSimpleWhiteboard
import GUSimpleWhiteboard
import XCTest

//swiftlint:disable file_length
//swiftlint:disable:next type_body_length
public class DemoTests: XCTestCase {

    public static var allTests: [(String, (DemoTests) -> () throws -> Void)] {
        return [
            ("test_equality", test_equality)
        ]
    }

    var demo: wb_demo = wb_demo()

    public override func setUp() {
        self.demo = wb_demo(str: "hi")
    }

    //swiftlint:disable:next function_body_length
    public func test_equality() {
        let lhs = self.demo
        var rhs = lhs
        XCTAssertEqual(lhs, rhs)
        rhs._str = "2"
        XCTAssertNotEqual(lhs, rhs)
        rhs._str = lhs._str
        XCTAssertEqual(lhs, rhs)
        rhs.b = true
        XCTAssertNotEqual(lhs, rhs)
        rhs.b = lhs.b
        XCTAssertEqual(lhs, rhs)
        rhs._c = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.c = lhs.c
        XCTAssertEqual(lhs, rhs)
        rhs._sc = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.sc = lhs.sc
        XCTAssertEqual(lhs, rhs)
        rhs._uc = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.uc = lhs.uc
        XCTAssertEqual(lhs, rhs)
        rhs.i = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i = lhs.i
        XCTAssertEqual(lhs, rhs)
        rhs.si = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.si = lhs.si
        XCTAssertEqual(lhs, rhs)
        rhs.sii = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sii = lhs.sii
        XCTAssertEqual(lhs, rhs)
        rhs.u = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u = lhs.u
        XCTAssertEqual(lhs, rhs)
        rhs.ui = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ui = lhs.ui
        XCTAssertEqual(lhs, rhs)
        rhs.u8 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u8 = lhs.u8
        XCTAssertEqual(lhs, rhs)
        rhs.u16 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u16 = lhs.u16
        XCTAssertEqual(lhs, rhs)
        rhs.u32 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u32 = lhs.u32
        XCTAssertEqual(lhs, rhs)
        rhs.u64 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u64 = lhs.u64
        XCTAssertEqual(lhs, rhs)
        rhs.i8 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i8 = lhs.i8
        XCTAssertEqual(lhs, rhs)
        rhs.i16 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i16 = lhs.i16
        XCTAssertEqual(lhs, rhs)
        rhs.i32 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i32 = lhs.i32
        XCTAssertEqual(lhs, rhs)
        rhs.i64 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i64 = lhs.i64
        XCTAssertEqual(lhs, rhs)
        rhs.s = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.s = lhs.s
        XCTAssertEqual(lhs, rhs)
        rhs.si_2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.si_2 = lhs.si_2
        XCTAssertEqual(lhs, rhs)
        rhs.ss = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ss = lhs.ss
        XCTAssertEqual(lhs, rhs)
        rhs.ssi = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ssi = lhs.ssi
        XCTAssertEqual(lhs, rhs)
        rhs.us = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.us = lhs.us
        XCTAssertEqual(lhs, rhs)
        rhs.usi = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.usi = lhs.usi
        XCTAssertEqual(lhs, rhs)
        rhs.l = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.l = lhs.l
        XCTAssertEqual(lhs, rhs)
        rhs.li = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.li = lhs.li
        XCTAssertEqual(lhs, rhs)
        rhs.sl = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sl = lhs.sl
        XCTAssertEqual(lhs, rhs)
        rhs.sli = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sli = lhs.sli
        XCTAssertEqual(lhs, rhs)
        rhs.ul = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ul = lhs.ul
        XCTAssertEqual(lhs, rhs)
        rhs.uli = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.uli = lhs.uli
        XCTAssertEqual(lhs, rhs)
        rhs.ll = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ll = lhs.ll
        XCTAssertEqual(lhs, rhs)
        rhs.lli = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.lli = lhs.lli
        XCTAssertEqual(lhs, rhs)
        rhs.sll = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sll = lhs.sll
        XCTAssertEqual(lhs, rhs)
        rhs.slli = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.slli = lhs.slli
        XCTAssertEqual(lhs, rhs)
        rhs.ull = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ull = lhs.ull
        XCTAssertEqual(lhs, rhs)
        rhs.ulli = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ulli = lhs.ulli
        XCTAssertEqual(lhs, rhs)
        rhs.f = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.f = lhs.f
        XCTAssertEqual(lhs, rhs)
        rhs.ft = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.ft = lhs.ft
        XCTAssertEqual(lhs, rhs)
        rhs.d = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.d = lhs.d
        XCTAssertEqual(lhs, rhs)
        rhs.dt = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.dt = lhs.dt
        XCTAssertEqual(lhs, rhs)
        rhs._str2 = "2"
        XCTAssertNotEqual(lhs, rhs)
        rhs._str2 = lhs._str2
        XCTAssertEqual(lhs, rhs)
        rhs.b2 = false
        XCTAssertNotEqual(lhs, rhs)
        rhs.b2 = lhs.b2
        XCTAssertEqual(lhs, rhs)
        rhs._c2 = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.c2 = lhs.c2
        XCTAssertEqual(lhs, rhs)
        rhs._sc2 = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.sc2 = lhs.sc2
        XCTAssertEqual(lhs, rhs)
        rhs._uc2 = "d"
        XCTAssertNotEqual(lhs, rhs)
        rhs.uc2 = lhs.uc2
        XCTAssertEqual(lhs, rhs)
        rhs.i2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i2 = lhs.i2
        XCTAssertEqual(lhs, rhs)
        rhs.si2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.si2 = lhs.si2
        XCTAssertEqual(lhs, rhs)
        rhs.sii2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sii2 = lhs.sii2
        XCTAssertEqual(lhs, rhs)
        rhs.u2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u2 = lhs.u2
        XCTAssertEqual(lhs, rhs)
        rhs.ui2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ui2 = lhs.ui2
        XCTAssertEqual(lhs, rhs)
        rhs.u82 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u82 = lhs.u82
        XCTAssertEqual(lhs, rhs)
        rhs.u162 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u162 = lhs.u162
        XCTAssertEqual(lhs, rhs)
        rhs.u322 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u322 = lhs.u322
        XCTAssertEqual(lhs, rhs)
        rhs.u642 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.u642 = lhs.u642
        XCTAssertEqual(lhs, rhs)
        rhs.i82 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i82 = lhs.i82
        XCTAssertEqual(lhs, rhs)
        rhs.i162 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i162 = lhs.i162
        XCTAssertEqual(lhs, rhs)
        rhs.i322 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i322 = lhs.i322
        XCTAssertEqual(lhs, rhs)
        rhs.i642 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.i642 = lhs.i642
        XCTAssertEqual(lhs, rhs)
        rhs.s2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.s2 = lhs.s2
        XCTAssertEqual(lhs, rhs)
        rhs.si_22 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.si_22 = lhs.si_22
        XCTAssertEqual(lhs, rhs)
        rhs.ss2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ss2 = lhs.ss2
        XCTAssertEqual(lhs, rhs)
        rhs.ssi2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ssi2 = lhs.ssi2
        XCTAssertEqual(lhs, rhs)
        rhs.us2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.us2 = lhs.us2
        XCTAssertEqual(lhs, rhs)
        rhs.usi2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.usi2 = lhs.usi2
        XCTAssertEqual(lhs, rhs)
        rhs.l2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.l2 = lhs.l2
        XCTAssertEqual(lhs, rhs)
        rhs.li2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.li2 = lhs.li2
        XCTAssertEqual(lhs, rhs)
        rhs.sl2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sl2 = lhs.sl2
        XCTAssertEqual(lhs, rhs)
        rhs.sli2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sli2 = lhs.sli2
        XCTAssertEqual(lhs, rhs)
        rhs.ul2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ul2 = lhs.ul2
        XCTAssertEqual(lhs, rhs)
        rhs.uli2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.uli2 = lhs.uli2
        XCTAssertEqual(lhs, rhs)
        rhs.ll2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ll2 = lhs.ll2
        XCTAssertEqual(lhs, rhs)
        rhs.lli2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.lli2 = lhs.lli2
        XCTAssertEqual(lhs, rhs)
        rhs.sll2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.sll2 = lhs.sll2
        XCTAssertEqual(lhs, rhs)
        rhs.slli2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.slli2 = lhs.slli2
        XCTAssertEqual(lhs, rhs)
        rhs.ull2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ull2 = lhs.ull2
        XCTAssertEqual(lhs, rhs)
        rhs.ulli2 = 2
        XCTAssertNotEqual(lhs, rhs)
        rhs.ulli2 = lhs.ulli2
        XCTAssertEqual(lhs, rhs)
        rhs.f2 = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.f2 = lhs.f2
        XCTAssertEqual(lhs, rhs)
        rhs.ft2 = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.ft2 = lhs.ft2
        XCTAssertEqual(lhs, rhs)
        rhs.d2 = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.d2 = lhs.d2
        XCTAssertEqual(lhs, rhs)
        rhs.dt2 = 2.0
        XCTAssertNotEqual(lhs, rhs)
        rhs.dt2 = lhs.dt2
        XCTAssertEqual(lhs, rhs)
    }

}
