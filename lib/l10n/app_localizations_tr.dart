// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Duraklat';

  @override
  String get back => 'Geri';

  @override
  String get settings => 'Ayarlar';

  @override
  String get tray => 'TEPSİ';

  @override
  String get trayFull => 'TEPSİ DOLU';

  @override
  String get undo => 'GERİ AL';

  @override
  String hintCount(String count) {
    return 'İPUCU · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Duraklatıldı';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · HAMLE $moves';
  }

  @override
  String get resume => 'Devam et';

  @override
  String get sound => 'SES';

  @override
  String get haptics => 'TİTREŞİM';

  @override
  String get reducedMotion => 'AZALTILMIŞ HAREKET';

  @override
  String get restart => 'BAŞTAN AL';

  @override
  String get exitToSheets => 'SAYFALARA DÖN';

  @override
  String get restartConfirmTitle => 'Bu sayfa baştan başlasın mı?';

  @override
  String restartConfirmBody(int moves) {
    return '$moves hamlelik ilerlemen kaybolacak.';
  }

  @override
  String get cancel => 'VAZGEÇ';

  @override
  String get stuckTitle => 'Boş yuva kalmadı.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vidayı',
      one: 'bir vidayı',
    );
    return '$plate tahtada hâlâ $_temp0 tutuyor. Geri almak bir yuva açar.';
  }

  @override
  String get stuckReasonGeneric =>
      'Tüm yuvalar dolu ve hiçbir plaka düşemiyor. Geri almak bir yuva açar.';

  @override
  String get undoLastMove => 'Son hamleyi geri al';

  @override
  String rescueSlotCoins(int coins) {
    return 'EK YUVA · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'EK YUVA · VİDEO';

  @override
  String get rescueSlotPro => 'EK YUVA · PRO';

  @override
  String get outOfHintsTitle => 'Bir ipucu daha ister misin?';

  @override
  String get hintsLeftZero => 'İPUCU · 0 KALDI';

  @override
  String get outOfHintsBody =>
      'İpucu işe yarayacak bir sonraki vidayı halkayla işaretler. Sayfayı asla senin yerine çözmez.';

  @override
  String get watchVideo => 'Kısa bir video izle';

  @override
  String get watchVideoMeta => 'İSTEĞE BAĞLI · ~30 SN · +1 İPUCU';

  @override
  String useCoins(int coins) {
    return '$coins altın kullan';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'BAKİYE $balance ¢';
  }

  @override
  String get keepThinking => 'Düşünmeye devam';

  @override
  String get notEnoughCoins => 'Henüz yeterli altının yok.';

  @override
  String get adUnavailable => 'Şu anda video yok.';

  @override
  String cleared(String code) {
    return '$code · TAMAMLANDI';
  }

  @override
  String get disassembled => 'Söküldü.';

  @override
  String get approved => 'ONAYLANDI';

  @override
  String get statMoves => 'HAMLE';

  @override
  String get statTime => 'SÜRE';

  @override
  String get statMastery => 'USTALIK';

  @override
  String nextSheet(String code) {
    return 'Sonraki sayfa · $code';
  }

  @override
  String get replay => 'TEKRAR';

  @override
  String get sheets => 'SAYFALAR';

  @override
  String get backHome => 'Ana ekrana dön';

  @override
  String chapterComplete(String chapter) {
    return 'BÖLÜM $chapter · TAMAMLANDI';
  }

  @override
  String get themeUnlocked => 'TEMA AÇILDI';

  @override
  String nextChapter(String chapter) {
    return 'SIRADAKİ · BÖLÜM $chapter';
  }

  @override
  String startChapter(String chapter) {
    return '$chapter. bölüme başla';
  }

  @override
  String equipTheme(String name) {
    return 'KULLAN: $name';
  }

  @override
  String get tutorialStep1 => 'ADIM 1 · VİDAYA DOKUN';

  @override
  String get tutorialLands => '↓ TEPSİYE DÜŞER';

  @override
  String get skipTutorial => 'EĞİTİMİ GEÇ';

  @override
  String get splashTagline => 'KATMANLARIN BULMACASI';

  @override
  String get splashFooter => 'REV 1.0 · SAYFA 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLAKA',
      one: '1 PLAKA',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'VİDA',
      one: 'VİDA',
    );
    return 'ŞEKİL 1\nPATLATILMIŞ GÖRÜNÜŞ\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'BÖLÜM $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'VİDA',
      one: 'VİDA',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'SONRAKİ SAYFA';

  @override
  String chapterLabel(String chapter) {
    return 'BÖLÜM $chapter';
  }

  @override
  String get campaign => 'KAMPANYA';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Devam · $code';
  }

  @override
  String get daily => 'GÜNLÜK';

  @override
  String get themes => 'TEMALAR';

  @override
  String get allCleared => 'Tüm sayfalar bitti';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total SAYFA';
  }

  @override
  String get fiveChapters => 'Beş bölüm';

  @override
  String get chaptersTitle => 'Bölümler';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'KİLİTLİ';

  @override
  String get downloadChapter => 'İNDİR';

  @override
  String get downloading => 'İNDİRİLİYOR…';

  @override
  String get comingSoon => 'YENİ SAYFALAR YAKINDA';

  @override
  String newMechanic(String mechanic) {
    return 'YENİ: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates plaka',
      one: '1 plaka',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers katman',
      one: '1 katman',
    );
    return '$_temp0 · $_temp1 · tepsi $tray';
  }

  @override
  String get theCampaign => 'KAMPANYA';

  @override
  String get campaignFooter =>
      'Bölümler, bir öncekini bitirince açılır. Ustalık işaretleri isteğe bağlıdır. İpuçları ilerlemeyi asla engellemez.';

  @override
  String get chapterBonus => 'BÖLÜM BONUSU';

  @override
  String get dailySheet => 'GÜNLÜK SAYFA';

  @override
  String get dailyTitle => 'BAŞLIK';

  @override
  String get dailyPlates => 'PLAKA';

  @override
  String get dailyReward => 'ÖDÜL';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak günlük seri.',
      one: '1 günlük seri.',
      zero: 'Bir seri başlat.',
    );
    return 'Bugün herkes için aynı sayfa. Süre yok. $_temp0 Bir günü kaçırmanın bedeli yok.';
  }

  @override
  String get startDaily => 'Bugünün sayfasına başla';

  @override
  String get dailyCompleted => 'Bugünlük bitti · yarın görüşürüz';

  @override
  String get replayDaily => 'Bugünkü sayfayı tekrarla';

  @override
  String get themesTitle => 'Temalar';

  @override
  String get themesCaption => 'SADECE GÖRÜNÜM · KURALLAR DEĞİŞMEZ';

  @override
  String get equipped => 'SEÇİLİ';

  @override
  String get owned => 'SENİN';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'ÖNİZLEME';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get feedbackSection => 'SES VE TİTREŞİM';

  @override
  String get soundEffects => 'Ses efektleri';

  @override
  String get music => 'Müzik';

  @override
  String get hapticsRow => 'Titreşim';

  @override
  String get reducedMotionRow => 'Azaltılmış hareket';

  @override
  String get reducedMotionCaption => 'Kaymak yerine solarak geçiş';

  @override
  String get generalSection => 'GENEL';

  @override
  String get highRefreshRate => 'Yüksek yenileme hızı';

  @override
  String highRefreshRateOn(int hz) {
    return 'Daha akıcı · $hz Hz\'e kadar · daha çok pil harcar';
  }

  @override
  String get highRefreshRateOff => 'Daha akıcı · daha çok pil harcar';

  @override
  String get highRefreshRateUnsupported => 'Bu ekran tek bir hızda çalışır';

  @override
  String get highRefreshRateBattery => 'Şu an pil tasarrufu nedeniyle sınırlı';

  @override
  String get highRefreshRateHeat => 'Telefon ısınmışken sınırlı';

  @override
  String highRefreshRateNow(int hz) {
    return 'Şu an $hz Hz';
  }

  @override
  String get language => 'Dil';

  @override
  String get notifications => 'Günlük hatırlatma';

  @override
  String get notificationsCaption =>
      'Yeni sayfa hazır olunca tek bir hatırlatma';

  @override
  String get accountSection => 'HESAP';

  @override
  String get signInGoogle => 'Google ile oturum açın';

  @override
  String get signInApple => 'Apple ile Giriş Yap';

  @override
  String signedInAs(String name) {
    return 'Giriş yapıldı · $name';
  }

  @override
  String get guestCaption =>
      'MİSAFİR OLARAK OYNUYORSUN · İLERLEMENİ KAYDETMEK İÇİN GİRİŞ YAP';

  @override
  String get signOut => 'ÇIKIŞ YAP';

  @override
  String get deleteAccount => 'HESABI SİL';

  @override
  String get purchasesSection => 'SATIN ALIMLAR';

  @override
  String get removeAds => 'Reklamları kaldır';

  @override
  String get restore => 'GERİ YÜKLE';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'REKLAMSIZ · SINIRSIZ İPUCU · TÜM TEMALAR · ÜCRETSİZ KURTARMA · AYLIK $coins ¢';
  }

  @override
  String get proMonthly => 'AYLIK';

  @override
  String get proYearly => 'YILLIK';

  @override
  String proTrialDays(int days) {
    return '$days GÜN ÜCRETSİZ';
  }

  @override
  String proThenPrice(String price) {
    return 'SONRA $price';
  }

  @override
  String get proTrialTerms =>
      'İptal etmezsen ücretsiz denemenin ardından otomatik olarak yenilenir. Aylık altınlar ilk ödemenle başlar.';

  @override
  String get proActive => 'PRO · ETKİN';

  @override
  String get adsRemoved => 'REKLAMLAR KALDIRILDI';

  @override
  String get coinPacks => 'ALTIN PAKETLERİ';

  @override
  String get aboutSection => 'HAKKINDA';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get termsOfUse => 'Kullanım koşulları';

  @override
  String get refundPolicy => 'İade politikası';

  @override
  String get privacyChoices => 'Gizlilik tercihleri';

  @override
  String get licenses => 'Lisanslar ve emeği geçenler';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Günlük sayfa için hatırlatma?';

  @override
  String get notificationPrimerBody =>
      'Oynamadığın günlerde sessiz bir hatırlatma. Günde birden fazla asla.';

  @override
  String get allow => 'İZİN VER';

  @override
  String get notNow => 'ŞİMDİ DEĞİL';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti.';

  @override
  String get purchaseThanks => 'Teşekkürler! Satın alım uygulandı.';

  @override
  String get purchasePending => 'Satın alım bekliyor. Onaylanınca uygulanacak.';

  @override
  String get purchaseFailed => 'Satın alım tamamlanmadı.';

  @override
  String get restored => 'Satın alımlar geri yüklendi.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Önce $chapter. bölümü bitir.';
  }

  @override
  String get moreSheetsTitle => 'Daha fazla sayfa';

  @override
  String get moreSheetsCaption => 'Yeni çizim setleri burada çıkar';

  @override
  String get equip => 'KULLAN';

  @override
  String buyFor(int coins) {
    return 'SATIN AL · $coins ¢';
  }

  @override
  String get close => 'KAPAT';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Lisanslar';

  @override
  String get licensesCaption => 'AÇIK KAYNAK BİLDİRİMLERİ';

  @override
  String playLevel(String code) {
    return '$code oyna';
  }

  @override
  String lockedLevel(int number) {
    return 'Sayfa $number, kilitli';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Liderlik tabloları';

  @override
  String get leaderboardCaption => 'GİRİŞ YAPAN OYUNCULAR · CANLI';

  @override
  String get boardSheets => 'SAYFA';

  @override
  String get boardDaily => 'GÜNLÜK';

  @override
  String get boardStreak => 'SERİ';

  @override
  String get boardWeekly => 'HAFTA';

  @override
  String get boardWeeklyHint =>
      'BU HAFTA BİTEN SAYFALAR · PAZARTESİ SIFIRLANIR';

  @override
  String get boardSheetsHint => 'EN ÇOK BİTİRİLEN SAYFA';

  @override
  String get boardDailyHint => 'BUGÜNÜN SAYFASI · EN AZ HAMLE, SONRA EN HIZLI';

  @override
  String get boardStreakHint => 'GÜNLÜK SAYFADA ART ARDA GÜN';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'HAMLE',
      one: 'HAMLE',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'GÜN',
      one: 'GÜN',
    );
    return '$_temp0 · EN İYİ $best';
  }

  @override
  String get boardYou => 'SEN';

  @override
  String get boardYourRank => 'SIRAN';

  @override
  String get boardNotRanked => 'Henüz sıralamada değilsin';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '/ $countString';
  }

  @override
  String get boardGuest =>
      'Adını tabloya yazdırmak için giriş yap. İlerlemen de seninle gelir.';

  @override
  String get boardEmpty => 'Henüz kimse yok. İlk sen ol.';

  @override
  String get boardOffline => 'Liderlik tablosuna şu an ulaşılamıyor.';

  @override
  String get tryAgainCaps => 'TEKRAR DENE';

  @override
  String get todaysBoard => 'BUGÜNÜN TABLOSU';

  @override
  String get signedOutToast =>
      'Çıkış yapıldı · bu cihaz temizlendi. İlerlemeni geri almak için tekrar giriş yap.';

  @override
  String get welcomeBack => 'Tekrar hoş geldin';

  @override
  String welcomeBackName(String name) {
    return 'Tekrar hoş geldin, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets sayfa',
      one: '1 sayfa',
    );
    return '$who · $_temp0 ve $coins altın geri yüklendi';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · giriş yaptın ve ilerlemen yedekleniyor';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets sayfa',
      one: '1 sayfa',
    );
    return '$who · bu cihazdaki ilerleme hesabına eklendi: $_temp0, $coins altın';
  }

  @override
  String syncSavedNew(String name) {
    return '$name olarak giriş yapıldı · ilerlemen artık hesabına kaydediliyor';
  }

  @override
  String get syncSavedNewPlain =>
      'Giriş yapıldı · ilerlemen artık hesabına kaydediliyor';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets yeni sayfa',
      one: '1 yeni sayfa',
      zero: 'ilerleme güncellendi',
    );
    return 'Diğer cihazından senkronize edildi · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Kayıtlı ilerlemen henüz yüklenemedi · bağlantı gelince otomatik olarak senkronize olacak';

  @override
  String get signedInOffline =>
      'Giriş yapıldı · çevrimiçi olunca ilerlemen senkronize olacak';

  @override
  String get proActivated =>
      'Pro etkin · reklam yok, tüm temalar ve sınırsız ipucu';

  @override
  String get accountDeletedToast => 'Hesabın ve tüm verileri silindi.';

  @override
  String accountDeletedProToast(String store) {
    return 'Hesap silindi. Pro, $store üzerinden iptal edene kadar ücretlendirilmeye devam eder.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days GÜNLÜK SERİ · +$coins BONUS';
  }

  @override
  String get workshopRecord => 'Atölye kaydı';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Atölye kaydı · $earned/$total';
  }

  @override
  String get recordCaption => 'KİLOMETRE TAŞLARI';

  @override
  String recordEarned(int earned, int total) {
    return '$earned / $total KAZANILDI';
  }

  @override
  String get badgeEarnedLabel => 'KAZANILDI';

  @override
  String badgeEarnedToast(String name) {
    return 'Rozet kazanıldı · $name';
  }

  @override
  String get badgeFirstTurn => 'İlk Tur';

  @override
  String get badgeApprentice => 'Çırak';

  @override
  String get badgeJourneyman => 'Kalfa';

  @override
  String get badgeCraftsman => 'Usta';

  @override
  String get badgeChiefEngineer => 'Baş Mühendis';

  @override
  String get badgeCleanWork => 'Temiz İş';

  @override
  String get badgePerfectionist => 'Mükemmeliyetçi';

  @override
  String get badgeRegular => 'Müdavim';

  @override
  String get badgeOnARoll => 'Ritim Tuttu';

  @override
  String get badgeFullWeek => 'Tam Hafta';

  @override
  String get badgeFortnight => 'İki Hafta';

  @override
  String get badgeFirstDetail => 'İlk sayfanı bitir';

  @override
  String badgeClearDetail(int n) {
    return '$n sayfa bitir';
  }

  @override
  String badgeChapterDetail(int n) {
    return '$n. bölümü bitir';
  }

  @override
  String badgeMasterDetail(int n) {
    return '$n sayfada ◆ kazan';
  }

  @override
  String badgeDailyDetail(int n) {
    return '$n günlük sayfa oyna';
  }

  @override
  String badgeStreakDetail(int n) {
    return '$n günlük seriye ulaş';
  }

  @override
  String get share => 'PAYLAŞ';

  @override
  String get shareResult => 'Sonucu paylaş';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves hamle',
      one: '1 hamle',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days günlük seri';
  }

  @override
  String get signOutSheetTitle => 'Çıkış yapılsın mı?';

  @override
  String get signOutSheetBody =>
      'Çıkış yapmak bu cihazdaki ilerlemeni siler. Yedeklenmiş her şey tekrar giriş yapınca geri gelir, ama henüz senkronize edilmemiş olanlar (örneğin çevrimdışı oynanan sayfalar) kaybolur.';

  @override
  String get staySignedIn => 'Oturumda kal';

  @override
  String get signOutConfirm => 'Çıkış yap';

  @override
  String get rateApp => 'Screw Out\'u puanla';

  @override
  String get sendFeedback => 'Geri bildirim gönder';

  @override
  String get replayTutorial => 'Eğitimi tekrar oyna';

  @override
  String feedbackNoEmailApp(String email) {
    return 'E-posta uygulaması bulunamadı. Bize $email adresinden yaz';
  }

  @override
  String get updateChip => 'GÜNCELLE';

  @override
  String get updateReadyRestart =>
      'Güncelleme indirildi. Yüklemek için yeniden başlat.';

  @override
  String get deleteSheetTitle => 'Hesabın silinsin mi?';

  @override
  String get deleteSheetBody =>
      'Bu işlem hesabını ve onunla kaydedilen her şeyi kalıcı olarak siler: tüm sayfalardaki ilerleme, altınlar, temalar, günlük serin ve liderlik sıraların. Geri alınamaz.';

  @override
  String deleteSheetPro(String store) {
    return 'Screw Out Pro aboneliğin var. Hesabını silmek aboneliği iptal etmez: aboneliği $store üzerinden iptal et, yoksa ücretlendirilmeye devam edersin.';
  }

  @override
  String get manageSubscription => 'Aboneliği yönet';

  @override
  String get deleteForever => 'Hesabımı sil';

  @override
  String get deleting => 'Siliniyor…';

  @override
  String get keepAccount => 'Hesabımı koru';

  @override
  String get deleteOffline =>
      'Çevrimdışısın. Hesabını silmek için internete bağlan.';

  @override
  String get deleteFailed => 'Hesabın silinemedi. Lütfen tekrar dene.';

  @override
  String get restoreNothing => 'Bu hesapta geri yüklenecek bir şey yok.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 ipucu';
  }

  @override
  String get hintEarnedToast => '+1 ipucu · izlediğin için teşekkürler';

  @override
  String get rescueToast => 'Bu sayfa için +1 tepsi yuvası';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 tepsi yuvası';
  }

  @override
  String get adNotCompleted => 'Video bitmedi, bu yüzden bu sefer ödül yok.';

  @override
  String themeEquippedToast(String name) {
    return '$name kullanılıyor';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return '$chapter. bölüm hazır';
  }

  @override
  String get signInFailed => 'Giriş tamamlanmadı.';

  @override
  String get themePurchased => 'Tema açıldı.';

  @override
  String themeBuyStore(String price) {
    return 'YA DA AL · $price';
  }

  @override
  String get themesBundleTitle => 'Tüm temalar';

  @override
  String get themesBundleBody =>
      'Tüm ücretli temalar, kalıcı olarak senin. Pro\'da da hepsi var.';

  @override
  String themesBundleBuy(String price) {
    return 'SATIN AL · $price';
  }

  @override
  String get dailyWeekDone => 'Tamam';

  @override
  String masteredCount(int count) {
    return '$count USTALIK';
  }

  @override
  String get reminderTitle => 'Bugünün sayfası hazır';

  @override
  String get reminderBody => 'Herkes için aynı, yepyeni bir çizim. Süre yok.';

  @override
  String get comebackReminderTitle => 'Sıradaki sayfan tezgâhta seni bekliyor';

  @override
  String get comebackReminderBody =>
      'Birkaç sakin dakika, birkaç vida. Kaldığın yerden devam et.';

  @override
  String get signInEmail => 'E-posta ile devam et';

  @override
  String get emailSignInTitle => 'Giriş yap';

  @override
  String get emailCreateTitle => 'Hesap oluştur';

  @override
  String get emailTabSignIn => 'GİRİŞ YAP';

  @override
  String get emailTabCreate => 'HESAP OLUŞTUR';

  @override
  String get emailSheetBody => 'Bu cihazdaki ilerlemen seninle gelir.';

  @override
  String get emailLabel => 'E-POSTA';

  @override
  String get passwordLabel => 'ŞİFRE';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String passwordHint(int min) {
    return 'En az $min karakter';
  }

  @override
  String get emailRequired => 'E-posta adresini gir.';

  @override
  String get emailInvalid => 'Bu e-posta adresi doğru görünmüyor.';

  @override
  String get passwordRequired => 'Şifreni gir.';

  @override
  String passwordTooShort(int min) {
    return 'En az $min karakter kullan.';
  }

  @override
  String get forgotPassword => 'Şifreni mi unuttun?';

  @override
  String get forgotNeedsEmail =>
      'Yukarıya e-postanı yaz, sonra Şifreni mi unuttun? bağlantısına dokun.';

  @override
  String resetSent(String email) {
    return '$email adresine ait bir hesap varsa sıfırlama bağlantısı yolda.';
  }

  @override
  String get emailWorking => 'Bir saniye…';

  @override
  String get authErrWrongCredentials => 'E-posta veya şifre yanlış.';

  @override
  String get authErrEmailInUse =>
      'Bu e-postanın zaten bir hesabı var. Bunun yerine giriş yap.';

  @override
  String get authErrWeakPassword => 'Daha güçlü bir şifre seç.';

  @override
  String get authErrDisabled => 'Bu hesap devre dışı bırakıldı.';

  @override
  String get authErrNotEnabled => 'E-posta ile giriş şu anda kullanılamıyor.';

  @override
  String get authErrTooMany => 'Çok fazla deneme. Biraz bekleyip tekrar dene.';

  @override
  String get authErrNetwork =>
      'Bağlantı yok. İnternetini kontrol edip tekrar dene.';

  @override
  String get authErrGeneric => 'Giriş yapılamadı. Lütfen tekrar dene.';

  @override
  String get deletePasswordBody => 'Sen olduğunu doğrulamak için şifreni gir.';

  @override
  String get deleteWrongPassword => 'Bu şifre bu hesapla eşleşmiyor.';

  @override
  String get purchaseSaveTitle => 'Satın alımını koru';

  @override
  String get purchaseSaveBody =>
      'İsteğe bağlı: satın alımlarını ve ilerlemeni tüm cihazlarında tutmak için giriş yap. Satın alımın bu cihazda zaten çalışıyor.';

  @override
  String get purchaseNeedsConnection =>
      'Sunucuya ulaşılamadı. Bağlantını kontrol edip tekrar dene.';

  @override
  String get languageSystemDefault => 'Sistem varsayılanı';

  @override
  String get startupFailed =>
      'BAŞLATILIRKEN BİR ŞEYLER TERS GİTTİ.\nUYGULAMAYI KAPATIP YENİDEN AÇ.';

  @override
  String get notificationChannelDescription =>
      'Günlük sayfa hatırlatmaları ve hesap bildirimleri';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Vida, plaka $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Vida, plaka $plate, $blocker tarafından engelleniyor';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled / $total';
  }

  @override
  String get chapterName1 => 'Atölye Temelleri';

  @override
  String get chapterName2 => 'Kat Kat';

  @override
  String get chapterName3 => 'Yer Aç';

  @override
  String get chapterName4 => 'İç İçe';

  @override
  String get chapterName5 => 'Usta Yapıcı';

  @override
  String get chapterGoal1 => 'Dokun, sök, kurtar';

  @override
  String get chapterGoal2 => 'Üst üste binme ve sıra';

  @override
  String get chapterGoal3 => 'Dar tepsiye göre planla';

  @override
  String get chapterGoal4 => 'Ortak destekler';

  @override
  String get chapterGoal5 => 'Hepsi bir arada, adil';

  @override
  String get chapterPitch1 =>
      'Bir vidaya dokun. Bir plakayı düşür. Kuralın hepsi bu.';

  @override
  String get chapterPitch2 =>
      'Plakalar plakaları gizler. Yukarıdan aşağı çalış.';

  @override
  String get chapterPitch3 =>
      'Daha dar tepsiler. Önce hangi vidaları sökeceğini planla.';

  @override
  String get chapterPitch4 => 'Bir plaka birkaçını tutar. Kilit parçayı bul.';

  @override
  String get chapterPitch5 =>
      'Derin yığınlar, tüm fikirler bir arada. Acele etme.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Çizim Seti $number';
  }

  @override
  String get chapterGoalDownloaded => 'Usta seviye sayfalar';

  @override
  String get chapterPitchDownloaded => 'Daha fazla sayfa, aynı adil kurallar.';

  @override
  String get mechanicOverlap => 'ÜST ÜSTE';

  @override
  String get mechanicTray => 'TEPSİ';

  @override
  String get mechanicLayers => 'KATMANLAR';

  @override
  String get mechanicCircles => 'DAİRELER';

  @override
  String get mechanicTraps => 'TUZAKLAR';

  @override
  String get mechanicSupports => 'DESTEKLER';

  @override
  String get sheetObjective004 =>
      'ALTTAKİ VİDAYA ULAŞMAK İÇİN ÜST PLAKAYI KALDIR';

  @override
  String get sheetObjective006 =>
      'TEPSİ 3 ALIR. KURTULAN PLAKA YUVALARINI BOŞALTIR';

  @override
  String get sheetObjective011 => 'ÜÇ KATMAN. YUKARIDAN AŞAĞI ÇALIŞ';

  @override
  String get sheetObjective012 => 'ALTTAKİLERDEN ÖNCE PL-04 PLAKASINI KALDIR';

  @override
  String get sheetObjective017 => 'CAZİP BİR HAMLE TEPSİYİ DOLDURUR';

  @override
  String get sheetObjective021 => 'YUVARLAK PLAKALAR DA DİĞERLERİ GİBİ ÖRTER';

  @override
  String get sheetObjective024 => 'KÖŞEYE ULAŞMAK İÇİN PL-04 PLAKASINI SÖK';

  @override
  String get sheetObjective041 => 'DAR TEPSİ. DOLMADAN BİR PLAKAYI KURTAR';

  @override
  String get sheetObjective061 => 'BİR PLAKA BİRÇOK PLAKAYI TUTABİLİR';

  @override
  String get sheetObjective081 => 'ÖĞRENDİĞİN HER ŞEY. ACELE ETME';

  @override
  String get themeNameBlueprint => 'Temiz Plan';

  @override
  String get themeNameWalnut => 'Ceviz Atölyesi';

  @override
  String get themeNameOcean => 'Okyanus Turkuazı';

  @override
  String get themeNameCopper => 'Sıcak Bakır';

  @override
  String get themeNameMidnight => 'Gece Atölyesi';

  @override
  String get themeNamePastel => 'Pastel Stüdyo';

  @override
  String sheetTitleNumbered(int number) {
    return 'Sayfa $number';
  }

  @override
  String get sheetTitle001 => 'İlk Tur';

  @override
  String get sheetTitle002 => 'İki Nokta';

  @override
  String get sheetTitle003 => 'Yan Yana';

  @override
  String get sheetTitle004 => 'Kapak Plakası';

  @override
  String get sheetTitle005 => 'Açılış';

  @override
  String get sheetTitle006 => 'Tepsi Günü';

  @override
  String get sheetTitle007 => 'Küçük Plan';

  @override
  String get sheetTitle008 => 'Sıkı Geçme';

  @override
  String get sheetTitle009 => 'Yuvarlak Çubuk';

  @override
  String get sheetTitle010 => 'Kontrol Noktası';

  @override
  String get sheetTitle011 => 'Üçüncü Katman';

  @override
  String get sheetTitle012 => 'Çapraz Destek';

  @override
  String get sheetTitle013 => 'Yuva Aç';

  @override
  String get sheetTitle014 => 'İki Hamle Önde';

  @override
  String get sheetTitle015 => 'Boyalı Çelik';

  @override
  String get sheetTitle016 => 'Tezgâh';

  @override
  String get sheetTitle017 => 'Cazip';

  @override
  String get sheetTitle018 => 'Şelale';

  @override
  String get sheetTitle019 => 'Atölye Karışımı';

  @override
  String get sheetTitle020 => 'Montaj';

  @override
  String get sheetTitle021 => 'Pul Yığını';

  @override
  String get sheetTitle022 => 'Conta';

  @override
  String get sheetTitle023 => 'Lens Kapağı';

  @override
  String get sheetTitle024 => 'Gizli Braket';

  @override
  String get sheetTitle025 => 'Ara Pul Seti';

  @override
  String get sheetTitle026 => 'Çerçeve';

  @override
  String get sheetTitle027 => 'Kuşgözü';

  @override
  String get sheetTitle028 => 'Nefes Molası';

  @override
  String get sheetTitle029 => 'Flanş Halkası';

  @override
  String get sheetTitle030 => 'Lomboz';

  @override
  String get sheetTitle031 => 'Ara Parça';

  @override
  String get sheetTitle032 => 'Bilezik';

  @override
  String get sheetTitle033 => 'Uç Kapağı';

  @override
  String get sheetTitle034 => 'Sessiz Vardiya';

  @override
  String get sheetTitle035 => 'Bölme';

  @override
  String get sheetTitle036 => 'Muayene Kapağı';

  @override
  String get sheetTitle037 => 'Ön Panel';

  @override
  String get sheetTitle038 => 'Hafif Mesai';

  @override
  String get sheetTitle039 => 'Rozet';

  @override
  String get sheetTitle040 => 'Kat Kat Pasta';

  @override
  String get sheetTitle041 => 'Yer Aç';

  @override
  String get sheetTitle042 => 'Kutuda Yer';

  @override
  String get sheetTitle043 => 'Taşma';

  @override
  String get sheetTitle044 => 'Dolap Gözü';

  @override
  String get sheetTitle045 => 'Parça Kutusu';

  @override
  String get sheetTitle046 => 'Az Malzeme';

  @override
  String get sheetTitle047 => 'Güvercinlik';

  @override
  String get sheetTitle048 => 'Kolay Çıkış';

  @override
  String get sheetTitle049 => 'Slot Makinesi';

  @override
  String get sheetTitle050 => 'Tam Kadro';

  @override
  String get sheetTitle051 => 'Birikmiş İş';

  @override
  String get sheetTitle052 => 'Yedek Yuva';

  @override
  String get sheetTitle053 => 'Boşluk';

  @override
  String get sheetTitle054 => 'Gevşek Geçme';

  @override
  String get sheetTitle055 => 'Envanter';

  @override
  String get sheetTitle056 => 'Pay';

  @override
  String get sheetTitle057 => 'Tolerans';

  @override
  String get sheetTitle058 => 'İzin Günü';

  @override
  String get sheetTitle059 => 'Tavan Payı';

  @override
  String get sheetTitle060 => 'Depo';

  @override
  String get sheetTitle061 => 'Kenetleme';

  @override
  String get sheetTitle062 => 'Köşebent';

  @override
  String get sheetTitle063 => 'Kilit Taşı';

  @override
  String get sheetTitle064 => 'Bindirme Ek';

  @override
  String get sheetTitle065 => 'Ek Plakası';

  @override
  String get sheetTitle066 => 'Kırlangıç Kuyruğu';

  @override
  String get sheetTitle067 => 'Lento';

  @override
  String get sheetTitle068 => 'Artık Parça';

  @override
  String get sheetTitle069 => 'Payanda';

  @override
  String get sheetTitle070 => 'Kafes Kiriş';

  @override
  String get sheetTitle071 => 'Çatal Mafsal';

  @override
  String get sheetTitle072 => 'Boyunduruk';

  @override
  String get sheetTitle073 => 'Semer';

  @override
  String get sheetTitle074 => 'Temel';

  @override
  String get sheetTitle075 => 'Braket Çifti';

  @override
  String get sheetTitle076 => 'Kelepçe Çubuğu';

  @override
  String get sheetTitle077 => 'Bağlantı Plakası';

  @override
  String get sheetTitle078 => 'Düz Panel';

  @override
  String get sheetTitle079 => 'Konsol';

  @override
  String get sheetTitle080 => 'Rijit Çerçeve';

  @override
  String get sheetTitle081 => 'Ana Plan';

  @override
  String get sheetTitle082 => 'Alt Montaj';

  @override
  String get sheetTitle083 => 'Patlatılmış Çizim';

  @override
  String get sheetTitle084 => 'Uyum Kontrolü';

  @override
  String get sheetTitle085 => 'Tork Değeri';

  @override
  String get sheetTitle086 => 'Mastar';

  @override
  String get sheetTitle087 => 'Fikstür';

  @override
  String get sheetTitle088 => 'Sakin Tezgâh';

  @override
  String get sheetTitle089 => 'Dişli Kutusu';

  @override
  String get sheetTitle090 => 'Gövde';

  @override
  String get sheetTitle091 => 'Şasi';

  @override
  String get sheetTitle092 => 'Panel Bölmesi';

  @override
  String get sheetTitle093 => 'Kapak Seti';

  @override
  String get sheetTitle094 => 'Hafif Tork';

  @override
  String get sheetTitle095 => 'Motor Takozu';

  @override
  String get sheetTitle096 => 'Şalt Panosu';

  @override
  String get sheetTitle097 => 'Kontrol Kutusu';

  @override
  String get sheetTitle098 => 'Çizim Masası';

  @override
  String get sheetTitle099 => 'Son Muayene';

  @override
  String get sheetTitle100 => 'Onay';
}
