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

    public let author: String

    public let preC: String?

    public let variables: String

    public let comments: String?
    
    public let embeddedC: String?

    public let preCFile: String?

    public let postCFile: String?

    public let postC: String?

    public let preCpp: String?

    public let embeddedCpp: String?

    public let postCpp: String?

    public let preSwift: String?

    public let embeddedSwift: String?

    public let postSwift: String?

    public init(
        author: String,
        preC: String? = nil,
        variables: String,
        comments: String? = nil,
        embeddedC: String? = nil,
        preCFile: String? = nil,
        postCFile: String? = nil,
        postC: String? = nil,
        preCpp: String? = nil,
        embeddedCpp: String? = nil,
        postCpp: String? = nil,
        preSwift: String? = nil,
        embeddedSwift: String? = nil,
        postSwift: String? = nil
    ) {
        self.author = author
        self.preC = preC
        self.variables = variables
        self.comments = comments
        self.embeddedC = embeddedC
        self.preCFile = preCFile
        self.postCFile = postCFile
        self.postC = postC
        self.preCpp = preCpp
        self.embeddedCpp = embeddedCpp
        self.postCpp = postCpp
        self.preSwift = preSwift
        self.embeddedSwift = embeddedSwift
        self.postSwift = postSwift
    }

}

extension Sections: Equatable {}

public func == (lhs: Sections, rhs: Sections) -> Bool {
    return lhs.author == rhs.author
        && lhs.preC == rhs.preC
        && lhs.variables == rhs.variables
        && lhs.comments == rhs.comments
        && lhs.embeddedC == rhs.embeddedC
        && lhs.postC == rhs.postC
        && lhs.preCpp == rhs.preCpp
        && lhs.embeddedCpp == rhs.embeddedCpp
        && lhs.postCpp == rhs.postCpp
        && lhs.preSwift == rhs.preSwift
        && lhs.embeddedSwift == rhs.embeddedSwift
        && lhs.postSwift == rhs.postSwift
}
