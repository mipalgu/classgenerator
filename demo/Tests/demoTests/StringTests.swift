/*
 * StringTests.swift 
 * demoTests 
 *
 * Created by Callum McColl on 19/09/2017.
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
 * Fifth Floor, Boston, MA  021.000000-1.0000001, USA.
 *
 */

import bridge
@testable import demo

import CGUSimpleWhiteboard
import GUSimpleWhiteboard
import XCTest

//swiftlint:disable identifier_name

public class StringTests: XCTestCase {

    public static var allTests: [(String, (StringTests) -> () throws -> Void)] {
        return [
            ("test_cDescriptionEqualsExpectedDescription", test_cDescriptionEqualsExpectedDescription),
            ("test_cToStringEqualsExpectedToString", test_cToStringEqualsExpectedToString),
            ("test_cFromStringCreatesStructFromDescription", test_cFromStringCreatesStructFromDescription),
            ("test_cFromStringCreatesStructFromToString", test_cFromStringCreatesStructFromToString),
            ("test_cFromStringParsesPartialDescription", test_cFromStringParsesPartialDescription),
            ("test_cFromStringParsesPartialMixedDescription", test_cFromStringParsesPartialMixedDescription),
            ("test_cppDescriptionEqualsExpectedDescription", test_cppDescriptionEqualsExpectedDescription),
            ("test_cppToStringEqualsExpectedToString", test_cppToStringEqualsExpectedToString),
            ("test_cppFromStringCreatesStructFromDescription", test_cppFromStringCreatesStructFromDescription),
            ("test_cppFromStringCreatesStructFromToString", test_cppFromStringCreatesStructFromToString),
            ("test_cppFromStringParsesPartialDescription", test_cppFromStringParsesPartialDescription),
            ("test_cppFromStringParsesPartialMixedDescription", test_cppFromStringParsesPartialMixedDescription),
            ("test_swiftDescriptionEqualsExpectedDescription", test_swiftDescriptionEqualsExpectedDescription),
            ("test_swiftDescriptionCanBeConvertedToStruct", test_swiftDescriptionCanBeConvertedToStruct)
        ]
    }

    var demo: wb_demo = wb_demo(sub2: wb_sub(1, b: true), subs: [wb_sub(0), wb_sub(1, b: true), wb_sub(2)])

    //swiftlint:disable line_length
    let expectedDemoDescription: String = """
        str=hi, b=false, c=c, sc=c, uc=c, i=1, si=1, sii=1, u=1, ui=1, u8=1, u16=1, u32=1, u64=1, i8=1, i16=1, i32=1, i64=1, s=1, si_2=1, ss=1, ssi=1, us=1, usi=1, l=1, li=1, sl=1, sli=1, ul=1, uli=1, ll=1, lli=1, sll=1, slli=1, ull=1, ulli=1, f=1.000000, ft=1.000000, d=1.000000, dt=1.000000, str2=, b2=true, c2=, sc2=, uc2=, i2=0, si2=0, sii2=0, u2=0, ui2=0, u82=0, u162=0, u322=0, u642=0, i82=0, i162=0, i322=0, i642=0, s2=0, si_22=0, ss2=0, ssi2=0, us2=0, usi2=0, l2=0, li2=0, sl2=0, sli2=0, ul2=0, uli2=0, ll2=0, lli2=0, sll2=0, slli2=0, ull2=0, ulli2=0, f2=0.000000, ft2=0.000000, d2=0.000000, dt2=0.000000, array16={1, 2, 3, 4}, bools={true, true, true}, myBit=0, myBit2=1, sub1={i=0, b=false}, sub2={i=1, b=true}, subs={{i=0, b=false}, {i=1, b=true}, {i=2, b=false}}, cameraResolution=0, cameraResolution2=2
        """

    let expectedToString: String = """
        hi, false, c, c, c, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.000000, 1.000000, 1.000000, 1.000000, , true, , , , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.000000, 0.000000, 0.000000, 0.000000, {1, 2, 3, 4}, {true, true, true}, 0, 1, {0, false}, {1, true}, {{0, false}, {1, true}, {2, false}}, 0, 2
        """

    var cDescription: String {
        let buffer = ContiguousArray<CChar>(repeating: 0, count: Int(DEMO_DESC_BUFFER_SIZE))
        return String(cString: buffer.withUnsafeBufferPointer {
            wb_demo_description(&self.demo, UnsafeMutablePointer(mutating: $0.baseAddress), Int(DEMO_DESC_BUFFER_SIZE))
        })
    }

    var cToString: String {
        let buffer = ContiguousArray<CChar>(repeating: 0, count: Int(DEMO_TO_STRING_BUFFER_SIZE))
        return String(cString: buffer.withUnsafeBufferPointer {
            wb_demo_to_string(&self.demo, UnsafeMutablePointer(mutating: $0.baseAddress), Int(DEMO_TO_STRING_BUFFER_SIZE))
        })
    }

    var cppDescription: String {
        let buffer = ContiguousArray<CChar>(repeating: 0, count: Int(DEMO_DESC_BUFFER_SIZE))
        return String(cString: buffer.withUnsafeBufferPointer {
            cpp_description(&self.demo, UnsafeMutablePointer(mutating: $0.baseAddress), Int(DEMO_DESC_BUFFER_SIZE))
        })
    }

