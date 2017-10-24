/*
 * Sections.swift 
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

public struct Sections {

    let author: (Int, String)

    let preC: (Int, String)?

    let variables: (Int, String)

    let comments: (Int, String)?

    let postC: (Int, String)?

    let preCpp: (Int, String)?

    let embeddedCpp: (Int, String)?

    let postCpp: (Int, String)?

    let preSwift: (Int, String)?

    let embeddedSwift: (Int, String)?

    let postSwift: (Int, String)?

}

extension Sections: Equatable {}

public func == (lhs: Sections, rhs: Sections) -> Bool {
    return lhs.author == rhs.author
        && lhs.preC?.0 == rhs.preC?.0 && lhs.preC?.1 == rhs.preC?.1
        && lhs.variables == rhs.variables
        && lhs.comments?.0 == rhs.comments?.0
        && lhs.comments?.1 == rhs.comments?.1
        && lhs.postC?.0 == rhs.postC?.0 && lhs.postC?.1 == rhs.postC?.1
        && lhs.preCpp?.0 == rhs.preCpp?.0 && lhs.preCpp?.1 == rhs.preCpp?.1
        && lhs.embeddedCpp?.0 == rhs.embeddedCpp?.0 && lhs.embeddedCpp?.1 == rhs.embeddedCpp?.1
        && lhs.postCpp?.0 == rhs.postCpp?.0 && lhs.postCpp?.1 == rhs.postCpp?.1
        && lhs.preSwift?.0 == rhs.preSwift?.0 && lhs.preSwift?.1 == rhs.preSwift?.1
        && lhs.embeddedSwift?.0 == rhs.embeddedSwift?.0 && lhs.embeddedSwift?.1 == rhs.embeddedSwift?.1
        && lhs.postSwift?.0 == rhs.postSwift?.0 && lhs.postSwift?.1 == rhs.postSwift?.1
}
