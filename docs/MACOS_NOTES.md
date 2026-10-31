# Notes for macOS / iOS sessions

The Windows machine can build and run Android only. Everything below was
written (or changed) there and still needs a check on an iPhone **and an
iPad** from a Mac. Tick items off here as they are verified, with the date.

## Always

- [ ] **iPad layout:** every screen goes through `BpTabletScale` (design
      frame scaled up). Check new UI on an iPad simulator (portrait and
      landscape if allowed) as well as on an iPhone.
- [ ] **Golden tests:** the Mac is the reference machine for
      `test/golden/goldens/*.png`. Re-record them here
      (`flutter test --update-goldens test/golden test/widget`) when a UI
      change is intended; the comparator tolerates small font-rendering
      differences so Windows also passes.
- Release entitlements: `ios/Runner/RunnerRelease.entitlements` has
  `aps-environment=production`; the debug one has `development`.

## From the 2026-10-31 roadmap (docs/ROADMAP.md)

### 1. Notifications
- [ ] The on-device daily reminder (19:00 local) now schedules for everyone
      who allowed notifications, signed in or not. On iOS, confirm the
      permission prompt appears (the primer after the 3rd cleared sheet),
      the reminder fires at 19:00, and tapping it opens the Daily screen.
- [ ] Server pushes (streak-at-risk, win-back, Pro coins) need the APNs
      auth key uploaded in Firebase (Project settings > Cloud Messaging >
      Apple app configuration). Send a test from the Firebase console to an
      iOS token.
- [ ] A notification that arrives while the app is open should still show
      (foreground presentation options).

### 4. Share your daily result
- [ ] **iPad:** the share sheet is a popover and must be anchored
      (`sharePositionOrigin` = the Share button's rect) or `share_plus`
      throws. The code passes the button's rect; confirm on an iPad that it
      opens next to the button, in portrait and landscape.
- [ ] iPhone: the share sheet opens; the text ends with https://screwout.pranta.dev (the marketing page, which should show the App Store button on iOS).

### Goldens recorded on Windows (re-record on the Mac)
- [ ] `test/golden/goldens/16-leaderboard*.png` were re-recorded on Windows
      for the new WEEK tab (2026-10-31). Run
      `flutter test --update-goldens test/golden/leaderboard_golden_test.dart`
      on the Mac so the reference images are Mac renders again.

### 5 to 7. Streak rewards, weekly board, workshop record
- [ ] Check the new UI on iPhone and iPad (fits, nothing clipped).

## From earlier work

- [ ] **Account deletion with Sign in with Apple:** deleting re-confirms
      with Apple and revokes the token (`revokeTokenWithAuthorizationCode`).
      Test on a device with a throwaway Apple-ID account: the Apple prompt
      appears, cancelling keeps the account, confirming deletes it.
- [ ] **In-app review** uses StoreKit on iOS (`in_app_review`); the gate
      (10 sheets, 2 days, 60-day spacing) is shared. "Rate Screw Out" in
      Settings opens the App Store page (`openStoreListing` may need the
      App Store id passed on iOS: check it opens the right listing).
- In-app **updates** are Android-only (Play); nothing to do on iOS.
