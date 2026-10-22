// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Pause';

  @override
  String get back => 'Back';

  @override
  String get settings => 'Settings';

  @override
  String coinsBalance(int coins) {
    return '$coins coins';
  }

  @override
  String get tray => 'TRAY';

  @override
  String get trayFull => 'TRAY FULL';

  @override
  String get undo => 'UNDO';

  @override
  String hintCount(String count) {
    return 'HINT · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Paused';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · MOVE $moves';
  }

  @override
  String get resume => 'Resume';

  @override
  String get sound => 'SOUND';

  @override
  String get haptics => 'HAPTICS';

  @override
  String get reducedMotion => 'REDUCED MOTION';

  @override
  String get restart => 'RESTART';

  @override
  String get exitToSheets => 'EXIT TO SHEETS';

  @override
  String get restartConfirmTitle => 'Restart this sheet?';

  @override
  String restartConfirmBody(int moves) {
    return 'You\'ll lose $moves moves of progress.';
  }

  @override
  String get cancel => 'CANCEL';

  @override
  String get stuckTitle => 'No open slots left.';

  @override
  String get stuckRescueTitle => 'OR BUY ONE EXTRA SLOT FOR THIS SHEET';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count screws',
      one: 'one screw',
    );
    return '$plate still holds $_temp0 on the board. Undo frees a slot.';
  }

  @override
  String get stuckReasonGeneric =>
      'Every slot is taken and no plate can drop. Undo frees a slot.';

  @override
  String get undoLastMove => 'Undo last move';

  @override
  String get hint => 'HINT';

  @override
  String get rescueSlot => 'EXTRA SLOT';

  @override
  String rescueSlotCoins(int coins) {
    return 'EXTRA SLOT · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'EXTRA SLOT · VIDEO';

  @override
  String get rescueSlotPro => 'EXTRA SLOT · PRO';

  @override
  String get outOfHintsTitle => 'Want one more hint?';

  @override
  String get hintsLeftZero => 'HINTS · 0 LEFT';

  @override
  String get outOfHintsBody =>
      'A hint rings one useful next screw. It never solves the sheet.';

  @override
  String get watchVideo => 'Watch a short video';

  @override
  String get watchVideoMeta => 'OPTIONAL · ~30 S · +1 HINT';

  @override
  String useCoins(int coins) {
    return 'Use $coins coins';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'BALANCE $balance ¢';
  }

  @override
  String get keepThinking => 'Keep thinking';

  @override
  String get notEnoughCoins => 'Not enough coins yet.';

  @override
  String get adUnavailable => 'No video available right now.';

  @override
  String cleared(String code) {
    return '$code · CLEARED';
  }

  @override
  String get disassembled => 'Disassembled.';

  @override
  String get approved => 'APPROVED';

  @override
  String get statMoves => 'MOVES';

  @override
  String get statTime => 'TIME';

  @override
  String get statMastery => 'MASTERY';

  @override
  String nextSheet(String code) {
    return 'Next sheet · $code';
  }

  @override
  String get replay => 'REPLAY';

  @override
  String get sheets => 'SHEETS';

  @override
  String get home => 'HOME';

  @override
  String get dailyDone => 'Daily sheet done';

  @override
  String get backHome => 'Back home';

  @override
  String chapterComplete(String chapter) {
    return 'CHAPTER $chapter · COMPLETE';
  }

  @override
  String chapterSheetsMastered(int done, int total, int mastered) {
    return '$done / $total SHEETS · $mastered MASTERED ◆';
  }

  @override
  String get rewardCoins => 'COINS';

  @override
  String get themeUnlocked => 'THEME UNLOCKED';

  @override
  String nextChapter(String chapter) {
    return 'NEXT · CHAPTER $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Start Chapter $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'EQUIP $name';
  }

  @override
  String get tutorialStep1 => 'STEP 1 · TAP THE SCREW';

  @override
  String get tutorialLands => '↓ IT LANDS IN THE TRAY';

  @override
  String get skipTutorial => 'SKIP TUTORIAL';

  @override
  String get splashTagline => 'A PUZZLE OF LAYERS';

  @override
  String get splashFooter => 'REV 1.0 · SHEET 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLATES',
      one: '1 PLATE',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'FASTENERS',
      one: 'FASTENER',
    );
    return 'FIG. 1\nEXPLODED VIEW\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'CHAPTER $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'FASTENERS',
      one: 'FASTENER',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'NEXT SHEET';

  @override
  String chapterLabel(String chapter) {
    return 'CHAPTER $chapter';
  }

  @override
  String get campaign => 'CAMPAIGN';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Continue · $code';
  }

  @override
  String get daily => 'DAILY';

  @override
  String get themes => 'THEMES';

  @override
  String get allCleared => 'All sheets cleared';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total SHEETS';
  }

  @override
  String get fiveChapters => 'Five chapters';

  @override
  String get chaptersTitle => 'Chapters';

  @override
  String get masteryNote =>
      '◆ MASTERY = CLEARED WITHOUT A HINT OR RESTART. PURELY COSMETIC, NEVER NEEDED TO PROGRESS.';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'LOCKED';

  @override
  String get downloadChapter => 'DOWNLOAD';

  @override
  String get downloading => 'DOWNLOADING…';

  @override
  String get comingSoon => 'MORE SHEETS SOON';

  @override
  String newMechanic(String mechanic) {
    return 'NEW: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates plates',
      one: '1 plate',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers layers',
      one: '1 layer',
    );
    return '$_temp0 · $_temp1 · tray $tray';
  }

  @override
  String get theCampaign => 'THE CAMPAIGN';

  @override
  String get campaignFooter =>
      'Chapters unlock by finishing the one before. Mastery marks are optional. Hints never block progress.';

  @override
  String get chapterBonus => 'CHAPTER BONUS';

  @override
  String get play => 'Play';

  @override
  String get dailySheet => 'DAILY SHEET';

  @override
  String get dailyTitle => 'TITLE';

  @override
  String get dailyPlates => 'PLATES';

  @override
  String get dailyReward => 'REWARD';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak-day streak.',
      one: '1-day streak.',
      zero: 'Start a streak.',
    );
    return 'Same sheet for everyone today. No timer. $_temp0 Missing a day costs nothing.';
  }

  @override
  String get startDaily => 'Start today\'s sheet';

  @override
  String get dailyCompleted => 'Done for today · back tomorrow';

  @override
  String get replayDaily => 'Replay today\'s sheet';

  @override
  String get themesTitle => 'Themes';

  @override
  String get themesCaption => 'COSMETIC · NEVER CHANGES RULES';

  @override
  String get equipped => 'EQUIPPED';

  @override
  String get owned => 'OWNED';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'PREVIEW';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get feedbackSection => 'FEEDBACK';

  @override
  String get soundEffects => 'Sound effects';

  @override
  String get music => 'Music';

  @override
  String get hapticsRow => 'Haptics';

  @override
  String get reducedMotionRow => 'Reduced motion';

  @override
  String get reducedMotionCaption => 'Fades instead of travel';

  @override
  String get generalSection => 'GENERAL';

  @override
  String get highRefreshRate => 'High refresh rate';

  @override
  String highRefreshRateOn(int hz) {
    return 'Smoother motion · up to $hz Hz · uses more battery';
  }

  @override
  String get highRefreshRateOff => 'Smoother motion · uses more battery';

  @override
  String get highRefreshRateUnsupported => 'This screen runs at a single rate';

  @override
  String get highRefreshRateBattery => 'Limited by battery saver right now';

  @override
  String get highRefreshRateHeat => 'Limited while the phone is warm';

  @override
  String highRefreshRateNow(int hz) {
    return 'Now $hz Hz';
  }

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Daily reminder';

  @override
  String get notificationsCaption => 'One nudge when a new sheet is up';

  @override
  String get accountSection => 'ACCOUNT';

  @override
  String get signInGoogle => 'Sign in with Google';

  @override
  String get signInApple => 'Sign in with Apple';

  @override
  String signedInAs(String name) {
    return 'Signed in · $name';
  }

  @override
  String get guestCaption => 'PLAYING AS GUEST · SIGN IN TO SAVE PROGRESS';

  @override
  String get signOut => 'SIGN OUT';

  @override
  String get deleteAccount => 'DELETE ACCOUNT';

  @override
  String get purchasesSection => 'PURCHASES';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get restore => 'RESTORE';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'NO ADS · UNLIMITED HINTS · ALL THEMES · FREE RESCUES · $coins ¢ MONTHLY';
  }

  @override
  String get proMonthly => 'MONTHLY';

  @override
  String get proYearly => 'YEARLY';

  @override
  String get proActive => 'PRO · ACTIVE';

  @override
  String get adsRemoved => 'ADS REMOVED';

  @override
  String get coinPacks => 'COIN PACKS';

  @override
  String get aboutSection => 'ABOUT';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get refundPolicy => 'Refund policy';

  @override
  String get privacyChoices => 'Privacy choices';

  @override
  String get licenses => 'Licenses & credits';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'A nudge for the daily sheet?';

  @override
  String get notificationPrimerBody =>
      'One quiet reminder in the evening when you haven\'t played. Never more.';

  @override
  String get allow => 'ALLOW';

  @override
  String get notNow => 'NOT NOW';

  @override
  String get offline => 'OFFLINE';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get purchaseThanks => 'Thank you! Purchase applied.';

  @override
  String get purchasePending =>
      'Purchase pending. It will apply once confirmed.';

  @override
  String get purchaseFailed => 'Purchase didn\'t go through.';

  @override
  String get signInToPurchase => 'Sign in first so your purchase follows you.';

  @override
  String get restored => 'Purchases restored.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Finish Chapter $chapter first.';
  }

  @override
  String get moreSheetsTitle => 'More sheets';

  @override
  String get moreSheetsCaption => 'New drawing sets arrive here';

  @override
  String get languageEnglish => 'English';

  @override
  String get equip => 'EQUIP';

  @override
  String buyFor(int coins) {
    return 'BUY · $coins ¢';
  }

  @override
  String get close => 'CLOSE';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Licenses';

  @override
  String get licensesCaption => 'OPEN-SOURCE NOTICES';

  @override
  String playLevel(String code) {
    return 'Play $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Sheet $number, locked';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Leaderboards';

  @override
  String get leaderboardCaption => 'SIGNED-IN PLAYERS · LIVE';

  @override
  String get boardSheets => 'SHEETS';

  @override
  String get boardDaily => 'DAILY';

  @override
  String get boardStreak => 'STREAK';

  @override
  String get boardSheetsHint => 'MOST SHEETS CLEARED';

  @override
  String get boardDailyHint => 'TODAY\'S SHEET · FEWEST MOVES, THEN FASTEST';

  @override
  String get boardStreakHint => 'DAYS IN A ROW ON THE DAILY SHEET';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'MOVES',
      one: 'MOVE',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'DAYS',
      one: 'DAY',
    );
    return '$_temp0 · BEST $best';
  }

  @override
  String get boardYou => 'YOU';

  @override
  String get boardYourRank => 'YOUR RANK';

  @override
  String get boardNotRanked => 'Not ranked yet';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'OF $countString';
  }

  @override
  String get boardGuest =>
      'Sign in to put your name on the board. Your progress comes with you.';

  @override
  String get boardEmpty => 'No one here yet. Be the first.';

  @override
  String get boardOffline => 'Can\'t reach the leaderboard right now.';

  @override
  String get tryAgainCaps => 'TRY AGAIN';

  @override
  String get todaysBoard => 'TODAY\'S BOARD';

  @override
  String get signedOutToast =>
      'Signed out · this device was cleared. Sign in again to get your progress back.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String welcomeBackName(String name) {
    return 'Welcome back, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets sheets',
      one: '1 sheet',
    );
    return '$who · $_temp0 and $coins coins restored';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · you\'re signed in and progress is backed up';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets sheets',
      one: '1 sheet',
    );
    return '$who · this device\'s progress was added to your account: $_temp0, $coins coins';
  }

  @override
  String syncSavedNew(String name) {
    return 'Signed in as $name · your progress is now saved to your account';
  }

  @override
  String get syncSavedNewPlain =>
      'Signed in · your progress is now saved to your account';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets new sheets',
      one: '1 new sheet',
      zero: 'progress updated',
    );
    return 'Synced from your other device · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Couldn\'t load your saved progress yet · it will sync automatically when the connection is back';

  @override
  String get signedInOffline =>
      'Signed in · your progress will sync when you\'re back online';

  @override
  String get proActivated =>
      'Pro is active · no ads, every theme and unlimited hints';

  @override
  String get accountDeletedToast =>
      'Your account and all its data were deleted.';

  @override
  String accountDeletedProToast(String store) {
    return 'Account deleted. Pro is still billed until you cancel it in $store.';
  }

  @override
  String get deleteSheetTitle => 'Delete your account?';

  @override
  String get deleteSheetBody =>
      'This permanently deletes your account and everything saved with it: progress on every sheet, coins, themes, your daily streak and leaderboard places. It can\'t be undone.';

  @override
  String deleteSheetPro(String store) {
    return 'You have Screw Out Pro. Deleting your account does not cancel it: cancel the subscription in $store or you\'ll keep being billed.';
  }

  @override
  String get manageSubscription => 'Manage subscription';

  @override
  String get deleteForever => 'Delete my account';

  @override
  String get deleting => 'Deleting…';

  @override
  String get keepAccount => 'Keep my account';

  @override
  String get deleteOffline =>
      'You\'re offline. Connect to the internet to delete your account.';

  @override
  String get deleteFailed => 'Couldn\'t delete your account. Please try again.';

  @override
  String get restoreNothing => 'Nothing to restore on this account.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 hint';
  }

  @override
  String get hintEarnedToast => '+1 hint · thanks for watching';

  @override
  String get rescueToast => '+1 tray slot for this sheet';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 tray slot';
  }

  @override
  String get adNotCompleted => 'Video didn\'t finish, so no reward this time.';

  @override
  String themeEquippedToast(String name) {
    return '$name equipped';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'Chapter $chapter is ready';
  }

  @override
  String get signInFailed => 'Sign-in didn\'t complete.';

  @override
  String get themePurchased => 'Theme unlocked.';

  @override
  String get proPerYear => '/ YEAR';

  @override
  String get proPerMonth => '/ MONTH';

  @override
  String sheetsTotal(int count) {
    return '$count SHEETS';
  }

  @override
  String get dailyWeekDone => 'Done';

  @override
  String masteredCount(int count) {
    return '$count MASTERED';
  }

  @override
  String get reminderTitle => 'Today\'s sheet is ready';

  @override
  String get reminderBody => 'One fresh drawing, same for everyone. No timer.';

  @override
  String get signInEmail => 'Continue with email';

  @override
  String get emailSignInTitle => 'Sign in';

  @override
  String get emailCreateTitle => 'Create account';

  @override
  String get emailTabSignIn => 'SIGN IN';

  @override
  String get emailTabCreate => 'CREATE ACCOUNT';

  @override
  String get emailSheetBody => 'Your progress on this device comes with you.';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String passwordHint(int min) {
    return 'At least $min characters';
  }

  @override
  String get emailRequired => 'Enter your email.';

  @override
  String get emailInvalid => 'That email address doesn\'t look right.';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String passwordTooShort(int min) {
    return 'Use at least $min characters.';
  }

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotNeedsEmail =>
      'Enter your email above, then tap Forgot password.';

  @override
  String resetSent(String email) {
    return 'If $email has an account, a reset link is on its way.';
  }

  @override
  String get emailWorking => 'One moment…';

  @override
  String get authErrWrongCredentials => 'Wrong email or password.';

  @override
  String get authErrEmailInUse =>
      'This email already has an account. Sign in instead.';

  @override
  String get authErrWeakPassword => 'Pick a stronger password.';

  @override
  String get authErrDisabled => 'This account has been disabled.';

  @override
  String get authErrNotEnabled => 'Email sign-in isn\'t available right now.';

  @override
  String get authErrTooMany => 'Too many tries. Wait a moment and try again.';

  @override
  String get authErrNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get authErrGeneric => 'Couldn\'t sign in. Please try again.';

  @override
  String get deletePasswordBody => 'Enter your password to confirm it\'s you.';

  @override
  String get deleteWrongPassword =>
      'That password doesn\'t match this account.';

  @override
  String get purchaseGateTitle => 'Sign in to buy';

  @override
  String get purchaseGateBody =>
      'Create an account or sign in to buy. Your purchases and progress stay with your account.';

  @override
  String get purchaseNeedsConnection =>
      'Couldn\'t reach the server. Check your connection and try again.';
}
