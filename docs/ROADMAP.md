# Screw Out roadmap (from 2026-10-31)

Android payments are not live yet (iOS payments are). Until they are, work
on things that need no Play billing. Every item must look right on phones
**and** tablets (Android Tab A9 here, iPad on the Mac): check the tablet
before calling anything done. iOS-only checks are collected in
[MACOS_NOTES.md](MACOS_NOTES.md).

Status: `[ ]` todo · `[~]` in progress · `[x]` done (commit noted).

## Why these items

Live data on 2026-10-31 (58 accounts, 115 sessions, 32 push tokens):
no crashes; the server notification log was **empty** (no push ever sent);
sheets 8 and 12 are early difficulty spikes (sheet 12: 25 tray-full moments,
12 restarts, 1 of 2 players through); the golden tests fail on whichever
machine did not record them.

## 1. Notifications that actually reach players

- [x] **App:** always schedule the on-device 19:00 daily reminder (dc0be64). It was
      skipped whenever the app had an API session (anyone who allowed
      notifications), on the assumption the server would send it; the server
      never did, so nobody got a reminder.
- [x] **API:** retire the server `daily-sheet-reminder` job (api e03beca) (the device owns
      that reminder now, so nobody gets two). Keep the server-only pushes:
      streak-at-risk (21:30), win-back (idle 7 to 90 days), Pro coins.
- [ ] **Ops (owner, on the server):** in the production `.env`, delete
      `HANGFIRE_SERVER_ENABLED` (or set it to `true`) and set
      `HANGFIRE_REDIS_PREFIX=screw_out_hangfire:`, then restart the API. Without
      this no background job runs: no pushes, no subscription expiry, no Pro
      monthly coins. Verify on the dashboard's System sheet (A-09).
- iOS: see MACOS_NOTES (permission prompt, APNs key in Firebase, local
  notification while foregrounded).

## 2. Ease the chapter-1 spikes (sheets 8 and 12)

- [x] Make sheets 8 and 12 gentler (4109767: sheet 12 random-win 3.8% to 77%, sheet 8 40% to 68%; old saves on those sheets restart fresh) (the campaign should feel easy), keep
      every sheet solver-valid (`dart run tool/validate_levels.dart`).

## 3. Golden tests that pass on every machine

- [x] Compare goldens with a small tolerance (5% off the Mac, strict on the Mac; test/flutter_test_config.dart) so the Mac (reference) and
      Windows renders both pass; real layout changes still fail.

## 4. Share your daily result

- [ ] "Share" on the daily result card and on the Daily screen once done:
      `Screw Out · D-289 · 11 moves ◆` plus the store link. Uses the system
      share sheet (`share_plus`). **iPad needs a popover anchor**
      (`sharePositionOrigin`) or it crashes: see MACOS_NOTES.

## 5. Streak rewards

- [ ] Coins when today's daily extends a streak to 3, 7 or 14 days (then
      every 7 days). Shown on the daily result card. Coins only, no real
      money. Awarded once per milestone day (idempotent ledger key), so a
      second device pulling the same daily never pays twice.

## 6. Weekly leaderboard

- [ ] **API:** new board `weekly`: sheets first cleared since Monday 00:00
      UTC (replays don't count).
- [ ] **App:** a WEEK tab next to SHEETS / DAILY / STREAK, so new players
      have a board they can top. Check the four tabs fit a 360 dp phone.

## 7. Workshop record (milestones)

- [ ] A "Workshop record" page with badges earned from progress already on
      the device (chapters finished, sheets cleared, ◆ count, best streak,
      dailies played), plus a toast the moment one is earned. Entry from the
      campaign screen. No server needed (all derived from synced data).

## Later

- Accessibility pass (screen-reader labels on screws and plates, contrast).
- Crash reporting (Firebase Crashlytics) now that both stores are live.
- Update the six plugins behind the "Kotlin Gradle Plugin" build warning
  when they publish Built-in Kotlin support.
- Android monetization once Play billing is live (products already exist).
