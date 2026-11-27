# screw_out_flutter_app

## Ad mediation (shared AdMob account)
This app is part of the owner's shared AdMob account with mediation (Unity Ads, Liftoff,
and Open Bidding exchanges). Read `docs/AD_MEDIATION.md` before any ads work: it lists
this app's AdMob IDs, which ad units sit in the shared mediation groups, the app-ads.txt
rule, and how to add the Unity/Liftoff adapters.

## Store names differ on purpose: Apple vs Google
The App Store listing is **not** the Play listing, and must stay different.
- Google Play: `Screw Out: Screw Puzzle`, with "screw puzzle / nuts and bolts"
  wording for search (see `STORE.md`).
- App Store: `Screw Out: Blueprint Puzzle`, built around blueprints and
  engineering drawings. Apple rejected the app on 2026-10-23 under Guideline
  4.3(a) (Spam) partly because the name and keywords echoed the screw puzzle
  genre ("bolt", "nut", "pin", "jam", "sort"). It passed only after the rename.
Never copy Play titles, short descriptions or keywords into App Store Connect
in any language. The App Store text, rules and checker for all 15 languages live
in `store_listings/app-store-i18n/` (`SOURCE.md`, `listings.json`, `check.py`).
