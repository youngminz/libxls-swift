import XCTest
@testable import LibXLS

final class LibXLSTests: XCTestCase {
    func testVersion() {
        XCTAssertEqual(LibXLS.version, "1.6.3")
    }
}
