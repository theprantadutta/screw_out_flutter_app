// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Pausa';

  @override
  String get back => 'Atrás';

  @override
  String get settings => 'Ajustes';

  @override
  String get tray => 'BANDEJA';

  @override
  String get trayFull => 'BANDEJA LLENA';

  @override
  String get undo => 'DESHACER';

  @override
  String hintCount(String count) {
    return 'PISTA · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'En pausa';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · MOVIMIENTO $moves';
  }

  @override
  String get resume => 'Continuar';

  @override
  String get sound => 'SONIDO';

  @override
  String get haptics => 'VIBRACIÓN';

  @override
  String get reducedMotion => 'MENOS MOVIMIENTO';

  @override
  String get restart => 'REINICIAR';

  @override
  String get exitToSheets => 'SALIR A LÁMINAS';

  @override
  String get restartConfirmTitle => '¿Reiniciar esta lámina?';

  @override
  String restartConfirmBody(int moves) {
    return 'Perderás $moves movimientos de progreso.';
  }

  @override
  String get cancel => 'CANCELAR';

  @override
  String get stuckTitle => 'No quedan ranuras libres.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tornillos',
      one: 'un tornillo',
    );
    return '$plate aún sujeta $_temp0 en el tablero. Deshacer libera una ranura.';
  }

  @override
  String get stuckReasonGeneric =>
      'Todas las ranuras están ocupadas y ninguna placa puede caer. Deshacer libera una ranura.';

  @override
  String get undoLastMove => 'Deshacer última jugada';

  @override
  String rescueSlotCoins(int coins) {
    return 'RANURA EXTRA · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'RANURA EXTRA · VIDEO';

  @override
  String get rescueSlotPro => 'RANURA EXTRA · PRO';

  @override
  String get outOfHintsTitle => '¿Quieres otra pista?';

  @override
  String get hintsLeftZero => 'PISTAS · QUEDAN 0';

  @override
  String get outOfHintsBody =>
      'Una pista marca con un círculo un tornillo útil. Nunca resuelve la lámina.';

  @override
  String get watchVideo => 'Mira un video corto';

  @override
  String get watchVideoMeta => 'OPCIONAL · ~30 S · +1 PISTA';

  @override
  String useCoins(int coins) {
    return 'Usar $coins monedas';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'SALDO $balance ¢';
  }

  @override
  String get keepThinking => 'Seguir pensando';

  @override
  String get notEnoughCoins => 'Aún no tienes suficientes monedas.';

  @override
  String get adUnavailable => 'No hay videos disponibles ahora.';

  @override
  String cleared(String code) {
    return '$code · COMPLETADA';
  }

  @override
  String get disassembled => 'Desmontado.';

  @override
  String get approved => 'APROBADO';

  @override
  String get statMoves => 'MOVIMIENTOS';

  @override
  String get statTime => 'TIEMPO';

  @override
  String get statMastery => 'MAESTRÍA';

  @override
  String nextSheet(String code) {
    return 'Siguiente · $code';
  }

  @override
  String get replay => 'REPETIR';

  @override
  String get sheets => 'LÁMINAS';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String chapterComplete(String chapter) {
    return 'CAPÍTULO $chapter · COMPLETADO';
  }

  @override
  String get themeUnlocked => 'TEMA DESBLOQUEADO';

  @override
  String nextChapter(String chapter) {
    return 'SIGUIENTE · CAPÍTULO $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Empezar capítulo $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'USAR $name';
  }

  @override
  String get tutorialStep1 => 'PASO 1 · TOCA EL TORNILLO';

  @override
  String get tutorialLands => '↓ CAE EN LA BANDEJA';

  @override
  String get skipTutorial => 'SALTAR TUTORIAL';

  @override
  String get splashTagline => 'UN ROMPECABEZAS DE CAPAS';

  @override
  String get splashFooter => 'REV 1.0 · LÁMINA 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates PLACAS',
      one: '1 PLACA',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'TORNILLOS',
      one: 'TORNILLO',
    );
    return 'FIG. 1\nVISTA EXPLOSIONADA\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'CAPÍTULO $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TORNILLOS',
      one: 'TORNILLO',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'SIGUIENTE LÁMINA';

  @override
  String chapterLabel(String chapter) {
    return 'CAPÍTULO $chapter';
  }

  @override
  String get campaign => 'CAMPAÑA';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Continuar · $code';
  }

  @override
  String get daily => 'DIARIA';

  @override
  String get themes => 'TEMAS';

  @override
  String get allCleared => 'Todas las láminas completadas';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total LÁMINAS';
  }

  @override
  String get fiveChapters => 'Cinco capítulos';

  @override
  String get chaptersTitle => 'Capítulos';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'BLOQUEADO';

  @override
  String get downloadChapter => 'DESCARGAR';

  @override
  String get downloading => 'DESCARGANDO…';

  @override
  String get comingSoon => 'PRONTO, MÁS LÁMINAS';

  @override
  String newMechanic(String mechanic) {
    return 'NUEVO: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates placas',
      one: '1 placa',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers capas',
      one: '1 capa',
    );
    return '$_temp0 · $_temp1 · bandeja $tray';
  }

  @override
  String get theCampaign => 'LA CAMPAÑA';

  @override
  String get campaignFooter =>
      'Los capítulos se desbloquean al terminar el anterior. Las marcas de maestría son opcionales. Las pistas nunca bloquean el progreso.';

  @override
  String get chapterBonus => 'BONO DE CAPÍTULO';

  @override
  String get dailySheet => 'LÁMINA DIARIA';

  @override
  String get dailyTitle => 'TÍTULO';

  @override
  String get dailyPlates => 'PLACAS';

  @override
  String get dailyReward => 'PREMIO';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'Racha de $streak días.',
      one: 'Racha de 1 día.',
      zero: 'Empieza una racha.',
    );
    return 'La misma lámina para todos hoy. Sin cronómetro. $_temp0 Saltarte un día no cuesta nada.';
  }

  @override
  String get startDaily => 'Empezar la lámina de hoy';

  @override
  String get dailyCompleted => 'Hecho por hoy · vuelve mañana';

  @override
  String get replayDaily => 'Repetir la lámina de hoy';

  @override
  String get themesTitle => 'Temas';

  @override
  String get themesCaption => 'ESTÉTICO · NUNCA CAMBIA LAS REGLAS';

  @override
  String get equipped => 'EN USO';

  @override
  String get owned => 'ADQUIRIDO';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'MUESTRA';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get feedbackSection => 'SONIDO Y VIBRACIÓN';

  @override
  String get soundEffects => 'Efectos de sonido';

  @override
  String get music => 'Música';

  @override
  String get hapticsRow => 'Vibración';

  @override
  String get reducedMotionRow => 'Menos movimiento';

  @override
  String get reducedMotionCaption => 'Fundidos en lugar de desplazamientos';

  @override
  String get generalSection => 'GENERAL';

  @override
  String get highRefreshRate => 'Alta frecuencia de actualización';

  @override
  String highRefreshRateOn(int hz) {
    return 'Movimiento más fluido · hasta $hz Hz · usa más batería';
  }

  @override
  String get highRefreshRateOff => 'Movimiento más fluido · usa más batería';

  @override
  String get highRefreshRateUnsupported =>
      'Esta pantalla funciona a una sola frecuencia';

  @override
  String get highRefreshRateBattery =>
      'Limitada ahora por el ahorro de batería';

  @override
  String get highRefreshRateHeat =>
      'Limitada mientras el teléfono esté caliente';

  @override
  String highRefreshRateNow(int hz) {
    return 'Ahora $hz Hz';
  }

  @override
  String get language => 'Idioma';

  @override
  String get notifications => 'Recordatorio diario';

  @override
  String get notificationsCaption => 'Un aviso cuando haya una lámina nueva';

  @override
  String get accountSection => 'CUENTA';

  @override
  String get signInGoogle => 'Acceder con Google';

  @override
  String get signInApple => 'Iniciar sesión con Apple';

  @override
  String signedInAs(String name) {
    return 'Sesión iniciada · $name';
  }

  @override
  String get guestCaption =>
      'JUGANDO COMO INVITADO · INICIA SESIÓN PARA GUARDAR TU PROGRESO';

  @override
  String get signOut => 'CERRAR SESIÓN';

  @override
  String get deleteAccount => 'ELIMINAR CUENTA';

  @override
  String get purchasesSection => 'COMPRAS';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String get restore => 'RESTAURAR';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'SIN ANUNCIOS · PISTAS ILIMITADAS · TODOS LOS TEMAS · RESCATES GRATIS · $coins ¢ AL MES';
  }

  @override
  String get proMonthly => 'MENSUAL';

  @override
  String get proYearly => 'ANUAL';

  @override
  String proTrialDays(int days) {
    return '$days DÍAS GRATIS';
  }

  @override
  String proThenPrice(String price) {
    return 'LUEGO $price';
  }

  @override
  String get proTrialTerms =>
      'Se renueva automáticamente al terminar la prueba gratuita, salvo que la canceles. Las monedas mensuales empiezan con tu primer pago.';

  @override
  String get proActive => 'PRO · ACTIVO';

  @override
  String get adsRemoved => 'SIN ANUNCIOS';

  @override
  String get coinPacks => 'PAQUETES DE MONEDAS';

  @override
  String get aboutSection => 'ACERCA DE';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get refundPolicy => 'Política de reembolso';

  @override
  String get privacyChoices => 'Opciones de privacidad';

  @override
  String get licenses => 'Licencias y créditos';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · REV $version ($build)';
  }

  @override
  String get notificationPrimerTitle => '¿Un aviso para la lámina diaria?';

  @override
  String get notificationPrimerBody =>
      'Un recordatorio discreto cuando no hayas jugado. Nunca más de uno al día.';

  @override
  String get allow => 'PERMITIR';

  @override
  String get notNow => 'AHORA NO';

  @override
  String get somethingWentWrong => 'Algo salió mal.';

  @override
  String get purchaseThanks => '¡Gracias! Compra aplicada.';

  @override
  String get purchasePending =>
      'Compra pendiente. Se aplicará cuando se confirme.';

  @override
  String get purchaseFailed => 'La compra no se completó.';

  @override
  String get restored => 'Compras restauradas.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Termina primero el capítulo $chapter.';
  }

  @override
  String get moreSheetsTitle => 'Más láminas';

  @override
  String get moreSheetsCaption => 'Aquí llegan nuevos juegos de planos';

  @override
  String get equip => 'USAR';

  @override
  String buyFor(int coins) {
    return 'COMPRAR · $coins ¢';
  }

  @override
  String get close => 'CERRAR';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Licencias';

  @override
  String get licensesCaption => 'AVISOS DE CÓDIGO ABIERTO';

  @override
  String playLevel(String code) {
    return 'Jugar $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Lámina $number, bloqueada';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Clasificaciones';

  @override
  String get leaderboardCaption => 'JUGADORES CON SESIÓN · EN VIVO';

  @override
  String get boardSheets => 'LÁMINAS';

  @override
  String get boardDaily => 'DIARIA';

  @override
  String get boardStreak => 'RACHA';

  @override
  String get boardWeekly => 'SEMANA';

  @override
  String get boardWeeklyHint =>
      'LÁMINAS COMPLETADAS ESTA SEMANA · SE REINICIA EL LUNES';

  @override
  String get boardSheetsHint => 'MÁS LÁMINAS COMPLETADAS';

  @override
  String get boardDailyHint =>
      'LÁMINA DE HOY · MENOS MOVIMIENTOS, LUEGO MÁS RÁPIDO';

  @override
  String get boardStreakHint => 'DÍAS SEGUIDOS EN LA LÁMINA DIARIA';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'MOVIMIENTOS',
      one: 'MOVIMIENTO',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'DÍAS',
      one: 'DÍA',
    );
    return '$_temp0 · MEJOR $best';
  }

  @override
  String get boardYou => 'TÚ';

  @override
  String get boardYourRank => 'TU PUESTO';

  @override
  String get boardNotRanked => 'Aún sin clasificar';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'DE $countString';
  }

  @override
  String get boardGuest =>
      'Inicia sesión para poner tu nombre en la clasificación. Tu progreso te acompaña.';

  @override
  String get boardEmpty => 'Aún no hay nadie. Sé el primero.';

  @override
  String get boardOffline => 'No se puede cargar la clasificación ahora.';

  @override
  String get tryAgainCaps => 'REINTENTAR';

  @override
  String get todaysBoard => 'CLASIFICACIÓN DE HOY';

  @override
  String get signedOutToast =>
      'Sesión cerrada · se borraron los datos de este dispositivo. Inicia sesión de nuevo para recuperar tu progreso.';

  @override
  String get welcomeBack => 'Hola de nuevo';

  @override
  String welcomeBackName(String name) {
    return 'Hola de nuevo, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets láminas',
      one: '1 lámina',
    );
    return '$who · se restauraron $_temp0 y $coins monedas';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · iniciaste sesión y tu progreso está respaldado';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets láminas',
      one: '1 lámina',
    );
    return '$who · el progreso de este dispositivo se añadió a tu cuenta: $_temp0, $coins monedas';
  }

  @override
  String syncSavedNew(String name) {
    return 'Sesión iniciada como $name · tu progreso ya se guarda en tu cuenta';
  }

  @override
  String get syncSavedNewPlain =>
      'Sesión iniciada · tu progreso ya se guarda en tu cuenta';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets láminas nuevas',
      one: '1 lámina nueva',
      zero: 'progreso actualizado',
    );
    return 'Sincronizado desde tu otro dispositivo · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Aún no se pudo cargar tu progreso guardado · se sincronizará solo cuando vuelva la conexión';

  @override
  String get signedInOffline =>
      'Sesión iniciada · tu progreso se sincronizará cuando vuelvas a tener conexión';

  @override
  String get proActivated =>
      'Pro está activo · sin anuncios, todos los temas y pistas ilimitadas';

  @override
  String get accountDeletedToast =>
      'Se eliminaron tu cuenta y todos sus datos.';

  @override
  String accountDeletedProToast(String store) {
    return 'Cuenta eliminada. Pro se sigue cobrando hasta que lo canceles en $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'RACHA DE $days DÍAS · BONO DE +$coins';
  }

  @override
  String get workshopRecord => 'Registro del taller';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Registro del taller · $earned/$total';
  }

  @override
  String get recordCaption => 'LOGROS';

  @override
  String recordEarned(int earned, int total) {
    return '$earned DE $total CONSEGUIDOS';
  }

  @override
  String get badgeEarnedLabel => 'CONSEGUIDO';

  @override
  String badgeEarnedToast(String name) {
    return 'Insignia conseguida · $name';
  }

  @override
  String get badgeFirstTurn => 'Primera vuelta';

  @override
  String get badgeApprentice => 'Aprendiz';

  @override
  String get badgeJourneyman => 'Oficial';

  @override
  String get badgeCraftsman => 'Artesano';

  @override
  String get badgeChiefEngineer => 'Ingeniero jefe';

  @override
  String get badgeCleanWork => 'Trabajo limpio';

  @override
  String get badgePerfectionist => 'Perfeccionista';

  @override
  String get badgeRegular => 'Habitual';

  @override
  String get badgeOnARoll => 'En racha';

  @override
  String get badgeFullWeek => 'Semana completa';

  @override
  String get badgeFortnight => 'Quincena';

  @override
  String get badgeFirstDetail => 'Completa tu primera lámina';

  @override
  String badgeClearDetail(int n) {
    return 'Completa $n láminas';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Termina el capítulo $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Consigue ◆ en $n láminas';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Juega $n láminas diarias';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Alcanza una racha de $n días';
  }

  @override
  String get share => 'COMPARTIR';

  @override
  String get shareResult => 'Compartir resultado';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves movimientos',
      one: '1 movimiento',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String get signOutSheetTitle => '¿Cerrar sesión?';

  @override
  String get signOutSheetBody =>
      'Al cerrar sesión se borra tu progreso de este dispositivo. Todo lo que ya está respaldado vuelve cuando inicias sesión de nuevo, pero lo que aún no se haya sincronizado (por ejemplo, láminas jugadas sin conexión) se perdería.';

  @override
  String get staySignedIn => 'Mantener la sesión';

  @override
  String get signOutConfirm => 'Cerrar sesión';

  @override
  String get rateApp => 'Califica Screw Out';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get replayTutorial => 'Repetir tutorial';

  @override
  String feedbackNoEmailApp(String email) {
    return 'No se encontró una app de correo. Escríbenos a $email';
  }

  @override
  String get updateChip => 'ACTUALIZAR';

  @override
  String get updateReadyRestart =>
      'Actualización descargada. Reinicia para instalarla.';

  @override
  String get deleteSheetTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteSheetBody =>
      'Esto elimina para siempre tu cuenta y todo lo guardado en ella: el progreso de cada lámina, las monedas, los temas, tu racha diaria y tus puestos en las clasificaciones. No se puede deshacer.';

  @override
  String deleteSheetPro(String store) {
    return 'Tienes Screw Out Pro. Eliminar tu cuenta no lo cancela: cancela la suscripción en $store o se te seguirá cobrando.';
  }

  @override
  String get manageSubscription => 'Administrar suscripción';

  @override
  String get deleteForever => 'Eliminar mi cuenta';

  @override
  String get deleting => 'Eliminando…';

  @override
  String get keepAccount => 'Conservar mi cuenta';

  @override
  String get deleteOffline =>
      'No tienes conexión. Conéctate a internet para eliminar tu cuenta.';

  @override
  String get deleteFailed =>
      'No se pudo eliminar tu cuenta. Inténtalo de nuevo.';

  @override
  String get restoreNothing => 'No hay nada que restaurar en esta cuenta.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 pista';
  }

  @override
  String get hintEarnedToast => '+1 pista · gracias por mirar';

  @override
  String get rescueToast => '+1 ranura de bandeja para esta lámina';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 ranura de bandeja';
  }

  @override
  String get adNotCompleted =>
      'El video no terminó, así que esta vez no hay premio.';

  @override
  String themeEquippedToast(String name) {
    return '$name en uso';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'El capítulo $chapter está listo';
  }

  @override
  String get signInFailed => 'No se completó el inicio de sesión.';

  @override
  String get themePurchased => 'Tema desbloqueado.';

  @override
  String themeBuyStore(String price) {
    return 'O COMPRA · $price';
  }

  @override
  String get themesBundleTitle => 'Todos los temas';

  @override
  String get themesBundleBody =>
      'Todos los temas de pago, tuyos para siempre. Pro también los incluye.';

  @override
  String themesBundleBuy(String price) {
    return 'COMPRAR · $price';
  }

  @override
  String get dailyWeekDone => 'Hecho';

  @override
  String masteredCount(int count) {
    return '$count DOMINADAS';
  }

  @override
  String get reminderTitle => 'La lámina de hoy está lista';

  @override
  String get reminderBody =>
      'Un plano nuevo, el mismo para todos. Sin cronómetro.';

  @override
  String get comebackReminderTitle =>
      'Tu próxima lámina te espera en el banco de trabajo';

  @override
  String get comebackReminderBody =>
      'Unos minutos tranquilos, unos cuantos tornillos. Sigue donde lo dejaste.';

  @override
  String get signInEmail => 'Continuar con correo';

  @override
  String get emailSignInTitle => 'Iniciar sesión';

  @override
  String get emailCreateTitle => 'Crear cuenta';

  @override
  String get emailTabSignIn => 'INICIAR SESIÓN';

  @override
  String get emailTabCreate => 'CREAR CUENTA';

  @override
  String get emailSheetBody => 'Tu progreso en este dispositivo te acompaña.';

  @override
  String get emailLabel => 'CORREO';

  @override
  String get passwordLabel => 'CONTRASEÑA';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String passwordHint(int min) {
    return 'Al menos $min caracteres';
  }

  @override
  String get emailRequired => 'Escribe tu correo.';

  @override
  String get emailInvalid => 'Esa dirección de correo no parece correcta.';

  @override
  String get passwordRequired => 'Escribe tu contraseña.';

  @override
  String passwordTooShort(int min) {
    return 'Usa al menos $min caracteres.';
  }

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotNeedsEmail =>
      'Escribe tu correo arriba y luego toca ¿Olvidaste tu contraseña?';

  @override
  String resetSent(String email) {
    return 'Si $email tiene una cuenta, ya va en camino un enlace para restablecer la contraseña.';
  }

  @override
  String get emailWorking => 'Un momento…';

  @override
  String get authErrWrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get authErrEmailInUse =>
      'Este correo ya tiene una cuenta. Mejor inicia sesión.';

  @override
  String get authErrWeakPassword => 'Elige una contraseña más segura.';

  @override
  String get authErrDisabled => 'Esta cuenta está desactivada.';

  @override
  String get authErrNotEnabled =>
      'El inicio de sesión con correo no está disponible ahora.';

  @override
  String get authErrTooMany =>
      'Demasiados intentos. Espera un momento y vuelve a intentarlo.';

  @override
  String get authErrNetwork =>
      'Sin conexión. Revisa tu internet y vuelve a intentarlo.';

  @override
  String get authErrGeneric => 'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get deletePasswordBody =>
      'Escribe tu contraseña para confirmar que eres tú.';

  @override
  String get deleteWrongPassword =>
      'Esa contraseña no coincide con esta cuenta.';

  @override
  String get purchaseSaveTitle => 'Conserva tu compra';

  @override
  String get purchaseSaveBody =>
      'Opcional: inicia sesión para conservar tus compras y tu progreso en todos tus dispositivos. Tu compra ya funciona en este.';

  @override
  String get purchaseNeedsConnection =>
      'No se pudo conectar con el servidor. Revisa tu conexión y vuelve a intentarlo.';

  @override
  String get languageSystemDefault => 'Predeterminado del sistema';

  @override
  String get startupFailed =>
      'ALGO SALIÓ MAL AL INICIAR.\nCIERRA LA APP Y ÁBRELA DE NUEVO.';

  @override
  String get notificationChannelDescription =>
      'Recordatorios de la lámina diaria y avisos de la cuenta';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Tornillo, placa $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Tornillo, placa $plate, bloqueado por $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled de $total';
  }

  @override
  String get chapterName1 => 'Básicos del taller';

  @override
  String get chapterName2 => 'Capa a capa';

  @override
  String get chapterName3 => 'Haz espacio';

  @override
  String get chapterName4 => 'Entrelazado';

  @override
  String get chapterName5 => 'Maestro constructor';

  @override
  String get chapterGoal1 => 'Toca, quita, suelta';

  @override
  String get chapterGoal2 => 'Superposición y orden';

  @override
  String get chapterGoal3 => 'Planea con bandeja justa';

  @override
  String get chapterGoal4 => 'Soportes compartidos';

  @override
  String get chapterGoal5 => 'Todo, siempre justo';

  @override
  String get chapterPitch1 =>
      'Toca un tornillo. Suelta una placa. Esa es toda la regla.';

  @override
  String get chapterPitch2 =>
      'Unas placas tapan a otras. Trabaja de arriba abajo.';

  @override
  String get chapterPitch3 =>
      'Bandejas más justas. Planea qué tornillos sacar primero.';

  @override
  String get chapterPitch4 =>
      'Una placa sujeta a varias. Encuentra la pieza clave.';

  @override
  String get chapterPitch5 =>
      'Pilas profundas, todas las ideas a la vez. Tómate tu tiempo.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Juego de planos $number';
  }

  @override
  String get chapterGoalDownloaded => 'Láminas de nivel maestro';

  @override
  String get chapterPitchDownloaded => 'Más láminas, las mismas reglas justas.';

  @override
  String get mechanicOverlap => 'SUPERPOSICIÓN';

  @override
  String get mechanicTray => 'BANDEJA';

  @override
  String get mechanicLayers => 'CAPAS';

  @override
  String get mechanicCircles => 'CÍRCULOS';

  @override
  String get mechanicTraps => 'TRAMPAS';

  @override
  String get mechanicSupports => 'SOPORTES';

  @override
  String get sheetObjective004 =>
      'QUITA LA PLACA SUPERIOR PARA LLEGAR AL TORNILLO';

  @override
  String get sheetObjective006 =>
      'BANDEJA DE 3. UNA PLACA SUELTA LIBERA RANURAS';

  @override
  String get sheetObjective011 => 'TRES CAPAS. TRABAJA DE ARRIBA ABAJO';

  @override
  String get sheetObjective012 => 'QUITA PL-04 ANTES QUE LAS PLACAS DE ABAJO';

  @override
  String get sheetObjective017 => 'UN MOVIMIENTO TENTADOR LLENA LA BANDEJA';

  @override
  String get sheetObjective021 =>
      'LAS PLACAS REDONDAS TAPAN COMO CUALQUIER OTRA';

  @override
  String get sheetObjective024 => 'QUITA PL-04 PARA LLEGAR A LA ESQUINA';

  @override
  String get sheetObjective041 => 'BANDEJA JUSTA. LIBERA UNA PLACA A TIEMPO';

  @override
  String get sheetObjective061 => 'UNA PLACA PUEDE SUJETAR A VARIAS OTRAS';

  @override
  String get sheetObjective081 => 'TODO LO QUE HAS APRENDIDO. TÓMATE TU TIEMPO';

  @override
  String get themeNameBlueprint => 'Plano limpio';

  @override
  String get themeNameWalnut => 'Taller de nogal';

  @override
  String get themeNameOcean => 'Turquesa océano';

  @override
  String get themeNameCopper => 'Cobre cálido';

  @override
  String get themeNameMidnight => 'Taller de medianoche';

  @override
  String get themeNamePastel => 'Estudio pastel';

  @override
  String sheetTitleNumbered(int number) {
    return 'Lámina $number';
  }

  @override
  String get sheetTitle001 => 'Primera vuelta';

  @override
  String get sheetTitle002 => 'Dos puntos';

  @override
  String get sheetTitle003 => 'Lado a lado';

  @override
  String get sheetTitle004 => 'Tapa';

  @override
  String get sheetTitle005 => 'A la vista';

  @override
  String get sheetTitle006 => 'Día de bandeja';

  @override
  String get sheetTitle007 => 'Plan pequeño';

  @override
  String get sheetTitle008 => 'Ajuste justo';

  @override
  String get sheetTitle009 => 'Barra redonda';

  @override
  String get sheetTitle010 => 'Control';

  @override
  String get sheetTitle011 => 'Tercera capa';

  @override
  String get sheetTitle012 => 'Riostra en cruz';

  @override
  String get sheetTitle013 => 'Libera una ranura';

  @override
  String get sheetTitle014 => 'Dos por delante';

  @override
  String get sheetTitle015 => 'Acero pintado';

  @override
  String get sheetTitle016 => 'Banco de trabajo';

  @override
  String get sheetTitle017 => 'Tentación';

  @override
  String get sheetTitle018 => 'Cascada';

  @override
  String get sheetTitle019 => 'Mezcla de taller';

  @override
  String get sheetTitle020 => 'Ensamblaje';

  @override
  String get sheetTitle021 => 'Pila de arandelas';

  @override
  String get sheetTitle022 => 'Junta';

  @override
  String get sheetTitle023 => 'Tapa de lente';

  @override
  String get sheetTitle024 => 'Soporte oculto';

  @override
  String get sheetTitle025 => 'Juego de calzas';

  @override
  String get sheetTitle026 => 'Bisel';

  @override
  String get sheetTitle027 => 'Ojal';

  @override
  String get sheetTitle028 => 'Respiro';

  @override
  String get sheetTitle029 => 'Anillo de brida';

  @override
  String get sheetTitle030 => 'Ojo de buey';

  @override
  String get sheetTitle031 => 'Separador';

  @override
  String get sheetTitle032 => 'Collarín';

  @override
  String get sheetTitle033 => 'Tapa final';

  @override
  String get sheetTitle034 => 'Turno tranquilo';

  @override
  String get sheetTitle035 => 'Mamparo';

  @override
  String get sheetTitle036 => 'Tapa de registro';

  @override
  String get sheetTitle037 => 'Placa frontal';

  @override
  String get sheetTitle038 => 'Servicio ligero';

  @override
  String get sheetTitle039 => 'Roseta';

  @override
  String get sheetTitle040 => 'Pastel de capas';

  @override
  String get sheetTitle041 => 'Haz espacio';

  @override
  String get sheetTitle042 => 'Hueco en el cajón';

  @override
  String get sheetTitle043 => 'Desborde';

  @override
  String get sheetTitle044 => 'Casillero';

  @override
  String get sheetTitle045 => 'Caja de piezas';

  @override
  String get sheetTitle046 => 'Poco material';

  @override
  String get sheetTitle047 => 'Casilla';

  @override
  String get sheetTitle048 => 'Salida fácil';

  @override
  String get sheetTitle049 => 'Ranura a ranura';

  @override
  String get sheetTitle050 => 'Lleno total';

  @override
  String get sheetTitle051 => 'Pendientes';

  @override
  String get sheetTitle052 => 'Ranura de reserva';

  @override
  String get sheetTitle053 => 'Holgura';

  @override
  String get sheetTitle054 => 'Ajuste flojo';

  @override
  String get sheetTitle055 => 'Inventario';

  @override
  String get sheetTitle056 => 'Margen';

  @override
  String get sheetTitle057 => 'Tolerancia';

  @override
  String get sheetTitle058 => 'Día libre';

  @override
  String get sheetTitle059 => 'Altura libre';

  @override
  String get sheetTitle060 => 'Almacén';

  @override
  String get sheetTitle061 => 'Enclavamiento';

  @override
  String get sheetTitle062 => 'Cartela';

  @override
  String get sheetTitle063 => 'Piedra angular';

  @override
  String get sheetTitle064 => 'Junta a solape';

  @override
  String get sheetTitle065 => 'Placa de empalme';

  @override
  String get sheetTitle066 => 'Cola de milano';

  @override
  String get sheetTitle067 => 'Dintel';

  @override
  String get sheetTitle068 => 'Retal';

  @override
  String get sheetTitle069 => 'Puntal';

  @override
  String get sheetTitle070 => 'Cercha';

  @override
  String get sheetTitle071 => 'Horquilla';

  @override
  String get sheetTitle072 => 'Yugo';

  @override
  String get sheetTitle073 => 'Silleta';

  @override
  String get sheetTitle074 => 'Zapata';

  @override
  String get sheetTitle075 => 'Par de soportes';

  @override
  String get sheetTitle076 => 'Barra de sujeción';

  @override
  String get sheetTitle077 => 'Placa de unión';

  @override
  String get sheetTitle078 => 'Panel liso';

  @override
  String get sheetTitle079 => 'Voladizo';

  @override
  String get sheetTitle080 => 'Pórtico rígido';

  @override
  String get sheetTitle081 => 'Plan maestro';

  @override
  String get sheetTitle082 => 'Subconjunto';

  @override
  String get sheetTitle083 => 'Vista explosionada';

  @override
  String get sheetTitle084 => 'Prueba de ajuste';

  @override
  String get sheetTitle085 => 'Par de apriete';

  @override
  String get sheetTitle086 => 'Plantilla';

  @override
  String get sheetTitle087 => 'Utillaje';

  @override
  String get sheetTitle088 => 'Banco tranquilo';

  @override
  String get sheetTitle089 => 'Caja de cambios';

  @override
  String get sheetTitle090 => 'Carcasa';

  @override
  String get sheetTitle091 => 'Chasis';

  @override
  String get sheetTitle092 => 'Bahía de paneles';

  @override
  String get sheetTitle093 => 'Juego de tapas';

  @override
  String get sheetTitle094 => 'Apriete suave';

  @override
  String get sheetTitle095 => 'Soporte de motor';

  @override
  String get sheetTitle096 => 'Cuadro eléctrico';

  @override
  String get sheetTitle097 => 'Caja de control';

  @override
  String get sheetTitle098 => 'Mesa de dibujo';

  @override
  String get sheetTitle099 => 'Inspección final';

  @override
  String get sheetTitle100 => 'Visto bueno';
}
