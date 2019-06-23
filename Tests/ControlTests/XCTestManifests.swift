import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ControlTests.allTests),
        testCase(PIDTests.allTests),
    ]
}
#endif
