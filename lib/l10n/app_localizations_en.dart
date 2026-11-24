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
  String get backHome => 'Back home';

  @override
  String chapterComplete(String chapter) {
    return 'CHAPTER $chapter · COMPLETE';
  }

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
  String proTrialDays(int days) {
    return '$days DAYS FREE';
  }

  @override
  String proThenPrice(String price) {
    return 'THEN $price';
  }

  @override
  String get proTrialTerms =>
      'Renews automatically after the free trial unless you cancel. Monthly coins start with your first payment.';

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
      'A quiet reminder when you haven\'t played. Never more than one a day.';

  @override
  String get allow => 'ALLOW';

  @override
  String get notNow => 'NOT NOW';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get purchaseThanks => 'Thank you! Purchase applied.';

  @override
  String get purchasePending =>
      'Purchase pending. It will apply once confirmed.';

  @override
  String get purchaseFailed => 'Purchase didn\'t go through.';

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
  String get boardWeekly => 'WEEK';

  @override
  String get boardWeeklyHint => 'SHEETS CLEARED THIS WEEK · RESETS MONDAY';

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
  String streakBonusLine(int days, int coins) {
    return '$days-DAY STREAK · +$coins BONUS';
  }

  @override
  String get workshopRecord => 'Workshop record';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Workshop record · $earned/$total';
  }

  @override
  String get recordCaption => 'MILESTONES';

  @override
  String recordEarned(int earned, int total) {
    return '$earned OF $total EARNED';
  }

  @override
  String get badgeEarnedLabel => 'EARNED';

  @override
  String badgeEarnedToast(String name) {
    return 'Badge earned · $name';
  }

  @override
  String get badgeFirstTurn => 'First Turn';

  @override
  String get badgeApprentice => 'Apprentice';

  @override
  String get badgeJourneyman => 'Journeyman';

  @override
  String get badgeCraftsman => 'Craftsman';

  @override
  String get badgeChiefEngineer => 'Chief Engineer';

  @override
  String get badgeCleanWork => 'Clean Work';

  @override
  String get badgePerfectionist => 'Perfectionist';

  @override
  String get badgeRegular => 'Regular';

  @override
  String get badgeOnARoll => 'On a Roll';

  @override
  String get badgeFullWeek => 'Full Week';

  @override
  String get badgeFortnight => 'Fortnight';

  @override
  String get badgeFirstDetail => 'Clear your first sheet';

  @override
  String badgeClearDetail(int n) {
    return 'Clear $n sheets';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Finish chapter $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Earn ◆ on $n sheets';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Play $n daily sheets';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Reach a $n-day streak';
  }

  @override
  String get share => 'SHARE';

  @override
  String get shareResult => 'Share result';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves moves',
      one: '1 move',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days-day streak';
  }

  @override
  String get signOutSheetTitle => 'Sign out?';

  @override
  String get signOutSheetBody =>
      'Signing out clears your progress from this device. Everything already backed up comes back when you sign in again, but anything not synced yet (for example, sheets played offline) would be lost.';

  @override
  String get staySignedIn => 'Stay signed in';

  @override
  String get signOutConfirm => 'Sign out';

  @override
  String get rateApp => 'Rate Screw Out';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get replayTutorial => 'Replay tutorial';

  @override
  String feedbackNoEmailApp(String email) {
    return 'No email app found. Write to us at $email';
  }

  @override
  String get updateChip => 'UPDATE';

  @override
  String get updateReadyRestart => 'Update downloaded. Restart to install it.';

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
  String themeBuyStore(String price) {
    return 'OR BUY · $price';
  }

  @override
  String get themesBundleTitle => 'All themes';

  @override
  String get themesBundleBody =>
      'Every paid theme, yours to keep. Pro includes them too.';

  @override
  String themesBundleBuy(String price) {
    return 'BUY · $price';
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
  String get comebackReminderTitle => 'Your next sheet is on the bench';

  @override
  String get comebackReminderBody =>
      'A few calm minutes, a few screws. Pick up where you left off.';

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
  String get purchaseSaveTitle => 'Keep your purchase';

  @override
  String get purchaseSaveBody =>
      'Optional: sign in to keep your purchases and progress on all your devices. Your purchase already works on this one.';

  @override
  String get purchaseNeedsConnection =>
      'Couldn\'t reach the server. Check your connection and try again.';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get startupFailed =>
      'SOMETHING WENT WRONG WHILE STARTING.\nCLOSE THE APP AND OPEN IT AGAIN.';

  @override
  String get notificationChannelDescription =>
      'Daily sheet reminders and account notices';

  @override
  String get storeAppStore => 'the App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Screw, plate $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Screw, plate $plate, blocked by $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled of $total';
  }

  @override
  String get chapterName1 => 'Workshop Basics';

  @override
  String get chapterName2 => 'Layer by Layer';

  @override
  String get chapterName3 => 'Make Room';

  @override
  String get chapterName4 => 'Interlocking';

  @override
  String get chapterName5 => 'Master Builder';

  @override
  String get chapterGoal1 => 'Tap, remove, release';

  @override
  String get chapterGoal2 => 'Overlap & reveal order';

  @override
  String get chapterGoal3 => 'Plan around a tight tray';

  @override
  String get chapterGoal4 => 'Shared supports';

  @override
  String get chapterGoal5 => 'Everything, fairly';

  @override
  String get chapterPitch1 =>
      'Tap a screw. Drop a plate. That is the whole rule.';

  @override
  String get chapterPitch2 => 'Plates hide plates. Work from the top down.';

  @override
  String get chapterPitch3 => 'Tighter trays. Plan which screws to pull first.';

  @override
  String get chapterPitch4 => 'One plate pins several. Find the key piece.';

  @override
  String get chapterPitch5 =>
      'Deep stacks, every idea at once. Take your time.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Drawing Set $number';
  }

  @override
  String get chapterGoalDownloaded => 'Master-level sheets';

  @override
  String get chapterPitchDownloaded => 'More sheets, same fair rules.';

  @override
  String get mechanicOverlap => 'OVERLAP';

  @override
  String get mechanicTray => 'TRAY';

  @override
  String get mechanicLayers => 'LAYERS';

  @override
  String get mechanicCircles => 'CIRCLES';

  @override
  String get mechanicTraps => 'TRAPS';

  @override
  String get mechanicSupports => 'SUPPORTS';

  @override
  String get sheetObjective004 => 'LIFT THE TOP PLATE TO REACH THE SCREW BELOW';

  @override
  String get sheetObjective006 =>
      'THE TRAY HOLDS 3. A RELEASED PLATE FREES ITS SLOTS';

  @override
  String get sheetObjective011 => 'THREE LAYERS. WORK FROM THE TOP DOWN';

  @override
  String get sheetObjective012 => 'LIFT PL-04 BEFORE THE PLATES BELOW';

  @override
  String get sheetObjective017 => 'ONE TEMPTING MOVE FILLS THE TRAY';

  @override
  String get sheetObjective021 => 'ROUND PLATES COVER LIKE ANY OTHER';

  @override
  String get sheetObjective024 => 'REMOVE PL-04 TO REACH THE CORNER';

  @override
  String get sheetObjective041 => 'TIGHT TRAY. FREE A PLATE BEFORE IT FILLS';

  @override
  String get sheetObjective061 => 'ONE PLATE CAN HOLD DOWN SEVERAL OTHERS';

  @override
  String get sheetObjective081 => 'EVERYTHING YOU HAVE LEARNED. TAKE YOUR TIME';

  @override
  String get themeNameBlueprint => 'Clean Blueprint';

  @override
  String get themeNameWalnut => 'Walnut Workshop';

  @override
  String get themeNameOcean => 'Ocean Teal';

  @override
  String get themeNameCopper => 'Warm Copper';

  @override
  String get themeNameMidnight => 'Midnight Workshop';

  @override
  String get themeNamePastel => 'Pastel Studio';

  @override
  String sheetTitleNumbered(int number) {
    return 'Sheet $number';
  }

  @override
  String get sheetTitle001 => 'First Turn';

  @override
  String get sheetTitle002 => 'Two Point';

  @override
  String get sheetTitle003 => 'Side by Side';

  @override
  String get sheetTitle004 => 'Cover Plate';

  @override
  String get sheetTitle005 => 'Reveal';

  @override
  String get sheetTitle006 => 'Tray Day';

  @override
  String get sheetTitle007 => 'Small Plan';

  @override
  String get sheetTitle008 => 'Tight Fit';

  @override
  String get sheetTitle009 => 'Round Stock';

  @override
  String get sheetTitle010 => 'Checkpoint';

  @override
  String get sheetTitle011 => 'Third Layer';

  @override
  String get sheetTitle012 => 'Cross Brace';

  @override
  String get sheetTitle013 => 'Free a Slot';

  @override
  String get sheetTitle014 => 'Two Ahead';

  @override
  String get sheetTitle015 => 'Painted Steel';

  @override
  String get sheetTitle016 => 'Workbench';

  @override
  String get sheetTitle017 => 'Tempting';

  @override
  String get sheetTitle018 => 'Cascade';

  @override
  String get sheetTitle019 => 'Shop Mix';

  @override
  String get sheetTitle020 => 'Assembly';

  @override
  String get sheetTitle021 => 'Washer Stack';

  @override
  String get sheetTitle022 => 'Gasket';

  @override
  String get sheetTitle023 => 'Lens Cap';

  @override
  String get sheetTitle024 => 'Hidden Bracket';

  @override
  String get sheetTitle025 => 'Shim Set';

  @override
  String get sheetTitle026 => 'Bezel';

  @override
  String get sheetTitle027 => 'Grommet';

  @override
  String get sheetTitle028 => 'Breather';

  @override
  String get sheetTitle029 => 'Flange Ring';

  @override
  String get sheetTitle030 => 'Porthole';

  @override
  String get sheetTitle031 => 'Spacer';

  @override
  String get sheetTitle032 => 'Collar';

  @override
  String get sheetTitle033 => 'End Cap';

  @override
  String get sheetTitle034 => 'Quiet Shift';

  @override
  String get sheetTitle035 => 'Bulkhead';

  @override
  String get sheetTitle036 => 'Inspection Port';

  @override
  String get sheetTitle037 => 'Faceplate';

  @override
  String get sheetTitle038 => 'Light Duty';

  @override
  String get sheetTitle039 => 'Rosette';

  @override
  String get sheetTitle040 => 'Layer Cake';

  @override
  String get sheetTitle041 => 'Make Room';

  @override
  String get sheetTitle042 => 'Bin Space';

  @override
  String get sheetTitle043 => 'Overflow';

  @override
  String get sheetTitle044 => 'Cubby';

  @override
  String get sheetTitle045 => 'Parts Bin';

  @override
  String get sheetTitle046 => 'Short Stock';

  @override
  String get sheetTitle047 => 'Pigeonhole';

  @override
  String get sheetTitle048 => 'Easy Out';

  @override
  String get sheetTitle049 => 'Slot Machine';

  @override
  String get sheetTitle050 => 'Full House';

  @override
  String get sheetTitle051 => 'Backlog';

  @override
  String get sheetTitle052 => 'Spare Slot';

  @override
  String get sheetTitle053 => 'Clearance';

  @override
  String get sheetTitle054 => 'Loose Fit';

  @override
  String get sheetTitle055 => 'Inventory';

  @override
  String get sheetTitle056 => 'Allowance';

  @override
  String get sheetTitle057 => 'Tolerance';

  @override
  String get sheetTitle058 => 'Day Off';

  @override
  String get sheetTitle059 => 'Head Room';

  @override
  String get sheetTitle060 => 'Storage';

  @override
  String get sheetTitle061 => 'Interlock';

  @override
  String get sheetTitle062 => 'Gusset';

  @override
  String get sheetTitle063 => 'Keystone';

  @override
  String get sheetTitle064 => 'Lap Joint';

  @override
  String get sheetTitle065 => 'Splice Plate';

  @override
  String get sheetTitle066 => 'Dovetail';

  @override
  String get sheetTitle067 => 'Lintel';

  @override
  String get sheetTitle068 => 'Off Cut';

  @override
  String get sheetTitle069 => 'Strut';

  @override
  String get sheetTitle070 => 'Truss';

  @override
  String get sheetTitle071 => 'Clevis';

  @override
  String get sheetTitle072 => 'Yoke';

  @override
  String get sheetTitle073 => 'Saddle';

  @override
  String get sheetTitle074 => 'Footing';

  @override
  String get sheetTitle075 => 'Bracket Pair';

  @override
  String get sheetTitle076 => 'Clamp Bar';

  @override
  String get sheetTitle077 => 'Tie Plate';

  @override
  String get sheetTitle078 => 'Plain Panel';

  @override
  String get sheetTitle079 => 'Cantilever';

  @override
  String get sheetTitle080 => 'Moment Frame';

  @override
  String get sheetTitle081 => 'Master Plan';

  @override
  String get sheetTitle082 => 'Subassembly';

  @override
  String get sheetTitle083 => 'Exploded View';

  @override
  String get sheetTitle084 => 'Fit Check';

  @override
  String get sheetTitle085 => 'Torque Spec';

  @override
  String get sheetTitle086 => 'Jig';

  @override
  String get sheetTitle087 => 'Fixture';

  @override
  String get sheetTitle088 => 'Calm Bench';

  @override
  String get sheetTitle089 => 'Gearbox';

  @override
  String get sheetTitle090 => 'Housing';

  @override
  String get sheetTitle091 => 'Chassis';

  @override
  String get sheetTitle092 => 'Panel Bay';

  @override
  String get sheetTitle093 => 'Cover Set';

  @override
  String get sheetTitle094 => 'Easy Torque';

  @override
  String get sheetTitle095 => 'Engine Mount';

  @override
  String get sheetTitle096 => 'Switchgear';

  @override
  String get sheetTitle097 => 'Control Box';

  @override
  String get sheetTitle098 => 'Drafting Table';

  @override
  String get sheetTitle099 => 'Final Inspection';

  @override
  String get sheetTitle100 => 'Sign Off';
}
