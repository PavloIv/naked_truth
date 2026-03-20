# App Store Infrastructure Checklist (Naked Truth)

## 1) Apple Developer: Identifier (App ID)

Create explicit App ID:

- Description: `Naked Truth iOS`
- Bundle ID: `com.ip.nakedTruth`
- Capabilities:
  - `Sign In with Apple`
  - `In-App Purchase`

Notes:
- Location permission does not require a separate capability.
- Keep Bundle ID exactly the same as in Xcode/Flutter project.

## 2) App Store Connect: App record

Create app:

- Platform: `iOS`
- Name: `Naked Truth`
- Primary language: `English (U.S.)` (or your target default)
- Bundle ID: `com.ip.nakedTruth`
- SKU: `nakedtruth-ios`
- User Access: `Full Access` (for owner/admin account)

## 3) In-App Purchases (required before production release)

Recommended product IDs:

- `com.ip.nakedTruth.premium.monthly`
- `com.ip.nakedTruth.premium.yearly`
- `com.ip.nakedTruth.premium.lifetime`

For each product in App Store Connect:

- Status must be `Ready to Submit` (or approved before release).
- Add display name, description, price, and localization.
- Attach screenshot for review (paywall/restore screen).

## 4) Certificates and Signing

In Apple Developer account:

- Create/verify `iOS Distribution` certificate.
- Create `App Store` provisioning profile for `com.ip.nakedTruth`.
- In Xcode Runner target:
  - Signing: `Automatically manage signing` ON
  - Team: your Apple Developer Team
  - Bundle Identifier: `com.ip.nakedTruth`

## 5) Firebase iOS infrastructure

In Firebase Console:

- Add iOS app with bundle ID `com.ip.nakedTruth`.
- Download `GoogleService-Info.plist`.
- Put file into `ios/Runner/GoogleService-Info.plist` and add it to Runner target.

## 6) Sign in with Apple + Google login dependencies

- Sign in with Apple:
  - Must be enabled in App ID capability.
  - Runner target should contain entitlements file with Apple Sign In capability.
- Google Sign-In:
  - Ensure URL scheme from `GoogleService-Info.plist` is present in iOS app config.

## 7) App Store policy-critical items (must exist)

- Public `Privacy Policy` URL.
- Public `Terms of Use` URL.
- In-app account deletion flow (if app has account creation/login).

