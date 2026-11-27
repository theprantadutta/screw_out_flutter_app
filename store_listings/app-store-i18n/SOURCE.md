# App Store Connect listing: English source and rules

The App Store listing deliberately differs from Google Play. Apple rejected the
app on 2026-10-23 under Guideline 4.3(a) (Spam) partly because the name and
keywords echoed the crowded "screw puzzle / nuts and bolts / pin / jam" genre.
It passed after the listing was rebuilt around the blueprint / engineering
drawing idea. Keep it that way in every language:

- Never use the words for "screw puzzle", "nuts and bolts", "bolt", "nut",
  "pin", "jam", "sort" or "screw jam" in the name, subtitle or keywords.
  "Screw Out" is the brand and stays in Latin letters, untranslated.
- In the description, call the pieces "fasteners" (or the language's normal
  word for fastener / fixing) and the levels "drawings", as the English does.
- No price words ("free" and equivalents) in name or subtitle.
- No em or en dashes anywhere (use commas, colons or full stops).
- Chapter and theme names must be exactly the app's own translations in
  `lib/l10n/app_<lang>.arb` (keys chapterName1..5, themeNameBlueprint,
  themeNameWalnut, themeNameOcean, themeNameCopper, themeNameMidnight,
  themeNamePastel).
- Keep "APPROVED" and "DWG 001 to DWG 100" as is (they are on-screen labels).
- Keep the two URLs at the end exactly as they are.

## Fields and limits

| Field | Limit | English |
|---|---|---|
| name | 30 chars | `Screw Out: Blueprint Puzzle` |
| subtitle | 30 chars | `Take apart blueprint drawings` |
| keywords | 100 chars, comma separated, no spaces after commas, no words already in the name | `engineering,mechanical,drafting,logic,brain,relaxing,offline,daily,teaser,mind,casual,plate,layer` |
| promotionalText | 170 chars | `100 engineering drawings to take apart, one plate at a time. Plan the order, keep the tray clear, earn the APPROVED stamp. No timers, no lives.` |
| description | 4000 chars | below |

## description (English)

Screw Out is a calm puzzle game set on the drafting table. Every level is a technical drawing: stacked plates held down by fasteners. Release them in the right order, keep your small tray from overflowing, and take the whole assembly apart until the sheet is stamped APPROVED. No timers, no lives, no pressure.

HOW IT PLAYS

Tap a fastener to move it into the tray. When a plate has nothing holding it, it lifts away and shows the part beneath. The tray only holds a few fasteners at a time, so each drawing is a small planning problem: read the layers, work from the top down, and keep room for the move you will need next.

THE DRAWINGS

100 drawings in five chapters, from Workshop Basics to Master Builder. Each drawing is numbered (DWG 001 to DWG 100), every plate is labelled, and every one is checked by a solver so it can always be cleared.

Daily drawing: the same sheet for everyone each day, with a week strip, streaks and a daily leaderboard. Missing a day costs nothing.

Hints and undo: a hint points at the next useful fastener and never blocks progress. Undo your last move at any time.

Mastery marks: clear a drawing without a hint, restart or rescue to earn the diamond. Completely optional.

Leaderboards: most drawings cleared, the daily drawing in the fewest moves, and the longest daily streaks.

Workshop themes: Clean Blueprint plus five cosmetic finishes, from Walnut Workshop to Pastel Studio. They change the look, never the rules.

CALM BY DESIGN

Offline first: every drawing plays without a connection. Sign in with Apple, Google or email to back up your progress and keep iPhone and iPad in step.

A drafting-table look in blueprint blue, a soundtrack and sound set made for the game, haptics, and a reduced motion mode.

Made for iPhone and iPad, in 14 languages.

FREE, WITH OPTIONAL EXTRAS

Screw Out is free to play. It shows a small banner on menu screens and an occasional ad between drawings, never while you are solving one.

Remove Ads, coin packs and theme packs are one time purchases. Screw Out Pro is an optional subscription that removes ads and adds unlimited hints, every theme, free rescues and monthly coins. Pro is available monthly or yearly. Subscriptions renew automatically unless cancelled at least 24 hours before the end of the current period, and you can manage or cancel them any time in your App Store account settings. No account is needed to buy; signing in is optional and keeps purchases on all your devices.

Privacy policy: https://legal.pranta.dev/privacy/html?projectName=screw_out
Terms of use: https://legal.pranta.dev/terms/html?projectName=screw_out
