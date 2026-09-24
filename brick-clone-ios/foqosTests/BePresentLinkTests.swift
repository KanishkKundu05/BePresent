import XCTest
@testable import foqos

@MainActor
final class BePresentLinkTests: XCTestCase {
  func testGeneratedProfileLinkRoutesToTheSameProfile() throws {
    let profile = BlockedProfiles(name: "Desk")
    let url = try XCTUnwrap(URL(string: BlockedProfiles.getProfileDeepLink(profile)))
    XCTAssertEqual(url.scheme, "bepresent")
    let navigation = NavigationManager()
    navigation.handleLink(url)
    XCTAssertEqual(navigation.profileId, profile.id.uuidString)
    XCTAssertEqual(navigation.link, url)
    navigation.clearNavigation()
    XCTAssertNil(navigation.profileId)
    XCTAssertNil(navigation.link)
  }

  func testWidgetNavigationDoesNotToggleTheProfile() throws {
    let id = UUID().uuidString
    let navigation = NavigationManager()
    navigation.handleLink(try XCTUnwrap(URL(string: "bepresent:///navigate/\(id)")))
    XCTAssertEqual(navigation.navigateToProfileId, id)
    XCTAssertNil(navigation.profileId)
  }
}
