# Screw Out: store products

Source of truth for in-app purchases on the App Store and Google Play. Product
IDs must match `lib/services/ports.dart` (`Products`) and the backend's
`ScrewOut.Domain/Catalog/ProductCatalog.cs` exactly.

House style for store copy: no em dashes or en dashes.

| Platform | Identifier |
|---|---|
| iOS (App Store) | `com.pranta.screwout` |
| Android (Google Play) | `com.pranta.screwout` |

All product IDs use the `com.pranta.screwout.` prefix.

---

## Products to create (10)

Everything the app sells for money. Pro, Remove Ads and the coin packs are
offered in **Settings > Purchases**; the theme packs and the bundle on the
**Themes** screen.

### Subscriptions (auto-renewable): group "Screw Out Pro"

| Product ID | Reference name | Display name | Duration | Price (USD) |
|---|---|---|---|---|
| `com.pranta.screwout.pro_monthly` | Pro Monthly | Screw Out Pro Monthly | 1 month | $2.99 |
| `com.pranta.screwout.pro_yearly` | Pro Yearly | Screw Out Pro Yearly | 1 year | $19.99 |

Yearly is 44% less than twelve months of monthly. Both sit in the same group
(level 1 = yearly, level 2 = monthly) so a player can switch between them.

**Description (both, 45 char limit):** `No ads, unlimited hints, all themes, coins` [42]

**What Pro gives** (`PremiumCubit`, `ProductCatalog.ProMonthlyCoinGrant`):
no banner, interstitial or app-open ads; unlimited hints; every theme; free
stuck rescues; 1,000 coins every month.

**Free trials:** `pro_monthly` has 3 days, `pro_yearly` has 7 days.

| Product | Google Play base plan | Google Play offer ID | Length |
|---|---|---|---|
| `pro_monthly` | `monthly` | `free-trial-3d` | 3 days |
| `pro_yearly` | `yearly` | `free-trial-7d` | 7 days |

Play eligibility is New customer acquisition, "Never had any subscription", so
one player gets one trial across both plans. On the App Store, add an
introductory offer (Free, same lengths) to each subscription.

The app reads trials from the store and shows them in Settings only to players
who qualify, so changing a length needs no app release. A trial grants Pro at
once, but the 1,000 monthly coins start with the first payment.

### Remove Ads (non-consumable)

| Product ID | Reference name | Display name | Price (USD) |
|---|---|---|---|
| `com.pranta.screwout.remove_ads` | Remove Ads | Remove Ads | $2.99 |

**Description:** `Removes banner and between-sheet ads forever` [44]

Turns off banner, interstitial and app-open ads. Rewarded videos stay as an
optional choice.

### Coin packs (consumable)

| Product ID | Reference name | Display name | Coins | Price (USD) | Coins per $ |
|---|---|---|---|---|---|
| `com.pranta.screwout.coins_small` | Coins Small | 500 Coins | 500 | $0.99 | 505 |
| `com.pranta.screwout.coins_medium` | Coins Medium | 1,500 Coins | 1,500 | $1.99 | 754 |
| `com.pranta.screwout.coins_large` | Coins Large | 4,000 Coins | 4,000 | $4.99 | 802 |

**Descriptions:**
- small: `A handful of coins for themes and rescues` [41]
- medium: `A stack of coins for themes and rescues` [39]
- large: `A crate of coins for themes and rescues` [38]

What coins buy: themes (300 to 800 coins) and the stuck rescue extra slot
(120 coins, `GameHost.rescueCoinCost`). Clearing a sheet earns 20 to 25 coins.

---

### Theme packs and bundle (non-consumable)

| Product ID | Reference name | Display name | Unlocks | Price (USD) |
|---|---|---|---|---|
| `com.pranta.screwout.theme_pack_workshop` | Theme Walnut | Walnut Workshop Theme | Walnut Workshop | $0.99 |
| `com.pranta.screwout.theme_pack_ocean` | Theme Ocean | Ocean Teal Theme | Ocean Teal | $0.99 |
| `com.pranta.screwout.theme_pack_midnight` | Theme Midnight | Midnight Workshop Theme | Midnight Workshop | $1.49 |
| `com.pranta.screwout.themes_bundle` | All Themes | All Themes | Every paid theme (5) | $2.99 |

**Descriptions (App Store, 45 char limit):**
- workshop: `Warm wood board theme, yours to keep` [36]
- ocean: `Sea-green board theme, yours to keep` [36]
- midnight: `Dark slate board theme, yours to keep` [37]
- bundle: `Every paid board theme, yours to keep` [37]

Where they are sold: a theme's preview sheet on the Themes screen shows
"OR BUY · price" under the coin price (Walnut, Ocean and Midnight only), and
an "All themes" card sits on top of the Themes screen until every paid theme
is owned. Both are hidden for Pro, which already includes every theme. Warm
Copper and Pastel Studio have no pack of their own: coins, chapter rewards,
Pro or the bundle.

Every theme can still be bought with coins (300 to 800) or earned by
finishing a chapter, so the packs are a shortcut, never a paywall.

The backend calls the Walnut theme `workshop`; the app maps it to `walnut`
(`lib/services/sync/wire_ids.dart`).

---

## App Store Connect checklist

1. **Subscriptions > Create group** "Screw Out Pro"; group display name
   "Screw Out Pro".
2. Add `pro_yearly` (level 1) and `pro_monthly` (level 2): duration, price,
   English (U.S.) display name and description, review screenshot (Settings
   purchases section), review note.
3. **In-App Purchases > Create**: `remove_ads`, the three theme packs and
   `themes_bundle` (non-consumable) and the three coin packs (consumable), each with price, display name, description,
   review screenshot and review note.
4. On the app version page, attach all ten under "In-App Purchases and
   Subscriptions" so they are reviewed with the build.
5. Agreements: the Paid Applications agreement, tax and banking must be active
   or products stay in "Missing Metadata".

## Google Play Console checklist

Same ten products with the same IDs and prices (theme packs and the bundle
are non-consumable one-time products, purchase option id `buy`; created on
Play 2026-11-08). Subscriptions: one
subscription per product ID with a base plan (`monthly` / `yearly`,
auto-renewing) and its free trial offer. Coins are consumable one-time
products; Remove Ads is a non-consumable one-time product.

Set the price currency to USD before typing: the Set prices dialog defaults to
the account's local currency (BDT).

## Review note (paste into each product)

> Sold in Settings > Purchases. Purchases require signing in (Sign in with
> Apple is on the same screen). Restore Purchases is next to Remove Ads.
