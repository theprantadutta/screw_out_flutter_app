// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get back => 'رجوع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get tray => 'الصينية';

  @override
  String get trayFull => 'الصينية ممتلئة';

  @override
  String get undo => 'تراجع';

  @override
  String hintCount(String count) {
    return 'تلميح · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · الحركة $moves';
  }

  @override
  String get resume => 'متابعة';

  @override
  String get sound => 'الصوت';

  @override
  String get haptics => 'الاهتزاز';

  @override
  String get reducedMotion => 'تقليل الحركة';

  @override
  String get restart => 'إعادة';

  @override
  String get exitToSheets => 'إلى الأوراق';

  @override
  String get restartConfirmTitle => 'إعادة هذه الورقة؟';

  @override
  String restartConfirmBody(int moves) {
    return 'ستفقد تقدّم $moves من الحركات.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get stuckTitle => 'لا توجد خانات فارغة.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count برغي',
      many: '$count برغيًا',
      few: '$count براغٍ',
      two: 'برغيين',
      one: 'برغيًا واحدًا',
      zero: 'لا براغي',
    );
    return '$plate لا يزال يثبّت $_temp0 على الرقعة. التراجع يحرّر خانة.';
  }

  @override
  String get stuckReasonGeneric =>
      'كل الخانات مشغولة ولا يمكن لأي لوح أن يسقط. التراجع يحرّر خانة.';

  @override
  String get undoLastMove => 'تراجع عن آخر حركة';

  @override
  String rescueSlotCoins(int coins) {
    return 'خانة إضافية · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'خانة إضافية · فيديو';

  @override
  String get rescueSlotPro => 'خانة إضافية · PRO';

  @override
  String get outOfHintsTitle => 'تريد تلميحًا آخر؟';

  @override
  String get hintsLeftZero => 'التلميحات · بقي 0';

  @override
  String get outOfHintsBody =>
      'التلميح يضع دائرة حول برغي مفيد تاليًا. لا يحل الورقة أبدًا.';

  @override
  String get watchVideo => 'شاهد فيديو قصيرًا';

  @override
  String get watchVideoMeta => 'اختياري · ~30 ث · +1 تلميح';

  @override
  String useCoins(int coins) {
    return 'استخدم $coins عملة';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'الرصيد $balance ¢';
  }

  @override
  String get keepThinking => 'سأفكر أكثر';

  @override
  String get notEnoughCoins => 'العملات لا تكفي بعد.';

  @override
  String get adUnavailable => 'لا يوجد فيديو متاح الآن.';

  @override
  String cleared(String code) {
    return '$code · مكتملة';
  }

  @override
  String get disassembled => 'تم التفكيك.';

  @override
  String get approved => 'مُعتمد';

  @override
  String get statMoves => 'الحركات';

  @override
  String get statTime => 'الوقت';

  @override
  String get statMastery => 'الإتقان';

  @override
  String nextSheet(String code) {
    return 'الورقة التالية · $code';
  }

  @override
  String get replay => 'إعادة';

  @override
  String get sheets => 'الأوراق';

  @override
  String get backHome => 'إلى الرئيسية';

  @override
  String chapterComplete(String chapter) {
    return 'الفصل $chapter · مكتمل';
  }

  @override
  String get themeUnlocked => 'سمة جديدة';

  @override
  String nextChapter(String chapter) {
    return 'التالي · الفصل $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'ابدأ الفصل $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'استخدم $name';
  }

  @override
  String get tutorialStep1 => 'الخطوة 1 · اضغط البرغي';

  @override
  String get tutorialLands => '↓ يستقر في الصينية';

  @override
  String get skipTutorial => 'تخطَّ الشرح';

  @override
  String get splashTagline => 'لغز من الطبقات';

  @override
  String get splashFooter => 'الإصدار 1.0 · الورقة 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates لوح',
      many: '$plates لوحًا',
      few: '$plates ألواح',
      two: 'لوحان',
      one: 'لوح واحد',
      zero: 'لا ألواح',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'مثبّت',
      many: 'مثبّتًا',
      few: 'مثبّتات',
      two: 'مثبّتان',
      one: 'مثبّت',
      zero: 'مثبّتات',
    );
    return 'الشكل 1\nمنظر مفكك\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'الفصل $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مثبّت',
      many: 'مثبّتًا',
      few: 'مثبّتات',
      two: 'مثبّتان',
      one: 'مثبّت',
      zero: 'مثبّتات',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'الورقة التالية';

  @override
  String chapterLabel(String chapter) {
    return 'الفصل $chapter';
  }

  @override
  String get campaign => 'الحملة';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'تابع · $code';
  }

  @override
  String get daily => 'اليومية';

  @override
  String get themes => 'السمات';

  @override
  String get allCleared => 'اكتملت كل الأوراق';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total ورقة';
  }

  @override
  String get fiveChapters => 'خمسة فصول';

  @override
  String get chaptersTitle => 'الفصول';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'مقفل';

  @override
  String get downloadChapter => 'تنزيل';

  @override
  String get downloading => 'جارٍ التنزيل…';

  @override
  String get comingSoon => 'أوراق جديدة قريبًا';

  @override
  String newMechanic(String mechanic) {
    return 'جديد: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates لوح',
      many: '$plates لوحًا',
      few: '$plates ألواح',
      two: 'لوحان',
      one: 'لوح واحد',
      zero: 'لا ألواح',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers طبقة',
      many: '$layers طبقة',
      few: '$layers طبقات',
      two: 'طبقتان',
      one: 'طبقة واحدة',
      zero: 'لا طبقات',
    );
    return '$_temp0 · $_temp1 · الصينية $tray';
  }

  @override
  String get theCampaign => 'الحملة';

  @override
  String get campaignFooter =>
      'يُفتح كل فصل بإنهاء الفصل الذي قبله. علامات الإتقان اختيارية. التلميحات لا تعيق التقدم أبدًا.';

  @override
  String get chapterBonus => 'مكافأة الفصل';

  @override
  String get dailySheet => 'الورقة اليومية';

  @override
  String get dailyTitle => 'العنوان';

  @override
  String get dailyPlates => 'الألواح';

  @override
  String get dailyReward => 'المكافأة';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'سلسلة $streak يوم.',
      many: 'سلسلة $streak يومًا.',
      few: 'سلسلة $streak أيام.',
      two: 'سلسلة يومين.',
      one: 'سلسلة يوم واحد.',
      zero: 'ابدأ سلسلة.',
    );
    return 'الورقة نفسها للجميع اليوم. بلا مؤقت. $_temp0 تفويت يوم لا يكلّفك شيئًا.';
  }

  @override
  String get startDaily => 'ابدأ ورقة اليوم';

  @override
  String get dailyCompleted => 'انتهيت لليوم · نلقاك غدًا';

  @override
  String get replayDaily => 'أعد ورقة اليوم';

  @override
  String get themesTitle => 'السمات';

  @override
  String get themesCaption => 'مظهر فقط · القواعد لا تتغير';

  @override
  String get equipped => 'مُستخدمة';

  @override
  String get owned => 'مملوكة';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'معاينة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get feedbackSection => 'التفاعل';

  @override
  String get soundEffects => 'المؤثرات الصوتية';

  @override
  String get music => 'الموسيقى';

  @override
  String get hapticsRow => 'الاهتزاز';

  @override
  String get reducedMotionRow => 'تقليل الحركة';

  @override
  String get reducedMotionCaption => 'تلاشٍ بدل الانتقال';

  @override
  String get generalSection => 'عام';

  @override
  String get highRefreshRate => 'معدل تحديث مرتفع';

  @override
  String highRefreshRateOn(int hz) {
    return 'حركة أنعم · حتى $hz هرتز · يستهلك بطارية أكثر';
  }

  @override
  String get highRefreshRateOff => 'حركة أنعم · يستهلك بطارية أكثر';

  @override
  String get highRefreshRateUnsupported => 'تعمل هذه الشاشة بمعدل واحد';

  @override
  String get highRefreshRateBattery => 'مقيّد حاليًا بوضع توفير البطارية';

  @override
  String get highRefreshRateHeat => 'مقيّد ما دام الهاتف ساخنًا';

  @override
  String highRefreshRateNow(int hz) {
    return 'الآن $hz هرتز';
  }

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'تذكير يومي';

  @override
  String get notificationsCaption => 'تنبيه واحد عند صدور ورقة جديدة';

  @override
  String get accountSection => 'الحساب';

  @override
  String get signInGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get signInApple => 'تسجيل الدخول باستخدام Apple';

  @override
  String signedInAs(String name) {
    return 'مسجّل الدخول · $name';
  }

  @override
  String get guestCaption => 'تلعب كضيف · سجّل الدخول لحفظ تقدمك';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get purchasesSection => 'المشتريات';

  @override
  String get removeAds => 'إزالة الإعلانات';

  @override
  String get restore => 'استعادة';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'بلا إعلانات · تلميحات غير محدودة · كل السمات · إنقاذ مجاني · $coins ¢ شهريًا';
  }

  @override
  String get proMonthly => 'شهري';

  @override
  String get proYearly => 'سنوي';

  @override
  String proTrialDays(int days) {
    return '$days أيام مجانًا';
  }

  @override
  String proThenPrice(String price) {
    return 'ثم $price';
  }

  @override
  String get proTrialTerms =>
      'يتجدد تلقائيًا بعد الفترة التجريبية المجانية ما لم تلغِه. تبدأ العملات الشهرية مع أول دفعة.';

  @override
  String get proActive => 'PRO · مُفعّل';

  @override
  String get adsRemoved => 'أُزيلت الإعلانات';

  @override
  String get coinPacks => 'حزم العملات';

  @override
  String get aboutSection => 'حول';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get refundPolicy => 'سياسة الاسترداد';

  @override
  String get privacyChoices => 'خيارات الخصوصية';

  @override
  String get licenses => 'التراخيص والشكر';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · الإصدار $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'تنبيه للورقة اليومية؟';

  @override
  String get notificationPrimerBody =>
      'تذكير هادئ عندما لا تلعب. لا أكثر من مرة في اليوم.';

  @override
  String get allow => 'سماح';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get somethingWentWrong => 'حدث خطأ ما.';

  @override
  String get purchaseThanks => 'شكرًا لك! تم تطبيق الشراء.';

  @override
  String get purchasePending => 'الشراء قيد الانتظار. سيُطبّق بعد تأكيده.';

  @override
  String get purchaseFailed => 'لم تكتمل عملية الشراء.';

  @override
  String get restored => 'تمت استعادة المشتريات.';

  @override
  String finishChapterFirst(String chapter) {
    return 'أنهِ الفصل $chapter أولًا.';
  }

  @override
  String get moreSheetsTitle => 'أوراق إضافية';

  @override
  String get moreSheetsCaption => 'مجموعات الرسومات الجديدة تصل هنا';

  @override
  String get equip => 'استخدام';

  @override
  String buyFor(int coins) {
    return 'شراء · $coins ¢';
  }

  @override
  String get close => 'إغلاق';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'التراخيص';

  @override
  String get licensesCaption => 'إشعارات المصادر المفتوحة';

  @override
  String playLevel(String code) {
    return 'العب $code';
  }

  @override
  String lockedLevel(int number) {
    return 'الورقة $number، مقفلة';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'لوحات الصدارة';

  @override
  String get leaderboardCaption => 'اللاعبون المسجّلون · مباشر';

  @override
  String get boardSheets => 'الأوراق';

  @override
  String get boardDaily => 'اليومية';

  @override
  String get boardStreak => 'السلسلة';

  @override
  String get boardWeekly => 'الأسبوع';

  @override
  String get boardWeeklyHint => 'أوراق هذا الأسبوع · تُصفّر يوم الاثنين';

  @override
  String get boardSheetsHint => 'أكثر الأوراق المُنجزة';

  @override
  String get boardDailyHint => 'ورقة اليوم · أقل حركات، ثم الأسرع';

  @override
  String get boardStreakHint => 'أيام متتالية في الورقة اليومية';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'حركة',
      many: 'حركة',
      few: 'حركات',
      two: 'حركتان',
      one: 'حركة',
      zero: 'حركة',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يوم',
      many: 'يومًا',
      few: 'أيام',
      two: 'يومان',
      one: 'يوم',
      zero: 'يوم',
    );
    return '$_temp0 · الأفضل $best';
  }

  @override
  String get boardYou => 'أنت';

  @override
  String get boardYourRank => 'ترتيبك';

  @override
  String get boardNotRanked => 'لا ترتيب بعد';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'من $countString';
  }

  @override
  String get boardGuest => 'سجّل الدخول ليظهر اسمك في اللوحة. تقدمك ينتقل معك.';

  @override
  String get boardEmpty => 'لا أحد هنا بعد. كن الأول.';

  @override
  String get boardOffline => 'تعذّر الوصول إلى لوحة الصدارة الآن.';

  @override
  String get tryAgainCaps => 'أعد المحاولة';

  @override
  String get todaysBoard => 'لوحة اليوم';

  @override
  String get signedOutToast =>
      'تم تسجيل الخروج · مُسح هذا الجهاز. سجّل الدخول مجددًا لاستعادة تقدمك.';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String welcomeBackName(String name) {
    return 'مرحبًا بعودتك يا $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets ورقة',
      many: '$sheets ورقة',
      few: '$sheets أوراق',
      two: 'ورقتين',
      one: 'ورقة واحدة',
      zero: 'لا أوراق',
    );
    return '$who · تمت استعادة $_temp0 و$coins عملة';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · أنت مسجّل الدخول وتقدمك محفوظ احتياطيًا';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets ورقة',
      many: '$sheets ورقة',
      few: '$sheets أوراق',
      two: 'ورقتان',
      one: 'ورقة واحدة',
      zero: 'لا أوراق',
    );
    return '$who · أُضيف تقدّم هذا الجهاز إلى حسابك: $_temp0، $coins عملة';
  }

  @override
  String syncSavedNew(String name) {
    return 'تم تسجيل الدخول باسم $name · تقدمك محفوظ الآن في حسابك';
  }

  @override
  String get syncSavedNewPlain => 'تم تسجيل الدخول · تقدمك محفوظ الآن في حسابك';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets ورقة جديدة',
      many: '$sheets ورقة جديدة',
      few: '$sheets أوراق جديدة',
      two: 'ورقتان جديدتان',
      one: 'ورقة جديدة واحدة',
      zero: 'تم تحديث التقدم',
    );
    return 'تمت المزامنة من جهازك الآخر · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'تعذّر تحميل تقدمك المحفوظ بعد · ستتم المزامنة تلقائيًا عند عودة الاتصال';

  @override
  String get signedInOffline =>
      'تم تسجيل الدخول · ستتم مزامنة تقدمك عند عودتك إلى الإنترنت';

  @override
  String get proActivated =>
      'Pro مُفعّل · بلا إعلانات، وكل السمات، وتلميحات غير محدودة';

  @override
  String get accountDeletedToast => 'تم حذف حسابك وكل بياناته.';

  @override
  String accountDeletedProToast(String store) {
    return 'تم حذف الحساب. سيستمر احتساب رسوم Pro حتى تلغيه في $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'سلسلة $days يوم · +$coins مكافأة';
  }

  @override
  String get workshopRecord => 'سجل الورشة';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'سجل الورشة · $earned/$total';
  }

  @override
  String get recordCaption => 'المحطات';

  @override
  String recordEarned(int earned, int total) {
    return '$earned من $total مُكتسبة';
  }

  @override
  String get badgeEarnedLabel => 'مُكتسبة';

  @override
  String badgeEarnedToast(String name) {
    return 'شارة جديدة · $name';
  }

  @override
  String get badgeFirstTurn => 'الدورة الأولى';

  @override
  String get badgeApprentice => 'متدرّب';

  @override
  String get badgeJourneyman => 'عامل ماهر';

  @override
  String get badgeCraftsman => 'حِرَفي';

  @override
  String get badgeChiefEngineer => 'كبير المهندسين';

  @override
  String get badgeCleanWork => 'عمل نظيف';

  @override
  String get badgePerfectionist => 'مُتقِن';

  @override
  String get badgeRegular => 'مواظب';

  @override
  String get badgeOnARoll => 'في أوج التألق';

  @override
  String get badgeFullWeek => 'أسبوع كامل';

  @override
  String get badgeFortnight => 'أسبوعان';

  @override
  String get badgeFirstDetail => 'أنجز ورقتك الأولى';

  @override
  String badgeClearDetail(int n) {
    return 'أنجز $n ورقة';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'أنهِ الفصل $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'احصل على ◆ في $n ورقة';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'العب $n ورقة يومية';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'حقق سلسلة $n يوم';
  }

  @override
  String get share => 'مشاركة';

  @override
  String get shareResult => 'شارك النتيجة';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves حركة',
      many: '$moves حركة',
      few: '$moves حركات',
      two: 'حركتان',
      one: 'حركة واحدة',
      zero: '0 حركة',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'سلسلة $days يوم';
  }

  @override
  String get signOutSheetTitle => 'تسجيل الخروج؟';

  @override
  String get signOutSheetBody =>
      'تسجيل الخروج يمسح تقدمك من هذا الجهاز. كل ما حُفظ احتياطيًا يعود عند تسجيل الدخول مجددًا، لكن ما لم تتم مزامنته بعد (مثل الأوراق التي لُعبت دون اتصال) سيضيع.';

  @override
  String get staySignedIn => 'البقاء مسجّلًا';

  @override
  String get signOutConfirm => 'تسجيل الخروج';

  @override
  String get rateApp => 'قيّم Screw Out';

  @override
  String get sendFeedback => 'أرسل ملاحظاتك';

  @override
  String get replayTutorial => 'أعد الشرح';

  @override
  String feedbackNoEmailApp(String email) {
    return 'لا يوجد تطبيق بريد. راسلنا على $email';
  }

  @override
  String get updateChip => 'تحديث';

  @override
  String get updateReadyRestart => 'تم تنزيل التحديث. أعد التشغيل لتثبيته.';

  @override
  String get deleteSheetTitle => 'حذف حسابك؟';

  @override
  String get deleteSheetBody =>
      'سيؤدي هذا إلى حذف حسابك نهائيًا وكل ما حُفظ معه: تقدمك في كل ورقة، والعملات، والسمات، وسلسلتك اليومية، ومراكزك في لوحات الصدارة. لا يمكن التراجع عن ذلك.';

  @override
  String deleteSheetPro(String store) {
    return 'لديك اشتراك Screw Out Pro. حذف حسابك لا يلغيه: ألغِ الاشتراك في $store وإلا ستستمر الرسوم.';
  }

  @override
  String get manageSubscription => 'إدارة الاشتراك';

  @override
  String get deleteForever => 'احذف حسابي';

  @override
  String get deleting => 'جارٍ الحذف…';

  @override
  String get keepAccount => 'أبقِ حسابي';

  @override
  String get deleteOffline => 'أنت غير متصل. اتصل بالإنترنت لحذف حسابك.';

  @override
  String get deleteFailed => 'تعذّر حذف حسابك. حاول مرة أخرى.';

  @override
  String get restoreNothing => 'لا يوجد ما يُستعاد في هذا الحساب.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 تلميح';
  }

  @override
  String get hintEarnedToast => '+1 تلميح · شكرًا على المشاهدة';

  @override
  String get rescueToast => '+1 خانة في الصينية لهذه الورقة';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 خانة';
  }

  @override
  String get adNotCompleted => 'لم يكتمل الفيديو، فلا مكافأة هذه المرة.';

  @override
  String themeEquippedToast(String name) {
    return 'تم استخدام $name';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'الفصل $chapter جاهز';
  }

  @override
  String get signInFailed => 'لم يكتمل تسجيل الدخول.';

  @override
  String get themePurchased => 'تم فتح السمة.';

  @override
  String themeBuyStore(String price) {
    return 'أو اشترِ · $price';
  }

  @override
  String get themesBundleTitle => 'كل السمات';

  @override
  String get themesBundleBody =>
      'كل السمات المدفوعة، ملكك للأبد. وPro يتضمنها أيضًا.';

  @override
  String themesBundleBuy(String price) {
    return 'شراء · $price';
  }

  @override
  String get dailyWeekDone => 'تم';

  @override
  String masteredCount(int count) {
    return '$count مُتقنة';
  }

  @override
  String get reminderTitle => 'ورقة اليوم جاهزة';

  @override
  String get reminderBody => 'رسم جديد واحد، هو نفسه للجميع. بلا مؤقت.';

  @override
  String get comebackReminderTitle => 'ورقتك التالية على طاولة العمل';

  @override
  String get comebackReminderBody =>
      'دقائق هادئة وبضعة براغٍ. تابع من حيث توقفت.';

  @override
  String get signInEmail => 'المتابعة بالبريد الإلكتروني';

  @override
  String get emailSignInTitle => 'تسجيل الدخول';

  @override
  String get emailCreateTitle => 'إنشاء حساب';

  @override
  String get emailTabSignIn => 'تسجيل الدخول';

  @override
  String get emailTabCreate => 'إنشاء حساب';

  @override
  String get emailSheetBody => 'تقدمك على هذا الجهاز ينتقل معك.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String passwordHint(int min) {
    return '$min أحرف على الأقل';
  }

  @override
  String get emailRequired => 'أدخل بريدك الإلكتروني.';

  @override
  String get emailInvalid => 'يبدو أن عنوان البريد غير صحيح.';

  @override
  String get passwordRequired => 'أدخل كلمة المرور.';

  @override
  String passwordTooShort(int min) {
    return 'استخدم $min أحرف على الأقل.';
  }

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get forgotNeedsEmail =>
      'أدخل بريدك الإلكتروني في الأعلى، ثم اضغط «نسيت كلمة المرور؟».';

  @override
  String resetSent(String email) {
    return 'إذا كان لـ $email حساب، فرابط إعادة التعيين في الطريق.';
  }

  @override
  String get emailWorking => 'لحظة…';

  @override
  String get authErrWrongCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrEmailInUse =>
      'هذا البريد لديه حساب بالفعل. سجّل الدخول بدلًا من ذلك.';

  @override
  String get authErrWeakPassword => 'اختر كلمة مرور أقوى.';

  @override
  String get authErrDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get authErrNotEnabled => 'تسجيل الدخول بالبريد غير متاح الآن.';

  @override
  String get authErrTooMany =>
      'محاولات كثيرة جدًا. انتظر قليلًا ثم حاول مجددًا.';

  @override
  String get authErrNetwork => 'لا يوجد اتصال. تحقق من الإنترنت وحاول مجددًا.';

  @override
  String get authErrGeneric => 'تعذّر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get deletePasswordBody => 'أدخل كلمة المرور لتأكيد هويتك.';

  @override
  String get deleteWrongPassword => 'كلمة المرور لا تطابق هذا الحساب.';

  @override
  String get purchaseSaveTitle => 'احتفظ بمشترياتك';

  @override
  String get purchaseSaveBody =>
      'اختياري: سجّل الدخول للاحتفاظ بمشترياتك وتقدمك على كل أجهزتك. مشترياتك تعمل بالفعل على هذا الجهاز.';

  @override
  String get purchaseNeedsConnection =>
      'تعذّر الوصول إلى الخادم. تحقق من اتصالك وحاول مجددًا.';

  @override
  String get languageSystemDefault => 'لغة النظام';

  @override
  String get startupFailed =>
      'حدث خطأ أثناء التشغيل.\nأغلق التطبيق وافتحه مرة أخرى.';

  @override
  String get notificationChannelDescription =>
      'تذكيرات الورقة اليومية وإشعارات الحساب';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'برغي، اللوح $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'برغي، اللوح $plate، يحجبه $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled من $total';
  }

  @override
  String get chapterName1 => 'أساسيات الورشة';

  @override
  String get chapterName2 => 'طبقة تلو طبقة';

  @override
  String get chapterName3 => 'أفسح المجال';

  @override
  String get chapterName4 => 'التشابك';

  @override
  String get chapterName5 => 'البنّاء الماهر';

  @override
  String get chapterGoal1 => 'اضغط، فُك، حرّر';

  @override
  String get chapterGoal2 => 'التداخل وترتيب الكشف';

  @override
  String get chapterGoal3 => 'خطط حول صينية ضيقة';

  @override
  String get chapterGoal4 => 'دعامات مشتركة';

  @override
  String get chapterGoal5 => 'كل شيء، بإنصاف';

  @override
  String get chapterPitch1 => 'اضغط برغيًا. أسقط لوحًا. هذه هي القاعدة كلها.';

  @override
  String get chapterPitch2 => 'ألواح تخفي ألواحًا. ابدأ من الأعلى إلى الأسفل.';

  @override
  String get chapterPitch3 => 'صوانٍ أضيق. خطط أي البراغي تفك أولًا.';

  @override
  String get chapterPitch4 => 'لوح واحد يثبّت عدة ألواح. جد القطعة المفتاح.';

  @override
  String get chapterPitch5 => 'أكوام عميقة، وكل الأفكار معًا. خذ وقتك.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'مجموعة الرسومات $number';
  }

  @override
  String get chapterGoalDownloaded => 'أوراق بمستوى الخبراء';

  @override
  String get chapterPitchDownloaded => 'أوراق أكثر، والقواعد العادلة نفسها.';

  @override
  String get mechanicOverlap => 'التداخل';

  @override
  String get mechanicTray => 'الصينية';

  @override
  String get mechanicLayers => 'الطبقات';

  @override
  String get mechanicCircles => 'الدوائر';

  @override
  String get mechanicTraps => 'الفخاخ';

  @override
  String get mechanicSupports => 'الدعامات';

  @override
  String get sheetObjective004 => 'ارفع اللوح العلوي لتصل إلى البرغي تحته';

  @override
  String get sheetObjective006 =>
      'الصينية تتسع لـ 3. اللوح المُحرَّر يُفرغ خاناته';

  @override
  String get sheetObjective011 => 'ثلاث طبقات. ابدأ من الأعلى إلى الأسفل';

  @override
  String get sheetObjective012 => 'ارفع PL-04 قبل الألواح التي تحته';

  @override
  String get sheetObjective017 => 'حركة واحدة مغرية تملأ الصينية';

  @override
  String get sheetObjective021 => 'الألواح المستديرة تغطي كغيرها';

  @override
  String get sheetObjective024 => 'أزل PL-04 لتصل إلى الزاوية';

  @override
  String get sheetObjective041 => 'صينية ضيقة. حرّر لوحًا قبل أن تمتلئ';

  @override
  String get sheetObjective061 => 'لوح واحد قد يثبّت عدة ألواح أخرى';

  @override
  String get sheetObjective081 => 'كل ما تعلمته. خذ وقتك';

  @override
  String get themeNameBlueprint => 'المخطط النظيف';

  @override
  String get themeNameWalnut => 'ورشة الجوز';

  @override
  String get themeNameOcean => 'فيروزي المحيط';

  @override
  String get themeNameCopper => 'النحاس الدافئ';

  @override
  String get themeNameMidnight => 'ورشة منتصف الليل';

  @override
  String get themeNamePastel => 'استوديو الباستيل';

  @override
  String sheetTitleNumbered(int number) {
    return 'الورقة $number';
  }

  @override
  String get sheetTitle001 => 'الدورة الأولى';

  @override
  String get sheetTitle002 => 'تثبيت بنقطتين';

  @override
  String get sheetTitle003 => 'جنبًا إلى جنب';

  @override
  String get sheetTitle004 => 'لوح الغطاء';

  @override
  String get sheetTitle005 => 'كشف';

  @override
  String get sheetTitle006 => 'يوم الصينية';

  @override
  String get sheetTitle007 => 'خطة صغيرة';

  @override
  String get sheetTitle008 => 'تركيب محكم';

  @override
  String get sheetTitle009 => 'قضبان مستديرة';

  @override
  String get sheetTitle010 => 'نقطة تفتيش';

  @override
  String get sheetTitle011 => 'الطبقة الثالثة';

  @override
  String get sheetTitle012 => 'دعامة متقاطعة';

  @override
  String get sheetTitle013 => 'أفرغ خانة';

  @override
  String get sheetTitle014 => 'خطوتان للأمام';

  @override
  String get sheetTitle015 => 'فولاذ مطلي';

  @override
  String get sheetTitle016 => 'طاولة العمل';

  @override
  String get sheetTitle017 => 'إغراء';

  @override
  String get sheetTitle018 => 'تتابع';

  @override
  String get sheetTitle019 => 'خليط الورشة';

  @override
  String get sheetTitle020 => 'التجميع';

  @override
  String get sheetTitle021 => 'كومة الحلقات';

  @override
  String get sheetTitle022 => 'الحشية';

  @override
  String get sheetTitle023 => 'غطاء العدسة';

  @override
  String get sheetTitle024 => 'الكتيفة المخفية';

  @override
  String get sheetTitle025 => 'طقم الرقائق';

  @override
  String get sheetTitle026 => 'الإطار';

  @override
  String get sheetTitle027 => 'الحلقة المطاطية';

  @override
  String get sheetTitle028 => 'استراحة';

  @override
  String get sheetTitle029 => 'حلقة الشفة';

  @override
  String get sheetTitle030 => 'الكوّة';

  @override
  String get sheetTitle031 => 'الفاصل';

  @override
  String get sheetTitle032 => 'الطوق';

  @override
  String get sheetTitle033 => 'الغطاء الطرفي';

  @override
  String get sheetTitle034 => 'وردية هادئة';

  @override
  String get sheetTitle035 => 'الحاجز';

  @override
  String get sheetTitle036 => 'فتحة الفحص';

  @override
  String get sheetTitle037 => 'اللوحة الأمامية';

  @override
  String get sheetTitle038 => 'مهمة خفيفة';

  @override
  String get sheetTitle039 => 'الوردة';

  @override
  String get sheetTitle040 => 'كعكة الطبقات';

  @override
  String get sheetTitle041 => 'أفسح المجال';

  @override
  String get sheetTitle042 => 'مساحة الصندوق';

  @override
  String get sheetTitle043 => 'فيض';

  @override
  String get sheetTitle044 => 'الرف الصغير';

  @override
  String get sheetTitle045 => 'صندوق القطع';

  @override
  String get sheetTitle046 => 'مخزون قليل';

  @override
  String get sheetTitle047 => 'الخانات';

  @override
  String get sheetTitle048 => 'مخرج سهل';

  @override
  String get sheetTitle049 => 'آلة الخانات';

  @override
  String get sheetTitle050 => 'امتلاء تام';

  @override
  String get sheetTitle051 => 'أعمال متراكمة';

  @override
  String get sheetTitle052 => 'خانة احتياطية';

  @override
  String get sheetTitle053 => 'الخلوص';

  @override
  String get sheetTitle054 => 'تركيب فضفاض';

  @override
  String get sheetTitle055 => 'الجرد';

  @override
  String get sheetTitle056 => 'السماحية';

  @override
  String get sheetTitle057 => 'التفاوت';

  @override
  String get sheetTitle058 => 'يوم عطلة';

  @override
  String get sheetTitle059 => 'متسع علوي';

  @override
  String get sheetTitle060 => 'التخزين';

  @override
  String get sheetTitle061 => 'تعشيق';

  @override
  String get sheetTitle062 => 'لوح التقوية';

  @override
  String get sheetTitle063 => 'حجر العقد';

  @override
  String get sheetTitle064 => 'وصلة تراكبية';

  @override
  String get sheetTitle065 => 'لوح الوصل';

  @override
  String get sheetTitle066 => 'ذيل الحمامة';

  @override
  String get sheetTitle067 => 'العتبة العلوية';

  @override
  String get sheetTitle068 => 'قصاصة';

  @override
  String get sheetTitle069 => 'الدعامة';

  @override
  String get sheetTitle070 => 'الجملون';

  @override
  String get sheetTitle071 => 'الشوكة';

  @override
  String get sheetTitle072 => 'النير';

  @override
  String get sheetTitle073 => 'السرج';

  @override
  String get sheetTitle074 => 'الأساس';

  @override
  String get sheetTitle075 => 'زوج كتائف';

  @override
  String get sheetTitle076 => 'قضيب التثبيت';

  @override
  String get sheetTitle077 => 'لوح الربط';

  @override
  String get sheetTitle078 => 'لوح بسيط';

  @override
  String get sheetTitle079 => 'الكابولي';

  @override
  String get sheetTitle080 => 'إطار صلب';

  @override
  String get sheetTitle081 => 'الخطة الكبرى';

  @override
  String get sheetTitle082 => 'تجميع فرعي';

  @override
  String get sheetTitle083 => 'منظر مفكك';

  @override
  String get sheetTitle084 => 'فحص التركيب';

  @override
  String get sheetTitle085 => 'مواصفة العزم';

  @override
  String get sheetTitle086 => 'قالب التوجيه';

  @override
  String get sheetTitle087 => 'المثبّت';

  @override
  String get sheetTitle088 => 'طاولة هادئة';

  @override
  String get sheetTitle089 => 'علبة التروس';

  @override
  String get sheetTitle090 => 'الغلاف';

  @override
  String get sheetTitle091 => 'الشاسيه';

  @override
  String get sheetTitle092 => 'حجرة الألواح';

  @override
  String get sheetTitle093 => 'طقم الأغطية';

  @override
  String get sheetTitle094 => 'عزم سهل';

  @override
  String get sheetTitle095 => 'قاعدة المحرك';

  @override
  String get sheetTitle096 => 'لوحة المفاتيح';

  @override
  String get sheetTitle097 => 'صندوق التحكم';

  @override
  String get sheetTitle098 => 'طاولة الرسم';

  @override
  String get sheetTitle099 => 'الفحص النهائي';

  @override
  String get sheetTitle100 => 'التوقيع النهائي';
}
