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
    return 'EXTRA SLOT · $coins ¢';
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
    return 'BALANCE $balance ¢';
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
    return 'Next sheet — $code';
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
    return 'FIG. 1\nEXPLODED VIEW\n$plates PLATES · $screws\nFASTENERS';
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
    return 'Continue — $code';
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
      '◆ MASTERY = CLEARED WITHOUT A HINT OR RESTART. PURELY COSMETIC — NEVER NEEDED TO PROGRESS.';

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
  String sheetMeta(int plates, int screws, int tray) {
    return '$plates PLATES · $screws SCREWS · TRAY $tray';
  }

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
      other: '$streak-day streak —',
      one: '1-day streak —',
      zero: 'Start a streak —',
    );
    return 'Same sheet for everyone today. No timer. $_temp0 missing a day costs nothing.';
  }

  @override
  String get startDaily => 'Start today\'s sheet';

  @override
  String get dailyCompleted => 'Done for today — back tomorrow';

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
    return '$coins ¢';
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
    return 'NO ADS · UNLIMITED HINTS · ALL THEMES · FREE RESCUES · $coins ¢ MONTHLY';
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
      'Purchase pending — it will apply once confirmed.';

  @override
  String get purchaseFailed => 'Purchase didn\'t go through.';

  @override
  String get signInToPurchase => 'Sign in first so your purchase follows you.';

  @override
  String get restored => 'Purchases restored.';
}
