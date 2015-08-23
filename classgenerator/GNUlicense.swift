//
//  GNUlicense.swift
//  classgenerator
//
//  Created by Mick Hawkins on 23/08/2015.
//  Copyright (c) 2015 Mick Hawkins. All rights reserved.
//



func getCreatorDetailsCommentWB(data: ClassData) -> String {
    
    var comment = "/** \n" +
        " * file \(data.wb).h \n" +
        " * \n" +
        " * Created by \(data.userName) on \(data.creationDate)" +
        " * Copyright (c) \(data.year) \(data.userName) \n" +
        " * All rights reserved. \n" +
        " * \n"
    
    return comment
}

func getCreatorDetailsCommentCPP(data: ClassData) -> String {
    
    var comment = "/** \n" +
        " * file \(data.camel).h \n" +
        " * \n" +
        " * Created by \(data.userName) on \(data.creationDate)" +
        " * Copyright (c) \(data.year) \(data.userName) \n" +
        " * All rights reserved. \n" +
        " * \n"
    
    return comment
}


func getLicense(name: String) -> String {
    
    var license = " * Redistribution and use in source and binary forms, with or without \n" +
    " * modification, are permitted provided that the following conditions \n" +
    " * are met: \n" +
    " * \n" +
    " * 1. Redistributions of source code must retain the above copyright \n" +
    " *    notice, this list of conditions and the following disclaimer. \n" +
    " * \n" +
    " * 2. Redistributions in binary form must reproduce the above \n" +
    " *    copyright notice, this list of conditions and the following \n" +
    " *    disclaimer in the documentation and/or other materials \n" +
    " *    provided with the distribution. \n" +
    " * \n" +
    " * 3. All advertising materials mentioning features or use of this \n" +
    " *    software must display the following acknowledgement: \n" +
    " * \n" +
    " *    This product includes software developed by \(name). \n" +
    " * \n" +
    " * 4. Neither the name of the author nor the names of contributors \n" +
    " *    may be used to endorse or promote products derived from this \n" +
    " *    software without specific prior written permission. \n" +
    " * \n" +
    " * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \n" +
    " * 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT \n" +
    " * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR \n" +
    " * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER \n" +
    " * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, \n" +
    " * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, \n" +
    " * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR \n" +
    " * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF \n" +
    " * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING \n" +
    " * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS \n" +
    " * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. \n" +
    " * \n" +
    " * ----------------------------------------------------------------------- \n" +
    " * This program is free software; you can redistribute it and/or \n" +
    " * modify it under the above terms or under the terms of the GNU \n" +
    " * General Public License as published by the Free Software Foundation; \n" +
    " * either version 2 of the License, or (at your option) any later version. \n" +
    " * \n" +
    " * This program is distributed in the hope that it will be useful, \n" +
    " * but WITHOUT ANY WARRANTY; without even the implied warranty of \n" +
    " * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the \n" +
    " * GNU General Public License for more details. \n" +
    " * \n" +
    " * You should have received a copy of the GNU General Public License \n" +
    " * along with this program; if not, see http://www.gnu.org/licenses/ \n" +
    " * or write to the Free Software Foundation, Inc., 51 Franklin Street, \n" +
    " * Fifth Floor, Boston, MA  02110-1301, USA. \n" +
    " */ \n\n\n"
    
    return license
}


