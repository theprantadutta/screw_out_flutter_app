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

## Products to create (6)

These are the only products the app sells for money today. All of them are
offered in **Settings > Purchases**.

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

No free trial is configured. If one is added later, add it in the store only;
the app reads offers from the store.

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

## In code but NOT sold (do not create yet)

These IDs exist in `Products` and the backend catalog, but no screen offers
them for money (themes are bought with coins on the Themes screen). Creating
them in App Store Connect without a way to buy them in the app gets the
submission rejected under Guideline 2.1.

| Product ID | Would unlock |
|---|---|
| `com.pranta.screwout.theme_pack_workshop` | Walnut Workshop theme |
| `com.pranta.screwout.theme_pack_ocean` | Ocean Teal theme |
| `com.pranta.screwout.theme_pack_midnight` | Midnight Workshop theme |
| `com.pranta.screwout.themes_bundle` | Every premium theme |

Note: the backend grants theme id `workshop` for `theme_pack_workshop`, while
the app's theme id is `walnut`. The app maps purchases to themes locally, so
this is harmless today, but align the two before selling theme packs.

---

## App Store Connect checklist

1. **Subscriptions > Create group** "Screw Out Pro"; group display name
   "Screw Out Pro".
2. Add `pro_yearly` (level 1) and `pro_monthly` (level 2): duration, price,
   English (U.S.) display name and description, review screenshot (Settings
   purchases section), review note.
3. **In-App Purchases > Create**: `remove_ads` (non-consumable) and the three
   coin packs (consumable), each with price, display name, description,
   review screenshot and review note.
4. On the app version page, attach all six under "In-App Purchases and
   Subscriptions" so they are reviewed with the build.
5. Agreements: the Paid Applications agreement, tax and banking must be active
   or products stay in "Missing Metadata".

## Google Play Console checklist

Same six products with the same IDs and prices. Subscriptions: one
subscription per product ID with a base plan (`monthly` / `yearly`,
auto-renewing). Coins are consumable one-time products; Remove Ads is a
non-consumable one-time product.

## Review note (paste into each product)

> Sold in Settings > Purchases. Purchases require signing in (Sign in with
> Apple is on the same screen). Restore Purchases is next to Remove Ads.
