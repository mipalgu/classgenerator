import XCTest
@testable import classgeneratorTests

XCTMain([
    testCase(CFileCreatorTests.allTests),
    testCase(CHeaderCreatorTests.allTests),
    testCase(CPPHeaderCreatorTests.allTests),
    testCase(DefaultValuesCalculatorTests.allTests),
    testCase(DemoTests.allTests),
    testCase(ParserTests.allTests),
    testCase(SanitiserTests.allTests),
    testCase(SectionsParserTests.allTests),
    testCase(SwiftFileCreatorTests.allTests),
    testCase(TypeIdentifierTests.allTests)
])
