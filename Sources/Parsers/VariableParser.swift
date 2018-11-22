/*
 * VariableParser.swift 
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

import Foundation

import Containers
import Data

public final class VariableParser<Container: ParserWarningsContainer>: VariableParserType {

    fileprivate let cTypeConverter: CTypeConverter

    fileprivate let defaultValuesCalculator: DefaultValuesCalculator

    fileprivate let identifier: TypeIdentifier

    fileprivate let sanitiser: Sanitiser

    fileprivate let typeConverter: TypeConverter

    public fileprivate(set) var container: Container

    public init(
        container: Container,
        cTypeConverter: CTypeConverter = CTypeConverter(),
        defaultValuesCalculator: DefaultValuesCalculator = DefaultValuesCalculator(),
        identifier: TypeIdentifier = TypeIdentifier(),
        sanitiser: Sanitiser = Sanitiser(),
        typeConverter: TypeConverter = TypeConverter()
    ) {
        self.container = container
        self.cTypeConverter = cTypeConverter
        self.defaultValuesCalculator = defaultValuesCalculator
        self.identifier = identifier
        self.sanitiser = sanitiser
        self.typeConverter = typeConverter
    }

    public func parseVariable(fromLine line: String) throws -> Variable {
        let (remaining, comment) = try self.parseComment(fromLine: line)
        return try self.parseVar(fromSegment: remaining, withComment: comment)
    }

    fileprivate func parseComment(fromLine line: String) throws -> (String, String) {
        let split = line.components(separatedBy: "//")
        guard split.count <= 2 else {
            throw ParsingErrors.parsingError(
                split[0].count + split[1].count + split[2].count,
                "Found multiple comments for variable."
            )
        }
        guard let first = split.first else {
            throw ParsingErrors.parsingError(0, "Empty line in variables table detected.")
        }
        let tabbed = first.components(separatedBy: "\t").lazy.map {
            $0.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if 1 == split.count && tabbed.count < 3 {
            throw ParsingErrors.parsingError(line.count, "You must supply a comment.")
        }
        if 2 == split.count {
            return (
                tabbed.reduce("") { $0 + " " + $1 }.trimmingCharacters(in: .whitespaces),
                split[1].trimmingCharacters(in: CharacterSet.whitespaces)
            )
        }
        return (
            tabbed[0] + " " + tabbed[1],
            tabbed.dropFirst(2).reduce("") { $0 + "\t" + $1 }.trimmingCharacters(in: .whitespaces)
        )
    }

    //swiftlint:disable large_tuple
    fileprivate func parseVar(fromSegment segment: String, withComment comment: String?) throws -> Variable {
        let split = segment.components(separatedBy: "=")
        guard split.count <= 2 else {
            throw ParsingErrors.parsingError(split.first?.count ?? 0, "You can only specify one default value.")
        }
        let words = split[0].trimmingCharacters(in: .whitespaces).components(separatedBy: CharacterSet.whitespaces)
        guard let label = words.last else {
            throw ParsingErrors.parsingError(split[0].count, "You must specify a label for the variable")
        }
        let trimmedLabel = label.trimmingCharacters(in: .whitespaces)
        let arrCounts: [String]
        do {
            arrCounts = try self.parseArrayCount(fromLabel: trimmedLabel)
        } catch ParsingErrors.parsingError(let offset, let message) {
            throw ParsingErrors.parsingError(split[0].count + offset, message)
        }
        let signature = words.dropLast().reduce("") { $0 + " " + $1 }.trimmingCharacters(in: .whitespaces)
        let type = self.identifier.identify(fromTypeSignature: signature, andArrayCounts: arrCounts)
        do {
            _ = try self.verify(type: type)
        } catch ParsingErrors.parsingError(_, let message) {
            throw ParsingErrors.parsingError(split[0].count, message)
        }
        let defaultValues: (String, String)
        do {
            defaultValues = try self.parseDefaultValues(fromSplit: split, forType: type, withSignature: signature)
        } catch ParsingErrors.parsingError(let offset, let message) {
            throw ParsingErrors.parsingError(0 + offset, message)
        }
        let swiftType: String
        do {
            swiftType = try self.typeConverter.convert(fromType: type, withSignature: signature)
        } catch ParsingErrors.parsingError(let offset, let message) {
            throw ParsingErrors.parsingError(signature.count + offset, message)
        }
        let cType = self.cTypeConverter.convert(
            signature: signature.components(separatedBy: "*")[0].trimmingCharacters(in: .whitespaces),
            withType: type
        )
        return Variable(
            label: trimmedLabel.components(separatedBy: "[")[0].trimmingCharacters(in: .whitespaces),
            type: type,
            cType: cType,
            swiftType: swiftType,
            defaultValue: defaultValues.0,
            swiftDefaultValue: defaultValues.1,
            comment: comment
        )
    }

    fileprivate func parseArrayCount(fromLabel label: String) throws -> [String] {
        let split = label.components(separatedBy: "[")
        return try split.dropFirst().map {
            let trimmed = $0.trimmingCharacters(in: .whitespaces)
            guard "]" == trimmed.last else {
                throw ParsingErrors.parsingError(0, "Malformed array size specifier: \(trimmed)")
            }
            return String(trimmed.dropLast())
        }
    }

    fileprivate func parseDefaultValues(
        fromSplit split: [String],
        forType type: VariableTypes,
        withSignature signature: String
    ) throws -> (String, String) {
        if split.count > 1 {
            return try self.parseDefaultValues(fromSegment: split[1], forType: type, withSignature: signature)
        }
        guard let defaultValues = self.defaultValuesCalculator.calculateDefaultValues(forType: type, withSignature: signature) else {
            throw ParsingErrors.parsingError(0, "Unable to calculate default value for type: \(type)")
        }
        return defaultValues
    }

    fileprivate func parseDefaultValues(
        fromSegment segment: String,
        forType type: VariableTypes,
        withSignature signature: String
    ) throws -> (String, String) {
        let split = segment.components(separatedBy: "|")
        guard split.count <= 2 else {
            throw ParsingErrors.parsingError(0, "Unable to parse default value of: \(segment)")
        }
        if 1 == split.count {
            let trimmed = segment.trimmingCharacters(in: CharacterSet.whitespaces)
            return (trimmed, self.sanitiser.sanitise(value: trimmed, forType: type, withSignature: signature) ?? trimmed)
        }
        guard 2 == split.count else {
            throw ParsingErrors.parsingError(split[0].count, "Malformed default value list: \(split[1])")
        }
        return (
            split[0].trimmingCharacters(in: CharacterSet.whitespaces),
            self.trimDefaultValueListSeparators(split[1]).trimmingCharacters(in: CharacterSet.whitespaces)
        )
    }

    fileprivate func trimDefaultValueListSeparators(_ str: String) -> String {
        return str.trimmingCharacters(in: CharacterSet(charactersIn: "|"))
    }

    fileprivate func verify(type: VariableTypes) throws -> Bool {
        switch type {
        case .array(let subtype, let length):
            switch subtype {
            case .array:
                throw ParsingErrors.parsingError(0, "The classgenerator currently does not support multi-dimensional arrays.")
            default:
                break
            }
            if length == "0" {
                throw ParsingErrors.parsingError(0, "Arrays must contain a length greater than zero.")
            }
            return true
        case .string(let length):
            if length == "0" {
                throw ParsingErrors.parsingError(0, "Strings must contain a length greater than zero.")
            }
            return true
        default:
            return true
        }
    }

}
