// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'বিরতি';

  @override
  String get back => 'পেছনে';

  @override
  String get settings => 'সেটিংস';

  @override
  String get tray => 'ট্রে';

  @override
  String get trayFull => 'ট্রে ভর্তি';

  @override
  String get undo => 'আনডু';

  @override
  String hintCount(String count) {
    return 'হিন্ট · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'বিরতি';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · চাল $moves';
  }

  @override
  String get resume => 'আবার খেলুন';

  @override
  String get sound => 'সাউন্ড';

  @override
  String get haptics => 'হ্যাপটিক্স';

  @override
  String get reducedMotion => 'কম মোশন';

  @override
  String get restart => 'আবার শুরু';

  @override
  String get exitToSheets => 'শিট তালিকায়';

  @override
  String get restartConfirmTitle => 'এই শিট আবার শুরু করবেন?';

  @override
  String restartConfirmBody(int moves) {
    return '$moves চালের অগ্রগতি হারিয়ে যাবে।';
  }

  @override
  String get cancel => 'বাতিল';

  @override
  String get stuckTitle => 'কোনো খালি স্লট নেই।';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি স্ক্রু',
      one: '$countটি স্ক্রু',
    );
    return '$plate এখনো বোর্ডে $_temp0 আটকে রেখেছে। আনডু করলে একটা স্লট খালি হবে।';
  }

  @override
  String get stuckReasonGeneric =>
      'সব স্লট ভর্তি, কোনো প্লেটও পড়তে পারছে না। আনডু করলে একটা স্লট খালি হবে।';

  @override
  String get undoLastMove => 'শেষ চাল ফিরিয়ে নিন';

  @override
  String rescueSlotCoins(int coins) {
    return 'বাড়তি স্লট · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'বাড়তি স্লট · ভিডিও';

  @override
  String get rescueSlotPro => 'বাড়তি স্লট · PRO';

  @override
  String get outOfHintsTitle => 'আরেকটা হিন্ট চাই?';

  @override
  String get hintsLeftZero => 'হিন্ট · 0 বাকি';

  @override
  String get outOfHintsBody =>
      'হিন্ট পরের কাজের একটা স্ক্রুর চারপাশে বৃত্ত আঁকে। পুরো শিট কখনো সমাধান করে দেয় না।';

  @override
  String get watchVideo => 'ছোট একটা ভিডিও দেখুন';

  @override
  String get watchVideoMeta => 'ঐচ্ছিক · ~30 সে. · +1 হিন্ট';

  @override
  String useCoins(int coins) {
    return '$coins কয়েন খরচ করুন';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'ব্যালান্স $balance ¢';
  }

  @override
  String get keepThinking => 'আরেকটু ভাবি';

  @override
  String get notEnoughCoins => 'এখনো যথেষ্ট কয়েন নেই।';

  @override
  String get adUnavailable => 'এই মুহূর্তে কোনো ভিডিও নেই।';

  @override
  String cleared(String code) {
    return '$code · সম্পন্ন';
  }

  @override
  String get disassembled => 'খোলা শেষ।';

  @override
  String get approved => 'অনুমোদিত';

  @override
  String get statMoves => 'চাল';

  @override
  String get statTime => 'সময়';

  @override
  String get statMastery => 'দক্ষতা';

  @override
  String nextSheet(String code) {
    return 'পরের শিট · $code';
  }

  @override
  String get replay => 'আবার খেলুন';

  @override
  String get sheets => 'শিট';

  @override
  String get backHome => 'হোমে ফিরুন';

  @override
  String chapterComplete(String chapter) {
    return 'অধ্যায় $chapter · সম্পন্ন';
  }

  @override
  String get themeUnlocked => 'থিম আনলক';

  @override
  String nextChapter(String chapter) {
    return 'পরবর্তী · অধ্যায় $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'অধ্যায় $chapter শুরু করুন';
  }

  @override
  String equipTheme(String name) {
    return '$name চালু করুন';
  }

  @override
  String get tutorialStep1 => 'ধাপ 1 · স্ক্রুতে ট্যাপ করুন';

  @override
  String get tutorialLands => '↓ এটা ট্রেতে গিয়ে পড়বে';

  @override
  String get skipTutorial => 'টিউটোরিয়াল বাদ';

  @override
  String get splashTagline => 'স্তরে স্তরে এক ধাঁধা';

  @override
  String get splashFooter => 'সংস্করণ 1.0 · শিট 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$platesটি প্লেট',
      one: '$platesটি প্লেট',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'ফাস্টেনার',
      one: 'ফাস্টেনার',
    );
    return 'চিত্র 1\nএক্সপ্লোডেড ভিউ\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'অধ্যায় $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ফাস্টেনার',
      one: 'ফাস্টেনার',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'পরের শিট';

  @override
  String chapterLabel(String chapter) {
    return 'অধ্যায় $chapter';
  }

  @override
  String get campaign => 'ক্যাম্পেইন';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'চালিয়ে যান · $code';
  }

  @override
  String get daily => 'দৈনিক';

  @override
  String get themes => 'থিম';

  @override
  String get allCleared => 'সব শিট শেষ';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total শিট';
  }

  @override
  String get fiveChapters => 'পাঁচটি অধ্যায়';

  @override
  String get chaptersTitle => 'অধ্যায়';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'লক করা';

  @override
  String get downloadChapter => 'ডাউনলোড';

  @override
  String get downloading => 'ডাউনলোড হচ্ছে…';

  @override
  String get comingSoon => 'শিগগিরই আরও শিট';

  @override
  String newMechanic(String mechanic) {
    return 'নতুন: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$platesটি প্লেট',
      one: '$platesটি প্লেট',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layersটি স্তর',
      one: '$layersটি স্তর',
    );
    return '$_temp0 · $_temp1 · ট্রে $tray';
  }

  @override
  String get theCampaign => 'ক্যাম্পেইন';

  @override
  String get campaignFooter =>
      'আগের অধ্যায় শেষ করলে পরেরটা খোলে। দক্ষতার চিহ্ন ঐচ্ছিক। হিন্ট কখনো অগ্রগতি আটকায় না।';

  @override
  String get chapterBonus => 'অধ্যায় বোনাস';

  @override
  String get dailySheet => 'দৈনিক শিট';

  @override
  String get dailyTitle => 'নাম';

  @override
  String get dailyPlates => 'প্লেট';

  @override
  String get dailyReward => 'পুরস্কার';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak দিনের স্ট্রিক।',
      one: '$streak দিনের স্ট্রিক।',
      zero: 'একটা স্ট্রিক শুরু করুন।',
    );
    return 'আজ সবার জন্য একই শিট। কোনো টাইমার নেই। $_temp0 একদিন বাদ পড়লেও কোনো ক্ষতি নেই।';
  }

  @override
  String get startDaily => 'আজকের শিট শুরু করুন';

  @override
  String get dailyCompleted => 'আজকের মতো শেষ · কাল আবার';

  @override
  String get replayDaily => 'আজকের শিট আবার খেলুন';

  @override
  String get themesTitle => 'থিম';

  @override
  String get themesCaption => 'শুধু চেহারা · নিয়ম বদলায় না';

  @override
  String get equipped => 'চালু আছে';

  @override
  String get owned => 'আপনার';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'প্রিভিউ';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get feedbackSection => 'ফিডব্যাক';

  @override
  String get soundEffects => 'সাউন্ড ইফেক্ট';

  @override
  String get music => 'মিউজিক';

  @override
  String get hapticsRow => 'হ্যাপটিক্স';

  @override
  String get reducedMotionRow => 'কম মোশন';

  @override
  String get reducedMotionCaption => 'সরে যাওয়ার বদলে মিলিয়ে যায়';

  @override
  String get generalSection => 'সাধারণ';

  @override
  String get highRefreshRate => 'হাই রিফ্রেশ রেট';

  @override
  String highRefreshRateOn(int hz) {
    return 'আরও মসৃণ নড়াচড়া · সর্বোচ্চ $hz Hz · ব্যাটারি বেশি খরচ হয়';
  }

  @override
  String get highRefreshRateOff => 'আরও মসৃণ নড়াচড়া · ব্যাটারি বেশি খরচ হয়';

  @override
  String get highRefreshRateUnsupported => 'এই স্ক্রিন একটাই রেটে চলে';

  @override
  String get highRefreshRateBattery => 'এখন ব্যাটারি সেভারের কারণে সীমিত';

  @override
  String get highRefreshRateHeat => 'ফোন গরম থাকায় সীমিত';

  @override
  String highRefreshRateNow(int hz) {
    return 'এখন $hz Hz';
  }

  @override
  String get language => 'ভাষা';

  @override
  String get notifications => 'দৈনিক রিমাইন্ডার';

  @override
  String get notificationsCaption => 'নতুন শিট এলে একবার মনে করিয়ে দেবে';

  @override
  String get accountSection => 'অ্যাকাউন্ট';

  @override
  String get signInGoogle => 'Google দিয়ে সাইন ইন করুন';

  @override
  String get signInApple => 'Apple দিয়ে সাইন ইন করুন';

  @override
  String signedInAs(String name) {
    return 'সাইন ইন করা · $name';
  }

  @override
  String get guestCaption => 'গেস্ট হিসেবে খেলছেন · অগ্রগতি রাখতে সাইন ইন করুন';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get deleteAccount => 'অ্যাকাউন্ট মুছুন';

  @override
  String get purchasesSection => 'কেনাকাটা';

  @override
  String get removeAds => 'বিজ্ঞাপন সরান';

  @override
  String get restore => 'ফিরিয়ে আনুন';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'বিজ্ঞাপন নেই · আনলিমিটেড হিন্ট · সব থিম · ফ্রি রেসকিউ · প্রতি মাসে $coins ¢';
  }

  @override
  String get proMonthly => 'মাসিক';

  @override
  String get proYearly => 'বাৎসরিক';

  @override
  String proTrialDays(int days) {
    return '$days দিন ফ্রি';
  }

  @override
  String proThenPrice(String price) {
    return 'এরপর $price';
  }

  @override
  String get proTrialTerms =>
      'ফ্রি ট্রায়ালের পর বাতিল না করলে নিজে থেকেই নবায়ন হবে। মাসিক কয়েন শুরু হবে আপনার প্রথম পেমেন্ট থেকে।';

  @override
  String get proActive => 'PRO · চালু';

  @override
  String get adsRemoved => 'বিজ্ঞাপন সরানো হয়েছে';

  @override
  String get coinPacks => 'কয়েন প্যাক';

  @override
  String get aboutSection => 'সম্পর্কে';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get termsOfUse => 'ব্যবহারের শর্তাবলি';

  @override
  String get refundPolicy => 'রিফান্ড নীতি';

  @override
  String get privacyChoices => 'গোপনীয়তা পছন্দ';

  @override
  String get licenses => 'লাইসেন্স ও কৃতজ্ঞতা';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · সংস্করণ $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'দৈনিক শিটের জন্য একটু মনে করিয়ে দেব?';

  @override
  String get notificationPrimerBody =>
      'অনেকক্ষণ না খেললে একটা শান্ত রিমাইন্ডার। দিনে একবারের বেশি কখনো নয়।';

  @override
  String get allow => 'অনুমতি দিন';

  @override
  String get notNow => 'এখন না';

  @override
  String get somethingWentWrong => 'কিছু একটা সমস্যা হয়েছে।';

  @override
  String get purchaseThanks => 'ধন্যবাদ! কেনাকাটা যোগ হয়েছে।';

  @override
  String get purchasePending => 'কেনাকাটা অপেক্ষমাণ। নিশ্চিত হলেই যোগ হবে।';

  @override
  String get purchaseFailed => 'কেনাকাটা সম্পন্ন হয়নি।';

  @override
  String get restored => 'কেনাকাটা ফিরিয়ে আনা হয়েছে।';

  @override
  String finishChapterFirst(String chapter) {
    return 'আগে অধ্যায় $chapter শেষ করুন।';
  }

  @override
  String get moreSheetsTitle => 'আরও শিট';

  @override
  String get moreSheetsCaption => 'নতুন নকশার সেট এখানে আসবে';

  @override
  String get equip => 'চালু করুন';

  @override
  String buyFor(int coins) {
    return 'কিনুন · $coins ¢';
  }

  @override
  String get close => 'বন্ধ';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'লাইসেন্স';

  @override
  String get licensesCaption => 'ওপেন সোর্স নোটিশ';

  @override
  String playLevel(String code) {
    return '$code খেলুন';
  }

  @override
  String lockedLevel(int number) {
    return 'শিট $number, লক করা';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'লিডারবোর্ড';

  @override
  String get leaderboardCaption => 'সাইন ইন করা খেলোয়াড় · লাইভ';

  @override
  String get boardSheets => 'শিট';

  @override
  String get boardDaily => 'দৈনিক';

  @override
  String get boardStreak => 'স্ট্রিক';

  @override
  String get boardWeekly => 'সপ্তাহ';

  @override
  String get boardWeeklyHint => 'এই সপ্তাহে শেষ করা শিট · সোমবার রিসেট';

  @override
  String get boardSheetsHint => 'সবচেয়ে বেশি শিট শেষ';

  @override
  String get boardDailyHint => 'আজকের শিট · সবচেয়ে কম চাল, তারপর দ্রুততম';

  @override
  String get boardStreakHint => 'দৈনিক শিটে টানা কত দিন';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'চাল',
      one: 'চাল',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'দিন',
      one: 'দিন',
    );
    return '$_temp0 · সেরা $best';
  }

  @override
  String get boardYou => 'আপনি';

  @override
  String get boardYourRank => 'আপনার র‍্যাংক';

  @override
  String get boardNotRanked => 'এখনো র‍্যাংক নেই';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString জনের মধ্যে';
  }

  @override
  String get boardGuest =>
      'বোর্ডে নাম তুলতে সাইন ইন করুন। আপনার অগ্রগতিও সাথে থাকবে।';

  @override
  String get boardEmpty => 'এখানে এখনো কেউ নেই। প্রথম হোন।';

  @override
  String get boardOffline => 'এই মুহূর্তে লিডারবোর্ডে পৌঁছানো যাচ্ছে না।';

  @override
  String get tryAgainCaps => 'আবার চেষ্টা';

  @override
  String get todaysBoard => 'আজকের বোর্ড';

  @override
  String get signedOutToast =>
      'সাইন আউট হয়েছে · এই ডিভাইস খালি করা হয়েছে। অগ্রগতি ফিরে পেতে আবার সাইন ইন করুন।';

  @override
  String get welcomeBack => 'আবার স্বাগতম';

  @override
  String welcomeBackName(String name) {
    return 'আবার স্বাগতম, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheetsটি শিট',
      one: '$sheetsটি শিট',
    );
    return '$who · $_temp0 ও $coins কয়েন ফিরিয়ে আনা হয়েছে';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · আপনি সাইন ইন করেছেন, অগ্রগতির ব্যাকআপ আছে';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheetsটি শিট',
      one: '$sheetsটি শিট',
    );
    return '$who · এই ডিভাইসের অগ্রগতি আপনার অ্যাকাউন্টে যোগ হয়েছে: $_temp0, $coins কয়েন';
  }

  @override
  String syncSavedNew(String name) {
    return '$name হিসেবে সাইন ইন · আপনার অগ্রগতি এখন অ্যাকাউন্টে সেভ হচ্ছে';
  }

  @override
  String get syncSavedNewPlain =>
      'সাইন ইন হয়েছে · আপনার অগ্রগতি এখন অ্যাকাউন্টে সেভ হচ্ছে';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheetsটি নতুন শিট',
      one: '$sheetsটি নতুন শিট',
      zero: 'অগ্রগতি আপডেট হয়েছে',
    );
    return 'আপনার অন্য ডিভাইস থেকে সিঙ্ক হয়েছে · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'সেভ করা অগ্রগতি এখনো লোড করা যায়নি · সংযোগ ফিরলে নিজে থেকেই সিঙ্ক হবে';

  @override
  String get signedInOffline =>
      'সাইন ইন হয়েছে · অনলাইনে ফিরলে অগ্রগতি সিঙ্ক হবে';

  @override
  String get proActivated =>
      'Pro চালু · বিজ্ঞাপন নেই, সব থিম আর আনলিমিটেড হিন্ট';

  @override
  String get accountDeletedToast =>
      'আপনার অ্যাকাউন্ট ও সব ডেটা মুছে ফেলা হয়েছে।';

  @override
  String accountDeletedProToast(String store) {
    return 'অ্যাকাউন্ট মুছে ফেলা হয়েছে। $store-এ বাতিল না করা পর্যন্ত Pro-এর বিল চলতে থাকবে।';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days দিনের স্ট্রিক · +$coins বোনাস';
  }

  @override
  String get workshopRecord => 'ওয়ার্কশপের খাতা';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'ওয়ার্কশপের খাতা · $earned/$total';
  }

  @override
  String get recordCaption => 'মাইলফলক';

  @override
  String recordEarned(int earned, int total) {
    return '$totalটির মধ্যে $earnedটি অর্জিত';
  }

  @override
  String get badgeEarnedLabel => 'অর্জিত';

  @override
  String badgeEarnedToast(String name) {
    return 'ব্যাজ অর্জিত · $name';
  }

  @override
  String get badgeFirstTurn => 'প্রথম প্যাঁচ';

  @override
  String get badgeApprentice => 'শিক্ষানবিশ';

  @override
  String get badgeJourneyman => 'কারিগর';

  @override
  String get badgeCraftsman => 'ওস্তাদ কারিগর';

  @override
  String get badgeChiefEngineer => 'প্রধান প্রকৌশলী';

  @override
  String get badgeCleanWork => 'পরিচ্ছন্ন কাজ';

  @override
  String get badgePerfectionist => 'নিখুঁত কারিগর';

  @override
  String get badgeRegular => 'নিয়মিত';

  @override
  String get badgeOnARoll => 'জমে উঠেছে';

  @override
  String get badgeFullWeek => 'পুরো সপ্তাহ';

  @override
  String get badgeFortnight => 'দুই সপ্তাহ';

  @override
  String get badgeFirstDetail => 'প্রথম শিট শেষ করুন';

  @override
  String badgeClearDetail(int n) {
    return '$nটি শিট শেষ করুন';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'অধ্যায় $n শেষ করুন';
  }

  @override
  String badgeMasterDetail(int n) {
    return '$nটি শিটে ◆ অর্জন করুন';
  }

  @override
  String badgeDailyDetail(int n) {
    return '$nটি দৈনিক শিট খেলুন';
  }

  @override
  String badgeStreakDetail(int n) {
    return '$n দিনের স্ট্রিকে পৌঁছান';
  }

  @override
  String get share => 'শেয়ার';

  @override
  String get shareResult => 'ফলাফল শেয়ার করুন';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves চাল',
      one: '$moves চাল',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days দিনের স্ট্রিক';
  }

  @override
  String get signOutSheetTitle => 'সাইন আউট করবেন?';

  @override
  String get signOutSheetBody =>
      'সাইন আউট করলে এই ডিভাইস থেকে আপনার অগ্রগতি মুছে যাবে। যা আগেই ব্যাকআপ হয়েছে তা আবার সাইন ইন করলে ফিরে আসবে, কিন্তু যা এখনো সিঙ্ক হয়নি (যেমন অফলাইনে খেলা শিট) তা হারিয়ে যাবে।';

  @override
  String get staySignedIn => 'সাইন ইন থাকুন';

  @override
  String get signOutConfirm => 'সাইন আউট';

  @override
  String get rateApp => 'Screw Out-কে রেটিং দিন';

  @override
  String get sendFeedback => 'ফিডব্যাক পাঠান';

  @override
  String get replayTutorial => 'টিউটোরিয়াল আবার দেখুন';

  @override
  String feedbackNoEmailApp(String email) {
    return 'কোনো ইমেইল অ্যাপ পাওয়া যায়নি। আমাদের লিখুন $email ঠিকানায়';
  }

  @override
  String get updateChip => 'আপডেট';

  @override
  String get updateReadyRestart =>
      'আপডেট ডাউনলোড হয়েছে। ইনস্টল করতে রিস্টার্ট করুন।';

  @override
  String get deleteSheetTitle => 'আপনার অ্যাকাউন্ট মুছবেন?';

  @override
  String get deleteSheetBody =>
      'এতে আপনার অ্যাকাউন্ট এবং এর সাথে সেভ করা সবকিছু চিরতরে মুছে যাবে: প্রতিটি শিটের অগ্রগতি, কয়েন, থিম, দৈনিক স্ট্রিক আর লিডারবোর্ডের অবস্থান। এটা আর ফেরানো যাবে না।';

  @override
  String deleteSheetPro(String store) {
    return 'আপনার Screw Out Pro আছে। অ্যাকাউন্ট মুছলে সাবস্ক্রিপশন বাতিল হয় না: $store-এ সাবস্ক্রিপশন বাতিল করুন, নইলে বিল চলতেই থাকবে।';
  }

  @override
  String get manageSubscription => 'সাবস্ক্রিপশন ম্যানেজ';

  @override
  String get deleteForever => 'আমার অ্যাকাউন্ট মুছুন';

  @override
  String get deleting => 'মোছা হচ্ছে…';

  @override
  String get keepAccount => 'অ্যাকাউন্ট রেখে দিন';

  @override
  String get deleteOffline =>
      'আপনি অফলাইনে আছেন। অ্যাকাউন্ট মুছতে ইন্টারনেটে যুক্ত হোন।';

  @override
  String get deleteFailed => 'অ্যাকাউন্ট মোছা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get restoreNothing => 'এই অ্যাকাউন্টে ফিরিয়ে আনার মতো কিছু নেই।';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 হিন্ট';
  }

  @override
  String get hintEarnedToast => '+1 হিন্ট · দেখার জন্য ধন্যবাদ';

  @override
  String get rescueToast => 'এই শিটের জন্য +1 ট্রে স্লট';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 ট্রে স্লট';
  }

  @override
  String get adNotCompleted => 'ভিডিও শেষ হয়নি, তাই এবার কোনো পুরস্কার নেই।';

  @override
  String themeEquippedToast(String name) {
    return '$name চালু হয়েছে';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'অধ্যায় $chapter তৈরি';
  }

  @override
  String get signInFailed => 'সাইন ইন সম্পন্ন হয়নি।';

  @override
  String get themePurchased => 'থিম আনলক হয়েছে।';

  @override
  String themeBuyStore(String price) {
    return 'অথবা কিনুন · $price';
  }

  @override
  String get themesBundleTitle => 'সব থিম';

  @override
  String get themesBundleBody =>
      'সব পেইড থিম, চিরদিনের জন্য আপনার। Pro-তেও এগুলো আছে।';

  @override
  String themesBundleBuy(String price) {
    return 'কিনুন · $price';
  }

  @override
  String get dailyWeekDone => 'সম্পন্ন';

  @override
  String masteredCount(int count) {
    return '$countটি দক্ষতা';
  }

  @override
  String get reminderTitle => 'আজকের শিট তৈরি';

  @override
  String get reminderBody => 'একটা নতুন নকশা, সবার জন্য একই। কোনো টাইমার নেই।';

  @override
  String get comebackReminderTitle => 'আপনার পরের শিট বেঞ্চে অপেক্ষা করছে';

  @override
  String get comebackReminderBody =>
      'কয়েক মিনিটের শান্তি, কয়েকটা স্ক্রু। যেখানে থেমেছিলেন সেখান থেকে শুরু করুন।';

  @override
  String get signInEmail => 'ইমেইল দিয়ে চালিয়ে যান';

  @override
  String get emailSignInTitle => 'সাইন ইন';

  @override
  String get emailCreateTitle => 'অ্যাকাউন্ট তৈরি';

  @override
  String get emailTabSignIn => 'সাইন ইন';

  @override
  String get emailTabCreate => 'অ্যাকাউন্ট তৈরি';

  @override
  String get emailSheetBody => 'এই ডিভাইসের অগ্রগতি আপনার সাথেই থাকবে।';

  @override
  String get emailLabel => 'ইমেইল';

  @override
  String get passwordLabel => 'পাসওয়ার্ড';

  @override
  String get showPassword => 'পাসওয়ার্ড দেখান';

  @override
  String get hidePassword => 'পাসওয়ার্ড লুকান';

  @override
  String passwordHint(int min) {
    return 'কমপক্ষে $min অক্ষর';
  }

  @override
  String get emailRequired => 'আপনার ইমেইল দিন।';

  @override
  String get emailInvalid => 'ইমেইল ঠিকানাটা সঠিক মনে হচ্ছে না।';

  @override
  String get passwordRequired => 'আপনার পাসওয়ার্ড দিন।';

  @override
  String passwordTooShort(int min) {
    return 'কমপক্ষে $min অক্ষর ব্যবহার করুন।';
  }

  @override
  String get forgotPassword => 'পাসওয়ার্ড ভুলে গেছেন?';

  @override
  String get forgotNeedsEmail =>
      'ওপরে আপনার ইমেইল দিন, তারপর \"পাসওয়ার্ড ভুলে গেছেন?\"-এ ট্যাপ করুন।';

  @override
  String resetSent(String email) {
    return '$email-এর অ্যাকাউন্ট থাকলে, রিসেট লিংক পাঠানো হয়েছে।';
  }

  @override
  String get emailWorking => 'এক মুহূর্ত…';

  @override
  String get authErrWrongCredentials => 'ইমেইল বা পাসওয়ার্ড ভুল।';

  @override
  String get authErrEmailInUse =>
      'এই ইমেইলে আগেই অ্যাকাউন্ট আছে। সাইন ইন করুন।';

  @override
  String get authErrWeakPassword => 'আরও শক্ত পাসওয়ার্ড বেছে নিন।';

  @override
  String get authErrDisabled => 'এই অ্যাকাউন্ট নিষ্ক্রিয় করা হয়েছে।';

  @override
  String get authErrNotEnabled =>
      'এই মুহূর্তে ইমেইল দিয়ে সাইন ইন করা যাচ্ছে না।';

  @override
  String get authErrTooMany =>
      'অনেকবার চেষ্টা হয়েছে। একটু অপেক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get authErrNetwork => 'সংযোগ নেই। ইন্টারনেট দেখে আবার চেষ্টা করুন।';

  @override
  String get authErrGeneric => 'সাইন ইন করা যায়নি। আবার চেষ্টা করুন।';

  @override
  String get deletePasswordBody =>
      'এটা যে আপনিই, তা নিশ্চিত করতে পাসওয়ার্ড দিন।';

  @override
  String get deleteWrongPassword => 'পাসওয়ার্ড এই অ্যাকাউন্টের সাথে মেলেনি।';

  @override
  String get purchaseSaveTitle => 'আপনার কেনাকাটা রেখে দিন';

  @override
  String get purchaseSaveBody =>
      'ঐচ্ছিক: সব ডিভাইসে কেনাকাটা ও অগ্রগতি রাখতে সাইন ইন করুন। এই ডিভাইসে আপনার কেনাকাটা আগে থেকেই কাজ করছে।';

  @override
  String get purchaseNeedsConnection =>
      'সার্ভারে পৌঁছানো যায়নি। সংযোগ দেখে আবার চেষ্টা করুন।';

  @override
  String get languageSystemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get startupFailed =>
      'চালু হওয়ার সময় সমস্যা হয়েছে।\nঅ্যাপটি বন্ধ করে আবার খুলুন।';

  @override
  String get notificationChannelDescription =>
      'দৈনিক শিটের রিমাইন্ডার ও অ্যাকাউন্টের নোটিশ';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'স্ক্রু, প্লেট $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'স্ক্রু, প্লেট $plate, $blocker দিয়ে আটকানো';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $totalটির মধ্যে $filledটি';
  }

  @override
  String get chapterName1 => 'ওয়ার্কশপের হাতেখড়ি';

  @override
  String get chapterName2 => 'স্তরে স্তরে';

  @override
  String get chapterName3 => 'জায়গা করুন';

  @override
  String get chapterName4 => 'পরস্পর আটকানো';

  @override
  String get chapterName5 => 'দক্ষ নির্মাতা';

  @override
  String get chapterGoal1 => 'ট্যাপ, খোলা, মুক্তি';

  @override
  String get chapterGoal2 => 'ওভারল্যাপ ও খোলার ক্রম';

  @override
  String get chapterGoal3 => 'ছোট ট্রেতে পরিকল্পনা';

  @override
  String get chapterGoal4 => 'ভাগাভাগি করা সাপোর্ট';

  @override
  String get chapterGoal5 => 'সবকিছু, ন্যায্যভাবে';

  @override
  String get chapterPitch1 =>
      'একটা স্ক্রুতে ট্যাপ করুন। একটা প্লেট ফেলুন। নিয়ম এটুকুই।';

  @override
  String get chapterPitch2 =>
      'প্লেটের নিচে প্লেট লুকিয়ে। ওপর থেকে নিচে কাজ করুন।';

  @override
  String get chapterPitch3 => 'আরও ছোট ট্রে। কোন স্ক্রু আগে খুলবেন, ভেবে নিন।';

  @override
  String get chapterPitch4 =>
      'একটা প্লেট কয়েকটাকে আটকে রাখে। আসল টুকরোটা খুঁজুন।';

  @override
  String get chapterPitch5 => 'গভীর স্তূপ, সব আইডিয়া একসাথে। সময় নিন।';

  @override
  String chapterNameDrawingSet(String number) {
    return 'নকশার সেট $number';
  }

  @override
  String get chapterGoalDownloaded => 'মাস্টার লেভেলের শিট';

  @override
  String get chapterPitchDownloaded => 'আরও শিট, একই ন্যায্য নিয়ম।';

  @override
  String get mechanicOverlap => 'ওভারল্যাপ';

  @override
  String get mechanicTray => 'ট্রে';

  @override
  String get mechanicLayers => 'স্তর';

  @override
  String get mechanicCircles => 'বৃত্ত';

  @override
  String get mechanicTraps => 'ফাঁদ';

  @override
  String get mechanicSupports => 'সাপোর্ট';

  @override
  String get sheetObjective004 => 'ওপরের প্লেট তুলে নিচের স্ক্রুতে পৌঁছান';

  @override
  String get sheetObjective006 =>
      'ট্রেতে 3টি জায়গা। প্লেট খুললে তার স্লট খালি হয়';

  @override
  String get sheetObjective011 => 'তিন স্তর। ওপর থেকে নিচে কাজ করুন';

  @override
  String get sheetObjective012 => 'নিচের প্লেটগুলোর আগে PL-04 তুলুন';

  @override
  String get sheetObjective017 => 'একটা লোভনীয় চাল ট্রে ভরিয়ে দেয়';

  @override
  String get sheetObjective021 => 'গোল প্লেটও অন্যগুলোর মতোই ঢাকে';

  @override
  String get sheetObjective024 => 'কোণে পৌঁছাতে PL-04 সরান';

  @override
  String get sheetObjective041 => 'ছোট ট্রে। ভরার আগে একটা প্লেট খুলুন';

  @override
  String get sheetObjective061 => 'একটা প্লেট আরও কয়েকটাকে আটকে রাখতে পারে';

  @override
  String get sheetObjective081 => 'যা শিখেছেন সবকিছু। সময় নিন';

  @override
  String get themeNameBlueprint => 'পরিষ্কার ব্লুপ্রিন্ট';

  @override
  String get themeNameWalnut => 'আখরোট ওয়ার্কশপ';

  @override
  String get themeNameOcean => 'সমুদ্র ফিরোজা';

  @override
  String get themeNameCopper => 'উষ্ণ তামা';

  @override
  String get themeNameMidnight => 'মাঝরাতের ওয়ার্কশপ';

  @override
  String get themeNamePastel => 'প্যাস্টেল স্টুডিও';

  @override
  String sheetTitleNumbered(int number) {
    return 'শিট $number';
  }

  @override
  String get sheetTitle001 => 'প্রথম প্যাঁচ';

  @override
  String get sheetTitle002 => 'দুই বিন্দু';

  @override
  String get sheetTitle003 => 'পাশাপাশি';

  @override
  String get sheetTitle004 => 'ঢাকনা প্লেট';

  @override
  String get sheetTitle005 => 'উন্মোচন';

  @override
  String get sheetTitle006 => 'ট্রে দিবস';

  @override
  String get sheetTitle007 => 'ছোট পরিকল্পনা';

  @override
  String get sheetTitle008 => 'আঁটসাঁট';

  @override
  String get sheetTitle009 => 'গোল রড';

  @override
  String get sheetTitle010 => 'চেকপয়েন্ট';

  @override
  String get sheetTitle011 => 'তৃতীয় স্তর';

  @override
  String get sheetTitle012 => 'আড়াআড়ি ঠেকনা';

  @override
  String get sheetTitle013 => 'একটা স্লট খালি';

  @override
  String get sheetTitle014 => 'দুই চাল আগে';

  @override
  String get sheetTitle015 => 'রং করা ইস্পাত';

  @override
  String get sheetTitle016 => 'ওয়ার্কবেঞ্চ';

  @override
  String get sheetTitle017 => 'লোভনীয়';

  @override
  String get sheetTitle018 => 'ধারাবাহিক';

  @override
  String get sheetTitle019 => 'ওয়ার্কশপ মিক্স';

  @override
  String get sheetTitle020 => 'সংযোজন';

  @override
  String get sheetTitle021 => 'ওয়াশারের স্তূপ';

  @override
  String get sheetTitle022 => 'গ্যাসকেট';

  @override
  String get sheetTitle023 => 'লেন্স ক্যাপ';

  @override
  String get sheetTitle024 => 'লুকানো ব্র্যাকেট';

  @override
  String get sheetTitle025 => 'শিম সেট';

  @override
  String get sheetTitle026 => 'বেজেল';

  @override
  String get sheetTitle027 => 'গ্রোমেট';

  @override
  String get sheetTitle028 => 'একটু জিরোনো';

  @override
  String get sheetTitle029 => 'ফ্ল্যাঞ্জ রিং';

  @override
  String get sheetTitle030 => 'গোল জানালা';

  @override
  String get sheetTitle031 => 'স্পেসার';

  @override
  String get sheetTitle032 => 'কলার';

  @override
  String get sheetTitle033 => 'এন্ড ক্যাপ';

  @override
  String get sheetTitle034 => 'শান্ত শিফট';

  @override
  String get sheetTitle035 => 'বাল্কহেড';

  @override
  String get sheetTitle036 => 'পরিদর্শন দ্বার';

  @override
  String get sheetTitle037 => 'ফেসপ্লেট';

  @override
  String get sheetTitle038 => 'হালকা কাজ';

  @override
  String get sheetTitle039 => 'রোজেট';

  @override
  String get sheetTitle040 => 'লেয়ার কেক';

  @override
  String get sheetTitle041 => 'জায়গা করুন';

  @override
  String get sheetTitle042 => 'বাক্সের জায়গা';

  @override
  String get sheetTitle043 => 'উপচে পড়া';

  @override
  String get sheetTitle044 => 'খোপ';

  @override
  String get sheetTitle045 => 'যন্ত্রাংশের বাক্স';

  @override
  String get sheetTitle046 => 'মজুত কম';

  @override
  String get sheetTitle047 => 'খোপের তাক';

  @override
  String get sheetTitle048 => 'সহজ পথ';

  @override
  String get sheetTitle049 => 'স্লট মেশিন';

  @override
  String get sheetTitle050 => 'হাউসফুল';

  @override
  String get sheetTitle051 => 'জমে থাকা কাজ';

  @override
  String get sheetTitle052 => 'বাড়তি স্লট';

  @override
  String get sheetTitle053 => 'ফাঁক';

  @override
  String get sheetTitle054 => 'ঢিলেঢালা';

  @override
  String get sheetTitle055 => 'মজুত হিসাব';

  @override
  String get sheetTitle056 => 'বাড়তি মাপ';

  @override
  String get sheetTitle057 => 'টলারেন্স';

  @override
  String get sheetTitle058 => 'ছুটির দিন';

  @override
  String get sheetTitle059 => 'মাথার ওপর জায়গা';

  @override
  String get sheetTitle060 => 'গুদাম';

  @override
  String get sheetTitle061 => 'খাঁজে খাঁজ';

  @override
  String get sheetTitle062 => 'গাসেট প্লেট';

  @override
  String get sheetTitle063 => 'কিস্টোন';

  @override
  String get sheetTitle064 => 'ল্যাপ জয়েন্ট';

  @override
  String get sheetTitle065 => 'জোড়া প্লেট';

  @override
  String get sheetTitle066 => 'ডোভটেইল';

  @override
  String get sheetTitle067 => 'লিন্টেল';

  @override
  String get sheetTitle068 => 'কাটা টুকরো';

  @override
  String get sheetTitle069 => 'ঠেকনা';

  @override
  String get sheetTitle070 => 'ট্রাস';

  @override
  String get sheetTitle071 => 'ক্লেভিস';

  @override
  String get sheetTitle072 => 'জোয়াল';

  @override
  String get sheetTitle073 => 'স্যাডল';

  @override
  String get sheetTitle074 => 'ভিত';

  @override
  String get sheetTitle075 => 'জোড়া ব্র্যাকেট';

  @override
  String get sheetTitle076 => 'ক্ল্যাম্প বার';

  @override
  String get sheetTitle077 => 'টাই প্লেট';

  @override
  String get sheetTitle078 => 'সাদামাটা প্যানেল';

  @override
  String get sheetTitle079 => 'ক্যান্টিলিভার';

  @override
  String get sheetTitle080 => 'মোমেন্ট ফ্রেম';

  @override
  String get sheetTitle081 => 'মহাপরিকল্পনা';

  @override
  String get sheetTitle082 => 'উপ-সংযোজন';

  @override
  String get sheetTitle083 => 'এক্সপ্লোডেড ভিউ';

  @override
  String get sheetTitle084 => 'মাপ যাচাই';

  @override
  String get sheetTitle085 => 'টর্কের মান';

  @override
  String get sheetTitle086 => 'জিগ';

  @override
  String get sheetTitle087 => 'ফিক্সচার';

  @override
  String get sheetTitle088 => 'শান্ত বেঞ্চ';

  @override
  String get sheetTitle089 => 'গিয়ারবক্স';

  @override
  String get sheetTitle090 => 'হাউজিং';

  @override
  String get sheetTitle091 => 'চেসিস';

  @override
  String get sheetTitle092 => 'প্যানেল বে';

  @override
  String get sheetTitle093 => 'কভার সেট';

  @override
  String get sheetTitle094 => 'সহজ টর্ক';

  @override
  String get sheetTitle095 => 'ইঞ্জিন মাউন্ট';

  @override
  String get sheetTitle096 => 'সুইচগিয়ার';

  @override
  String get sheetTitle097 => 'কন্ট্রোল বক্স';

  @override
  String get sheetTitle098 => 'ড্রাফটিং টেবিল';

  @override
  String get sheetTitle099 => 'চূড়ান্ত পরিদর্শন';

  @override
  String get sheetTitle100 => 'চূড়ান্ত স্বাক্ষর';
}
