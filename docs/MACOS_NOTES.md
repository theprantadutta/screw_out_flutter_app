# Notes for macOS / iOS sessions

The Windows machine can build and run Android only. Everything below was
written (or changed) there and still needs a check on an iPhone **and an
iPad** from a Mac. Tick items off here as they are verified, with the date.

## Start here: iOS status (2026-11-08)

**iOS is not on sale, and the next build will likely be rejected until the
blocker below is fixed.** Android is live with all six products and the trials.

### Blocker: Apple rejected 1.0.2 under Guideline 5.1.1(v)

Rejected 2026-11-05 (build 1.0.2 (4), reviewed on an iPad Air 11-inch M3). The
app forces guests to register before buying, and Apple requires registration
to be optional, for subscriptions too. It may explain the benefit of an
account, but it cannot require one.

**Fixed 2026-11-08 in 1.3.0 (10)** (approved by Pranta). Guests buy and
restore with no account, and get an optional "Keep your purchase" sign-in
after buying (once per run). The server accepts guest receipts and, when
another account presents a guest's receipt (sign-in to an existing account,
or reinstall plus Restore), moves the guest's purchases, subscription ids,
billing period and unclaimed coins to it (`GuestPurchaseTransfer.cs`).
Receipts owned by a real account never move. What used to block guests:

| Where | What |
|---|---|
| `lib/widgets/purchase_gate.dart` | `ensureAccountForPurchase` shows the sign-in sheet to guests |
| `lib/services/user_service.dart` | `canPurchase` is false for guests |
| `lib/services/purchases/purchase_service.dart` | `_accountReady` stops `buy` and `restore` |
| Backend `VerifyPurchase.cs` | refuses guests with `ANONYMOUS_ACCOUNT_PURCHASE_BLOCKED` |
| App Store Connect review notes, `STORE.md` | both say purchases require an account |

Proposed fix, **waiting on Pranta's approval**: guests buy on their anonymous
account on both platforms, the app offers an optional "sign in to keep your
purchases on all your devices", and Restore Purchases covers reinstalls. The
hard part is the backend, which assumes a real account owns each purchase: when
a guest signs in later, the purchase has to move to that account or Pro gets
stranded on the guest. Purchases are keyed by store transaction, so a second
account restoring the same receipt is the case to design for.

### What App Store Connect has

App id `6825659147`, subscription group `22503171` ("Screw Out Pro").

| Item | Id | State |
|---|---|---|
| Pro Monthly | `6825698367` | Ready for Review, 3-day free intro offer, Nov 8 2026, no end date, 175 regions |
| Pro Yearly | `6825696999` | Ready for Review, 1-week free intro offer, Nov 8 2026, no end date, 175 regions |
| Remove Ads, Coins Small / Medium / Large | | Ready for Review |
| Theme Walnut / Ocean / Midnight, All Themes | `6832207387` / `6832207864` / `6832208231` / `6832208705` | Created 2026-11-08: $0.99 / $0.99 / $1.49 / $2.99, 175 regions, review screenshots in `app-store-review/` |
| iOS version | 1.0.2 (4) | Rejected, submission `1e853d9a-7e4e-4075-8df7-0e1a4fb23a9f` |

Every purchase sits inside that rejected submission, so none of them ship until
a version is accepted.

### Next steps, in order

1. [x] Agree and build the guest purchase fix (above), on the app and backend.
       (2026-11-08; backend deploy needed before the review)
2. [ ] Set up this machine (see below).
3. [ ] Run the trial checks and the sandbox checks further down.
4. [ ] App Store Connect: create version 1.3.0 (or later) and upload the build.
       The repo is at `1.3.0+9`; the store still shows 1.0.2.
5. [ ] Reword the review notes on both subscriptions: drop "Purchases require
       an account", and mention the free trials. Update `STORE.md` to match.
6. [ ] Reply to App Review saying what changed, then resubmit with the
       purchases attached.

### Setting up the Mac

- Flutter 3.47.9 or newer: `pubspec.yaml` needs Dart `^3.13.5`.
- `dart run build_runner build --delete-conflicting-outputs`: the `*.g.dart`
  files are gitignored, and the app and tests will not compile without them.
- `lib/firebase_options.dart`, `ios/Runner/GoogleService-Info.plist` and `.env`
  are gitignored too, so copy them over or regenerate them.

### Free trial checks (added 2026-11-07, never run on iOS)

Tested only by unit and widget tests so far: no iOS device or sandbox run, and
no real purchase on either platform.

- [ ] **Settings shows the trial:** a new sandbox account sees "3 DAYS FREE /
      THEN $2.99" and "7 DAYS FREE / THEN $19.99", plus the renewal terms.
      Check the taller buttons (68 instead of 52) on iPhone and iPad. Goldens
      use a store with no trial, so they do not cover this layout.
- [ ] **Eligibility:** `_loadIntroEligibility` calls
      `isEligibleForIntroOfferIOS` with the subscription group id, and plugin
      11.3.0 sends that value under a key named `productId`. Confirm it answers
      correctly. If it fails, the app shows no trial (safe) while StoreKit
      still applies it at checkout, so the player gets a trial they were not
      told about in the app.
- [ ] **Already used a trial:** a sandbox account that had one sees plain
      prices. On iOS, one intro offer per subscription group.
