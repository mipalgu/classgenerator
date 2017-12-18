/*
 * CNetworkCompressionCreator.swift 
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

public final class CNetworkCompressionCreator {

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
        let definition = "size_t \(structName)_\(fLabel)(const struct \(structName) *self, char *dst)\n{"
        let head = """
                uint16_t bit_offset = 0;
            """
        let descriptions = cls.variables.flatMap {
            self.createNetworkCompressed(
                forVariable: $0,
                forClassNamed: cls.name
            )
        }
        let vars = self.stringHelpers.indent(descriptions.combine("") {
            $0 +
            "\n\n" +
            $1
        })
        let returnStatement = "    return offset;"
        let endDefinition = "}"
        return comment + "\n" + definition + "\n" + head + "\n" + vars + "\n" + returnStatement + "\n" + endDefinition
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

    /*
    fileprivate func createArrayDescription(
        forType type: VariableTypes,
        withLabel label: String,
        andClassName className: String,
        _ level: Int = 0
    ) -> String? {
        switch type {
            case .array(let subtype, _):
                let arrLabel = 0 == level ? label : label + "_\(level)"
                let temp: String?
                switch subtype {
                    case .array:
                        temp = self.createArrayDescription(
                            forType: subtype,
                            withLabel: label,
                            andClassName: className,
                            level + 1
                        )
                    default:
                      break;
                        /*temp = self.createValue(
                            forType: subtype,
                            withLabel: self.createIndexes(forLabel: label, level),
                            andClassName: className
                        )*/
                }
                guard let value = temp else {
                    return nil
                }
                //swiftlint:disable line_length
                return """
                    int \(arrLabel)_first = 0;
                    for (int \(arrLabel)_index = 0; \(arrLabel)_index < \(self.stringHelpers.toSnakeCase(className).uppercased())_\(arrLabel.uppercased())_ARRAY_SIZE; \(arrLabel)_index++) {
                        if (1 == \(arrLabel)_first) {
                        }
                    \(self.stringHelpers.indent(value))
                        \(arrLabel)_first = 1;
                    }
                    """
            default:
                break
                /*
                return self.createDescription(
                    forType: type,
                    withLabel: label,
                    andClassName: className
                )*/
        }
    }

    fileprivate func createIndexes(forLabel label: String, _ level: Int) -> String {
        return Array(0...level).map { 0 == $0 ? "[\(label)_index]" : "[\(label)_\($0)_index]" }.reduce(label, +)
    }
*/

    fileprivate func bitSetterGenerator(data: String) -> String {
        return """
          do {
            uint16_t byte = bit_offset / 8;
            uint16_t bit = bit_offset % 8;
            unsigned long newbit = !!(\(data));
            dst[byte] ^= (-newbit ^ dst[byte]) & (1UL << bit);
            bit_offset = bit_offset + 1;
          } while(false);
        """
    }

    fileprivate func createNetworkCompressed(
        forVariable variable: Variable,
        forClassNamed className: String
    ) -> String? {
      let label = variable.label
        switch variable.type {
            case .array:
              return nil
              /*
                return self.createArrayDescription(
                    forType: type,
                    withLabel: label,
                    andClassName: className,
                    appendingTo: strLabel
                )
                */
            case .bit:
                return bitSetterGenerator(data: "self->\(label)")
            case .bool:
                return bitSetterGenerator(data: "self->\(label) ? 1 : 0")
            case .char:
                return """
                  for (uint8_t b = 0; b < 8; b++) {
                    \(bitSetterGenerator(data: "(self->\(label) >> b) & 1U"))
                  }
                  """
            case .numeric:
                guard let bitSize: UInt8 = numericBitSize[variable.cType] else {
                  return ""
                }
                return """
                    \(variable.cType) \(label)_nbo = \(htonC(bits: bitSize))(self->\(label));
                    for (uint8_t b = 0; b < \(bitSize); b++) {
                        \(bitSetterGenerator(data: "(\(label)_nbo >> b) & 1U"))
                    }
                    """
            case .string:
                return """
                  uint8_t len = strlen(self->\(label));
                  for (uint8_t b = 0; b < 8; b++) {
                    \(bitSetterGenerator(data: "(len >> b) & 1U"))
                  }
                  for (uint8_t c = 0; c < len; c++) {
                    for (uint8_t b = 0; b < 8; b++) {
                      \(bitSetterGenerator(data: "(self->\(label)[len] >> b) & 1U"))
                    }
                  }
                  """
            default:
                return nil
        }
    }

    fileprivate func htonC(bits: UInt8) -> String {
      switch bits {
        case 8:
          return ""
        case 16:
          return "htons"
        case 32:
          return "htonl"
        case 64:
          return "htonll"
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
