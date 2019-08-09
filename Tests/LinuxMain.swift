import XCTest
@testable import classgeneratorTests

XCTMain([
    testCase(DefaultValuesCalculatorTests.allTests),
    testCase(DemoTests.allTests),
    testCase(ParserTests.allTests),
    testCase(SanitiserTests.allTests),
    testCase(SectionsParserTests.allTests),
    testCase(TypeIdentifierTests.allTests)
    testCase(EnumParserTests.allTests)
    testCase(MixinParserTests.allTests)
])
