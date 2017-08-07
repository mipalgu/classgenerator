import XCTest
@testable import classgeneratorTests

XCTMain([
    testCase(ClassGeneratorTests.allTests),
    testCase(Parser.allTests),
    testCase(SectionsParser.allTests)
])
