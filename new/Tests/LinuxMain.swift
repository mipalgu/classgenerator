import XCTest
@testable import classgeneratorTests

XCTMain([
    testCase(CHeaderCreatorTests.allTests),
    testCase(CPPHeaderCreatorTests.allTests),
    testCase(DemoTests.allTests),
    testCase(ParserTests.allTests),
    testCase(SectionsParserTests.allTests),
    testCase(StringHelpersTests.allTests)
])
