import XCTest
@testable import classgeneratorTests

XCTMain([
    testCase(ClassGeneratorTests.allTests),
    testCase(ParserTests.allTests),
    testCase(SectionsParserTests.allTests)
    testCase(StringHelpersTests.allTests)
])