    var cppToString: String {
        let buffer = ContiguousArray<CChar>(repeating: 0, count: Int(DEMO_DESC_BUFFER_SIZE))
        return String(cString: buffer.withUnsafeBufferPointer {
            cpp_to_string(&self.demo, UnsafeMutablePointer(mutating: $0.baseAddress), Int(DEMO_DESC_BUFFER_SIZE))
        })
    }

    public override func setUp() {
        self.demo = wb_demo("hi", sub2: wb_sub(1, b: true), subs: [wb_sub(0), wb_sub(1, b: true), wb_sub(2)])
    }

    public func test_cDescriptionEqualsExpectedDescription() {
        XCTAssertEqual(self.expectedDemoDescription, self.cDescription)
    }

    public func test_cToStringEqualsExpectedToString() {
        XCTAssertEqual(self.expectedToString, self.cToString)
    }

    public func test_cFromStringCreatesStructFromDescription() {
        var target: wb_demo = wb_demo()
        let result = self.expectedDemoDescription.utf8CString.withUnsafeBufferPointer {
            wb_demo_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(self.demo, r.pointee)
    }

    public func test_cFromStringCreatesStructFromToString() {
        var target: wb_demo = wb_demo()
        let result = self.expectedToString.utf8CString.withUnsafeBufferPointer {
            wb_demo_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(self.demo, r.pointee)
    }

    public func test_cFromStringParsesPartialDescription() {
        var target: wb_demo = wb_demo.make()
        let str = "str2=abc"
        let result = str.utf8CString.withUnsafeBufferPointer {
            wb_demo_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(wb_demo(str2: "abc"), r.pointee)
    }

    public func test_cFromStringParsesPartialMixedDescription() {
        var target: wb_demo = wb_demo(subs: [wb_sub(0), wb_sub(0), wb_sub(0)])
        let str = "array16={4, 3, 2, 1}, str2=cba, subs={{b=true}, {b=false}, {b=true}}"
        let result = str.utf8CString.withUnsafeBufferPointer {
            wb_demo_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        let expected = wb_demo(
            str2: "cba",
            array16: [4, 3, 2, 1],
            subs: [wb_sub(b: true), wb_sub(b: false), wb_sub(b: true)]
        )
        XCTAssertEqual(expected, r.pointee)
    }

    public func test_cppDescriptionEqualsExpectedDescription() {
        let expected = self.expectedDemoDescription
            .replacingOccurrences(of: "0.000000", with: "0")
            .replacingOccurrences(of: "1.000000", with: "1")
        let result = self.cppDescription
            .replacingOccurrences(of: "0.000000", with: "0")
            .replacingOccurrences(of: "1.000000", with: "1")
        XCTAssertEqual(expected, result)
    }

    public func test_cppToStringEqualsExpectedToString() {
        let expected = self.expectedToString
            .replacingOccurrences(of: "0.000000", with: "0")
            .replacingOccurrences(of: "1.000000", with: "1")
        let result = self.cppToString
            .replacingOccurrences(of: "0.000000", with: "0")
            .replacingOccurrences(of: "1.000000", with: "1")
        XCTAssertEqual(expected, result)
    }

    public func test_cppFromStringCreatesStructFromDescription() {
        var target: wb_demo = wb_demo()
        let result = self.expectedDemoDescription.utf8CString.withUnsafeBufferPointer {
            cpp_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(self.demo, r.pointee)
    }

    public func test_cppFromStringCreatesStructFromToString() {
        var target: wb_demo = wb_demo()
        let result = self.expectedToString.utf8CString.withUnsafeBufferPointer {
            cpp_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(self.demo, r.pointee)
    }

    public func test_cppFromStringParsesPartialDescription() {
        var target: wb_demo = wb_demo.make()
        let str = "str2=abc"
        let result = str.utf8CString.withUnsafeBufferPointer {
            cpp_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(wb_demo(str2: "abc"), r.pointee)
    }

    public func test_cppFromStringParsesPartialMixedDescription() {
        var target: wb_demo = wb_demo(subs: [wb_sub(0), wb_sub(0), wb_sub(0)])
        let str = "array16={4, 3, 2, 1}, str2=cba, subs={{b=true}, {b=false}, {b=true}}"
        let result = str.utf8CString.withUnsafeBufferPointer {
            cpp_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        let expected = wb_demo(
            str2: "cba",
            array16: [4, 3, 2, 1],
            subs: [wb_sub(b: true), wb_sub(b: false), wb_sub(b: true)]
        )
        XCTAssertEqual(expected, r.pointee)
    }

    public func test_swiftDescriptionEqualsExpectedDescription() {
        let expected = self.expectedDemoDescription
            .replacingOccurrences(of: "0.000000", with: "0.0")
            .replacingOccurrences(of: "1.000000", with: "1.0")
        XCTAssertEqual(expected, "\(self.demo)")
    }

    public func test_swiftDescriptionCanBeConvertedToStruct() {
        var target = wb_demo("tar")
        let description = "\(self.demo)"
        let result = description.utf8CString.withUnsafeBufferPointer {
            wb_demo_from_string(&target, UnsafeMutablePointer(mutating: $0.baseAddress))
        }
        XCTAssertNotNil(result)
        guard let r = result else {
            return
        }
        XCTAssertEqual(r.pointee, self.demo)
        XCTAssertEqual(r.pointee, target)
    }

}
