// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Jeda';

  @override
  String get back => 'Kembali';

  @override
  String get settings => 'Pengaturan';

  @override
  String get tray => 'NAMPAN';

  @override
  String get trayFull => 'NAMPAN PENUH';

  @override
  String get undo => 'URUNGKAN';

  @override
  String hintCount(String count) {
    return 'PETUNJUK $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Dijeda';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · LANGKAH $moves';
  }

  @override
  String get resume => 'Lanjutkan';

  @override
  String get sound => 'SUARA';

  @override
  String get haptics => 'GETARAN';

  @override
  String get reducedMotion => 'GERAKAN MINIM';

  @override
  String get restart => 'ULANGI';

  @override
  String get exitToSheets => 'KE DAFTAR LEMBAR';

  @override
  String get restartConfirmTitle => 'Ulangi lembar ini?';

  @override
  String restartConfirmBody(int moves) {
    return 'Progres $moves langkah akan hilang.';
  }

  @override
  String get cancel => 'BATAL';

  @override
  String get stuckTitle => 'Tidak ada slot kosong lagi.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sekrup',
      one: 'satu sekrup',
    );
    return '$plate masih menahan $_temp0 di papan. Urungkan untuk mengosongkan slot.';
  }

  @override
  String get stuckReasonGeneric =>
      'Semua slot terisi dan tidak ada pelat yang bisa jatuh. Urungkan untuk mengosongkan slot.';

  @override
  String get undoLastMove => 'Urungkan langkah';

  @override
  String rescueSlotCoins(int coins) {
    return 'SLOT EKSTRA · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'SLOT EKSTRA · VIDEO';

  @override
  String get rescueSlotPro => 'SLOT EKSTRA · PRO';

  @override
  String get outOfHintsTitle => 'Mau satu petunjuk lagi?';

  @override
  String get hintsLeftZero => 'PETUNJUK · SISA 0';

  @override
  String get outOfHintsBody =>
      'Petunjuk melingkari satu sekrup berikutnya yang berguna. Petunjuk tidak pernah menyelesaikan lembar untukmu.';

  @override
  String get watchVideo => 'Tonton video singkat';

  @override
  String get watchVideoMeta => 'OPSIONAL · ~30 DTK · +1 PETUNJUK';

  @override
  String useCoins(int coins) {
    return 'Pakai $coins koin';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'SALDO $balance ¢';
  }

  @override
  String get keepThinking => 'Pikirkan lagi';

  @override
  String get notEnoughCoins => 'Koinmu belum cukup.';

  @override
  String get adUnavailable => 'Video sedang tidak tersedia.';

  @override
  String cleared(String code) {
    return '$code · SELESAI';
  }

  @override
  String get disassembled => 'Terbongkar.';

  @override
  String get approved => 'DISETUJUI';

  @override
  String get statMoves => 'LANGKAH';

  @override
  String get statTime => 'WAKTU';

  @override
  String get statMastery => 'PENGUASAAN';

  @override
  String nextSheet(String code) {
    return 'Lembar berikutnya · $code';
  }

  @override
  String get replay => 'ULANGI';

  @override
  String get sheets => 'LEMBAR';

  @override
  String get backHome => 'Kembali ke beranda';

  @override
  String chapterComplete(String chapter) {
    return 'BAB $chapter · SELESAI';
  }

  @override
  String get themeUnlocked => 'TEMA TERBUKA';

  @override
  String nextChapter(String chapter) {
    return 'BERIKUTNYA · BAB $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Mulai Bab $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'PAKAI $name';
  }

  @override
  String get tutorialStep1 => 'LANGKAH 1 · KETUK SEKRUPNYA';

  @override
  String get tutorialLands => '↓ MASUK KE NAMPAN';

  @override
  String get skipTutorial => 'LEWATI TUTORIAL';

  @override
  String get splashTagline => 'PUZZLE LAPIS DEMI LAPIS';

  @override
  String get splashFooter => 'REV 1.0 · LEMBAR 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PELAT',
      one: '1 PELAT',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'SEKRUP',
      one: 'SEKRUP',
    );
    return 'GBR. 1\nTAMPAK TERURAI\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'BAB $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'SEKRUP',
      one: 'SEKRUP',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'LEMBAR BERIKUTNYA';

  @override
  String chapterLabel(String chapter) {
    return 'BAB $chapter';
  }

  @override
  String get campaign => 'KAMPANYE';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Lanjut · $code';
  }

  @override
  String get daily => 'HARIAN';

  @override
  String get themes => 'TEMA';

  @override
  String get allCleared => 'Semua lembar selesai';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total LEMBAR';
  }

  @override
  String get fiveChapters => 'Lima bab';

  @override
  String get chaptersTitle => 'Bab';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'TERKUNCI';

  @override
  String get downloadChapter => 'UNDUH';

  @override
  String get downloading => 'MENGUNDUH…';

  @override
  String get comingSoon => 'LEMBAR BARU SEGERA';

  @override
  String newMechanic(String mechanic) {
    return 'BARU: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates pelat',
      one: '1 pelat',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers lapis',
      one: '1 lapis',
    );
    return '$_temp0 · $_temp1 · nampan $tray';
  }

  @override
  String get theCampaign => 'KAMPANYE';

  @override
  String get campaignFooter =>
      'Bab terbuka setelah bab sebelumnya selesai. Tanda penguasaan bersifat opsional. Petunjuk tidak pernah menghambat kemajuan.';

  @override
  String get chapterBonus => 'BONUS BAB';

  @override
  String get dailySheet => 'LEMBAR HARIAN';

  @override
  String get dailyTitle => 'JUDUL';

  @override
  String get dailyPlates => 'PELAT';

  @override
  String get dailyReward => 'HADIAH';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'Runtunan $streak hari.',
      one: 'Runtunan 1 hari.',
      zero: 'Mulai runtunan.',
    );
    return 'Lembar yang sama untuk semua orang hari ini. Tanpa batas waktu. $_temp0 Terlewat sehari tidak merugikan apa-apa.';
  }

  @override
  String get startDaily => 'Mulai lembar hari ini';

  @override
  String get dailyCompleted => 'Selesai hari ini · kembali besok';

  @override
  String get replayDaily => 'Ulangi lembar hari ini';

  @override
  String get themesTitle => 'Tema';

  @override
  String get themesCaption => 'KOSMETIK · TIDAK MENGUBAH ATURAN';

  @override
  String get equipped => 'DIPAKAI';

  @override
  String get owned => 'DIMILIKI';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'PRATINJAU';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get feedbackSection => 'SUARA & GETARAN';

  @override
  String get soundEffects => 'Efek suara';

  @override
  String get music => 'Musik';

  @override
  String get hapticsRow => 'Getaran';

  @override
  String get reducedMotionRow => 'Gerakan minim';

  @override
  String get reducedMotionCaption => 'Memudar, bukan berpindah';

  @override
  String get generalSection => 'UMUM';

  @override
  String get highRefreshRate => 'Kecepatan refresh tinggi';

  @override
  String highRefreshRateOn(int hz) {
    return 'Gerakan lebih halus · hingga $hz Hz · lebih boros baterai';
  }

  @override
  String get highRefreshRateOff => 'Gerakan lebih halus · lebih boros baterai';

  @override
  String get highRefreshRateUnsupported =>
      'Layar ini hanya punya satu kecepatan';

  @override
  String get highRefreshRateBattery => 'Sedang dibatasi oleh penghemat baterai';

  @override
  String get highRefreshRateHeat => 'Dibatasi saat ponsel panas';

  @override
  String highRefreshRateNow(int hz) {
    return 'Sekarang $hz Hz';
  }

  @override
  String get language => 'Bahasa';

  @override
  String get notifications => 'Pengingat harian';

  @override
  String get notificationsCaption => 'Satu pengingat saat ada lembar baru';

  @override
  String get accountSection => 'AKUN';

  @override
  String get signInGoogle => 'Login dengan Google';

  @override
  String get signInApple => 'Masuk dengan Apple';

  @override
  String signedInAs(String name) {
    return 'Sudah masuk · $name';
  }

  @override
  String get guestCaption =>
      'BERMAIN SEBAGAI TAMU · MASUK UNTUK MENYIMPAN PROGRES';

  @override
  String get signOut => 'KELUAR';

  @override
  String get deleteAccount => 'HAPUS AKUN';

  @override
  String get purchasesSection => 'PEMBELIAN';

  @override
  String get removeAds => 'Hapus iklan';

  @override
  String get restore => 'PULIHKAN';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'TANPA IKLAN · PETUNJUK TANPA BATAS · SEMUA TEMA · PENYELAMATAN GRATIS · $coins ¢ TIAP BULAN';
  }

  @override
  String get proMonthly => 'BULANAN';

  @override
  String get proYearly => 'TAHUNAN';

  @override
  String proTrialDays(int days) {
    return 'GRATIS $days HARI';
  }

  @override
  String proThenPrice(String price) {
    return 'LALU $price';
  }

  @override
  String get proTrialTerms =>
      'Diperpanjang otomatis setelah uji coba gratis kecuali kamu membatalkannya. Koin bulanan dimulai sejak pembayaran pertama.';

  @override
  String get proActive => 'PRO · AKTIF';

  @override
  String get adsRemoved => 'IKLAN DIHAPUS';

  @override
  String get coinPacks => 'PAKET KOIN';

  @override
  String get aboutSection => 'TENTANG';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get termsOfUse => 'Ketentuan penggunaan';

  @override
  String get refundPolicy => 'Kebijakan pengembalian dana';

  @override
  String get privacyChoices => 'Pilihan privasi';

  @override
  String get licenses => 'Lisensi & kredit';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Mau diingatkan lembar harian?';

  @override
  String get notificationPrimerBody =>
      'Pengingat pelan saat kamu belum bermain. Tidak pernah lebih dari sekali sehari.';

  @override
  String get allow => 'IZINKAN';

  @override
  String get notNow => 'NANTI SAJA';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan.';

  @override
  String get purchaseThanks => 'Terima kasih! Pembelian diterapkan.';

  @override
  String get purchasePending =>
      'Pembelian tertunda. Akan diterapkan setelah dikonfirmasi.';

  @override
  String get purchaseFailed => 'Pembelian tidak berhasil.';

  @override
  String get restored => 'Pembelian dipulihkan.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Selesaikan Bab $chapter dulu.';
  }

  @override
  String get moreSheetsTitle => 'Lembar lainnya';

  @override
  String get moreSheetsCaption => 'Set gambar baru muncul di sini';

  @override
  String get equip => 'PAKAI';

  @override
  String buyFor(int coins) {
    return 'BELI · $coins ¢';
  }

  @override
  String get close => 'TUTUP';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Lisensi';

  @override
  String get licensesCaption => 'PEMBERITAHUAN OPEN SOURCE';

  @override
  String playLevel(String code) {
    return 'Main $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Lembar $number, terkunci';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Papan peringkat';

  @override
  String get leaderboardCaption => 'PEMAIN YANG MASUK · LANGSUNG';

  @override
  String get boardSheets => 'LEMBAR';

  @override
  String get boardDaily => 'HARIAN';

  @override
  String get boardStreak => 'RUNTUNAN';

  @override
  String get boardWeekly => 'MINGGU';

  @override
  String get boardWeeklyHint => 'LEMBAR SELESAI MINGGU INI · RESET TIAP SENIN';

  @override
  String get boardSheetsHint => 'LEMBAR SELESAI TERBANYAK';

  @override
  String get boardDailyHint =>
      'LEMBAR HARI INI · LANGKAH TERSEDIKIT, LALU TERCEPAT';

  @override
  String get boardStreakHint => 'HARI BERTURUT-TURUT DI LEMBAR HARIAN';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'LANGKAH',
      one: 'LANGKAH',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'HARI',
      one: 'HARI',
    );
    return '$_temp0 · TERBAIK $best';
  }

  @override
  String get boardYou => 'KAMU';

  @override
  String get boardYourRank => 'PERINGKATMU';

  @override
  String get boardNotRanked => 'Belum masuk peringkat';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'DARI $countString';
  }

  @override
  String get boardGuest =>
      'Masuk agar namamu tampil di papan. Progresmu ikut terbawa.';

  @override
  String get boardEmpty => 'Belum ada siapa-siapa. Jadilah yang pertama.';

  @override
  String get boardOffline => 'Papan peringkat tidak bisa dijangkau saat ini.';

  @override
  String get tryAgainCaps => 'COBA LAGI';

  @override
  String get todaysBoard => 'PAPAN HARI INI';

  @override
  String get signedOutToast =>
      'Sudah keluar · perangkat ini dikosongkan. Masuk lagi untuk mengembalikan progresmu.';

  @override
  String get welcomeBack => 'Selamat datang kembali';

  @override
  String welcomeBackName(String name) {
    return 'Selamat datang kembali, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets lembar',
      one: '1 lembar',
    );
    return '$who · $_temp0 dan $coins koin dipulihkan';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · kamu sudah masuk dan progres dicadangkan';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets lembar',
      one: '1 lembar',
    );
    return '$who · progres perangkat ini ditambahkan ke akunmu: $_temp0, $coins koin';
  }

  @override
  String syncSavedNew(String name) {
    return 'Masuk sebagai $name · progresmu kini tersimpan di akunmu';
  }

  @override
  String get syncSavedNewPlain =>
      'Sudah masuk · progresmu kini tersimpan di akunmu';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets lembar baru',
      one: '1 lembar baru',
      zero: 'progres diperbarui',
    );
    return 'Disinkronkan dari perangkat lainmu · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Progres tersimpan belum bisa dimuat · akan tersinkron otomatis saat koneksi kembali';

  @override
  String get signedInOffline =>
      'Sudah masuk · progresmu akan tersinkron saat kamu online lagi';

  @override
  String get proActivated =>
      'Pro aktif · tanpa iklan, semua tema, dan petunjuk tanpa batas';

  @override
  String get accountDeletedToast => 'Akunmu dan semua datanya sudah dihapus.';

  @override
  String accountDeletedProToast(String store) {
    return 'Akun dihapus. Pro tetap ditagih sampai kamu membatalkannya di $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'RUNTUNAN $days HARI · BONUS +$coins';
  }

  @override
  String get workshopRecord => 'Catatan bengkel';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Catatan bengkel · $earned/$total';
  }

  @override
  String get recordCaption => 'PENCAPAIAN';

  @override
  String recordEarned(int earned, int total) {
    return '$earned DARI $total DIRAIH';
  }

  @override
  String get badgeEarnedLabel => 'DIRAIH';

  @override
  String badgeEarnedToast(String name) {
    return 'Lencana diraih · $name';
  }

  @override
  String get badgeFirstTurn => 'Putaran Pertama';

  @override
  String get badgeApprentice => 'Pemagang';

  @override
  String get badgeJourneyman => 'Tukang';

  @override
  String get badgeCraftsman => 'Perajin';

  @override
  String get badgeChiefEngineer => 'Kepala Insinyur';

  @override
  String get badgeCleanWork => 'Kerja Rapi';

  @override
  String get badgePerfectionist => 'Perfeksionis';

  @override
  String get badgeRegular => 'Pemain Setia';

  @override
  String get badgeOnARoll => 'Lagi Lancar';

  @override
  String get badgeFullWeek => 'Seminggu Penuh';

  @override
  String get badgeFortnight => 'Dua Minggu';

  @override
  String get badgeFirstDetail => 'Selesaikan lembar pertamamu';

  @override
  String badgeClearDetail(int n) {
    return 'Selesaikan $n lembar';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Selesaikan bab $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Raih ◆ di $n lembar';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Mainkan $n lembar harian';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Capai runtunan $n hari';
  }

  @override
  String get share => 'BAGIKAN';

  @override
  String get shareResult => 'Bagikan hasil';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves langkah',
      one: '1 langkah',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'Runtunan $days hari';
  }

  @override
  String get signOutSheetTitle => 'Keluar?';

  @override
  String get signOutSheetBody =>
      'Keluar akan menghapus progresmu dari perangkat ini. Semua yang sudah dicadangkan akan kembali saat kamu masuk lagi, tetapi yang belum tersinkron (misalnya lembar yang dimainkan offline) akan hilang.';

  @override
  String get staySignedIn => 'Tetap masuk';

  @override
  String get signOutConfirm => 'Keluar';

  @override
  String get rateApp => 'Beri nilai Screw Out';

  @override
  String get sendFeedback => 'Kirim masukan';

  @override
  String get replayTutorial => 'Ulangi tutorial';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Aplikasi email tidak ditemukan. Kirim email ke $email';
  }

  @override
  String get updateChip => 'PERBARUI';

  @override
  String get updateReadyRestart =>
      'Pembaruan sudah diunduh. Mulai ulang untuk memasangnya.';

  @override
  String get deleteSheetTitle => 'Hapus akunmu?';

  @override
  String get deleteSheetBody =>
      'Ini akan menghapus akunmu secara permanen beserta semua yang tersimpan: progres di setiap lembar, koin, tema, runtunan harian, dan posisi di papan peringkat. Tindakan ini tidak bisa dibatalkan.';

  @override
  String deleteSheetPro(String store) {
    return 'Kamu punya Screw Out Pro. Menghapus akun tidak membatalkannya: batalkan langganan di $store, atau kamu akan terus ditagih.';
  }

  @override
  String get manageSubscription => 'Kelola langganan';

  @override
  String get deleteForever => 'Hapus akun saya';

  @override
  String get deleting => 'Menghapus…';

  @override
  String get keepAccount => 'Simpan akun saya';

  @override
  String get deleteOffline =>
      'Kamu sedang offline. Sambungkan ke internet untuk menghapus akun.';

  @override
  String get deleteFailed => 'Akun gagal dihapus. Silakan coba lagi.';

  @override
  String get restoreNothing => 'Tidak ada yang bisa dipulihkan di akun ini.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 petunjuk';
  }

  @override
  String get hintEarnedToast => '+1 petunjuk · terima kasih sudah menonton';

  @override
  String get rescueToast => '+1 slot nampan untuk lembar ini';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 slot nampan';
  }

  @override
  String get adNotCompleted =>
      'Video tidak selesai, jadi kali ini tidak ada hadiah.';

  @override
  String themeEquippedToast(String name) {
    return '$name dipakai';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'Bab $chapter siap';
  }

  @override
  String get signInFailed => 'Gagal masuk.';

  @override
  String get themePurchased => 'Tema terbuka.';

  @override
  String themeBuyStore(String price) {
    return 'ATAU BELI · $price';
  }

  @override
  String get themesBundleTitle => 'Semua tema';

  @override
  String get themesBundleBody =>
      'Semua tema berbayar, jadi milikmu selamanya. Pro juga sudah termasuk.';

  @override
  String themesBundleBuy(String price) {
    return 'BELI · $price';
  }

  @override
  String get dailyWeekDone => 'Selesai';

  @override
  String masteredCount(int count) {
    return '$count DIKUASAI';
  }

  @override
  String get reminderTitle => 'Lembar hari ini sudah siap';

  @override
  String get reminderBody =>
      'Satu gambar baru, sama untuk semua orang. Tanpa batas waktu.';

  @override
  String get comebackReminderTitle =>
      'Lembar berikutnya menunggu di meja kerja';

  @override
  String get comebackReminderBody =>
      'Beberapa menit santai, beberapa sekrup. Lanjutkan dari terakhir kali.';

  @override
  String get signInEmail => 'Lanjutkan dengan email';

  @override
  String get emailSignInTitle => 'Masuk';

  @override
  String get emailCreateTitle => 'Buat akun';

  @override
  String get emailTabSignIn => 'MASUK';

  @override
  String get emailTabCreate => 'BUAT AKUN';

  @override
  String get emailSheetBody => 'Progresmu di perangkat ini ikut terbawa.';

  @override
  String get emailLabel => 'EMAIL';

  @override
  String get passwordLabel => 'KATA SANDI';

  @override
  String get showPassword => 'Tampilkan sandi';

  @override
  String get hidePassword => 'Sembunyikan sandi';

  @override
  String passwordHint(int min) {
    return 'Minimal $min karakter';
  }

  @override
  String get emailRequired => 'Masukkan emailmu.';

  @override
  String get emailInvalid => 'Alamat email itu sepertinya tidak benar.';

  @override
  String get passwordRequired => 'Masukkan kata sandimu.';

  @override
  String passwordTooShort(int min) {
    return 'Gunakan minimal $min karakter.';
  }

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get forgotNeedsEmail =>
      'Masukkan emailmu di atas, lalu ketuk Lupa kata sandi.';

  @override
  String resetSent(String email) {
    return 'Jika $email punya akun, tautan reset sedang dikirim.';
  }

  @override
  String get emailWorking => 'Sebentar…';

  @override
  String get authErrWrongCredentials => 'Email atau kata sandi salah.';

  @override
  String get authErrEmailInUse => 'Email ini sudah punya akun. Masuk saja.';

  @override
  String get authErrWeakPassword => 'Pilih kata sandi yang lebih kuat.';

  @override
  String get authErrDisabled => 'Akun ini telah dinonaktifkan.';

  @override
  String get authErrNotEnabled => 'Masuk dengan email sedang tidak tersedia.';

  @override
  String get authErrTooMany =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get authErrNetwork =>
      'Tidak ada koneksi. Periksa internetmu lalu coba lagi.';

  @override
  String get authErrGeneric => 'Tidak bisa masuk. Silakan coba lagi.';

  @override
  String get deletePasswordBody =>
      'Masukkan kata sandimu untuk memastikan ini kamu.';

  @override
  String get deleteWrongPassword =>
      'Kata sandi itu tidak cocok dengan akun ini.';

  @override
  String get purchaseSaveTitle => 'Amankan pembelianmu';

  @override
  String get purchaseSaveBody =>
      'Opsional: masuk untuk menyimpan pembelian dan progresmu di semua perangkat. Pembelianmu sudah berfungsi di perangkat ini.';

  @override
  String get purchaseNeedsConnection =>
      'Tidak bisa menghubungi server. Periksa koneksimu lalu coba lagi.';

  @override
  String get languageSystemDefault => 'Default sistem';

  @override
  String get startupFailed =>
      'TERJADI KESALAHAN SAAT MEMULAI.\nTUTUP APLIKASI LALU BUKA LAGI.';

  @override
  String get notificationChannelDescription =>
      'Pengingat lembar harian dan pemberitahuan akun';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Sekrup, pelat $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Sekrup, pelat $plate, terhalang $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled dari $total';
  }

  @override
  String get chapterName1 => 'Dasar Bengkel';

  @override
  String get chapterName2 => 'Lapis demi Lapis';

  @override
  String get chapterName3 => 'Beri Ruang';

  @override
  String get chapterName4 => 'Saling Mengunci';

  @override
  String get chapterName5 => 'Pembangun Ulung';

  @override
  String get chapterGoal1 => 'Ketuk, lepas, bebaskan';

  @override
  String get chapterGoal2 => 'Tumpang tindih & urutan';

  @override
  String get chapterGoal3 => 'Rencanakan di nampan sempit';

  @override
  String get chapterGoal4 => 'Penyangga bersama';

  @override
  String get chapterGoal5 => 'Semuanya, secara adil';

  @override
  String get chapterPitch1 =>
      'Ketuk sekrup. Jatuhkan pelat. Itu saja aturannya.';

  @override
  String get chapterPitch2 =>
      'Pelat menutupi pelat. Kerjakan dari atas ke bawah.';

  @override
  String get chapterPitch3 =>
      'Nampan lebih sempit. Rencanakan sekrup mana yang dicabut dulu.';

  @override
  String get chapterPitch4 =>
      'Satu pelat menahan beberapa. Temukan bagian kuncinya.';

  @override
  String get chapterPitch5 =>
      'Tumpukan dalam, semua ide sekaligus. Santai saja.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Set Gambar $number';
  }

  @override
  String get chapterGoalDownloaded => 'Lembar tingkat ahli';

  @override
  String get chapterPitchDownloaded =>
      'Lebih banyak lembar, aturan adil yang sama.';

  @override
  String get mechanicOverlap => 'TUMPANG TINDIH';

  @override
  String get mechanicTray => 'NAMPAN';

  @override
  String get mechanicLayers => 'LAPISAN';

  @override
  String get mechanicCircles => 'LINGKARAN';

  @override
  String get mechanicTraps => 'JEBAKAN';

  @override
  String get mechanicSupports => 'PENYANGGA';

  @override
  String get sheetObjective004 => 'ANGKAT PELAT ATAS UNTUK MERAIH SEKRUP BAWAH';

  @override
  String get sheetObjective006 =>
      'NAMPAN MUAT 3. PELAT LEPAS MENGOSONGKAN SLOTNYA';

  @override
  String get sheetObjective011 => 'TIGA LAPIS. KERJAKAN DARI ATAS KE BAWAH';

  @override
  String get sheetObjective012 => 'ANGKAT PL-04 SEBELUM PELAT DI BAWAHNYA';

  @override
  String get sheetObjective017 => 'SATU LANGKAH MENGGODA MEMENUHI NAMPAN';

  @override
  String get sheetObjective021 => 'PELAT BULAT JUGA MENUTUPI SEPERTI YANG LAIN';

  @override
  String get sheetObjective024 => 'LEPAS PL-04 UNTUK MERAIH SUDUT';

  @override
  String get sheetObjective041 => 'NAMPAN SEMPIT. BEBASKAN PELAT SEBELUM PENUH';

  @override
  String get sheetObjective061 => 'SATU PELAT BISA MENAHAN BEBERAPA PELAT LAIN';

  @override
  String get sheetObjective081 => 'SEMUA YANG SUDAH KAMU PELAJARI. SANTAI SAJA';

  @override
  String get themeNameBlueprint => 'Cetak Biru Bersih';

  @override
  String get themeNameWalnut => 'Bengkel Kenari';

  @override
  String get themeNameOcean => 'Toska Samudra';

  @override
  String get themeNameCopper => 'Tembaga Hangat';

  @override
  String get themeNameMidnight => 'Bengkel Tengah Malam';

  @override
  String get themeNamePastel => 'Studio Pastel';

  @override
  String sheetTitleNumbered(int number) {
    return 'Lembar $number';
  }

  @override
  String get sheetTitle001 => 'Putaran Pertama';

  @override
  String get sheetTitle002 => 'Dua Titik';

  @override
  String get sheetTitle003 => 'Berdampingan';

  @override
  String get sheetTitle004 => 'Pelat Penutup';

  @override
  String get sheetTitle005 => 'Terungkap';

  @override
  String get sheetTitle006 => 'Hari Nampan';

  @override
  String get sheetTitle007 => 'Rencana Kecil';

  @override
  String get sheetTitle008 => 'Pas Sekali';

  @override
  String get sheetTitle009 => 'Batang Bulat';

  @override
  String get sheetTitle010 => 'Pos Pemeriksaan';

  @override
  String get sheetTitle011 => 'Lapis Ketiga';

  @override
  String get sheetTitle012 => 'Penguat Silang';

  @override
  String get sheetTitle013 => 'Kosongkan Slot';

  @override
  String get sheetTitle014 => 'Dua Langkah Maju';

  @override
  String get sheetTitle015 => 'Baja Bercat';

  @override
  String get sheetTitle016 => 'Meja Kerja';

  @override
  String get sheetTitle017 => 'Menggoda';

  @override
  String get sheetTitle018 => 'Air Terjun';

  @override
  String get sheetTitle019 => 'Campuran Bengkel';

  @override
  String get sheetTitle020 => 'Perakitan';

  @override
  String get sheetTitle021 => 'Tumpukan Ring';

  @override
  String get sheetTitle022 => 'Paking';

  @override
  String get sheetTitle023 => 'Tutup Lensa';

  @override
  String get sheetTitle024 => 'Braket Tersembunyi';

  @override
  String get sheetTitle025 => 'Set Ganjal';

  @override
  String get sheetTitle026 => 'Bingkai';

  @override
  String get sheetTitle027 => 'Mata Ayam';

  @override
  String get sheetTitle028 => 'Rehat Sejenak';

  @override
  String get sheetTitle029 => 'Cincin Flensa';

  @override
  String get sheetTitle030 => 'Jendela Kapal';

  @override
  String get sheetTitle031 => 'Pengganjal';

  @override
  String get sheetTitle032 => 'Kerah';

  @override
  String get sheetTitle033 => 'Tutup Ujung';

  @override
  String get sheetTitle034 => 'Sif Tenang';

  @override
  String get sheetTitle035 => 'Sekat';

  @override
  String get sheetTitle036 => 'Lubang Inspeksi';

  @override
  String get sheetTitle037 => 'Pelat Muka';

  @override
  String get sheetTitle038 => 'Tugas Ringan';

  @override
  String get sheetTitle039 => 'Roset';

  @override
  String get sheetTitle040 => 'Kue Lapis';

  @override
  String get sheetTitle041 => 'Beri Ruang';

  @override
  String get sheetTitle042 => 'Ruang di Laci';

  @override
  String get sheetTitle043 => 'Meluap';

  @override
  String get sheetTitle044 => 'Rak Kecil';

  @override
  String get sheetTitle045 => 'Kotak Suku Cadang';

  @override
  String get sheetTitle046 => 'Stok Tipis';

  @override
  String get sheetTitle047 => 'Kotak Sekat';

  @override
  String get sheetTitle048 => 'Jalan Mudah';

  @override
  String get sheetTitle049 => 'Mesin Slot';

  @override
  String get sheetTitle050 => 'Penuh Sesak';

  @override
  String get sheetTitle051 => 'Tumpukan Kerja';

  @override
  String get sheetTitle052 => 'Slot Cadangan';

  @override
  String get sheetTitle053 => 'Celah';

  @override
  String get sheetTitle054 => 'Pas Longgar';

  @override
  String get sheetTitle055 => 'Inventaris';

  @override
  String get sheetTitle056 => 'Kelonggaran';

  @override
  String get sheetTitle057 => 'Toleransi';

  @override
  String get sheetTitle058 => 'Hari Libur';

  @override
  String get sheetTitle059 => 'Ruang Atas';

  @override
  String get sheetTitle060 => 'Gudang';

  @override
  String get sheetTitle061 => 'Saling Kunci';

  @override
  String get sheetTitle062 => 'Pelat Siku';

  @override
  String get sheetTitle063 => 'Batu Kunci';

  @override
  String get sheetTitle064 => 'Sambungan Tumpang';

  @override
  String get sheetTitle065 => 'Pelat Sambung';

  @override
  String get sheetTitle066 => 'Ekor Burung';

  @override
  String get sheetTitle067 => 'Ambang Atas';

  @override
  String get sheetTitle068 => 'Potongan Sisa';

  @override
  String get sheetTitle069 => 'Penopang';

  @override
  String get sheetTitle070 => 'Rangka Batang';

  @override
  String get sheetTitle071 => 'Klevis';

  @override
  String get sheetTitle072 => 'Kuk';

  @override
  String get sheetTitle073 => 'Sadel';

  @override
  String get sheetTitle074 => 'Pondasi';

  @override
  String get sheetTitle075 => 'Sepasang Braket';

  @override
  String get sheetTitle076 => 'Batang Penjepit';

  @override
  String get sheetTitle077 => 'Pelat Pengikat';

  @override
  String get sheetTitle078 => 'Panel Polos';

  @override
  String get sheetTitle079 => 'Kantilever';

  @override
  String get sheetTitle080 => 'Rangka Kaku';

  @override
  String get sheetTitle081 => 'Rencana Induk';

  @override
  String get sheetTitle082 => 'Sub-rakitan';

  @override
  String get sheetTitle083 => 'Gambar Terurai';

  @override
  String get sheetTitle084 => 'Cek Kepasan';

  @override
  String get sheetTitle085 => 'Spesifikasi Torsi';

  @override
  String get sheetTitle086 => 'Mal';

  @override
  String get sheetTitle087 => 'Penjepit Kerja';

  @override
  String get sheetTitle088 => 'Meja Tenang';

  @override
  String get sheetTitle089 => 'Kotak Roda Gigi';

  @override
  String get sheetTitle090 => 'Rumah Mesin';

  @override
  String get sheetTitle091 => 'Sasis';

  @override
  String get sheetTitle092 => 'Ruang Panel';

  @override
  String get sheetTitle093 => 'Set Penutup';

  @override
  String get sheetTitle094 => 'Torsi Ringan';

  @override
  String get sheetTitle095 => 'Dudukan Mesin';

  @override
  String get sheetTitle096 => 'Panel Listrik';

  @override
  String get sheetTitle097 => 'Kotak Kontrol';

  @override
  String get sheetTitle098 => 'Meja Gambar';

  @override
  String get sheetTitle099 => 'Inspeksi Akhir';

  @override
  String get sheetTitle100 => 'Disahkan';
}
