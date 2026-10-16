/// Pure interstitial / app-open decisions (snake-classic's GameOverAdGate,
/// adapted). Unit-tested; AdService only feeds it facts.
abstract final class AdGate {
  /// Never before this many clears in an install, and never on the first
  /// [firstAdSheet] − 1 sheets (they teach the game).
  static const minClearsBeforeInterstitial = 15;
  static const firstAdSheet = 16;

  /// Show at most every Nth level completion…
  static const everyNCompletions = 6;

  /// …and never more often than this, whatever the pace of play.
  static const minGapMs = 6 * 60 * 1000;

  /// Gap between any two full-screen ads (interstitial or app-open).
  static const minFullScreenGapMs = 3 * 60 * 1000;

  /// Interstitial after a level-complete card is dismissed?
  static bool interstitial({
    required bool noAds,
    required bool adsEnabled,
    required bool loaded,
    required bool isDaily,
    required int levelId,
    required int clearsThisInstall,
    required int completionsSinceLastAd,
    required int msSinceLastInterstitial,
    required int msSinceAnyFullScreenAd,
  }) {
    if (noAds || !adsEnabled || !loaded) return false;
    if (isDaily) return false;
    if (levelId < firstAdSheet || clearsThisInstall < minClearsBeforeInterstitial) return false;
    if (completionsSinceLastAd + 1 < everyNCompletions) return false;
    if (msSinceLastInterstitial < minGapMs) return false;
    if (msSinceAnyFullScreenAd < minFullScreenGapMs) return false;
    return true;
  }

  static const appOpenMinAwayMs = 30 * 60 * 1000;
  static const appOpenMinGapMs = 30 * 60 * 1000;

  /// App-open ad on resume?
  static bool appOpen({
    required bool noAds,
    required bool adsEnabled,
    required bool loaded,
    required bool coldStart,
    required bool suppressed,
    required int msAway,
    required int msSinceLastAppOpen,
    required int msSinceAnyFullScreenAd,
  }) {
    if (noAds || !adsEnabled || !loaded || coldStart || suppressed) return false;
    if (msAway < appOpenMinAwayMs) return false;
    if (msSinceLastAppOpen < appOpenMinGapMs) return false;
    if (msSinceAnyFullScreenAd < minFullScreenGapMs) return false;
    return true;
  }
}