- [ ] **No coins at trial start:** Pro unlocks at once and no 1,000 coins
      arrive. The backend reads `offerDiscountType` = `FREE_TRIAL` from the JWS.
- [ ] **Coins at conversion:** when the sandbox trial converts, 1,000 coins
      arrive once. **This depends on App Store Server Notifications V2** (the
      checkbox further down): during a trial no billing period is stored, and
      there is no Apple reconcile job, so without DID_RENEW the coins never
      come. Check that URL is set before testing this.
- [ ] **Cancelled trial:** cancel during the trial. Pro ends at the trial's
      end and no coins are ever paid.

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

## In-app purchases (flutter_inapp_purchase 11.3, 2026-10-31)

The plugin went from 10.7.3 to 11.3.0 (OpenIAP apple 4.0.6, google 4.0.7 /
Play Billing 9.1.0). Android was built and checked on Windows; nothing on
iOS has been run yet. The app code did not change: the only API break was
the new required `storeId` field ('apple' / 'play'), which only the test
fixtures construct. Do these in order.

### Build
- [ ] `flutter clean && flutter pub get`, then `cd ios && pod install
      --repo-update` (or let SwiftPM resolve it if the project uses SPM).
      OpenIAP needs iOS 15+; the project already targets 15.0.
- [ ] `flutter build ios --release` builds with no new warnings about
      OpenIAP. The app already uses `FlutterSceneDelegate`
      (`ios/Runner/SceneDelegate.swift`), which newer SDKs require.
- [ ] Debug run on an iPhone: the store screen lists real prices (not
      placeholders). If products come back empty, check in App Store
      Connect that every product below is "Ready to Submit" or approved,
      that the Paid Apps agreement is active, and the bundle id matches.

Product ids (all prefixed `com.pranta.screwout.`): consumables
`coins_small`, `coins_medium`, `coins_large`; non-consumables
`remove_ads`, `theme_pack_workshop`, `theme_pack_ocean`,
`theme_pack_midnight`, `themes_bundle`; subscriptions `pro_monthly`,
`pro_yearly`.

### Sandbox purchase checks (Settings > App Store > Sandbox Account)
Run these as a guest (no account) and again signed in: guests can buy since
2026-11-08 (see "Start here"). Also check a guest who buys, then signs into an
EXISTING account: the purchase must follow to that account.
- [ ] **Coins:** buy `coins_small`. The balance goes up once, the toast
      shows, and buying the same pack again works (the transaction was
      finished as a consumable). Kill the app mid-purchase once: on
      relaunch the coins arrive exactly once, never twice.
- [ ] **Non-consumable:** buy `remove_ads`. Ads stop. Delete and reinstall,
      sign in, tap Restore: it comes back with no second charge.
- [ ] **Subscription:** buy `pro_monthly`. Pro shows in Settings and the
      server row (`/api/v1/purchases/verify` succeeded; check the dashboard
      Purchases page shows platform ios with an expiry). Sandbox renews
      every few minutes: leave it running and confirm the expiry moves.
      Cancel in sandbox settings and confirm Pro ends after the last
      renewal.
- [ ] **Ask to Buy / deferred:** with a sandbox child account (or StoreKit
      config "Ask to Buy"), the purchase shows as pending, grants nothing,
      and grants once approved (the reconcile on resume picks it up).
- [ ] **Cancel:** cancelling the Apple sheet shows no error toast.
- [ ] **Server down:** turn off Wi-Fi after the Apple sheet confirms. The
      item is delivered locally, the receipt is queued, and when the
      network returns the server verifies it (no duplicate grant). This is
      deliberate (it mirrors the Play rule that unfinished purchases get
      refunded), even though the OpenIAP AI guide says to finish only
      after the backend grants.
- [ ] **Rejected receipt:** not easy to force; if seen, iOS finishes the
      transaction (Apple has no auto-refund) and grants nothing.

### What the server expects from iOS
- `purchaseToken` on iOS is the StoreKit 2 JWS; the API verifies it with
  `AppleJwsVerifier` (Apple root cert chain) and dedupes by transaction id.
  The production API needs `APPLE_BUNDLE_ID`, `APPLE_ENVIRONMENT`,
  `APPLE_ISSUER_ID`, `APPLE_KEY_ID` and `APPLE_PRIVATE_KEY` set;
  sandbox JWS from TestFlight must be accepted (check the environment
  claim handling if TestFlight purchases are rejected).
- `appAccountToken` is the user's UUID. Confirm in the JWS payload (API
  logs at debug level) that it matches the signed-in user.
- [ ] App Store Server Notifications V2: set the URL in App Store Connect
      (App Information > App Store Server Notifications) to
      `https://<api host>/api/v1/purchases/webhook/app-store` (V2, both
      production and sandbox), for refunds and renewals while the app is closed.

### Crashlytics on iOS (added the same day)
- [ ] Add the Crashlytics dSYM upload run script to the Runner target
      (`flutterfire configure` can add it, or
      `${PODS_ROOT}/FirebaseCrashlytics/run`), so stack traces symbolicate.
- [ ] Release build: use Debug > SEND TEST CRASH REPORT in a debug build,
      and confirm a real report appears in the Firebase console for the
      iOS app within a few minutes.

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
