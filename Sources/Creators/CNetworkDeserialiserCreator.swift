/*
 * CNetworkDeserialiserCreator.swift 
 * classgenerator 
 *
 * Created by Callum McColl and Carl Lusty on 30/11/2017.
 * Copyright © 2017 Callum McColl and Carl Lusty. All rights reserved.
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

public final class CNetworkDeserialiserCreator {

    fileprivate let creatorHelpers: CreatorHelpers
    fileprivate let stringHelpers: StringHelpers

    public init(creatorHelpers: CreatorHelpers = CreatorHelpers(), stringHelpers: StringHelpers = StringHelpers()) {
        self.creatorHelpers = creatorHelpers
        self.stringHelpers = stringHelpers
    }

    //swiftlint:disable function_parameter_count
    public func createFunction(
        creating fLabel: String,
        withComment comment: String,
        forClass cls: Class,
        withStructNamed structName: String
    ) -> String {
        //swiftlint:disable:next line_length
        let definition = "size_t \(structName)_\(fLabel)(const char *src, struct \(structName) *dst)\n{"
        let head = """
                uint16_t bit_offset = 0;
            """
        let descriptions = cls.variables.compactMap {
            self.createNetworkCompressed(
                forVariable: $0,
                forClassNamed: cls.name
            )
        }
        let vars = self.stringHelpers.cIndent(descriptions.combine("") {
            $0 +
            "\n\n" +
            $1
        })
        let useVariables = """
            //avoid unused variable warnings when you try to use an empty gen file or a gen file with no supported serialisation types.
            (void)src;
            (void)dst;
        """
        let returnStatement = "    return bit_offset;"
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + head + "\n" + vars + "\n" + useVariables + "\n" + returnStatement + "\n" + endDefinition
    }

    fileprivate func createGuard(withStructNamed structName: String) -> String {
        return """
            /*
            do {
              size_t offset = (bit_size / 8) + (bit_size % 8 == 0 ? 0 : 1);
              if (offset >= \(structName)_networkByteOrderSize()) {
                return -1;
              }
            } while(false);
            */
            """
    }

    fileprivate func bitGetterGenerator(variable: String) -> String {
        return """
          do {
            uint16_t byte = bit_offset / 8;
            uint16_t bit = 7 - (bit_offset % 8);
            char dataByte = src[byte];
            unsigned char bitValue = (dataByte >> bit) & 1U;
            \(variable)
            bit_offset = bit_offset + 1;
          } while(false);
        """
    }

    //swiftlint:disable:next function_body_length
    fileprivate func createNetworkCompressed(
        forVariable variable: Variable,
        forClassNamed className: String
    ) -> String? {
        let label = variable.label
        func createNetworkCompressed(forType type: VariableTypes) -> String? {
            switch type {
                case .array(_, let len):
                  return """
                      //Class generator does not support array network compression.
                      //Copying into the buffer, uncompressed
                      do { //limit declaration scope
                        uint32_t len = \(len);
                        uint32_t bytes = len * sizeof(\(variable.cType));
                        char *buf = (char *)malloc(bytes);
                        uint32_t c;
                        int8_t b;
                        for (c = 0; c < bytes; c++) {
                          for (b = 7; b >= 0; b--) {
                            \(bitGetterGenerator(variable: "buf[c] ^= (-bitValue ^ buf[c]) & (1UL << b);"))
                          }
                        }
                        memcpy(&dst->\(label)[0], &buf[0], bytes);
                        free(buf);
                      } while(false);
                  """
                case .bit:
                    return bitGetterGenerator(variable: "dst->\(label) ^= (-bitValue ^ dst->\(label)) & (1UL << 0);")
                case .bool:
                    return bitGetterGenerator(variable: "dst->\(label) = bitValue != 0;")
                case .char:
                    return """
                        do {
                            int8_t b;
                            for (b = 7; b >= 0; b--) {
                                \(bitGetterGenerator(variable: "dst->\(label) ^= (-bitValue ^ dst->\(label)) & (1UL << b);"))
                            }
                        } while (false);
                        """
                case .enumerated:
                    let bitSize:UInt8 = 32
                    return """
                      do {
                        int8_t b;
                        for (b = (\(bitSize) - 1); b >= 0; b--) {
                          \(bitGetterGenerator(variable: "dst->\(label) ^= (-bitValue ^ dst->\(label)) & (1UL << b);"))
                        }
                      } while(false);
                      dst->\(label) = \(ntohC(bits: bitSize))(dst->\(label));
                      """
                case .numeric(let numericType):
                    switch numericType {
                        case .double, .float, .long(.double), .long(.float):
                            return "//The class generator does not support float types for network conversion."
                        default:
                            guard let bitSize: UInt8 = numericBitSize[variable.cType] else {
                                return "//The class generator does not support '\(variable.cType)' network conversion."
                            }
                            return """
                                do {
                                  int8_t b;
                                  for (b = (\(bitSize) - 1); b >= 0; b--) {
                                    \(bitGetterGenerator(variable: "dst->\(label) ^= (-bitValue ^ dst->\(label)) & (1UL << b);"))
                                  }
                                } while(false);
                                dst->\(label) = \(ntohC(bits: bitSize))(dst->\(label));
                                """
                    }
                case .string:
                    return """
                      do {
                        uint8_t len = 0;
                        int8_t b;
                        for (b = 7; b >= 0; b--) {
                          \(bitGetterGenerator(variable: "len ^= (-bitValue ^ len) & (1UL << b);"))
                        }
                        uint8_t c;
                        for (c = 0; c < len; c++) {
                          for (b = 7; b >= 0; b--) {
                            \(bitGetterGenerator(variable: "dst->\(label)[c] ^= (-bitValue ^ dst->\(label)[c]) & (1UL << b);"))
                          }
                        }
                      } while (false);
                      """
                case .mixed(let macOS, let linux):
                    guard
                        let macValue = createNetworkCompressed(forType: macOS),
                        let linuxValue = createNetworkCompressed(forType: linux)
                    else {
                        return nil
                    }
                    if macValue == linuxValue {
                        return macValue
                    }
                    return """
                        #ifdef __APPLE__
                        \(macValue)
                        #else
                        \(linuxValue)
                        #endif
                        """
                default:
                    return nil
            }
        }
        return createNetworkCompressed(forType: variable.type)
    }

    fileprivate func ntohC(bits: UInt8) -> String {
      switch bits {
        case 8:
          return ""
        case 16:
          return "ntohs"
        case 32:
          return "ntohl"
        case 64:
          return "ntohll"
        default:
          return ""
      }
    }

    fileprivate let numericBitSize: [String: UInt8] = [
        "signed": 32,
        "signed int": 32,
        "unsigned": 32,
        "unsigned int": 32,
        "uint8_t": 8,
        "uint16_t": 16,
        "uint32_t": 32,
        "uint64_t": 64,
        "int8_t": 8,
        "int16_t": 16,
        "int32_t": 32,
        "int64_t": 64,
        "int": 32,
        "uint": 32,
        "short": 16,
        "short int": 16,
        "signed short": 16,
        "signed short int": 16,
        "unsigned short": 16,
        "unsigned short int": 16,
        "long": 64,
        "long int": 64,
        "signed long": 64,
        "signed long int": 64,
        "unsigned long": 64,
        "unsigned long int": 64,
        "long long": 64,
        "long long int": 64,
        "signed long long": 64,
        "signed long long int": 64,
        "unsigned long long": 64,
        "unsigned long long int": 64,
        "long64_t": 64,
        "float": 32,
        "float_t": 32,
        "double": 64,
        "double_t": 64,
        "long double": 80,
        "double double": 80
    ]
}
