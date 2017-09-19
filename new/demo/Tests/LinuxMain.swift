import XCTest
@testable import demoTests

XCTMain([
    testCase(DemoTests.allTests),
    testCase(StringTests.allTests),
    testCase(WhiteboardTests.allTests)
])
