// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'रोकें';

  @override
  String get back => 'वापस';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get tray => 'ट्रे';

  @override
  String get trayFull => 'ट्रे भरी';

  @override
  String get undo => 'वापस लें';

  @override
  String hintCount(String count) {
    return 'हिंट · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'खेल रुका है';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · चाल $moves';
  }

  @override
  String get resume => 'जारी रखें';

  @override
  String get sound => 'आवाज़';

  @override
  String get haptics => 'वाइब्रेशन';

  @override
  String get reducedMotion => 'कम एनिमेशन';

  @override
  String get restart => 'फिर से';

  @override
  String get exitToSheets => 'शीट सूची पर';

  @override
  String get restartConfirmTitle => 'यह शीट फिर से शुरू करें?';

  @override
  String restartConfirmBody(int moves) {
    return 'आपकी $moves चालों की प्रगति मिट जाएगी।';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get stuckTitle => 'कोई खाली स्लॉट नहीं बचा।';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count स्क्रू',
      one: 'एक स्क्रू',
    );
    return '$plate अभी भी बोर्ड पर $_temp0 थामे हुए है। चाल वापस लेने से एक स्लॉट खाली होगा।';
  }

  @override
  String get stuckReasonGeneric =>
      'सारे स्लॉट भरे हैं और कोई प्लेट गिर नहीं सकती। चाल वापस लेने से एक स्लॉट खाली होगा।';

  @override
  String get undoLastMove => 'आखिरी चाल वापस लें';

  @override
  String rescueSlotCoins(int coins) {
    return '+1 स्लॉट · $coins ¢';
  }

  @override
  String get rescueSlotAd => '+1 स्लॉट · वीडियो';

  @override
  String get rescueSlotPro => '+1 स्लॉट · PRO';

  @override
  String get outOfHintsTitle => 'एक और हिंट चाहिए?';

  @override
  String get hintsLeftZero => 'हिंट · 0 बचे';

  @override
  String get outOfHintsBody =>
      'हिंट अगले काम के स्क्रू पर घेरा बनाता है। यह शीट को कभी खुद हल नहीं करता।';

  @override
  String get watchVideo => 'एक छोटा वीडियो देखें';

  @override
  String get watchVideoMeta => 'वैकल्पिक · ~30 सेकंड · +1 हिंट';

  @override
  String useCoins(int coins) {
    return '$coins सिक्के खर्च करें';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'बैलेंस $balance ¢';
  }

  @override
  String get keepThinking => 'थोड़ा और सोचें';

  @override
  String get notEnoughCoins => 'अभी पर्याप्त सिक्के नहीं हैं।';

  @override
  String get adUnavailable => 'अभी कोई वीडियो उपलब्ध नहीं है।';

  @override
  String cleared(String code) {
    return '$code · पूरी';
  }

  @override
  String get disassembled => 'खुल गया।';

  @override
  String get approved => 'स्वीकृत';

  @override
  String get statMoves => 'चालें';

  @override
  String get statTime => 'समय';

  @override
  String get statMastery => 'महारत';

  @override
  String nextSheet(String code) {
    return 'अगली शीट · $code';
  }

  @override
  String get replay => 'दोबारा';

  @override
  String get sheets => 'शीट';

  @override
  String get backHome => 'होम पर जाएं';

  @override
  String chapterComplete(String chapter) {
    return 'अध्याय $chapter · पूरा';
  }

  @override
  String get themeUnlocked => 'थीम अनलॉक';

  @override
  String nextChapter(String chapter) {
    return 'आगे · अध्याय $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'अध्याय $chapter शुरू करें';
  }

  @override
  String equipTheme(String name) {
    return '$name लगाएं';
  }

  @override
  String get tutorialStep1 => 'कदम 1 · स्क्रू पर टैप करें';

  @override
  String get tutorialLands => '↓ यह ट्रे में जाता है';

  @override
  String get skipTutorial => 'ट्यूटोरियल छोड़ें';

  @override
  String get splashTagline => 'परतों की पहेली';

  @override
  String get splashFooter => 'REV 1.0 · शीट 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates प्लेटें',
      one: '1 प्लेट',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'स्क्रू',
      one: 'स्क्रू',
    );
    return 'चित्र 1\nखुला दृश्य\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'अध्याय $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'स्क्रू',
      one: 'स्क्रू',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'अगली शीट';

  @override
  String chapterLabel(String chapter) {
    return 'अध्याय $chapter';
  }

  @override
  String get campaign => 'कैंपेन';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'जारी रखें · $code';
  }

  @override
  String get daily => 'रोज़ाना';

  @override
  String get themes => 'थीम';

  @override
  String get allCleared => 'सारी शीट पूरी';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total शीट';
  }

  @override
  String get fiveChapters => 'पांच अध्याय';

  @override
  String get chaptersTitle => 'अध्याय';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'लॉक';

  @override
  String get downloadChapter => 'डाउनलोड';

  @override
  String get downloading => 'डाउनलोड…';

  @override
  String get comingSoon => 'नई शीट जल्द';

  @override
  String newMechanic(String mechanic) {
    return 'नया: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates प्लेटें',
      one: '1 प्लेट',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers परतें',
      one: '1 परत',
    );
    return '$_temp0 · $_temp1 · ट्रे $tray';
  }

  @override
  String get theCampaign => 'कैंपेन';

  @override
  String get campaignFooter =>
      'पिछला अध्याय पूरा करने पर अगला खुलता है। महारत के निशान वैकल्पिक हैं। हिंट कभी प्रगति नहीं रोकते।';

  @override
  String get chapterBonus => 'अध्याय बोनस';

  @override
  String get dailySheet => 'रोज़ की शीट';

  @override
  String get dailyTitle => 'नाम';

  @override
  String get dailyPlates => 'प्लेटें';

  @override
  String get dailyReward => 'इनाम';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak दिन की स्ट्रीक।',
      one: '1 दिन की स्ट्रीक।',
      zero: 'स्ट्रीक शुरू करें।',
    );
    return 'आज सबके लिए एक ही शीट। कोई टाइमर नहीं। $_temp0 एक दिन छूटने से कुछ नहीं जाता।';
  }

  @override
  String get startDaily => 'आज की शीट शुरू करें';

  @override
  String get dailyCompleted => 'आज का काम पूरा · कल फिर मिलेंगे';

  @override
  String get replayDaily => 'आज की शीट दोबारा खेलें';

  @override
  String get themesTitle => 'थीम';

  @override
  String get themesCaption => 'सिर्फ़ लुक · नियम कभी नहीं बदलते';

  @override
  String get equipped => 'लगी है';

  @override
  String get owned => 'आपकी';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'प्रीव्यू';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get feedbackSection => 'आवाज़ और वाइब्रेशन';

  @override
  String get soundEffects => 'साउंड इफ़ेक्ट';

  @override
  String get music => 'संगीत';

  @override
  String get hapticsRow => 'वाइब्रेशन';

  @override
  String get reducedMotionRow => 'कम एनिमेशन';

  @override
  String get reducedMotionCaption => 'उड़ने की जगह धीरे से ओझल';

  @override
  String get generalSection => 'सामान्य';

  @override
  String get highRefreshRate => 'हाई रिफ़्रेश रेट';

  @override
  String highRefreshRateOn(int hz) {
    return 'ज़्यादा स्मूद · $hz Hz तक · बैटरी ज़्यादा खर्च';
  }

  @override
  String get highRefreshRateOff => 'ज़्यादा स्मूद · बैटरी ज़्यादा खर्च';

  @override
  String get highRefreshRateUnsupported => 'यह स्क्रीन एक ही रेट पर चलती है';

  @override
  String get highRefreshRateBattery => 'अभी बैटरी सेवर की वजह से सीमित';

  @override
  String get highRefreshRateHeat => 'फ़ोन गर्म होने तक सीमित';

  @override
  String highRefreshRateNow(int hz) {
    return 'अभी $hz Hz';
  }

  @override
  String get language => 'भाषा';

  @override
  String get notifications => 'रोज़ का रिमाइंडर';

  @override
  String get notificationsCaption => 'नई शीट आने पर एक रिमाइंडर';

  @override
  String get accountSection => 'अकाउंट';

  @override
  String get signInGoogle => 'Google से साइन इन करें';

  @override
  String get signInApple => 'Apple से साइन इन करें';

  @override
  String signedInAs(String name) {
    return 'साइन इन · $name';
  }

  @override
  String get guestCaption =>
      'गेस्ट के तौर पर खेल रहे हैं · प्रगति सेव करने के लिए साइन इन करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get deleteAccount => 'अकाउंट हटाएं';

  @override
  String get purchasesSection => 'खरीदारी';

  @override
  String get removeAds => 'विज्ञापन हटाएं';

  @override
  String get restore => 'रीस्टोर';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'विज्ञापन नहीं · अनलिमिटेड हिंट · सारी थीम · मुफ़्त रेस्क्यू · हर महीने $coins ¢';
  }

  @override
  String get proMonthly => 'मासिक';

  @override
  String get proYearly => 'सालाना';

  @override
  String proTrialDays(int days) {
    return '$days दिन मुफ़्त';
  }

  @override
  String proThenPrice(String price) {
    return 'फिर $price';
  }

  @override
  String get proTrialTerms =>
      'मुफ़्त ट्रायल के बाद यह अपने आप रिन्यू होता है, जब तक आप रद्द न करें। मासिक सिक्के आपके पहले भुगतान से शुरू होते हैं।';

  @override
  String get proActive => 'PRO · चालू';

  @override
  String get adsRemoved => 'विज्ञापन हटाए गए';

  @override
  String get coinPacks => 'सिक्कों के पैक';

  @override
  String get aboutSection => 'जानकारी';

  @override
  String get privacyPolicy => 'प्राइवेसी पॉलिसी';

  @override
  String get termsOfUse => 'इस्तेमाल की शर्तें';

  @override
  String get refundPolicy => 'रिफ़ंड पॉलिसी';

  @override
  String get privacyChoices => 'प्राइवेसी विकल्प';

  @override
  String get licenses => 'लाइसेंस और क्रेडिट';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'रोज़ की शीट के लिए रिमाइंडर?';

  @override
  String get notificationPrimerBody =>
      'जब आपने न खेला हो, तब एक शांत-सा रिमाइंडर। दिन में एक से ज़्यादा कभी नहीं।';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई।';

  @override
  String get purchaseThanks => 'धन्यवाद! खरीदारी लागू हो गई।';

  @override
  String get purchasePending => 'खरीदारी बाकी है। पुष्टि होते ही लागू होगी।';

  @override
  String get purchaseFailed => 'खरीदारी पूरी नहीं हुई।';

  @override
  String get restored => 'खरीदारी रीस्टोर हो गई।';

  @override
  String finishChapterFirst(String chapter) {
    return 'पहले अध्याय $chapter पूरा करें।';
  }

  @override
  String get moreSheetsTitle => 'और शीट';

  @override
  String get moreSheetsCaption => 'नए ड्रॉइंग सेट यहां आते हैं';

  @override
  String get equip => 'लगाएं';

  @override
  String buyFor(int coins) {
    return 'खरीदें · $coins ¢';
  }

  @override
  String get close => 'बंद करें';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'लाइसेंस';

  @override
  String get licensesCaption => 'ओपन-सोर्स सूचनाएं';

  @override
  String playLevel(String code) {
    return '$code खेलें';
  }

  @override
  String lockedLevel(int number) {
    return 'शीट $number, लॉक';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'लीडरबोर्ड';

  @override
  String get leaderboardCaption => 'साइन-इन खिलाड़ी · लाइव';

  @override
  String get boardSheets => 'शीट';

  @override
  String get boardDaily => 'डेली';

  @override
  String get boardStreak => 'स्ट्रीक';

  @override
  String get boardWeekly => 'हफ़्ता';

  @override
  String get boardWeeklyHint => 'इस हफ़्ते पूरी की गई शीट · सोमवार को रीसेट';

  @override
  String get boardSheetsHint => 'सबसे ज़्यादा पूरी शीट';

  @override
  String get boardDailyHint => 'आज की शीट · सबसे कम चालें, फिर सबसे तेज़';

  @override
  String get boardStreakHint => 'डेली शीट पर लगातार दिन';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'चालें',
      one: 'चाल',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'दिन',
      one: 'दिन',
    );
    return '$_temp0 · बेस्ट $best';
  }

  @override
  String get boardYou => 'आप';

  @override
  String get boardYourRank => 'आपकी रैंक';

  @override
  String get boardNotRanked => 'अभी रैंक नहीं';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString में से';
  }

  @override
  String get boardGuest =>
      'बोर्ड पर अपना नाम लाने के लिए साइन इन करें। आपकी प्रगति साथ रहेगी।';

  @override
  String get boardEmpty => 'अभी यहां कोई नहीं। पहले आप बनें।';

  @override
  String get boardOffline => 'अभी लीडरबोर्ड तक नहीं पहुंच पा रहे।';

  @override
  String get tryAgainCaps => 'फिर कोशिश';

  @override
  String get todaysBoard => 'आज का बोर्ड';

  @override
  String get signedOutToast =>
      'साइन आउट हो गए · इस डिवाइस का डेटा मिटा दिया गया। प्रगति वापस पाने के लिए फिर से साइन इन करें।';

  @override
  String get welcomeBack => 'फिर से स्वागत है';

  @override
  String welcomeBackName(String name) {
    return 'फिर से स्वागत है, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets शीट',
      one: '1 शीट',
    );
    return '$who · $_temp0 और $coins सिक्के वापस आ गए';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · आप साइन इन हैं और प्रगति का बैकअप है';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets शीट',
      one: '1 शीट',
    );
    return '$who · इस डिवाइस की प्रगति आपके अकाउंट में जुड़ गई: $_temp0, $coins सिक्के';
  }

  @override
  String syncSavedNew(String name) {
    return '$name के रूप में साइन इन · अब आपकी प्रगति अकाउंट में सेव होती है';
  }

  @override
  String get syncSavedNewPlain =>
      'साइन इन हो गए · अब आपकी प्रगति अकाउंट में सेव होती है';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets नई शीट',
      one: '1 नई शीट',
      zero: 'प्रगति अपडेट हुई',
    );
    return 'दूसरे डिवाइस से सिंक हुआ · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'आपकी सेव प्रगति अभी लोड नहीं हो पाई · कनेक्शन लौटते ही यह अपने आप सिंक हो जाएगी';

  @override
  String get signedInOffline =>
      'साइन इन हो गए · ऑनलाइन होते ही प्रगति सिंक हो जाएगी';

  @override
  String get proActivated =>
      'Pro चालू है · कोई विज्ञापन नहीं, सारी थीम और अनलिमिटेड हिंट';

  @override
  String get accountDeletedToast =>
      'आपका अकाउंट और उसका सारा डेटा हटा दिया गया।';

  @override
  String accountDeletedProToast(String store) {
    return 'अकाउंट हटा दिया गया। जब तक आप $store में रद्द नहीं करते, Pro का बिल बनता रहेगा।';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days दिन की स्ट्रीक · +$coins बोनस';
  }

  @override
  String get workshopRecord => 'वर्कशॉप रिकॉर्ड';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'वर्कशॉप रिकॉर्ड · $earned/$total';
  }

  @override
  String get recordCaption => 'उपलब्धियां';

  @override
  String recordEarned(int earned, int total) {
    return '$total में से $earned हासिल';
  }

  @override
  String get badgeEarnedLabel => 'हासिल';

  @override
  String badgeEarnedToast(String name) {
    return 'बैज मिला · $name';
  }

  @override
  String get badgeFirstTurn => 'पहला पेंच';

  @override
  String get badgeApprentice => 'शागिर्द';

  @override
  String get badgeJourneyman => 'कारीगर';

  @override
  String get badgeCraftsman => 'उस्ताद';

  @override
  String get badgeChiefEngineer => 'चीफ़ इंजीनियर';

  @override
  String get badgeCleanWork => 'साफ़ काम';

  @override
  String get badgePerfectionist => 'परफ़ेक्शनिस्ट';

  @override
  String get badgeRegular => 'नियमित खिलाड़ी';

  @override
  String get badgeOnARoll => 'लय में';

  @override
  String get badgeFullWeek => 'पूरा हफ़्ता';

  @override
  String get badgeFortnight => 'दो हफ़्ते';

  @override
  String get badgeFirstDetail => 'अपनी पहली शीट पूरी करें';

  @override
  String badgeClearDetail(int n) {
    return '$n शीट पूरी करें';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'अध्याय $n पूरा करें';
  }

  @override
  String badgeMasterDetail(int n) {
    return '$n शीट पर ◆ पाएं';
  }

  @override
  String badgeDailyDetail(int n) {
    return '$n डेली शीट खेलें';
  }

  @override
  String badgeStreakDetail(int n) {
    return '$n दिन की स्ट्रीक बनाएं';
  }

  @override
  String get share => 'शेयर';

  @override
  String get shareResult => 'नतीजा शेयर करें';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves चालें',
      one: '1 चाल',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days दिन की स्ट्रीक';
  }

  @override
  String get signOutSheetTitle => 'साइन आउट करें?';

  @override
  String get signOutSheetBody =>
      'साइन आउट करने से इस डिवाइस से आपकी प्रगति मिट जाती है। जिसका बैकअप हो चुका है, वह दोबारा साइन इन करने पर लौट आएगा, लेकिन जो अभी सिंक नहीं हुआ (जैसे ऑफ़लाइन खेली गई शीट) वह खो जाएगा।';

  @override
  String get staySignedIn => 'साइन इन रहें';

  @override
  String get signOutConfirm => 'साइन आउट';

  @override
  String get rateApp => 'Screw Out को रेट करें';

  @override
  String get sendFeedback => 'फ़ीडबैक भेजें';

  @override
  String get replayTutorial => 'ट्यूटोरियल दोबारा देखें';

  @override
  String feedbackNoEmailApp(String email) {
    return 'कोई ईमेल ऐप नहीं मिला। हमें $email पर लिखें';
  }

  @override
  String get updateChip => 'अपडेट';

  @override
  String get updateReadyRestart =>
      'अपडेट डाउनलोड हो गया। इंस्टॉल करने के लिए रीस्टार्ट करें।';

  @override
  String get deleteSheetTitle => 'अपना अकाउंट हटाएं?';

  @override
  String get deleteSheetBody =>
      'इससे आपका अकाउंट और उसमें सेव हर चीज़ हमेशा के लिए हट जाएगी: हर शीट की प्रगति, सिक्के, थीम, डेली स्ट्रीक और लीडरबोर्ड की जगहें। इसे वापस नहीं लिया जा सकता।';

  @override
  String deleteSheetPro(String store) {
    return 'आपके पास Screw Out Pro है। अकाउंट हटाने से यह रद्द नहीं होता: $store में सब्सक्रिप्शन रद्द करें, वरना बिल बनता रहेगा।';
  }

  @override
  String get manageSubscription => 'सब्सक्रिप्शन मैनेज करें';

  @override
  String get deleteForever => 'मेरा अकाउंट हटाएं';

  @override
  String get deleting => 'हटाया जा रहा है…';

  @override
  String get keepAccount => 'मेरा अकाउंट रखें';

  @override
  String get deleteOffline =>
      'आप ऑफ़लाइन हैं। अकाउंट हटाने के लिए इंटरनेट से जुड़ें।';

  @override
  String get deleteFailed => 'अकाउंट नहीं हट पाया। कृपया फिर कोशिश करें।';

  @override
  String get restoreNothing => 'इस अकाउंट पर रीस्टोर करने को कुछ नहीं है।';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 हिंट';
  }

  @override
  String get hintEarnedToast => '+1 हिंट · देखने के लिए धन्यवाद';

  @override
  String get rescueToast => 'इस शीट के लिए +1 ट्रे स्लॉट';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 ट्रे स्लॉट';
  }

  @override
  String get adNotCompleted =>
      'वीडियो पूरा नहीं हुआ, इसलिए इस बार कोई इनाम नहीं।';

  @override
  String themeEquippedToast(String name) {
    return '$name लगा दी गई';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'अध्याय $chapter तैयार है';
  }

  @override
  String get signInFailed => 'साइन इन पूरा नहीं हुआ।';

  @override
  String get themePurchased => 'थीम अनलॉक हो गई।';

  @override
  String themeBuyStore(String price) {
    return 'या खरीदें · $price';
  }

  @override
  String get themesBundleTitle => 'सारी थीम';

  @override
  String get themesBundleBody =>
      'हर पेड थीम, हमेशा के लिए आपकी। Pro में भी ये शामिल हैं।';

  @override
  String themesBundleBuy(String price) {
    return 'खरीदें · $price';
  }

  @override
  String get dailyWeekDone => 'पूरा';

  @override
  String masteredCount(int count) {
    return '$count में महारत';
  }

  @override
  String get reminderTitle => 'आज की शीट तैयार है';

  @override
  String get reminderBody => 'एक नई ड्रॉइंग, सबके लिए एक जैसी। कोई टाइमर नहीं।';

  @override
  String get comebackReminderTitle => 'आपकी अगली शीट बेंच पर इंतज़ार कर रही है';

  @override
  String get comebackReminderBody =>
      'कुछ सुकून भरे मिनट, कुछ स्क्रू। वहीं से शुरू करें जहां छोड़ा था।';

  @override
  String get signInEmail => 'ईमेल से जारी रखें';

  @override
  String get emailSignInTitle => 'साइन इन';

  @override
  String get emailCreateTitle => 'अकाउंट बनाएं';

  @override
  String get emailTabSignIn => 'साइन इन';

  @override
  String get emailTabCreate => 'अकाउंट बनाएं';

  @override
  String get emailSheetBody => 'इस डिवाइस की आपकी प्रगति साथ चलेगी।';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get hidePassword => 'पासवर्ड छिपाएं';

  @override
  String passwordHint(int min) {
    return 'कम से कम $min अक्षर';
  }

  @override
  String get emailRequired => 'अपना ईमेल डालें।';

  @override
  String get emailInvalid => 'यह ईमेल पता सही नहीं लग रहा।';

  @override
  String get passwordRequired => 'अपना पासवर्ड डालें।';

  @override
  String passwordTooShort(int min) {
    return 'कम से कम $min अक्षर इस्तेमाल करें।';
  }

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get forgotNeedsEmail =>
      'ऊपर अपना ईमेल डालें, फिर पासवर्ड भूल गए? पर टैप करें।';

  @override
  String resetSent(String email) {
    return 'अगर $email का अकाउंट है, तो रीसेट लिंक भेजा जा रहा है।';
  }

  @override
  String get emailWorking => 'एक पल…';

  @override
  String get authErrWrongCredentials => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get authErrEmailInUse =>
      'इस ईमेल का अकाउंट पहले से है। इसके बजाय साइन इन करें।';

  @override
  String get authErrWeakPassword => 'कोई मज़बूत पासवर्ड चुनें।';

  @override
  String get authErrDisabled => 'यह अकाउंट बंद कर दिया गया है।';

  @override
  String get authErrNotEnabled => 'ईमेल से साइन इन अभी उपलब्ध नहीं है।';

  @override
  String get authErrTooMany =>
      'बहुत ज़्यादा कोशिशें। थोड़ा रुककर फिर कोशिश करें।';

  @override
  String get authErrNetwork =>
      'कनेक्शन नहीं है। इंटरनेट जांचें और फिर कोशिश करें।';

  @override
  String get authErrGeneric => 'साइन इन नहीं हो पाया। कृपया फिर कोशिश करें।';

  @override
  String get deletePasswordBody =>
      'यह आप ही हैं, इसकी पुष्टि के लिए अपना पासवर्ड डालें।';

  @override
  String get deleteWrongPassword => 'यह पासवर्ड इस अकाउंट से मेल नहीं खाता।';

  @override
  String get purchaseSaveTitle => 'अपनी खरीदारी सुरक्षित रखें';

  @override
  String get purchaseSaveBody =>
      'वैकल्पिक: अपनी खरीदारी और प्रगति सभी डिवाइस पर रखने के लिए साइन इन करें। आपकी खरीदारी इस डिवाइस पर पहले से काम कर रही है।';

  @override
  String get purchaseNeedsConnection =>
      'सर्वर तक नहीं पहुंच पाए। कनेक्शन जांचें और फिर कोशिश करें।';

  @override
  String get languageSystemDefault => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get startupFailed =>
      'शुरू करते समय कुछ गड़बड़ हो गई।\nऐप बंद करके फिर से खोलें।';

  @override
  String get notificationChannelDescription =>
      'रोज़ की शीट के रिमाइंडर और अकाउंट की सूचनाएं';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'स्क्रू, प्लेट $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'स्क्रू, प्लेट $plate, $blocker से ढका हुआ';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $total में से $filled';
  }

  @override
  String get chapterName1 => 'वर्कशॉप की बुनियाद';

  @override
  String get chapterName2 => 'परत दर परत';

  @override
  String get chapterName3 => 'जगह बनाओ';

  @override
  String get chapterName4 => 'आपस में जुड़े';

  @override
  String get chapterName5 => 'मास्टर बिल्डर';

  @override
  String get chapterGoal1 => 'टैप करें, निकालें, छुड़ाएं';

  @override
  String get chapterGoal2 => 'ओवरलैप और खुलने का क्रम';

  @override
  String get chapterGoal3 => 'तंग ट्रे के हिसाब से योजना';

  @override
  String get chapterGoal4 => 'साझा सपोर्ट';

  @override
  String get chapterGoal5 => 'सब कुछ, निष्पक्ष ढंग से';

  @override
  String get chapterPitch1 =>
      'स्क्रू पर टैप करें। प्लेट गिराएं। बस यही पूरा नियम है।';

  @override
  String get chapterPitch2 =>
      'प्लेटें प्लेटों को छिपाती हैं। ऊपर से नीचे की ओर चलें।';

  @override
  String get chapterPitch3 =>
      'तंग ट्रे। तय करें कि पहले कौन से स्क्रू निकालने हैं।';

  @override
  String get chapterPitch4 =>
      'एक प्लेट कई प्लेटों को थामे है। असली कुंजी खोजें।';

  @override
  String get chapterPitch5 => 'गहरी परतें, सारे आइडिया एक साथ। आराम से खेलें।';

  @override
  String chapterNameDrawingSet(String number) {
    return 'ड्रॉइंग सेट $number';
  }

  @override
  String get chapterGoalDownloaded => 'मास्टर लेवल की शीट';

  @override
  String get chapterPitchDownloaded => 'और शीट, वही निष्पक्ष नियम।';

  @override
  String get mechanicOverlap => 'ओवरलैप';

  @override
  String get mechanicTray => 'ट्रे';

  @override
  String get mechanicLayers => 'परतें';

  @override
  String get mechanicCircles => 'गोल प्लेटें';

  @override
  String get mechanicTraps => 'जाल';

  @override
  String get mechanicSupports => 'सपोर्ट';

  @override
  String get sheetObjective004 =>
      'नीचे का स्क्रू पाने के लिए ऊपर की प्लेट हटाएं';

  @override
  String get sheetObjective006 =>
      'ट्रे में 3 जगह। प्लेट हटते ही उसके स्लॉट खाली';

  @override
  String get sheetObjective011 => 'तीन परतें। ऊपर से नीचे की ओर चलें';

  @override
  String get sheetObjective012 => 'नीचे की प्लेटों से पहले PL-04 हटाएं';

  @override
  String get sheetObjective017 => 'एक लुभावनी चाल ट्रे भर देती है';

  @override
  String get sheetObjective021 => 'गोल प्लेटें भी बाकी की तरह ढकती हैं';

  @override
  String get sheetObjective024 => 'कोने तक पहुंचने के लिए PL-04 हटाएं';

  @override
  String get sheetObjective041 => 'तंग ट्रे। भरने से पहले एक प्लेट छुड़ाएं';

  @override
  String get sheetObjective061 => 'एक प्लेट कई दूसरी प्लेटों को दबा सकती है';

  @override
  String get sheetObjective081 => 'अब तक का सब कुछ। आराम से खेलें';

  @override
  String get themeNameBlueprint => 'साफ़ ब्लूप्रिंट';

  @override
  String get themeNameWalnut => 'अखरोट वर्कशॉप';

  @override
  String get themeNameOcean => 'समुद्री फ़िरोज़ी';

  @override
  String get themeNameCopper => 'गर्म तांबा';

  @override
  String get themeNameMidnight => 'आधी रात की वर्कशॉप';

  @override
  String get themeNamePastel => 'पेस्टल स्टूडियो';

  @override
  String sheetTitleNumbered(int number) {
    return 'शीट $number';
  }

  @override
  String get sheetTitle001 => 'पहला पेंच';

  @override
  String get sheetTitle002 => 'दो बिंदु';

  @override
  String get sheetTitle003 => 'अगल-बगल';

  @override
  String get sheetTitle004 => 'ढक्कन प्लेट';

  @override
  String get sheetTitle005 => 'पर्दा उठा';

  @override
  String get sheetTitle006 => 'ट्रे का दिन';

  @override
  String get sheetTitle007 => 'छोटी योजना';

  @override
  String get sheetTitle008 => 'कसी फ़िटिंग';

  @override
  String get sheetTitle009 => 'गोल छड़';

  @override
  String get sheetTitle010 => 'चेकपॉइंट';

  @override
  String get sheetTitle011 => 'तीसरी परत';

  @override
  String get sheetTitle012 => 'क्रॉस ब्रेस';

  @override
  String get sheetTitle013 => 'स्लॉट खाली करें';

  @override
  String get sheetTitle014 => 'दो कदम आगे';

  @override
  String get sheetTitle015 => 'रंगा हुआ स्टील';

  @override
  String get sheetTitle016 => 'वर्कबेंच';

  @override
  String get sheetTitle017 => 'लालच';

  @override
  String get sheetTitle018 => 'झरना';

  @override
  String get sheetTitle019 => 'वर्कशॉप मिक्स';

  @override
  String get sheetTitle020 => 'असेंबली';

  @override
  String get sheetTitle021 => 'वॉशर का ढेर';

  @override
  String get sheetTitle022 => 'गैसकेट';

  @override
  String get sheetTitle023 => 'लेंस कैप';

  @override
  String get sheetTitle024 => 'छिपा ब्रैकेट';

  @override
  String get sheetTitle025 => 'शिम सेट';

  @override
  String get sheetTitle026 => 'बेज़ल';

  @override
  String get sheetTitle027 => 'ग्रोमेट';

  @override
  String get sheetTitle028 => 'थोड़ा आराम';

  @override
  String get sheetTitle029 => 'फ़्लैंज रिंग';

  @override
  String get sheetTitle030 => 'पोर्टहोल';

  @override
  String get sheetTitle031 => 'स्पेसर';

  @override
  String get sheetTitle032 => 'कॉलर';

  @override
  String get sheetTitle033 => 'एंड कैप';

  @override
  String get sheetTitle034 => 'शांत शिफ़्ट';

  @override
  String get sheetTitle035 => 'बल्कहेड';

  @override
  String get sheetTitle036 => 'जांच खिड़की';

  @override
  String get sheetTitle037 => 'फ़ेसप्लेट';

  @override
  String get sheetTitle038 => 'हल्का काम';

  @override
  String get sheetTitle039 => 'रोज़ेट';

  @override
  String get sheetTitle040 => 'परतदार केक';

  @override
  String get sheetTitle041 => 'जगह बनाओ';

  @override
  String get sheetTitle042 => 'डिब्बे में जगह';

  @override
  String get sheetTitle043 => 'ओवरफ़्लो';

  @override
  String get sheetTitle044 => 'छोटा खाना';

  @override
  String get sheetTitle045 => 'पुर्ज़ों का डिब्बा';

  @override
  String get sheetTitle046 => 'कम स्टॉक';

  @override
  String get sheetTitle047 => 'कबूतरखाना';

  @override
  String get sheetTitle048 => 'आसान रास्ता';

  @override
  String get sheetTitle049 => 'स्लॉट मशीन';

  @override
  String get sheetTitle050 => 'हाउसफ़ुल';

  @override
  String get sheetTitle051 => 'बकाया काम';

  @override
  String get sheetTitle052 => 'अतिरिक्त स्लॉट';

  @override
  String get sheetTitle053 => 'खाली जगह';

  @override
  String get sheetTitle054 => 'ढीली फ़िटिंग';

  @override
  String get sheetTitle055 => 'इन्वेंटरी';

  @override
  String get sheetTitle056 => 'गुंजाइश';

  @override
  String get sheetTitle057 => 'टॉलरेंस';

  @override
  String get sheetTitle058 => 'छुट्टी का दिन';

  @override
  String get sheetTitle059 => 'ऊपर की जगह';

  @override
  String get sheetTitle060 => 'गोदाम';

  @override
  String get sheetTitle061 => 'इंटरलॉक';

  @override
  String get sheetTitle062 => 'गसेट';

  @override
  String get sheetTitle063 => 'मुख्य पत्थर';

  @override
  String get sheetTitle064 => 'लैप जोड़';

  @override
  String get sheetTitle065 => 'जोड़ प्लेट';

  @override
  String get sheetTitle066 => 'डवटेल';

  @override
  String get sheetTitle067 => 'चौखट';

  @override
  String get sheetTitle068 => 'कतरन';

  @override
  String get sheetTitle069 => 'स्ट्रट';

  @override
  String get sheetTitle070 => 'ट्रस';

  @override
  String get sheetTitle071 => 'क्लेविस';

  @override
  String get sheetTitle072 => 'जुआ';

  @override
  String get sheetTitle073 => 'काठी';

  @override
  String get sheetTitle074 => 'नींव';

  @override
  String get sheetTitle075 => 'ब्रैकेट जोड़ी';

  @override
  String get sheetTitle076 => 'क्लैंप बार';

  @override
  String get sheetTitle077 => 'टाई प्लेट';

  @override
  String get sheetTitle078 => 'सादा पैनल';

  @override
  String get sheetTitle079 => 'कैंटिलीवर';

  @override
  String get sheetTitle080 => 'मज़बूत फ़्रेम';

  @override
  String get sheetTitle081 => 'मास्टर प्लान';

  @override
  String get sheetTitle082 => 'सब-असेंबली';

  @override
  String get sheetTitle083 => 'खुला दृश्य';

  @override
  String get sheetTitle084 => 'फ़िट चेक';

  @override
  String get sheetTitle085 => 'टॉर्क स्पेक';

  @override
  String get sheetTitle086 => 'जिग';

  @override
  String get sheetTitle087 => 'फ़िक्स्चर';

  @override
  String get sheetTitle088 => 'शांत बेंच';

  @override
  String get sheetTitle089 => 'गियरबॉक्स';

  @override
  String get sheetTitle090 => 'हाउसिंग';

  @override
  String get sheetTitle091 => 'चेसिस';

  @override
  String get sheetTitle092 => 'पैनल बे';

  @override
  String get sheetTitle093 => 'कवर सेट';

  @override
  String get sheetTitle094 => 'हल्का टॉर्क';

  @override
  String get sheetTitle095 => 'इंजन माउंट';

  @override
  String get sheetTitle096 => 'स्विचगियर';

  @override
  String get sheetTitle097 => 'कंट्रोल बॉक्स';

  @override
  String get sheetTitle098 => 'ड्रॉइंग टेबल';

  @override
  String get sheetTitle099 => 'अंतिम जांच';

  @override
  String get sheetTitle100 => 'मंज़ूरी';
}
