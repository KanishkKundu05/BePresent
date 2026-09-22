# BePresent

A minimal native SwiftUI iPhone app, styled in BePresent blue and white. Requires iOS 17 or later. Two screens: a local welcome/login entry with no account or backend, and a home screen. App selection uses Apple's system Screen Time picker.

## Run

Open `BePresent.xcodeproj`, select the **BePresent** scheme, and choose your development team under Signing & Capabilities. Set a unique bundle identifier if needed. Run on a physical NFC-capable iPhone for the complete flow.

The project includes Family Controls and NFC Tag Reading entitlements. Your signing profile must support both capabilities. Apple approval for Family Controls distribution is required before distributing through TestFlight or the App Store. No development team or credentials are committed.

The checked-in project can be regenerated with `xcodegen generate` using `project.yml`.

## Flow

1. Tap **Get started**. This stores a local entry flag; it is not authentication.
2. Enable Screen Time access and approve Apple's individual authorization prompt.
3. Choose apps, categories, and/or websites under **Your distractions**.
4. Tap **Scan to be present**, then hold the top of your iPhone against a compatible NFC tag. The first successful scan pairs its identifier and starts blocking.
5. Tap **Scan to unlock** and scan the same tag to remove the shields. Other tags are rejected. App selection cannot be edited during a session.

The pairing, selection, and session start time persist locally. Shields use a named Managed Settings store and are reapplied when the app becomes active with authorization. Cancelled or failed scans do not toggle the session. There is no in-app manual unlock or pairing reset.

## Hardware and platform limits

- Supports readable MIFARE tags (e.g. NTAG213/215/216) and ISO 15693 tags. No NDEF payload or tag programming is needed. Proprietary Brick hardware compatibility is **not verified**; this implementation uses standard NFC tags rather than Brick's private protocol.
- Core NFC requires the app's foreground, user-initiated scan sheet. Touching a tag while the app is closed does not automatically toggle blocking.
- Screen Time shields selected apps/categories/websites, not the entire phone. System-required functionality remains available. Uses Apple's default shield UI.
- Individual authorization can be revoked in iOS Settings, and the user can uninstall the app. This is a voluntary focus tool, not a tamper-proof lock. If access is revoked, the home screen requests access again rather than claiming shields are active.
- Pairing uses a tag identifier, not cryptographic authentication. Cloned identifiers and tags with changing identifiers are outside this prototype's guarantees.
- Losing the paired tag leaves no in-app unlock path. OS-level authorization controls remain available.
- The simulator can display the UI and run policy tests, but cannot validate NFC reads or real Screen Time enforcement.

## Validation

Run the `BePresentTests` target in Xcode (Product → Test). Tests cover first-scan pairing, matching-tag unlock, wrong-tag rejection both during and after a session, missing-selection/empty-tag rejection, and persistence round trips.

Before shipping, verify on a signed physical iPhone: allow/deny/revoke authorization, choose an app and a website, start a session, confirm both shields, relaunch while blocked, reject a different tag, cancel a scan, and unlock with the original tag. Also test category selection and NFC timeout behavior.

## Apple references

- [Individual Screen Time authorization](https://developer.apple.com/documentation/familycontrols/authorizationcenter/requestauthorization(for:))
- [Family Controls entitlement](https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.developer.family-controls)
- [NFC polling options](https://developer.apple.com/documentation/corenfc/nfctagreadersession/pollingoption)
- [Managed Settings category shields](https://developer.apple.com/documentation/managedsettings/shieldsettings/applicationcategories-swift.property)
