# BePresent

BePresent uses the [Foqos](https://github.com/awaseem/foqos) app foundation with white-on-blue BePresent branding. See [UPSTREAM.md](UPSTREAM.md) for the imported revision and [LICENSE](LICENSE) for the original MIT license.

## Run

Open `BePresent.xcodeproj`, select the **BePresent** scheme, and run on an iPhone simulator or signed physical iPhone. The upstream internal iOS target/module is still named `foqos`; the installed app is named **BePresent**. Use Xcode 26 or newer. The main app targets iOS 17.6; individual extensions retain upstream minimum versions through iOS 18.5.

For a physical device, choose your development team for the app and its four iOS extension targets. Configure Family Controls, NFC, and the shared App Group `group.com.bepresent.brick`. All bundle IDs use `com.bepresent.brick`. Distribution requires Apple's Family Controls entitlement approval. No upstream signing team is configured.

## Included functionality

- Blocking profiles, app/category/domain selection, allow mode, strict physical unlock rules.
- NFC, QR/barcode, manual, timer, pause-timer, and temporary-access strategies.
- Scheduled sessions, breaks, persisted session history, and insights.
- Device Activity monitor, shield configuration/action extensions, widgets, Live Activities, and App Intents.
- Upstream model, timer, break, temporary-access, persistence, and regression tests.

The SwiftData models and blocking engine are retained from upstream. The old two-screen prototype has been replaced. End any active prototype session before updating; prototype preferences and pairing are not migrated.

## Links and branding

BePresent uses `bepresent:///profile/<UUID>` and `bepresent:///navigate/<UUID>` links for QR codes, NFC payloads, and widgets. It does not claim the upstream `foqos.app` associated domain. Foreground NFC scanning remains available; background NFC opening requires a separately configured HTTPS universal-link domain and is not promised by this custom scheme.

The app icon, onboarding, header, shields, accent color, app name, and About screen use BePresent branding. Upstream copyright notices and internal source/type names remain for attribution and easier upstream updates. The inherited macOS sources are retained for project completeness but are not part of iOS validation.

## Validation

Run Product → Test with the BePresent scheme, or:

```sh
xcodebuild test -project BePresent.xcodeproj -scheme BePresent -destination 'platform=iOS Simulator,name=iPhone 17' CODE_SIGNING_ALLOWED=NO
```

A signed physical device is required to verify NFC reads/writes, Screen Time enforcement, scheduling, shields, and cross-process App Group behavior. Simulator tests validate model and policy logic, not real device enforcement.

The two STL files are the BePresent hardware models and are independent of the app sources.
