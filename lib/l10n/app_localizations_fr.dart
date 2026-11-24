// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Pause';

  @override
  String get back => 'Retour';

  @override
  String get settings => 'Paramètres';

  @override
  String get tray => 'PLATEAU';

  @override
  String get trayFull => 'PLATEAU PLEIN';

  @override
  String get undo => 'ANNULER';

  @override
  String hintCount(String count) {
    return 'INDICE · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'En pause';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · COUP $moves';
  }

  @override
  String get resume => 'Reprendre';

  @override
  String get sound => 'SON';

  @override
  String get haptics => 'VIBRATIONS';

  @override
  String get reducedMotion => 'MOUVEMENTS RÉDUITS';

  @override
  String get restart => 'RECOMMENCER';

  @override
  String get exitToSheets => 'VERS LES PLANCHES';

  @override
  String get restartConfirmTitle => 'Recommencer cette planche ?';

  @override
  String restartConfirmBody(int moves) {
    return 'Vous perdrez $moves coups de progression.';
  }

  @override
  String get cancel => 'ANNULER';

  @override
  String get stuckTitle => 'Plus aucun emplacement libre.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vis',
      one: 'une vis',
    );
    return '$plate retient encore $_temp0 sur la planche. Annuler libère un emplacement.';
  }

  @override
  String get stuckReasonGeneric =>
      'Tous les emplacements sont pris et aucune plaque ne peut tomber. Annuler libère un emplacement.';

  @override
  String get undoLastMove => 'Annuler le dernier coup';

  @override
  String rescueSlotCoins(int coins) {
    return '+1 EMPLACEMENT · $coins ¢';
  }

  @override
  String get rescueSlotAd => '+1 EMPLACEMENT · VIDÉO';

  @override
  String get rescueSlotPro => '+1 EMPLACEMENT · PRO';

  @override
  String get outOfHintsTitle => 'Encore un indice ?';

  @override
  String get hintsLeftZero => 'INDICES · 0 RESTANT';

  @override
  String get outOfHintsBody =>
      'Un indice entoure une vis utile pour la suite. Il ne résout jamais la planche.';

  @override
  String get watchVideo => 'Regarder une courte vidéo';

  @override
  String get watchVideoMeta => 'FACULTATIF · ~30 S · +1 INDICE';

  @override
  String useCoins(int coins) {
    return 'Utiliser $coins pièces';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'SOLDE $balance ¢';
  }

  @override
  String get keepThinking => 'Réfléchir encore';

  @override
  String get notEnoughCoins => 'Pas encore assez de pièces.';

  @override
  String get adUnavailable => 'Aucune vidéo disponible pour le moment.';

  @override
  String cleared(String code) {
    return '$code · TERMINÉE';
  }

  @override
  String get disassembled => 'Démonté.';

  @override
  String get approved => 'APPROUVÉ';

  @override
  String get statMoves => 'COUPS';

  @override
  String get statTime => 'TEMPS';

  @override
  String get statMastery => 'MAÎTRISE';

  @override
  String nextSheet(String code) {
    return 'Suivante · $code';
  }

  @override
  String get replay => 'REJOUER';

  @override
  String get sheets => 'PLANCHES';

  @override
  String get backHome => 'Retour à l\'accueil';

  @override
  String chapterComplete(String chapter) {
    return 'CHAPITRE $chapter · TERMINÉ';
  }

  @override
  String get themeUnlocked => 'THÈME DÉBLOQUÉ';

  @override
  String nextChapter(String chapter) {
    return 'SUITE · CHAPITRE $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Commencer le chapitre $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'APPLIQUER $name';
  }

  @override
  String get tutorialStep1 => 'ÉTAPE 1 · TOUCHEZ LA VIS';

  @override
  String get tutorialLands => '↓ ELLE ATTERRIT DANS LE PLATEAU';

  @override
  String get skipTutorial => 'PASSER LE TUTO';

  @override
  String get splashTagline => 'UN PUZZLE EN COUCHES';

  @override
  String get splashFooter => 'RÉV. 1.0 · PLANCHE 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLAQUES',
      one: '$plates PLAQUE',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'FIXATIONS',
      one: 'FIXATION',
    );
    return 'FIG. 1\nVUE ÉCLATÉE\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'CHAPITRE $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'FIXATIONS',
      one: 'FIXATION',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'PLANCHE SUIVANTE';

  @override
  String chapterLabel(String chapter) {
    return 'CHAPITRE $chapter';
  }

  @override
  String get campaign => 'CAMPAGNE';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Continuer · $code';
  }

  @override
  String get daily => 'DU JOUR';

  @override
  String get themes => 'THÈMES';

  @override
  String get allCleared => 'Toutes les planches terminées';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total PLANCHES';
  }

  @override
  String get fiveChapters => 'Cinq chapitres';

  @override
  String get chaptersTitle => 'Chapitres';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'VERROUILLÉ';

  @override
  String get downloadChapter => 'TÉLÉCHARGER';

  @override
  String get downloading => 'TÉLÉCHARGEMENT…';

  @override
  String get comingSoon => 'D\'AUTRES PLANCHES BIENTÔT';

  @override
  String newMechanic(String mechanic) {
    return 'NOUVEAU : $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates plaques',
      one: '$plates plaque',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers couches',
      one: '$layers couche',
    );
    return '$_temp0 · $_temp1 · plateau $tray';
  }

  @override
  String get theCampaign => 'LA CAMPAGNE';

  @override
  String get campaignFooter =>
      'Chaque chapitre se débloque en terminant le précédent. Les marques de maîtrise sont facultatives. Les indices ne bloquent jamais la progression.';

  @override
  String get chapterBonus => 'BONUS DE CHAPITRE';

  @override
  String get dailySheet => 'PLANCHE DU JOUR';

  @override
  String get dailyTitle => 'TITRE';

  @override
  String get dailyPlates => 'PLAQUES';

  @override
  String get dailyReward => 'PRIME';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'Série de $streak jours.',
      one: 'Série de 1 jour.',
      zero: 'Lancez une série.',
    );
    return 'La même planche pour tout le monde aujourd\'hui. Pas de chrono. $_temp0 Manquer un jour ne coûte rien.';
  }

  @override
  String get startDaily => 'Jouer la planche du jour';

  @override
  String get dailyCompleted => 'Fini pour aujourd\'hui · à demain';

  @override
  String get replayDaily => 'Rejouer la planche du jour';

  @override
  String get themesTitle => 'Thèmes';

  @override
  String get themesCaption => 'ESTHÉTIQUE · NE CHANGE JAMAIS LES RÈGLES';

  @override
  String get equipped => 'APPLIQUÉ';

  @override
  String get owned => 'ACQUIS';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'APERÇU';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get feedbackSection => 'SON ET VIBRATIONS';

  @override
  String get soundEffects => 'Effets sonores';

  @override
  String get music => 'Musique';

  @override
  String get hapticsRow => 'Vibrations';

  @override
  String get reducedMotionRow => 'Mouvements réduits';

  @override
  String get reducedMotionCaption => 'Fondus au lieu de déplacements';

  @override
  String get generalSection => 'GÉNÉRAL';

  @override
  String get highRefreshRate => 'Taux de rafraîchissement élevé';

  @override
  String highRefreshRateOn(int hz) {
    return 'Animation plus fluide · jusqu\'à $hz Hz · consomme plus de batterie';
  }

  @override
  String get highRefreshRateOff =>
      'Animation plus fluide · consomme plus de batterie';

  @override
  String get highRefreshRateUnsupported =>
      'Cet écran fonctionne à une seule fréquence';

  @override
  String get highRefreshRateBattery =>
      'Limité pour le moment par l\'économiseur de batterie';

  @override
  String get highRefreshRateHeat => 'Limité tant que le téléphone est chaud';

  @override
  String highRefreshRateNow(int hz) {
    return 'Actuellement $hz Hz';
  }

  @override
  String get language => 'Langue';

  @override
  String get notifications => 'Rappel quotidien';

  @override
  String get notificationsCaption =>
      'Un petit rappel quand une nouvelle planche sort';

  @override
  String get accountSection => 'COMPTE';

  @override
  String get signInGoogle => 'Se connecter avec Google';

  @override
  String get signInApple => 'Se connecter avec Apple';

  @override
  String signedInAs(String name) {
    return 'Connecté · $name';
  }

  @override
  String get guestCaption =>
      'MODE INVITÉ · CONNECTEZ-VOUS POUR SAUVEGARDER VOTRE PROGRESSION';

  @override
  String get signOut => 'DÉCONNEXION';

  @override
  String get deleteAccount => 'SUPPRIMER LE COMPTE';

  @override
  String get purchasesSection => 'ACHATS';

  @override
  String get removeAds => 'Supprimer les pubs';

  @override
  String get restore => 'RESTAURER';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'SANS PUB · INDICES ILLIMITÉS · TOUS LES THÈMES · SAUVETAGES OFFERTS · $coins ¢ PAR MOIS';
  }

  @override
  String get proMonthly => 'MENSUEL';

  @override
  String get proYearly => 'ANNUEL';

  @override
  String proTrialDays(int days) {
    return '$days JOURS OFFERTS';
  }

  @override
  String proThenPrice(String price) {
    return 'PUIS $price';
  }

  @override
  String get proTrialTerms =>
      'Renouvellement automatique après l\'essai gratuit, sauf résiliation. Les pièces mensuelles commencent avec votre premier paiement.';

  @override
  String get proActive => 'PRO · ACTIF';

  @override
  String get adsRemoved => 'PUBS SUPPRIMÉES';

  @override
  String get coinPacks => 'PACKS DE PIÈCES';

  @override
  String get aboutSection => 'À PROPOS';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get refundPolicy => 'Politique de remboursement';

  @override
  String get privacyChoices => 'Choix de confidentialité';

  @override
  String get licenses => 'Licences et crédits';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · RÉV. $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Un rappel pour la planche du jour ?';

  @override
  String get notificationPrimerBody =>
      'Un rappel discret quand vous n\'avez pas joué. Jamais plus d\'un par jour.';

  @override
  String get allow => 'AUTORISER';

  @override
  String get notNow => 'PLUS TARD';

  @override
  String get somethingWentWrong => 'Un problème est survenu.';

  @override
  String get purchaseThanks => 'Merci ! Achat appliqué.';

  @override
  String get purchasePending =>
      'Achat en attente. Il sera appliqué une fois confirmé.';

  @override
  String get purchaseFailed => 'L\'achat n\'a pas abouti.';

  @override
  String get restored => 'Achats restaurés.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Terminez d\'abord le chapitre $chapter.';
  }

  @override
  String get moreSheetsTitle => 'Plus de planches';

  @override
  String get moreSheetsCaption => 'Les nouvelles séries de plans arrivent ici';

  @override
  String get equip => 'APPLIQUER';

  @override
  String buyFor(int coins) {
    return 'ACHETER · $coins ¢';
  }

  @override
  String get close => 'FERMER';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Licences';

  @override
  String get licensesCaption => 'MENTIONS OPEN SOURCE';

  @override
  String playLevel(String code) {
    return 'Jouer $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Planche $number, verrouillée';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Classements';

  @override
  String get leaderboardCaption => 'JOUEURS CONNECTÉS · EN DIRECT';

  @override
  String get boardSheets => 'PLANCHES';

  @override
  String get boardDaily => 'JOUR';

  @override
  String get boardStreak => 'SÉRIE';

  @override
  String get boardWeekly => 'SEMAINE';

  @override
  String get boardWeeklyHint =>
      'PLANCHES TERMINÉES CETTE SEMAINE · REMISE À ZÉRO LE LUNDI';

  @override
  String get boardSheetsHint => 'LE PLUS DE PLANCHES TERMINÉES';

  @override
  String get boardDailyHint =>
      'PLANCHE DU JOUR · MOINS DE COUPS, PUIS LE PLUS RAPIDE';

  @override
  String get boardStreakHint => 'JOURS D\'AFFILÉE SUR LA PLANCHE DU JOUR';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'COUPS',
      one: 'COUP',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'JOURS',
      one: 'JOUR',
    );
    return '$_temp0 · RECORD $best';
  }

  @override
  String get boardYou => 'VOUS';

  @override
  String get boardYourRank => 'VOTRE RANG';

  @override
  String get boardNotRanked => 'Pas encore classé';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'SUR $countString';
  }

  @override
  String get boardGuest =>
      'Connectez-vous pour inscrire votre nom au classement. Votre progression vous suit.';

  @override
  String get boardEmpty => 'Personne pour l\'instant. Soyez le premier.';

  @override
  String get boardOffline =>
      'Impossible de joindre le classement pour le moment.';

  @override
  String get tryAgainCaps => 'RÉESSAYER';

  @override
  String get todaysBoard => 'CLASSEMENT DU JOUR';

  @override
  String get signedOutToast =>
      'Déconnecté · les données de cet appareil ont été effacées. Reconnectez-vous pour retrouver votre progression.';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String welcomeBackName(String name) {
    return 'Bon retour, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets planches',
      one: '$sheets planche',
    );
    return '$who · $_temp0 et $coins pièces restaurées';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · vous êtes connecté et votre progression est sauvegardée';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets planches',
      one: '$sheets planche',
    );
    return '$who · la progression de cet appareil a été ajoutée à votre compte : $_temp0, $coins pièces';
  }

  @override
  String syncSavedNew(String name) {
    return 'Connecté en tant que $name · votre progression est désormais enregistrée sur votre compte';
  }

  @override
  String get syncSavedNewPlain =>
      'Connecté · votre progression est désormais enregistrée sur votre compte';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets nouvelles planches',
      one: '$sheets nouvelle planche',
      zero: 'progression mise à jour',
    );
    return 'Synchronisé depuis votre autre appareil · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Impossible de charger votre progression pour l\'instant · elle se synchronisera automatiquement au retour de la connexion';

  @override
  String get signedInOffline =>
      'Connecté · votre progression se synchronisera dès que vous serez en ligne';

  @override
  String get proActivated =>
      'Pro est actif · sans pub, tous les thèmes et indices illimités';

  @override
  String get accountDeletedToast =>
      'Votre compte et toutes ses données ont été supprimés.';

  @override
  String accountDeletedProToast(String store) {
    return 'Compte supprimé. Pro reste facturé tant que vous ne l\'avez pas résilié sur $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'SÉRIE DE $days JOURS · BONUS DE +$coins';
  }

  @override
  String get workshopRecord => 'Carnet d\'atelier';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Carnet d\'atelier · $earned/$total';
  }

  @override
  String get recordCaption => 'ÉTAPES CLÉS';

  @override
  String recordEarned(int earned, int total) {
    return '$earned SUR $total OBTENUS';
  }

  @override
  String get badgeEarnedLabel => 'OBTENU';

  @override
  String badgeEarnedToast(String name) {
    return 'Badge obtenu · $name';
  }

  @override
  String get badgeFirstTurn => 'Premier tour';

  @override
  String get badgeApprentice => 'Apprenti';

  @override
  String get badgeJourneyman => 'Compagnon';

  @override
  String get badgeCraftsman => 'Artisan';

  @override
  String get badgeChiefEngineer => 'Ingénieur en chef';

  @override
  String get badgeCleanWork => 'Travail propre';

  @override
  String get badgePerfectionist => 'Perfectionniste';

  @override
  String get badgeRegular => 'Habitué';

  @override
  String get badgeOnARoll => 'Sur la lancée';

  @override
  String get badgeFullWeek => 'Semaine complète';

  @override
  String get badgeFortnight => 'Quinzaine';

  @override
  String get badgeFirstDetail => 'Terminez votre première planche';

  @override
  String badgeClearDetail(int n) {
    return 'Terminez $n planches';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Finissez le chapitre $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Obtenez ◆ sur $n planches';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Jouez $n planches du jour';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Atteignez une série de $n jours';
  }

  @override
  String get share => 'PARTAGER';

  @override
  String get shareResult => 'Partager le résultat';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves coups',
      one: '$moves coup',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'Série de $days jours';
  }

  @override
  String get signOutSheetTitle => 'Se déconnecter ?';

  @override
  String get signOutSheetBody =>
      'Se déconnecter efface votre progression de cet appareil. Tout ce qui est déjà sauvegardé revient quand vous vous reconnectez, mais ce qui n\'est pas encore synchronisé (par exemple des planches jouées hors ligne) serait perdu.';

  @override
  String get staySignedIn => 'Rester connecté';

  @override
  String get signOutConfirm => 'Se déconnecter';

  @override
  String get rateApp => 'Noter Screw Out';

  @override
  String get sendFeedback => 'Envoyer un avis';

  @override
  String get replayTutorial => 'Revoir le tutoriel';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Aucune app d\'e-mail trouvée. Écrivez-nous à $email';
  }

  @override
  String get updateChip => 'MISE À JOUR';

  @override
  String get updateReadyRestart =>
      'Mise à jour téléchargée. Redémarrez pour l\'installer.';

  @override
  String get deleteSheetTitle => 'Supprimer votre compte ?';

  @override
  String get deleteSheetBody =>
      'Cela supprime définitivement votre compte et tout ce qui y est enregistré : la progression de chaque planche, les pièces, les thèmes, votre série quotidienne et vos places au classement. C\'est irréversible.';

  @override
  String deleteSheetPro(String store) {
    return 'Vous avez Screw Out Pro. Supprimer votre compte ne le résilie pas : résiliez l\'abonnement sur $store, sinon vous continuerez d\'être facturé.';
  }

  @override
  String get manageSubscription => 'Gérer l\'abonnement';

  @override
  String get deleteForever => 'Supprimer mon compte';

  @override
  String get deleting => 'Suppression…';

  @override
  String get keepAccount => 'Garder mon compte';

  @override
  String get deleteOffline =>
      'Vous êtes hors ligne. Connectez-vous à Internet pour supprimer votre compte.';

  @override
  String get deleteFailed =>
      'Impossible de supprimer votre compte. Veuillez réessayer.';

  @override
  String get restoreNothing => 'Rien à restaurer sur ce compte.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 indice';
  }

  @override
  String get hintEarnedToast => '+1 indice · merci d\'avoir regardé';

  @override
  String get rescueToast => '+1 emplacement de plateau pour cette planche';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 emplacement de plateau';
  }

  @override
  String get adNotCompleted =>
      'La vidéo n\'est pas allée jusqu\'au bout, pas de récompense cette fois.';

  @override
  String themeEquippedToast(String name) {
    return '$name appliqué';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'Le chapitre $chapter est prêt';
  }

  @override
  String get signInFailed => 'La connexion n\'a pas abouti.';

  @override
  String get themePurchased => 'Thème débloqué.';

  @override
  String themeBuyStore(String price) {
    return 'OU ACHETER · $price';
  }

  @override
  String get themesBundleTitle => 'Tous les thèmes';

  @override
  String get themesBundleBody =>
      'Tous les thèmes payants, à vous pour de bon. Pro les inclut aussi.';

  @override
  String themesBundleBuy(String price) {
    return 'ACHETER · $price';
  }

  @override
  String get dailyWeekDone => 'Fait';

  @override
  String masteredCount(int count) {
    return '$count MAÎTRISÉES';
  }

  @override
  String get reminderTitle => 'La planche du jour est prête';

  @override
  String get reminderBody =>
      'Un nouveau plan, le même pour tous. Pas de chrono.';

  @override
  String get comebackReminderTitle =>
      'Votre prochaine planche vous attend sur l\'établi';

  @override
  String get comebackReminderBody =>
      'Quelques minutes au calme, quelques vis. Reprenez là où vous en étiez.';

  @override
  String get signInEmail => 'Continuer avec un e-mail';

  @override
  String get emailSignInTitle => 'Se connecter';

  @override
  String get emailCreateTitle => 'Créer un compte';

  @override
  String get emailTabSignIn => 'CONNEXION';

  @override
  String get emailTabCreate => 'CRÉER UN COMPTE';

  @override
  String get emailSheetBody => 'Votre progression sur cet appareil vous suit.';

  @override
  String get emailLabel => 'E-MAIL';

  @override
  String get passwordLabel => 'MOT DE PASSE';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String passwordHint(int min) {
    return 'Au moins $min caractères';
  }

  @override
  String get emailRequired => 'Saisissez votre e-mail.';

  @override
  String get emailInvalid => 'Cette adresse e-mail semble incorrecte.';

  @override
  String get passwordRequired => 'Saisissez votre mot de passe.';

  @override
  String passwordTooShort(int min) {
    return 'Utilisez au moins $min caractères.';
  }

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotNeedsEmail =>
      'Saisissez votre e-mail ci-dessus, puis touchez Mot de passe oublié.';

  @override
  String resetSent(String email) {
    return 'Si $email a un compte, un lien de réinitialisation est en route.';
  }

  @override
  String get emailWorking => 'Un instant…';

  @override
  String get authErrWrongCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get authErrEmailInUse =>
      'Cet e-mail a déjà un compte. Connectez-vous plutôt.';

  @override
  String get authErrWeakPassword => 'Choisissez un mot de passe plus solide.';

  @override
  String get authErrDisabled => 'Ce compte a été désactivé.';

  @override
  String get authErrNotEnabled =>
      'La connexion par e-mail n\'est pas disponible pour le moment.';

  @override
  String get authErrTooMany =>
      'Trop de tentatives. Patientez un instant et réessayez.';

  @override
  String get authErrNetwork =>
      'Pas de connexion. Vérifiez votre accès à Internet et réessayez.';

  @override
  String get authErrGeneric => 'Connexion impossible. Veuillez réessayer.';

  @override
  String get deletePasswordBody =>
      'Saisissez votre mot de passe pour confirmer que c\'est bien vous.';

  @override
  String get deleteWrongPassword =>
      'Ce mot de passe ne correspond pas à ce compte.';

  @override
  String get purchaseSaveTitle => 'Gardez votre achat';

  @override
  String get purchaseSaveBody =>
      'Facultatif : connectez-vous pour garder vos achats et votre progression sur tous vos appareils. Votre achat fonctionne déjà sur celui-ci.';

  @override
  String get purchaseNeedsConnection =>
      'Impossible de joindre le serveur. Vérifiez votre connexion et réessayez.';

  @override
  String get languageSystemDefault => 'Langue du système';

  @override
  String get startupFailed =>
      'UN PROBLÈME EST SURVENU AU DÉMARRAGE.\nFERMEZ L\'APP ET ROUVREZ-LA.';

  @override
  String get notificationChannelDescription =>
      'Rappels de la planche du jour et avis concernant le compte';

  @override
  String get storeAppStore => 'l\'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Vis, plaque $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Vis, plaque $plate, bloquée par $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled sur $total';
  }

  @override
  String get chapterName1 => 'Les bases de l\'atelier';

  @override
  String get chapterName2 => 'Couche par couche';

  @override
  String get chapterName3 => 'Faites de la place';

  @override
  String get chapterName4 => 'Imbrications';

  @override
  String get chapterName5 => 'Maître bâtisseur';

  @override
  String get chapterGoal1 => 'Toucher, retirer, libérer';

  @override
  String get chapterGoal2 => 'Chevauchement et ordre';

  @override
  String get chapterGoal3 => 'Plateau serré, à anticiper';

  @override
  String get chapterGoal4 => 'Supports partagés';

  @override
  String get chapterGoal5 => 'Tout, en toute équité';

  @override
  String get chapterPitch1 =>
      'Touchez une vis. Libérez une plaque. C\'est toute la règle.';

  @override
  String get chapterPitch2 =>
      'Les plaques en cachent d\'autres. Travaillez de haut en bas.';

  @override
  String get chapterPitch3 =>
      'Plateaux plus serrés. Choisissez quelles vis retirer en premier.';

  @override
  String get chapterPitch4 =>
      'Une plaque en retient plusieurs. Trouvez la pièce maîtresse.';

  @override
  String get chapterPitch5 =>
      'Piles profondes, toutes les idées à la fois. Prenez votre temps.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Série de plans $number';
  }

  @override
  String get chapterGoalDownloaded => 'Planches de niveau maître';

  @override
  String get chapterPitchDownloaded =>
      'Plus de planches, mêmes règles équitables.';

  @override
  String get mechanicOverlap => 'CHEVAUCHEMENT';

  @override
  String get mechanicTray => 'PLATEAU';

  @override
  String get mechanicLayers => 'COUCHES';

  @override
  String get mechanicCircles => 'CERCLES';

  @override
  String get mechanicTraps => 'PIÈGES';

  @override
  String get mechanicSupports => 'SUPPORTS';

  @override
  String get sheetObjective004 =>
      'RETIREZ LA PLAQUE DU HAUT POUR ATTEINDRE LA VIS';

  @override
  String get sheetObjective006 =>
      'PLATEAU DE 3. UNE PLAQUE LIBÉRÉE REND SES PLACES';

  @override
  String get sheetObjective011 => 'TROIS COUCHES. TRAVAILLEZ DE HAUT EN BAS';

  @override
  String get sheetObjective012 => 'RETIREZ PL-04 AVANT LES PLAQUES DESSOUS';

  @override
  String get sheetObjective017 => 'UN COUP TENTANT REMPLIT LE PLATEAU';

  @override
  String get sheetObjective021 =>
      'LES PLAQUES RONDES COUVRENT COMME LES AUTRES';

  @override
  String get sheetObjective024 => 'RETIREZ PL-04 POUR ATTEINDRE LE COIN';

  @override
  String get sheetObjective041 => 'PLATEAU SERRÉ. LIBÉREZ UNE PLAQUE À TEMPS';

  @override
  String get sheetObjective061 => 'UNE PLAQUE PEUT EN RETENIR PLUSIEURS AUTRES';

  @override
  String get sheetObjective081 =>
      'TOUT CE QUE VOUS AVEZ APPRIS. PRENEZ VOTRE TEMPS';

  @override
  String get themeNameBlueprint => 'Plan épuré';

  @override
  String get themeNameWalnut => 'Atelier noyer';

  @override
  String get themeNameOcean => 'Océan turquoise';

  @override
  String get themeNameCopper => 'Cuivre chaud';

  @override
  String get themeNameMidnight => 'Atelier de minuit';

  @override
  String get themeNamePastel => 'Studio pastel';

  @override
  String sheetTitleNumbered(int number) {
    return 'Planche $number';
  }

  @override
  String get sheetTitle001 => 'Premier tour';

  @override
  String get sheetTitle002 => 'Deux points';

  @override
  String get sheetTitle003 => 'Côte à côte';

  @override
  String get sheetTitle004 => 'Cache';

  @override
  String get sheetTitle005 => 'Révélation';

  @override
  String get sheetTitle006 => 'Jour de plateau';

  @override
  String get sheetTitle007 => 'Petit plan';

  @override
  String get sheetTitle008 => 'Ajustement serré';

  @override
  String get sheetTitle009 => 'Barre ronde';

  @override
  String get sheetTitle010 => 'Point de contrôle';

  @override
  String get sheetTitle011 => 'Troisième couche';

  @override
  String get sheetTitle012 => 'Croisillon';

  @override
  String get sheetTitle013 => 'Libérer une place';

  @override
  String get sheetTitle014 => 'Deux d\'avance';

  @override
  String get sheetTitle015 => 'Acier peint';

  @override
  String get sheetTitle016 => 'Établi';

  @override
  String get sheetTitle017 => 'Tentation';

  @override
  String get sheetTitle018 => 'Cascade';

  @override
  String get sheetTitle019 => 'Mélange d\'atelier';

  @override
  String get sheetTitle020 => 'Assemblage';

  @override
  String get sheetTitle021 => 'Pile de rondelles';

  @override
  String get sheetTitle022 => 'Joint';

  @override
  String get sheetTitle023 => 'Cache objectif';

  @override
  String get sheetTitle024 => 'Équerre cachée';

  @override
  String get sheetTitle025 => 'Jeu de cales';

  @override
  String get sheetTitle026 => 'Lunette';

  @override
  String get sheetTitle027 => 'Œillet';

  @override
  String get sheetTitle028 => 'Petite pause';

  @override
  String get sheetTitle029 => 'Anneau de bride';

  @override
  String get sheetTitle030 => 'Hublot';

  @override
  String get sheetTitle031 => 'Entretoise';

  @override
  String get sheetTitle032 => 'Collier';

  @override
  String get sheetTitle033 => 'Embout';

  @override
  String get sheetTitle034 => 'Poste tranquille';

  @override
  String get sheetTitle035 => 'Cloison';

  @override
  String get sheetTitle036 => 'Trappe de visite';

  @override
  String get sheetTitle037 => 'Plaque avant';

  @override
  String get sheetTitle038 => 'Usage léger';

  @override
  String get sheetTitle039 => 'Rosace';

  @override
  String get sheetTitle040 => 'Mille-feuille';

  @override
  String get sheetTitle041 => 'Faites de la place';

  @override
  String get sheetTitle042 => 'Place au bac';

  @override
  String get sheetTitle043 => 'Trop-plein';

  @override
  String get sheetTitle044 => 'Casier';

  @override
  String get sheetTitle045 => 'Bac à pièces';

  @override
  String get sheetTitle046 => 'Stock réduit';

  @override
  String get sheetTitle047 => 'Case';

  @override
  String get sheetTitle048 => 'Sortie facile';

  @override
  String get sheetTitle049 => 'Machine à sous';

  @override
  String get sheetTitle050 => 'Salle comble';

  @override
  String get sheetTitle051 => 'En attente';

  @override
  String get sheetTitle052 => 'Place de secours';

  @override
  String get sheetTitle053 => 'Dégagement';

  @override
  String get sheetTitle054 => 'Jeu libre';

  @override
  String get sheetTitle055 => 'Inventaire';

  @override
  String get sheetTitle056 => 'Marge';

  @override
  String get sheetTitle057 => 'Tolérance';

  @override
  String get sheetTitle058 => 'Jour de repos';

  @override
  String get sheetTitle059 => 'Hauteur libre';

  @override
  String get sheetTitle060 => 'Rangement';

  @override
  String get sheetTitle061 => 'Verrouillage';

  @override
  String get sheetTitle062 => 'Gousset';

  @override
  String get sheetTitle063 => 'Clé de voûte';

  @override
  String get sheetTitle064 => 'Mi-bois';

  @override
  String get sheetTitle065 => 'Éclisse';

  @override
  String get sheetTitle066 => 'Queue d\'aronde';

  @override
  String get sheetTitle067 => 'Linteau';

  @override
  String get sheetTitle068 => 'Chute';

  @override
  String get sheetTitle069 => 'Étai';

  @override
  String get sheetTitle070 => 'Treillis';

  @override
  String get sheetTitle071 => 'Chape';

  @override
  String get sheetTitle072 => 'Joug';

  @override
  String get sheetTitle073 => 'Selle';

  @override
  String get sheetTitle074 => 'Semelle';

  @override
  String get sheetTitle075 => 'Paire d\'équerres';

  @override
  String get sheetTitle076 => 'Barre de serrage';

  @override
  String get sheetTitle077 => 'Plaque de liaison';

  @override
  String get sheetTitle078 => 'Panneau simple';

  @override
  String get sheetTitle079 => 'Porte-à-faux';

  @override
  String get sheetTitle080 => 'Cadre rigide';

  @override
  String get sheetTitle081 => 'Plan directeur';

  @override
  String get sheetTitle082 => 'Sous-ensemble';

  @override
  String get sheetTitle083 => 'Vue éclatée';

  @override
  String get sheetTitle084 => 'Essai d\'ajustage';

  @override
  String get sheetTitle085 => 'Couple de serrage';

  @override
  String get sheetTitle086 => 'Gabarit';

  @override
  String get sheetTitle087 => 'Montage';

  @override
  String get sheetTitle088 => 'Établi tranquille';

  @override
  String get sheetTitle089 => 'Boîte de vitesses';

  @override
  String get sheetTitle090 => 'Carter';

  @override
  String get sheetTitle091 => 'Châssis';

  @override
  String get sheetTitle092 => 'Baie de panneaux';

  @override
  String get sheetTitle093 => 'Jeu de capots';

  @override
  String get sheetTitle094 => 'Serrage doux';

  @override
  String get sheetTitle095 => 'Support moteur';

  @override
  String get sheetTitle096 => 'Appareillage';

  @override
  String get sheetTitle097 => 'Boîte de commande';

  @override
  String get sheetTitle098 => 'Table à dessin';

  @override
  String get sheetTitle099 => 'Inspection finale';

  @override
  String get sheetTitle100 => 'Bon pour accord';
}
