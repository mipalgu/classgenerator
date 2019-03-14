/*
 * CFileCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl on 24/08/2017.
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

import Containers
import Data
import Helpers

public final class CFileCreator: ErrorContainer {

    public let errors: [String] = []

    public var lastError: String? {
        return self.errors.last
    }

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let descriptionCreator: CDescriptionCreator
    fileprivate let networkSerialiserCreator: CNetworkSerialiserCreator
    fileprivate let networkDeserialiserCreator: CNetworkDeserialiserCreator
    fileprivate let fromStringCreator: CFromStringCreator<FromStringImplementationCreator>

    public init(
        creatorHelpers: CreatorHelpers = CreatorHelpers(),
        descriptionCreator: CDescriptionCreator = CDescriptionCreator(),
        networkSerialiserCreator: CNetworkSerialiserCreator = CNetworkSerialiserCreator(),
        networkDeserialiserCreator: CNetworkDeserialiserCreator = CNetworkDeserialiserCreator(),
        fromStringCreator: CFromStringCreator<FromStringImplementationCreator> = CFromStringCreator(
            implementationCreator: FromStringImplementationCreator()
        )
    ) {
        self.creatorHelpers = creatorHelpers
        self.descriptionCreator = descriptionCreator
        self.networkSerialiserCreator = networkSerialiserCreator
        self.networkDeserialiserCreator = networkDeserialiserCreator
        self.fromStringCreator = fromStringCreator
    }

    //swiftlint:disable:next function_body_length
    public func createCFile(
        forClass cls: Class,
        forFileNamed fileName: String,
        withStructName structName: String,
        generatedFrom genFile: String
    ) -> String? {
        let comment = self.creatorHelpers.createFileComment(
            forFile: fileName,
            withAuthor: cls.author,
            andGenFile: genFile
        )
        let head = self.createHead(forStructNamed: structName)
        let descriptionFunc = self.descriptionCreator.createFunction(
            creating: "description",
            withComment: """
                /**
                 * Convert to a description string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "descString",
            includeLabels: true
        )
        let toStringFunc = self.descriptionCreator.createFunction(
            creating: "to_string",
            withComment: """
                /**
                 * Convert to a string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "toString",
            includeLabels: false
        )
        let toNetworkSerialised = self.networkSerialiserCreator.createFunction(
            creating: "to_network_serialised",
            withComment: """
                /**
                 * Convert to a compressed, serialised, network byte order byte stream.
                 */
                """,
            forClass: cls,
            withStructNamed: structName
        )
        let fromNetworkSerialised = self.networkDeserialiserCreator.createFunction(
            creating: "from_network_serialised",
            withComment: """
                /**
                 * Convert from a compressed, serialised, network byte order byte stream.
                 */
                """,
            forClass: cls,
            withStructNamed: structName
        )
        let fromStringFunc = self.fromStringCreator.createFunction(
            creating: "from_string",
            withComment: """
                /**
                 * Convert from a string.
                 */
                """,
            forClass: cls,
            withStructNamed: structName,
            forStrVariable: "str"
        )
        let posterIfdef = "#ifndef WHITEBOARD_POSTER_STRING_CONVERSION"
        let posterEndif = "#endif // WHITEBOARD_POSTER_STRING_CONVERSION"
        let posterDef =  "#define WHITEBOARD_POSTER_STRING_CONVERSION"
        let serialiseIfDef = "/*#ifdef WHITEBOARD_SERIALISATION*/"
        let serialiseEndIf = "/*#endif // WHITEBOARD_SERIALISATION*/"
        let preC = cls.preCFile.map { $0 + "\n\n" } ?? ""
        let postC = cls.postCFile.map { "\n\n" + $0 } ?? ""
        return comment + "\n\n" + posterIfdef + "\n" + posterDef + "\n" + posterEndif
            + "\n\n" + head + "\n\n" + preC
            + "\n\n" + descriptionFunc + "\n\n" + toStringFunc
            + "\n\n" + fromStringFunc
            + "\n\n" + serialiseIfDef + "\n\n" + toNetworkSerialised
            + "\n\n" + fromNetworkSerialised + "\n\n" + serialiseEndIf
            + postC
            + "\n"
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createHead(forStructNamed structName: String) -> String {
        return """
            #include "\(structName).h"
            #include <stdio.h>
            #include <string.h>
            #include <stdlib.h>
            #include <ctype.h>

            /* Network byte order functions */
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wunused-macros"
            #if defined(__linux)
            #  include <endian.h>
            #  include <byteswap.h>
            #elif defined(__APPLE__) 
            #  include <machine/endian.h>           //Needed for __BYTE_ORDER
            #  include <architecture/byte_order.h>   //Needed for byte swap functions
            #  define bswap_16(x) NXSwapShort(x)
            #  define bswap_32(x) NXSwapInt(x)
            #  define bswap_64(x) NXSwapLongLong(x)
            #elif defined(ESP8266)
            #  define bswap_16(x) __builtin_bswap16(x)
            #  define bswap_32(x) __builtin_bswap32(x)
            #  define bswap_64(x) __builtin_bswap64(x)
            #else
              //Manually define swap macros?
            #endif

            #if __BYTE_ORDER == __LITTLE_ENDIAN
            #  if !defined(htonll) && !defined(ntohll)
            #   define htonll(x) bswap_64(x)
            #   define ntohll(x) bswap_64(x)
            #  endif
            #  if !defined(htonl) && !defined(ntohl)
            #   define htonl(x) bswap_32(x)
            #   define ntohl(x) bswap_32(x)
            #  endif
            #  if !defined(htons) && !defined(ntohs)
            #   define htons(x) bswap_16(x)
            #   define ntohs(x) bswap_16(x)
            #  endif
            #else
            #  if !defined(htonll) && !defined(ntohll)
            #   define htonll(x) (x)
            #   define ntohll(x) (x)
            #  endif
            #  if !defined(htonl) && !defined(ntohl)
            #   define htonl(x) (x)
            #   define ntohl(x) (x)
            #  endif
            #  if !defined(htons) && !defined(ntohs)
            #   define htons(x) (x)
            #   define ntohs(x) (x)
            #  endif
            #endif
            #pragma clang diagnostic pop
            """
    }

}
