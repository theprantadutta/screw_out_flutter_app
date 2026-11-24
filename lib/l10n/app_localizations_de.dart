// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Pause';

  @override
  String get back => 'Zurück';

  @override
  String get settings => 'Einstellungen';

  @override
  String get tray => 'ABLAGE';

  @override
  String get trayFull => 'ABLAGE VOLL';

  @override
  String get undo => 'RÜCKGÄNGIG';

  @override
  String hintCount(String count) {
    return 'TIPP · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Pausiert';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · ZUG $moves';
  }

  @override
  String get resume => 'Weiter';

  @override
  String get sound => 'TON';

  @override
  String get haptics => 'VIBRATION';

  @override
  String get reducedMotion => 'WENIGER BEWEGUNG';

  @override
  String get restart => 'NEUSTART';

  @override
  String get exitToSheets => 'ZU DEN BLÄTTERN';

  @override
  String get restartConfirmTitle => 'Dieses Blatt neu starten?';

  @override
  String restartConfirmBody(int moves) {
    return 'Du verlierst den Fortschritt von $moves Zügen.';
  }

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get stuckTitle => 'Keine freien Plätze mehr.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schrauben',
      one: 'eine Schraube',
    );
    return '$plate hält noch $_temp0 auf dem Brett. Rückgängig gibt einen Platz frei.';
  }

  @override
  String get stuckReasonGeneric =>
      'Alle Plätze sind belegt und keine Platte kann fallen. Rückgängig gibt einen Platz frei.';

  @override
  String get undoLastMove => 'Letzten Zug rückgängig';

  @override
  String rescueSlotCoins(int coins) {
    return 'EXTRAPLATZ · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'EXTRAPLATZ · VIDEO';

  @override
  String get rescueSlotPro => 'EXTRAPLATZ · PRO';

  @override
  String get outOfHintsTitle => 'Noch einen Tipp?';

  @override
  String get hintsLeftZero => 'TIPPS · 0 ÜBRIG';

  @override
  String get outOfHintsBody =>
      'Ein Tipp kreist eine nützliche nächste Schraube ein. Er löst nie das Blatt.';

  @override
  String get watchVideo => 'Kurzes Video ansehen';

  @override
  String get watchVideoMeta => 'OPTIONAL · ~30 S · +1 TIPP';

  @override
  String useCoins(int coins) {
    return '$coins Münzen einsetzen';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'GUTHABEN $balance ¢';
  }

  @override
  String get keepThinking => 'Weiter nachdenken';

  @override
  String get notEnoughCoins => 'Noch nicht genug Münzen.';

  @override
  String get adUnavailable => 'Gerade ist kein Video verfügbar.';

  @override
  String cleared(String code) {
    return '$code · GELÖST';
  }

  @override
  String get disassembled => 'Zerlegt.';

  @override
  String get approved => 'GENEHMIGT';

  @override
  String get statMoves => 'ZÜGE';

  @override
  String get statTime => 'ZEIT';

  @override
  String get statMastery => 'MEISTERUNG';

  @override
  String nextSheet(String code) {
    return 'Nächstes Blatt · $code';
  }

  @override
  String get replay => 'NOCHMAL';

  @override
  String get sheets => 'BLÄTTER';

  @override
  String get backHome => 'Zum Start';

  @override
  String chapterComplete(String chapter) {
    return 'KAPITEL $chapter · ABGESCHLOSSEN';
  }

  @override
  String get themeUnlocked => 'DESIGN FREIGESCHALTET';

  @override
  String nextChapter(String chapter) {
    return 'ALS NÄCHSTES · KAPITEL $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Kapitel $chapter starten';
  }

  @override
  String equipTheme(String name) {
    return '$name VERWENDEN';
  }

  @override
  String get tutorialStep1 => 'SCHRITT 1 · TIPPE AUF DIE SCHRAUBE';

  @override
  String get tutorialLands => '↓ SIE LANDET IN DER ABLAGE';

  @override
  String get skipTutorial => 'ÜBERSPRINGEN';

  @override
  String get splashTagline => 'EIN PUZZLE AUS SCHICHTEN';

  @override
  String get splashFooter => 'REV 1.0 · BLATT 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLATTEN',
      one: '1 PLATTE',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'SCHRAUBEN',
      one: 'SCHRAUBE',
    );
    return 'ABB. 1\nEXPLOSIONSZEICHNUNG\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'KAPITEL $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'SCHRAUBEN',
      one: 'SCHRAUBE',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'NÄCHSTES BLATT';

  @override
  String chapterLabel(String chapter) {
    return 'KAPITEL $chapter';
  }

  @override
  String get campaign => 'KAMPAGNE';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Weiter · $code';
  }

  @override
  String get daily => 'TAGESBLATT';

  @override
  String get themes => 'DESIGNS';

  @override
  String get allCleared => 'Alle Blätter gelöst';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total BLÄTTER';
  }

  @override
  String get fiveChapters => 'Fünf Kapitel';

  @override
  String get chaptersTitle => 'Kapitel';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'GESPERRT';

  @override
  String get downloadChapter => 'LADEN';

  @override
  String get downloading => 'LÄDT…';

  @override
  String get comingSoon => 'BALD MEHR BLÄTTER';

  @override
  String newMechanic(String mechanic) {
    return 'NEU: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates Platten',
      one: '1 Platte',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers Schichten',
      one: '1 Schicht',
    );
    return '$_temp0 · $_temp1 · Ablage $tray';
  }

  @override
  String get theCampaign => 'DIE KAMPAGNE';

  @override
  String get campaignFooter =>
      'Kapitel werden freigeschaltet, wenn du das vorherige abschließt. Meistermarken sind optional. Tipps blockieren nie den Fortschritt.';

  @override
  String get chapterBonus => 'KAPITELBONUS';

  @override
  String get dailySheet => 'TAGESBLATT';

  @override
  String get dailyTitle => 'TITEL';

  @override
  String get dailyPlates => 'PLATTEN';

  @override
  String get dailyReward => 'PRÄMIE';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak Tage in Folge.',
      one: '1 Tag in Folge.',
      zero: 'Starte eine Serie.',
    );
    return 'Heute dasselbe Blatt für alle. Kein Timer. $_temp0 Ein verpasster Tag kostet nichts.';
  }

  @override
  String get startDaily => 'Heutiges Blatt starten';

  @override
  String get dailyCompleted => 'Für heute erledigt · bis morgen';

  @override
  String get replayDaily => 'Heutiges Blatt wiederholen';

  @override
  String get themesTitle => 'Designs';

  @override
  String get themesCaption => 'NUR OPTIK · ÄNDERT NIE DIE REGELN';

  @override
  String get equipped => 'AKTIV';

  @override
  String get owned => 'IM BESITZ';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'VORSCHAU';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get feedbackSection => 'TON UND VIBRATION';

  @override
  String get soundEffects => 'Soundeffekte';

  @override
  String get music => 'Musik';

  @override
  String get hapticsRow => 'Vibration';

  @override
  String get reducedMotionRow => 'Weniger Bewegung';

  @override
  String get reducedMotionCaption => 'Überblenden statt Bewegen';

  @override
  String get generalSection => 'ALLGEMEIN';

  @override
  String get highRefreshRate => 'Hohe Bildwiederholrate';

  @override
  String highRefreshRateOn(int hz) {
    return 'Flüssigere Bewegung · bis zu $hz Hz · braucht mehr Akku';
  }

  @override
  String get highRefreshRateOff => 'Flüssigere Bewegung · braucht mehr Akku';

  @override
  String get highRefreshRateUnsupported =>
      'Dieser Bildschirm hat nur eine Bildrate';

  @override
  String get highRefreshRateBattery => 'Gerade vom Energiesparmodus begrenzt';

  @override
  String get highRefreshRateHeat => 'Begrenzt, solange das Handy warm ist';

  @override
  String highRefreshRateNow(int hz) {
    return 'Aktuell $hz Hz';
  }

  @override
  String get language => 'Sprache';

  @override
  String get notifications => 'Tägliche Erinnerung';

  @override
  String get notificationsCaption =>
      'Ein kurzer Hinweis, wenn ein neues Blatt da ist';

  @override
  String get accountSection => 'KONTO';

  @override
  String get signInGoogle => 'Mit Google anmelden';

  @override
  String get signInApple => 'Mit Apple anmelden';

  @override
  String signedInAs(String name) {
    return 'Angemeldet · $name';
  }

  @override
  String get guestCaption =>
      'DU SPIELST ALS GAST · MELDE DICH AN, UM DEINEN FORTSCHRITT ZU SICHERN';

  @override
  String get signOut => 'ABMELDEN';

  @override
  String get deleteAccount => 'KONTO LÖSCHEN';

  @override
  String get purchasesSection => 'KÄUFE';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String get restore => 'WIEDERHERSTELLEN';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'KEINE WERBUNG · UNBEGRENZTE TIPPS · ALLE DESIGNS · GRATIS-RETTUNGEN · $coins ¢ MONATLICH';
  }

  @override
  String get proMonthly => 'MONATLICH';

  @override
  String get proYearly => 'JÄHRLICH';

  @override
  String proTrialDays(int days) {
    return '$days TAGE GRATIS';
  }

  @override
  String proThenPrice(String price) {
    return 'DANN $price';
  }

  @override
  String get proTrialTerms =>
      'Verlängert sich nach dem kostenlosen Test automatisch, wenn du nicht kündigst. Die monatlichen Münzen beginnen mit deiner ersten Zahlung.';

  @override
  String get proActive => 'PRO · AKTIV';

  @override
  String get adsRemoved => 'WERBUNG ENTFERNT';

  @override
  String get coinPacks => 'MÜNZPAKETE';

  @override
  String get aboutSection => 'ÜBER';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get refundPolicy => 'Erstattungsrichtlinie';

  @override
  String get privacyChoices => 'Datenschutzoptionen';

  @override
  String get licenses => 'Lizenzen und Credits';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Eine Erinnerung ans Tagesblatt?';

  @override
  String get notificationPrimerBody =>
      'Ein leiser Hinweis, wenn du nicht gespielt hast. Nie mehr als einer pro Tag.';

  @override
  String get allow => 'ERLAUBEN';

  @override
  String get notNow => 'SPÄTER';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen.';

  @override
  String get purchaseThanks => 'Danke! Kauf freigeschaltet.';

  @override
  String get purchasePending =>
      'Kauf ausstehend. Er wird nach der Bestätigung freigeschaltet.';

  @override
  String get purchaseFailed => 'Der Kauf hat nicht geklappt.';

  @override
  String get restored => 'Käufe wiederhergestellt.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Schließe zuerst Kapitel $chapter ab.';
  }

  @override
  String get moreSheetsTitle => 'Mehr Blätter';

  @override
  String get moreSheetsCaption => 'Neue Zeichnungssätze kommen hier an';

  @override
  String get equip => 'VERWENDEN';

  @override
  String buyFor(int coins) {
    return 'KAUFEN · $coins ¢';
  }

  @override
  String get close => 'SCHLIESSEN';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Lizenzen';

  @override
  String get licensesCaption => 'OPEN-SOURCE-HINWEISE';

  @override
  String playLevel(String code) {
    return '$code spielen';
  }

  @override
  String lockedLevel(int number) {
    return 'Blatt $number, gesperrt';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Bestenlisten';

  @override
  String get leaderboardCaption => 'ANGEMELDETE SPIELER · LIVE';

  @override
  String get boardSheets => 'BLÄTTER';

  @override
  String get boardDaily => 'TAG';

  @override
  String get boardStreak => 'SERIE';

  @override
  String get boardWeekly => 'WOCHE';

  @override
  String get boardWeeklyHint =>
      'GELÖSTE BLÄTTER DIESE WOCHE · NEUSTART AM MONTAG';

  @override
  String get boardSheetsHint => 'MEISTE GELÖSTE BLÄTTER';

  @override
  String get boardDailyHint =>
      'HEUTIGES BLATT · WENIGSTE ZÜGE, DANN SCHNELLSTE ZEIT';

  @override
  String get boardStreakHint => 'TAGE IN FOLGE BEIM TAGESBLATT';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ZÜGE',
      one: 'ZUG',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TAGE',
      one: 'TAG',
    );
    return '$_temp0 · REKORD $best';
  }

  @override
  String get boardYou => 'DU';

  @override
  String get boardYourRank => 'DEIN RANG';

  @override
  String get boardNotRanked => 'Noch kein Rang';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'VON $countString';
  }

  @override
  String get boardGuest =>
      'Melde dich an, um mit deinem Namen in die Bestenliste zu kommen. Dein Fortschritt kommt mit.';

  @override
  String get boardEmpty => 'Noch niemand hier. Sei der Erste.';

  @override
  String get boardOffline => 'Die Bestenliste ist gerade nicht erreichbar.';

  @override
  String get tryAgainCaps => 'WIEDERHOLEN';

  @override
  String get todaysBoard => 'HEUTIGE BESTENLISTE';

  @override
  String get signedOutToast =>
      'Abgemeldet · die Daten auf diesem Gerät wurden gelöscht. Melde dich wieder an, um deinen Fortschritt zurückzuholen.';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String welcomeBackName(String name) {
    return 'Willkommen zurück, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets Blätter',
      one: '1 Blatt',
    );
    return '$who · $_temp0 und $coins Münzen wiederhergestellt';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · du bist angemeldet und dein Fortschritt ist gesichert';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets Blätter',
      one: '1 Blatt',
    );
    return '$who · der Fortschritt dieses Geräts wurde deinem Konto hinzugefügt: $_temp0, $coins Münzen';
  }

  @override
  String syncSavedNew(String name) {
    return 'Angemeldet als $name · dein Fortschritt wird jetzt in deinem Konto gespeichert';
  }

  @override
  String get syncSavedNewPlain =>
      'Angemeldet · dein Fortschritt wird jetzt in deinem Konto gespeichert';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets neue Blätter',
      one: '1 neues Blatt',
      zero: 'Fortschritt aktualisiert',
    );
    return 'Von deinem anderen Gerät synchronisiert · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Dein gespeicherter Fortschritt konnte noch nicht geladen werden · er synchronisiert sich automatisch, sobald die Verbindung wieder da ist';

  @override
  String get signedInOffline =>
      'Angemeldet · dein Fortschritt wird synchronisiert, sobald du wieder online bist';

  @override
  String get proActivated =>
      'Pro ist aktiv · keine Werbung, alle Designs und unbegrenzte Tipps';

  @override
  String get accountDeletedToast =>
      'Dein Konto und alle zugehörigen Daten wurden gelöscht.';

  @override
  String accountDeletedProToast(String store) {
    return 'Konto gelöscht. Pro wird weiter abgerechnet, bis du es $store kündigst.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days TAGE IN FOLGE · +$coins BONUS';
  }

  @override
  String get workshopRecord => 'Werkstattbuch';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Werkstattbuch · $earned/$total';
  }

  @override
  String get recordCaption => 'MEILENSTEINE';

  @override
  String recordEarned(int earned, int total) {
    return '$earned VON $total ERREICHT';
  }

  @override
  String get badgeEarnedLabel => 'ERREICHT';

  @override
  String badgeEarnedToast(String name) {
    return 'Abzeichen erhalten · $name';
  }

  @override
  String get badgeFirstTurn => 'Erste Drehung';

  @override
  String get badgeApprentice => 'Lehrling';

  @override
  String get badgeJourneyman => 'Geselle';

  @override
  String get badgeCraftsman => 'Handwerker';

  @override
  String get badgeChiefEngineer => 'Chefingenieur';

  @override
  String get badgeCleanWork => 'Saubere Arbeit';

  @override
  String get badgePerfectionist => 'Perfektionist';

  @override
  String get badgeRegular => 'Stammgast';

  @override
  String get badgeOnARoll => 'In Fahrt';

  @override
  String get badgeFullWeek => 'Volle Woche';

  @override
  String get badgeFortnight => 'Zwei Wochen';

  @override
  String get badgeFirstDetail => 'Löse dein erstes Blatt';

  @override
  String badgeClearDetail(int n) {
    return 'Löse $n Blätter';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Schließe Kapitel $n ab';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Hol dir ◆ auf $n Blättern';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Spiele $n Tagesblätter';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Erreiche eine Serie von $n Tagen';
  }

  @override
  String get share => 'TEILEN';

  @override
  String get shareResult => 'Ergebnis teilen';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves Züge',
      one: '1 Zug',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days Tage in Folge';
  }

  @override
  String get signOutSheetTitle => 'Abmelden?';

  @override
  String get signOutSheetBody =>
      'Beim Abmelden wird dein Fortschritt von diesem Gerät gelöscht. Alles, was schon gesichert ist, kommt bei der nächsten Anmeldung zurück, aber was noch nicht synchronisiert ist (zum Beispiel offline gespielte Blätter), ginge verloren.';

  @override
  String get staySignedIn => 'Angemeldet bleiben';

  @override
  String get signOutConfirm => 'Abmelden';

  @override
  String get rateApp => 'Screw Out bewerten';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get replayTutorial => 'Tutorial wiederholen';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Keine E-Mail-App gefunden. Schreib uns an $email';
  }

  @override
  String get updateChip => 'UPDATE';

  @override
  String get updateReadyRestart =>
      'Update heruntergeladen. Neu starten, um es zu installieren.';

  @override
  String get deleteSheetTitle => 'Konto löschen?';

  @override
  String get deleteSheetBody =>
      'Damit werden dein Konto und alles darin dauerhaft gelöscht: Fortschritt auf jedem Blatt, Münzen, Designs, deine Tagesserie und deine Plätze in den Bestenlisten. Das lässt sich nicht rückgängig machen.';

  @override
  String deleteSheetPro(String store) {
    return 'Du hast Screw Out Pro. Das Löschen des Kontos kündigt es nicht: Kündige das Abo $store, sonst wird es weiter abgerechnet.';
  }

  @override
  String get manageSubscription => 'Abo verwalten';

  @override
  String get deleteForever => 'Mein Konto löschen';

  @override
  String get deleting => 'Wird gelöscht…';

  @override
  String get keepAccount => 'Konto behalten';

  @override
  String get deleteOffline =>
      'Du bist offline. Verbinde dich mit dem Internet, um dein Konto zu löschen.';

  @override
  String get deleteFailed =>
      'Dein Konto konnte nicht gelöscht werden. Bitte versuch es noch einmal.';

  @override
  String get restoreNothing =>
      'Für dieses Konto gibt es nichts wiederherzustellen.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 Tipp';
  }

  @override
  String get hintEarnedToast => '+1 Tipp · danke fürs Zuschauen';

  @override
  String get rescueToast => '+1 Ablageplatz für dieses Blatt';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 Ablageplatz';
  }

  @override
  String get adNotCompleted =>
      'Das Video lief nicht bis zum Ende, diesmal also keine Belohnung.';

  @override
  String themeEquippedToast(String name) {
    return '$name aktiv';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'Kapitel $chapter ist bereit';
  }

  @override
  String get signInFailed => 'Die Anmeldung wurde nicht abgeschlossen.';

  @override
  String get themePurchased => 'Design freigeschaltet.';

  @override
  String themeBuyStore(String price) {
    return 'ODER KAUFEN · $price';
  }

  @override
  String get themesBundleTitle => 'Alle Designs';

  @override
  String get themesBundleBody =>
      'Alle kostenpflichtigen Designs, für immer deine. Pro enthält sie auch.';

  @override
  String themesBundleBuy(String price) {
    return 'KAUFEN · $price';
  }

  @override
  String get dailyWeekDone => 'Erledigt';

  @override
  String masteredCount(int count) {
    return '$count GEMEISTERT';
  }

  @override
  String get reminderTitle => 'Das heutige Blatt ist bereit';

  @override
  String get reminderBody =>
      'Eine frische Zeichnung, für alle dieselbe. Kein Timer.';

  @override
  String get comebackReminderTitle =>
      'Dein nächstes Blatt liegt auf der Werkbank';

  @override
  String get comebackReminderBody =>
      'Ein paar ruhige Minuten, ein paar Schrauben. Mach da weiter, wo du aufgehört hast.';

  @override
  String get signInEmail => 'Weiter mit E-Mail';

  @override
  String get emailSignInTitle => 'Anmelden';

  @override
  String get emailCreateTitle => 'Konto erstellen';

  @override
  String get emailTabSignIn => 'ANMELDEN';

  @override
  String get emailTabCreate => 'KONTO ERSTELLEN';

  @override
  String get emailSheetBody => 'Dein Fortschritt auf diesem Gerät kommt mit.';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get passwordLabel => 'PASSWORT';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String passwordHint(int min) {
    return 'Mindestens $min Zeichen';
  }

  @override
  String get emailRequired => 'Gib deine E-Mail-Adresse ein.';

  @override
  String get emailInvalid => 'Diese E-Mail-Adresse sieht nicht richtig aus.';

  @override
  String get passwordRequired => 'Gib dein Passwort ein.';

  @override
  String passwordTooShort(int min) {
    return 'Verwende mindestens $min Zeichen.';
  }

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotNeedsEmail =>
      'Gib oben deine E-Mail-Adresse ein und tippe dann auf Passwort vergessen.';

  @override
  String resetSent(String email) {
    return 'Falls $email ein Konto hat, ist ein Link zum Zurücksetzen unterwegs.';
  }

  @override
  String get emailWorking => 'Einen Moment…';

  @override
  String get authErrWrongCredentials => 'E-Mail oder Passwort falsch.';

  @override
  String get authErrEmailInUse =>
      'Für diese E-Mail gibt es schon ein Konto. Melde dich stattdessen an.';

  @override
  String get authErrWeakPassword => 'Wähle ein sichereres Passwort.';

  @override
  String get authErrDisabled => 'Dieses Konto wurde deaktiviert.';

  @override
  String get authErrNotEnabled =>
      'Die Anmeldung per E-Mail ist gerade nicht verfügbar.';

  @override
  String get authErrTooMany =>
      'Zu viele Versuche. Warte kurz und versuch es noch einmal.';

  @override
  String get authErrNetwork =>
      'Keine Verbindung. Prüfe dein Internet und versuch es noch einmal.';

  @override
  String get authErrGeneric =>
      'Anmeldung fehlgeschlagen. Bitte versuch es noch einmal.';

  @override
  String get deletePasswordBody =>
      'Gib dein Passwort ein, um zu bestätigen, dass du es bist.';

  @override
  String get deleteWrongPassword =>
      'Dieses Passwort passt nicht zu diesem Konto.';

  @override
  String get purchaseSaveTitle => 'Behalte deinen Kauf';

  @override
  String get purchaseSaveBody =>
      'Optional: Melde dich an, um deine Käufe und deinen Fortschritt auf all deinen Geräten zu behalten. Auf diesem Gerät funktioniert dein Kauf schon.';

  @override
  String get purchaseNeedsConnection =>
      'Der Server ist nicht erreichbar. Prüfe deine Verbindung und versuch es noch einmal.';

  @override
  String get languageSystemDefault => 'Systemstandard';

  @override
  String get startupFailed =>
      'BEIM START IST ETWAS SCHIEFGELAUFEN.\nSCHLIESSE DIE APP UND ÖFFNE SIE ERNEUT.';

  @override
  String get notificationChannelDescription =>
      'Erinnerungen ans Tagesblatt und Kontohinweise';

  @override
  String get storeAppStore => 'im App Store';

  @override
  String get storeGooglePlay => 'bei Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Schraube, Platte $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Schraube, Platte $plate, verdeckt von $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled von $total';
  }

  @override
  String get chapterName1 => 'Werkstatt-Grundlagen';

  @override
  String get chapterName2 => 'Schicht für Schicht';

  @override
  String get chapterName3 => 'Platz schaffen';

  @override
  String get chapterName4 => 'Verzahnt';

  @override
  String get chapterName5 => 'Baumeister';

  @override
  String get chapterGoal1 => 'Tippen, lösen, freigeben';

  @override
  String get chapterGoal2 => 'Überlappung und Reihenfolge';

  @override
  String get chapterGoal3 => 'Planen mit knapper Ablage';

  @override
  String get chapterGoal4 => 'Gemeinsame Stützen';

  @override
  String get chapterGoal5 => 'Alles, und immer fair';

  @override
  String get chapterPitch1 =>
      'Tippe auf eine Schraube. Lass eine Platte fallen. Das ist die ganze Regel.';

  @override
  String get chapterPitch2 =>
      'Platten verdecken Platten. Arbeite dich von oben nach unten.';

  @override
  String get chapterPitch3 =>
      'Knappere Ablagen. Plane, welche Schrauben zuerst raus sollen.';

  @override
  String get chapterPitch4 =>
      'Eine Platte hält mehrere fest. Finde das Schlüsselteil.';

  @override
  String get chapterPitch5 =>
      'Tiefe Stapel, alle Ideen auf einmal. Lass dir Zeit.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Zeichnungssatz $number';
  }

  @override
  String get chapterGoalDownloaded => 'Blätter auf Meisterniveau';

  @override
  String get chapterPitchDownloaded => 'Mehr Blätter, dieselben fairen Regeln.';

  @override
  String get mechanicOverlap => 'ÜBERLAPPUNG';

  @override
  String get mechanicTray => 'ABLAGE';

  @override
  String get mechanicLayers => 'SCHICHTEN';

  @override
  String get mechanicCircles => 'KREISE';

  @override
  String get mechanicTraps => 'FALLEN';

  @override
  String get mechanicSupports => 'STÜTZEN';

  @override
  String get sheetObjective004 =>
      'HEB DIE OBERE PLATTE FÜR DIE SCHRAUBE DARUNTER';

  @override
  String get sheetObjective006 =>
      'ABLAGE FÜR 3. GELÖSTE PLATTEN GEBEN PLÄTZE FREI';

  @override
  String get sheetObjective011 => 'DREI SCHICHTEN. ARBEITE VON OBEN NACH UNTEN';

  @override
  String get sheetObjective012 => 'HEB PL-04 VOR DEN PLATTEN DARUNTER';

  @override
  String get sheetObjective017 => 'EIN VERLOCKENDER ZUG FÜLLT DIE ABLAGE';

  @override
  String get sheetObjective021 => 'RUNDE PLATTEN VERDECKEN WIE JEDE ANDERE';

  @override
  String get sheetObjective024 => 'ENTFERNE PL-04, UM AN DIE ECKE ZU KOMMEN';

  @override
  String get sheetObjective041 => 'KNAPPE ABLAGE. LÖSE RECHTZEITIG EINE PLATTE';

  @override
  String get sheetObjective061 => 'EINE PLATTE KANN MEHRERE ANDERE FESTHALTEN';

  @override
  String get sheetObjective081 => 'ALLES, WAS DU GELERNT HAST. LASS DIR ZEIT';

  @override
  String get themeNameBlueprint => 'Klare Blaupause';

  @override
  String get themeNameWalnut => 'Nussbaum-Werkstatt';

  @override
  String get themeNameOcean => 'Ozean-Petrol';

  @override
  String get themeNameCopper => 'Warmes Kupfer';

  @override
  String get themeNameMidnight => 'Mitternachtswerkstatt';

  @override
  String get themeNamePastel => 'Pastellstudio';

  @override
  String sheetTitleNumbered(int number) {
    return 'Blatt $number';
  }

  @override
  String get sheetTitle001 => 'Erste Drehung';

  @override
  String get sheetTitle002 => 'Zwei Punkte';

  @override
  String get sheetTitle003 => 'Seite an Seite';

  @override
  String get sheetTitle004 => 'Abdeckplatte';

  @override
  String get sheetTitle005 => 'Enthüllung';

  @override
  String get sheetTitle006 => 'Ablagetag';

  @override
  String get sheetTitle007 => 'Kleiner Plan';

  @override
  String get sheetTitle008 => 'Passgenau';

  @override
  String get sheetTitle009 => 'Rundmaterial';

  @override
  String get sheetTitle010 => 'Kontrollpunkt';

  @override
  String get sheetTitle011 => 'Dritte Schicht';

  @override
  String get sheetTitle012 => 'Kreuzstrebe';

  @override
  String get sheetTitle013 => 'Ein Platz frei';

  @override
  String get sheetTitle014 => 'Zwei voraus';

  @override
  String get sheetTitle015 => 'Lackierter Stahl';

  @override
  String get sheetTitle016 => 'Werkbank';

  @override
  String get sheetTitle017 => 'Verlockung';

  @override
  String get sheetTitle018 => 'Kaskade';

  @override
  String get sheetTitle019 => 'Werkstattmix';

  @override
  String get sheetTitle020 => 'Baugruppe';

  @override
  String get sheetTitle021 => 'Scheibenstapel';

  @override
  String get sheetTitle022 => 'Dichtung';

  @override
  String get sheetTitle023 => 'Objektivdeckel';

  @override
  String get sheetTitle024 => 'Verdeckter Winkel';

  @override
  String get sheetTitle025 => 'Passscheiben';

  @override
  String get sheetTitle026 => 'Blende';

  @override
  String get sheetTitle027 => 'Tülle';

  @override
  String get sheetTitle028 => 'Verschnaufpause';

  @override
  String get sheetTitle029 => 'Flanschring';

  @override
  String get sheetTitle030 => 'Bullauge';

  @override
  String get sheetTitle031 => 'Abstandshalter';

  @override
  String get sheetTitle032 => 'Stellring';

  @override
  String get sheetTitle033 => 'Endkappe';

  @override
  String get sheetTitle034 => 'Ruhige Schicht';

  @override
  String get sheetTitle035 => 'Schott';

  @override
  String get sheetTitle036 => 'Prüföffnung';

  @override
  String get sheetTitle037 => 'Frontplatte';

  @override
  String get sheetTitle038 => 'Leichter Dienst';

  @override
  String get sheetTitle039 => 'Rosette';

  @override
  String get sheetTitle040 => 'Schichttorte';

  @override
  String get sheetTitle041 => 'Platz schaffen';

  @override
  String get sheetTitle042 => 'Platz im Kasten';

  @override
  String get sheetTitle043 => 'Überlauf';

  @override
  String get sheetTitle044 => 'Fach';

  @override
  String get sheetTitle045 => 'Teilekiste';

  @override
  String get sheetTitle046 => 'Knappes Material';

  @override
  String get sheetTitle047 => 'Schubfach';

  @override
  String get sheetTitle048 => 'Leicht raus';

  @override
  String get sheetTitle049 => 'Einarmiger Bandit';

  @override
  String get sheetTitle050 => 'Volles Haus';

  @override
  String get sheetTitle051 => 'Rückstau';

  @override
  String get sheetTitle052 => 'Reserveplatz';

  @override
  String get sheetTitle053 => 'Freiraum';

  @override
  String get sheetTitle054 => 'Spielpassung';

  @override
  String get sheetTitle055 => 'Inventur';

  @override
  String get sheetTitle056 => 'Zugabe';

  @override
  String get sheetTitle057 => 'Toleranz';

  @override
  String get sheetTitle058 => 'Freier Tag';

  @override
  String get sheetTitle059 => 'Kopffreiheit';

  @override
  String get sheetTitle060 => 'Lager';

  @override
  String get sheetTitle061 => 'Verriegelung';

  @override
  String get sheetTitle062 => 'Knotenblech';

  @override
  String get sheetTitle063 => 'Schlussstein';

  @override
  String get sheetTitle064 => 'Überblattung';

  @override
  String get sheetTitle065 => 'Laschenplatte';

  @override
  String get sheetTitle066 => 'Schwalbenschwanz';

  @override
  String get sheetTitle067 => 'Sturz';

  @override
  String get sheetTitle068 => 'Verschnitt';

  @override
  String get sheetTitle069 => 'Strebe';

  @override
  String get sheetTitle070 => 'Fachwerk';

  @override
  String get sheetTitle071 => 'Gabelkopf';

  @override
  String get sheetTitle072 => 'Joch';

  @override
  String get sheetTitle073 => 'Sattel';

  @override
  String get sheetTitle074 => 'Fundament';

  @override
  String get sheetTitle075 => 'Winkelpaar';

  @override
  String get sheetTitle076 => 'Spannleiste';

  @override
  String get sheetTitle077 => 'Verbindungsblech';

  @override
  String get sheetTitle078 => 'Schlichte Platte';

  @override
  String get sheetTitle079 => 'Auskragung';

  @override
  String get sheetTitle080 => 'Rahmentragwerk';

  @override
  String get sheetTitle081 => 'Masterplan';

  @override
  String get sheetTitle082 => 'Unterbaugruppe';

  @override
  String get sheetTitle083 => 'Explosionsansicht';

  @override
  String get sheetTitle084 => 'Passprobe';

  @override
  String get sheetTitle085 => 'Anzugsmoment';

  @override
  String get sheetTitle086 => 'Schablone';

  @override
  String get sheetTitle087 => 'Vorrichtung';

  @override
  String get sheetTitle088 => 'Ruhige Werkbank';

  @override
  String get sheetTitle089 => 'Getriebe';

  @override
  String get sheetTitle090 => 'Gehäuse';

  @override
  String get sheetTitle091 => 'Fahrgestell';

  @override
  String get sheetTitle092 => 'Paneelfeld';

  @override
  String get sheetTitle093 => 'Deckelsatz';

  @override
  String get sheetTitle094 => 'Sanftes Drehmoment';

  @override
  String get sheetTitle095 => 'Motorlager';

  @override
  String get sheetTitle096 => 'Schaltanlage';

  @override
  String get sheetTitle097 => 'Steuerkasten';

  @override
  String get sheetTitle098 => 'Zeichentisch';

  @override
  String get sheetTitle099 => 'Endabnahme';

  @override
  String get sheetTitle100 => 'Freigabe';
}
