import XCTest
@testable import BePresent

final class FocusSessionTests: XCTestCase {
    func testFirstScanPairsAndStartsThenMatchingScanUnlocks() throws {
        var session = FocusSession()
        let start = Date(timeIntervalSince1970: 100)
        try session.scan(tag: "mifare:123", hasSelection: true, now: start)
        XCTAssertEqual(session.pairedTag, "mifare:123")
        XCTAssertEqual(session.startedAt, start)
        try session.scan(tag: "mifare:123", hasSelection: false)
        XCTAssertFalse(session.isBlocking)
        XCTAssertEqual(session.pairedTag, "mifare:123")
    }

    func testDifferentTagCannotUnlockOrReplacePairing() throws {
        var session = FocusSession()
        try session.scan(tag: "original", hasSelection: true)
        let original = session
        XCTAssertThrowsError(try session.scan(tag: "other", hasSelection: true))
        XCTAssertEqual(session, original)
        try session.scan(tag: "original", hasSelection: true)
        XCTAssertThrowsError(try session.scan(tag: "other", hasSelection: true))
        XCTAssertEqual(session.pairedTag, "original")
        XCTAssertFalse(session.isBlocking)
    }

    func testEmptySelectionAndEmptyTagDoNotStartOrPair() {
        var session = FocusSession()
        XCTAssertThrowsError(try session.scan(tag: "tag", hasSelection: false))
        XCTAssertThrowsError(try session.scan(tag: "", hasSelection: true))
        XCTAssertEqual(session, FocusSession())
    }

    func testPersistedSessionStillRequiresSameTag() throws {
        var session = FocusSession()
        try session.scan(tag: "original", hasSelection: true)
        var restored = try JSONDecoder().decode(FocusSession.self, from: JSONEncoder().encode(session))
        XCTAssertEqual(restored, session)
        XCTAssertThrowsError(try restored.scan(tag: "other", hasSelection: true))
        try restored.scan(tag: "original", hasSelection: false)
        XCTAssertFalse(restored.isBlocking)
    }
}
