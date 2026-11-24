// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => 'Пауза';

  @override
  String get back => 'Назад';

  @override
  String get settings => 'Настройки';

  @override
  String get tray => 'ЛОТОК';

  @override
  String get trayFull => 'ЛОТОК ПОЛОН';

  @override
  String get undo => 'ОТМЕНИТЬ';

  @override
  String hintCount(String count) {
    return 'ПОДСК. · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => 'Пауза';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · ХОД $moves';
  }

  @override
  String get resume => 'Продолжить';

  @override
  String get sound => 'ЗВУК';

  @override
  String get haptics => 'ВИБРАЦИЯ';

  @override
  String get reducedMotion => 'МЕНЬШЕ АНИМАЦИИ';

  @override
  String get restart => 'ЗАНОВО';

  @override
  String get exitToSheets => 'К ЛИСТАМ';

  @override
  String get restartConfirmTitle => 'Начать лист заново?';

  @override
  String restartConfirmBody(int moves) {
    return 'Будет потеряно ходов: $moves.';
  }

  @override
  String get cancel => 'ОТМЕНА';

  @override
  String get stuckTitle => 'Свободных ячеек нет.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count винта',
      many: '$count винтов',
      few: '$count винта',
      one: '$count винт',
    );
    return '$plate ещё держит на поле $_temp0. Отмена хода освободит ячейку.';
  }

  @override
  String get stuckReasonGeneric =>
      'Все ячейки заняты, и ни одна пластина не может упасть. Отмена хода освободит ячейку.';

  @override
  String get undoLastMove => 'Отменить ход';

  @override
  String rescueSlotCoins(int coins) {
    return 'ДОП. ЯЧЕЙКА · $coins ¢';
  }

  @override
  String get rescueSlotAd => 'ДОП. ЯЧЕЙКА · ВИДЕО';

  @override
  String get rescueSlotPro => 'ДОП. ЯЧЕЙКА · PRO';

  @override
  String get outOfHintsTitle => 'Ещё одну подсказку?';

  @override
  String get hintsLeftZero => 'ПОДСКАЗОК · 0';

  @override
  String get outOfHintsBody =>
      'Подсказка обводит один полезный винт. Решать лист за вас она не станет.';

  @override
  String get watchVideo => 'Посмотреть короткое видео';

  @override
  String get watchVideoMeta => 'ПО ЖЕЛАНИЮ · ~30 С · +1 ПОДСКАЗКА';

  @override
  String useCoins(int coins) {
    return 'Потратить монеты: $coins';
  }

  @override
  String useCoinsMeta(int balance) {
    return 'БАЛАНС $balance ¢';
  }

  @override
  String get keepThinking => 'Подумаю ещё';

  @override
  String get notEnoughCoins => 'Пока не хватает монет.';

  @override
  String get adUnavailable => 'Сейчас нет доступного видео.';

  @override
  String cleared(String code) {
    return '$code · ПРОЙДЕН';
  }

  @override
  String get disassembled => 'Разобрано.';

  @override
  String get approved => 'ПРИНЯТО';

  @override
  String get statMoves => 'ХОДЫ';

  @override
  String get statTime => 'ВРЕМЯ';

  @override
  String get statMastery => 'МАСТЕРСТВО';

  @override
  String nextSheet(String code) {
    return 'Следующий лист · $code';
  }

  @override
  String get replay => 'ЕЩЁ РАЗ';

  @override
  String get sheets => 'ЛИСТЫ';

  @override
  String get backHome => 'На главную';

  @override
  String chapterComplete(String chapter) {
    return 'ГЛАВА $chapter · ПРОЙДЕНА';
  }

  @override
  String get themeUnlocked => 'ТЕМА ОТКРЫТА';

  @override
  String nextChapter(String chapter) {
    return 'ДАЛЕЕ · ГЛАВА $chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'Начать главу $chapter';
  }

  @override
  String equipTheme(String name) {
    return 'ВЫБРАТЬ $name';
  }

  @override
  String get tutorialStep1 => 'ШАГ 1 · НАЖМИТЕ НА ВИНТ';

  @override
  String get tutorialLands => '↓ ОН ПОПАДЁТ В ЛОТОК';

  @override
  String get skipTutorial => 'ПРОПУСТИТЬ';

  @override
  String get splashTagline => 'ГОЛОВОЛОМКА ИЗ СЛОЁВ';

  @override
  String get splashFooter => 'ИЗМ. 1.0 · ЛИСТ 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates ПЛАСТИНЫ',
      many: '$plates ПЛАСТИН',
      few: '$plates ПЛАСТИНЫ',
      one: '$plates ПЛАСТИНА',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: 'ВИНТА',
      many: 'ВИНТОВ',
      few: 'ВИНТА',
      one: 'ВИНТ',
    );
    return 'РИС. 1\nВИД В РАЗНЕСЕНИИ\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'ГЛАВА $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ВИНТА',
      many: 'ВИНТОВ',
      few: 'ВИНТА',
      one: 'ВИНТ',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => 'СЛЕДУЮЩИЙ ЛИСТ';

  @override
  String chapterLabel(String chapter) {
    return 'ГЛАВА $chapter';
  }

  @override
  String get campaign => 'КАМПАНИЯ';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return 'Продолжить · $code';
  }

  @override
  String get daily => 'ЛИСТ ДНЯ';

  @override
  String get themes => 'ТЕМЫ';

  @override
  String get allCleared => 'Все листы пройдены';

  @override
  String sheetsCount(int done, int total) {
    return 'ЛИСТЫ: $done / $total';
  }

  @override
  String get fiveChapters => 'Пять глав';

  @override
  String get chaptersTitle => 'Главы';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'ЗАКРЫТО';

  @override
  String get downloadChapter => 'СКАЧАТЬ';

  @override
  String get downloading => 'ЗАГРУЗКА…';

  @override
  String get comingSoon => 'СКОРО НОВЫЕ ЛИСТЫ';

  @override
  String newMechanic(String mechanic) {
    return 'НОВОЕ: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates пластины',
      many: '$plates пластин',
      few: '$plates пластины',
      one: '$plates пластина',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers слоя',
      many: '$layers слоёв',
      few: '$layers слоя',
      one: '$layers слой',
    );
    return '$_temp0 · $_temp1 · лоток $tray';
  }

  @override
  String get theCampaign => 'КАМПАНИЯ';

  @override
  String get campaignFooter =>
      'Главы открываются по порядку. Знаки мастерства необязательны. Подсказки никогда не мешают прогрессу.';

  @override
  String get chapterBonus => 'БОНУС ЗА ГЛАВУ';

  @override
  String get dailySheet => 'ЛИСТ ДНЯ';

  @override
  String get dailyTitle => 'НАЗВАНИЕ';

  @override
  String get dailyPlates => 'ПЛАСТИНЫ';

  @override
  String get dailyReward => 'НАГРАДА';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: 'Серия: $streak дня.',
      many: 'Серия: $streak дней.',
      few: 'Серия: $streak дня.',
      one: 'Серия: $streak день.',
      zero: 'Начните серию.',
    );
    return 'Сегодня у всех один и тот же лист. Без таймера. $_temp0 Пропуск дня ничего не стоит.';
  }

  @override
  String get startDaily => 'Начать лист дня';

  @override
  String get dailyCompleted => 'На сегодня всё · ждём завтра';

  @override
  String get replayDaily => 'Пройти лист дня снова';

  @override
  String get themesTitle => 'Темы';

  @override
  String get themesCaption => 'ТОЛЬКО ВИД · ПРАВИЛА НЕ МЕНЯЮТСЯ';

  @override
  String get equipped => 'ВЫБРАНА';

  @override
  String get owned => 'ДОСТУПНА';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'ПРОСМОТР';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get feedbackSection => 'ЗВУК И ВИБРАЦИЯ';

  @override
  String get soundEffects => 'Звуковые эффекты';

  @override
  String get music => 'Музыка';

  @override
  String get hapticsRow => 'Вибрация';

  @override
  String get reducedMotionRow => 'Меньше анимации';

  @override
  String get reducedMotionCaption => 'Плавное появление вместо полёта';

  @override
  String get generalSection => 'ОБЩИЕ';

  @override
  String get highRefreshRate => 'Высокая частота обновления';

  @override
  String highRefreshRateOn(int hz) {
    return 'Плавнее · до $hz Гц · больше расход батареи';
  }

  @override
  String get highRefreshRateOff => 'Плавнее · больше расход батареи';

  @override
  String get highRefreshRateUnsupported =>
      'Этот экран работает на одной частоте';

  @override
  String get highRefreshRateBattery =>
      'Сейчас ограничено режимом энергосбережения';

  @override
  String get highRefreshRateHeat => 'Ограничено, пока телефон нагрет';

  @override
  String highRefreshRateNow(int hz) {
    return 'Сейчас $hz Гц';
  }

  @override
  String get language => 'Язык';

  @override
  String get notifications => 'Ежедневное напоминание';

  @override
  String get notificationsCaption => 'Одно напоминание о новом листе';

  @override
  String get accountSection => 'АККАУНТ';

  @override
  String get signInGoogle => 'Войти через Google';

  @override
  String get signInApple => 'Вход с Apple';

  @override
  String signedInAs(String name) {
    return 'Вход выполнен · $name';
  }

  @override
  String get guestCaption =>
      'ВЫ ИГРАЕТЕ КАК ГОСТЬ · ВОЙДИТЕ, ЧТОБЫ СОХРАНИТЬ ПРОГРЕСС';

  @override
  String get signOut => 'ВЫЙТИ';

  @override
  String get deleteAccount => 'УДАЛИТЬ АККАУНТ';

  @override
  String get purchasesSection => 'ПОКУПКИ';

  @override
  String get removeAds => 'Отключить рекламу';

  @override
  String get restore => 'ВОССТАНОВИТЬ';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return 'БЕЗ РЕКЛАМЫ · БЕЗЛИМИТНЫЕ ПОДСКАЗКИ · ВСЕ ТЕМЫ · БЕСПЛАТНОЕ СПАСЕНИЕ · $coins ¢ В МЕСЯЦ';
  }

  @override
  String get proMonthly => 'МЕСЯЦ';

  @override
  String get proYearly => 'ГОД';

  @override
  String proTrialDays(int days) {
    return '$days ДН. БЕСПЛАТНО';
  }

  @override
  String proThenPrice(String price) {
    return 'ЗАТЕМ $price';
  }

  @override
  String get proTrialTerms =>
      'Подписка продлевается автоматически после пробного периода, если вы её не отмените. Ежемесячные монеты начисляются с первого платежа.';

  @override
  String get proActive => 'PRO · АКТИВНА';

  @override
  String get adsRemoved => 'РЕКЛАМА ОТКЛЮЧЕНА';

  @override
  String get coinPacks => 'НАБОРЫ МОНЕТ';

  @override
  String get aboutSection => 'О ПРИЛОЖЕНИИ';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get refundPolicy => 'Политика возврата';

  @override
  String get privacyChoices => 'Настройки конфиденциальности';

  @override
  String get licenses => 'Лицензии и авторы';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · ИЗМ. $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'Напоминать о листе дня?';

  @override
  String get notificationPrimerBody =>
      'Тихое напоминание, если вы не играли. Не чаще раза в день.';

  @override
  String get allow => 'РАЗРЕШИТЬ';

  @override
  String get notNow => 'НЕ СЕЙЧАС';

  @override
  String get somethingWentWrong => 'Что-то пошло не так.';

  @override
  String get purchaseThanks => 'Спасибо! Покупка применена.';

  @override
  String get purchasePending =>
      'Покупка обрабатывается. Она вступит в силу после подтверждения.';

  @override
  String get purchaseFailed => 'Покупка не прошла.';

  @override
  String get restored => 'Покупки восстановлены.';

  @override
  String finishChapterFirst(String chapter) {
    return 'Сначала пройдите главу $chapter.';
  }

  @override
  String get moreSheetsTitle => 'Новые листы';

  @override
  String get moreSheetsCaption => 'Здесь появляются новые наборы чертежей';

  @override
  String get equip => 'ВЫБРАТЬ';

  @override
  String buyFor(int coins) {
    return 'КУПИТЬ · $coins ¢';
  }

  @override
  String get close => 'ЗАКРЫТЬ';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'Лицензии';

  @override
  String get licensesCaption => 'ОТКРЫТОЕ ПО';

  @override
  String playLevel(String code) {
    return 'Играть $code';
  }

  @override
  String lockedLevel(int number) {
    return 'Лист $number, закрыт';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'Рейтинги';

  @override
  String get leaderboardCaption => 'ИГРОКИ С АККАУНТОМ · ОНЛАЙН';

  @override
  String get boardSheets => 'ЛИСТЫ';

  @override
  String get boardDaily => 'ДЕНЬ';

  @override
  String get boardStreak => 'СЕРИЯ';

  @override
  String get boardWeekly => 'НЕДЕЛЯ';

  @override
  String get boardWeeklyHint => 'ЛИСТЫ ЗА НЕДЕЛЮ · СБРОС В ПОНЕДЕЛЬНИК';

  @override
  String get boardSheetsHint => 'БОЛЬШЕ ВСЕГО ПРОЙДЕННЫХ ЛИСТОВ';

  @override
  String get boardDailyHint => 'ЛИСТ ДНЯ · МЕНЬШЕ ХОДОВ, ПОТОМ БЫСТРЕЕ';

  @override
  String get boardStreakHint => 'ДНЕЙ ПОДРЯД С ЛИСТОМ ДНЯ';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ХОДА',
      many: 'ХОДОВ',
      few: 'ХОДА',
      one: 'ХОД',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ДНЯ',
      many: 'ДНЕЙ',
      few: 'ДНЯ',
      one: 'ДЕНЬ',
    );
    return '$_temp0 · РЕКОРД $best';
  }

  @override
  String get boardYou => 'ВЫ';

  @override
  String get boardYourRank => 'ВАШЕ МЕСТО';

  @override
  String get boardNotRanked => 'Пока без места';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'ИЗ $countString';
  }

  @override
  String get boardGuest =>
      'Войдите, чтобы ваше имя появилось в рейтинге. Прогресс сохранится.';

  @override
  String get boardEmpty => 'Здесь пока никого. Будьте первым.';

  @override
  String get boardOffline => 'Сейчас не удаётся загрузить рейтинг.';

  @override
  String get tryAgainCaps => 'ПОВТОРИТЬ';

  @override
  String get todaysBoard => 'РЕЙТИНГ ДНЯ';

  @override
  String get signedOutToast =>
      'Вы вышли · данные на устройстве очищены. Войдите снова, чтобы вернуть прогресс.';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String welcomeBackName(String name) {
    return 'С возвращением, $name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets листа',
      many: '$sheets листов',
      few: '$sheets листа',
      one: '$sheets лист',
    );
    return '$who · восстановлено: $_temp0 и монеты ($coins)';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · вход выполнен, прогресс сохранён';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets листа',
      many: '$sheets листов',
      few: '$sheets листа',
      one: '$sheets лист',
    );
    return '$who · прогресс с этого устройства добавлен в аккаунт: $_temp0, монеты: $coins';
  }

  @override
  String syncSavedNew(String name) {
    return 'Вход как $name · теперь прогресс сохраняется в аккаунте';
  }

  @override
  String get syncSavedNewPlain =>
      'Вход выполнен · теперь прогресс сохраняется в аккаунте';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets новых листа',
      many: '$sheets новых листов',
      few: '$sheets новых листа',
      one: '$sheets новый лист',
      zero: 'прогресс обновлён',
    );
    return 'Синхронизировано с другим устройством · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      'Пока не удалось загрузить сохранённый прогресс · он синхронизируется сам, когда появится связь';

  @override
  String get signedInOffline =>
      'Вход выполнен · прогресс синхронизируется, когда вы будете онлайн';

  @override
  String get proActivated =>
      'Pro активна · без рекламы, все темы и безлимитные подсказки';

  @override
  String get accountDeletedToast => 'Ваш аккаунт и все его данные удалены.';

  @override
  String accountDeletedProToast(String store) {
    return 'Аккаунт удалён. Pro оплачивается, пока вы не отмените подписку в $store.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return 'СЕРИЯ $days ДН. · БОНУС +$coins';
  }

  @override
  String get workshopRecord => 'Журнал мастерской';

  @override
  String workshopRecordButton(int earned, int total) {
    return 'Журнал мастерской · $earned/$total';
  }

  @override
  String get recordCaption => 'ДОСТИЖЕНИЯ';

  @override
  String recordEarned(int earned, int total) {
    return 'ПОЛУЧЕНО $earned ИЗ $total';
  }

  @override
  String get badgeEarnedLabel => 'ПОЛУЧЕН';

  @override
  String badgeEarnedToast(String name) {
    return 'Значок получен · $name';
  }

  @override
  String get badgeFirstTurn => 'Первый оборот';

  @override
  String get badgeApprentice => 'Ученик';

  @override
  String get badgeJourneyman => 'Подмастерье';

  @override
  String get badgeCraftsman => 'Мастер';

  @override
  String get badgeChiefEngineer => 'Главный инженер';

  @override
  String get badgeCleanWork => 'Чистая работа';

  @override
  String get badgePerfectionist => 'Перфекционист';

  @override
  String get badgeRegular => 'Завсегдатай';

  @override
  String get badgeOnARoll => 'В ударе';

  @override
  String get badgeFullWeek => 'Целая неделя';

  @override
  String get badgeFortnight => 'Две недели';

  @override
  String get badgeFirstDetail => 'Пройдите первый лист';

  @override
  String badgeClearDetail(int n) {
    return 'Пройдите листов: $n';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'Пройдите главу $n';
  }

  @override
  String badgeMasterDetail(int n) {
    return 'Получите ◆ на листах: $n';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'Сыграйте листов дня: $n';
  }

  @override
  String badgeStreakDetail(int n) {
    return 'Наберите серию: $n дн.';
  }

  @override
  String get share => 'ПОДЕЛИТЬСЯ';

  @override
  String get shareResult => 'Поделиться результатом';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves хода',
      many: '$moves ходов',
      few: '$moves хода',
      one: '$moves ход',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return 'Серия: $days дн.';
  }

  @override
  String get signOutSheetTitle => 'Выйти?';

  @override
  String get signOutSheetBody =>
      'При выходе прогресс на этом устройстве удаляется. Всё, что уже сохранено, вернётся при следующем входе, но несинхронизированные данные (например, листы, пройденные офлайн) будут потеряны.';

  @override
  String get staySignedIn => 'Остаться';

  @override
  String get signOutConfirm => 'Выйти';

  @override
  String get rateApp => 'Оценить Screw Out';

  @override
  String get sendFeedback => 'Написать отзыв';

  @override
  String get replayTutorial => 'Пройти обучение снова';

  @override
  String feedbackNoEmailApp(String email) {
    return 'Почтовое приложение не найдено. Напишите нам: $email';
  }

  @override
  String get updateChip => 'ОБНОВИТЬ';

  @override
  String get updateReadyRestart =>
      'Обновление загружено. Перезапустите, чтобы установить.';

  @override
  String get deleteSheetTitle => 'Удалить аккаунт?';

  @override
  String get deleteSheetBody =>
      'Аккаунт будет удалён навсегда вместе со всеми данными: прогрессом на всех листах, монетами, темами, серией листа дня и местами в рейтингах. Это нельзя отменить.';

  @override
  String deleteSheetPro(String store) {
    return 'У вас есть Screw Out Pro. Удаление аккаунта не отменяет подписку: отмените её в $store, иначе списания продолжатся.';
  }

  @override
  String get manageSubscription => 'Управлять подпиской';

  @override
  String get deleteForever => 'Удалить аккаунт';

  @override
  String get deleting => 'Удаление…';

  @override
  String get keepAccount => 'Оставить аккаунт';

  @override
  String get deleteOffline =>
      'Нет подключения. Подключитесь к интернету, чтобы удалить аккаунт.';

  @override
  String get deleteFailed => 'Не удалось удалить аккаунт. Попробуйте ещё раз.';

  @override
  String get restoreNothing => 'На этом аккаунте нечего восстанавливать.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · +1 подсказка';
  }

  @override
  String get hintEarnedToast => '+1 подсказка · спасибо за просмотр';

  @override
  String get rescueToast => '+1 ячейка лотка на этот лист';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · +1 ячейка лотка';
  }

  @override
  String get adNotCompleted => 'Видео не досмотрено, поэтому награды нет.';

  @override
  String themeEquippedToast(String name) {
    return 'Выбрана тема «$name»';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'Глава $chapter готова';
  }

  @override
  String get signInFailed => 'Вход не выполнен.';

  @override
  String get themePurchased => 'Тема открыта.';

  @override
  String themeBuyStore(String price) {
    return 'ИЛИ КУПИТЬ · $price';
  }

  @override
  String get themesBundleTitle => 'Все темы';

  @override
  String get themesBundleBody =>
      'Все платные темы навсегда. В Pro они тоже входят.';

  @override
  String themesBundleBuy(String price) {
    return 'КУПИТЬ · $price';
  }

  @override
  String get dailyWeekDone => 'Пройден';

  @override
  String masteredCount(int count) {
    return 'С МАСТЕРСТВОМ: $count';
  }

  @override
  String get reminderTitle => 'Лист дня готов';

  @override
  String get reminderBody => 'Один новый чертёж, общий для всех. Без таймера.';

  @override
  String get comebackReminderTitle => 'Следующий лист ждёт на верстаке';

  @override
  String get comebackReminderBody =>
      'Несколько спокойных минут, несколько винтов. Продолжите с того же места.';

  @override
  String get signInEmail => 'Войти по почте';

  @override
  String get emailSignInTitle => 'Вход';

  @override
  String get emailCreateTitle => 'Создать аккаунт';

  @override
  String get emailTabSignIn => 'ВХОД';

  @override
  String get emailTabCreate => 'РЕГИСТРАЦИЯ';

  @override
  String get emailSheetBody =>
      'Прогресс с этого устройства перейдёт в аккаунт.';

  @override
  String get emailLabel => 'ЭЛ. ПОЧТА';

  @override
  String get passwordLabel => 'ПАРОЛЬ';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String passwordHint(int min) {
    return 'Минимум $min символов';
  }

  @override
  String get emailRequired => 'Введите адрес почты.';

  @override
  String get emailInvalid => 'Похоже, адрес почты указан неверно.';

  @override
  String get passwordRequired => 'Введите пароль.';

  @override
  String passwordTooShort(int min) {
    return 'Используйте не менее $min символов.';
  }

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get forgotNeedsEmail =>
      'Введите почту выше, затем нажмите «Забыли пароль?».';

  @override
  String resetSent(String email) {
    return 'Если для $email есть аккаунт, ссылка для сброса уже отправлена.';
  }

  @override
  String get emailWorking => 'Минутку…';

  @override
  String get authErrWrongCredentials => 'Неверная почта или пароль.';

  @override
  String get authErrEmailInUse =>
      'Для этой почты уже есть аккаунт. Войдите в него.';

  @override
  String get authErrWeakPassword => 'Выберите пароль понадёжнее.';

  @override
  String get authErrDisabled => 'Этот аккаунт отключён.';

  @override
  String get authErrNotEnabled => 'Вход по почте сейчас недоступен.';

  @override
  String get authErrTooMany =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get authErrNetwork =>
      'Нет подключения. Проверьте интернет и попробуйте снова.';

  @override
  String get authErrGeneric => 'Не удалось войти. Попробуйте ещё раз.';

  @override
  String get deletePasswordBody =>
      'Введите пароль, чтобы подтвердить, что это вы.';

  @override
  String get deleteWrongPassword => 'Пароль не подходит к этому аккаунту.';

  @override
  String get purchaseSaveTitle => 'Сохраните покупку';

  @override
  String get purchaseSaveBody =>
      'По желанию: войдите, чтобы покупки и прогресс были на всех ваших устройствах. На этом покупка уже работает.';

  @override
  String get purchaseNeedsConnection =>
      'Не удалось связаться с сервером. Проверьте подключение и попробуйте снова.';

  @override
  String get languageSystemDefault => 'Как в системе';

  @override
  String get startupFailed =>
      'ПРИ ЗАПУСКЕ ЧТО-ТО ПОШЛО НЕ ТАК.\nЗАКРОЙТЕ ПРИЛОЖЕНИЕ И ОТКРОЙТЕ СНОВА.';

  @override
  String get notificationChannelDescription =>
      'Напоминания о листе дня и уведомления аккаунта';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'Винт, пластина $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'Винт, пластина $plate, закрыт пластиной $blocker';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label: $filled из $total';
  }

  @override
  String get chapterName1 => 'Основы мастерской';

  @override
  String get chapterName2 => 'Слой за слоем';

  @override
  String get chapterName3 => 'Освободите место';

  @override
  String get chapterName4 => 'Сцепление';

  @override
  String get chapterName5 => 'Мастер-строитель';

  @override
  String get chapterGoal1 => 'Нажать, выкрутить, снять';

  @override
  String get chapterGoal2 => 'Наложение и порядок';

  @override
  String get chapterGoal3 => 'План для тесного лотка';

  @override
  String get chapterGoal4 => 'Общие опоры';

  @override
  String get chapterGoal5 => 'Всё сразу, честно';

  @override
  String get chapterPitch1 =>
      'Нажмите на винт. Снимите пластину. Вот и все правила.';

  @override
  String get chapterPitch2 =>
      'Пластины прячут пластины. Работайте сверху вниз.';

  @override
  String get chapterPitch3 =>
      'Лотки теснее. Решите, какие винты выкрутить первыми.';

  @override
  String get chapterPitch4 =>
      'Одна пластина держит несколько. Найдите ключевую.';

  @override
  String get chapterPitch5 => 'Глубокие стопки, все идеи сразу. Не торопитесь.';

  @override
  String chapterNameDrawingSet(String number) {
    return 'Набор чертежей $number';
  }

  @override
  String get chapterGoalDownloaded => 'Листы для мастеров';

  @override
  String get chapterPitchDownloaded => 'Больше листов, те же честные правила.';

  @override
  String get mechanicOverlap => 'НАЛОЖЕНИЕ';

  @override
  String get mechanicTray => 'ЛОТОК';

  @override
  String get mechanicLayers => 'СЛОИ';

  @override
  String get mechanicCircles => 'КРУГИ';

  @override
  String get mechanicTraps => 'ЛОВУШКИ';

  @override
  String get mechanicSupports => 'ОПОРЫ';

  @override
  String get sheetObjective004 =>
      'СНИМИТЕ ВЕРХНЮЮ ПЛАСТИНУ, ЧТОБЫ ДОСТАТЬ ВИНТ';

  @override
  String get sheetObjective006 =>
      'В ЛОТКЕ 3 ЯЧЕЙКИ. СНЯТАЯ ПЛАСТИНА ИХ ОСВОБОДИТ';

  @override
  String get sheetObjective011 => 'ТРИ СЛОЯ. РАБОТАЙТЕ СВЕРХУ ВНИЗ';

  @override
  String get sheetObjective012 => 'СНИМИТЕ PL-04 РАНЬШЕ НИЖНИХ ПЛАСТИН';

  @override
  String get sheetObjective017 => 'ОДИН ЗАМАНЧИВЫЙ ХОД ЗАПОЛНИТ ЛОТОК';

  @override
  String get sheetObjective021 => 'КРУГЛЫЕ ПЛАСТИНЫ ТОЖЕ ПЕРЕКРЫВАЮТ';

  @override
  String get sheetObjective024 => 'СНИМИТЕ PL-04, ЧТОБЫ ДОБРАТЬСЯ ДО УГЛА';

  @override
  String get sheetObjective041 =>
      'ТЕСНЫЙ ЛОТОК. СНИМИТЕ ПЛАСТИНУ, ПОКА ОН НЕ ПОЛОН';

  @override
  String get sheetObjective061 =>
      'ОДНА ПЛАСТИНА МОЖЕТ ДЕРЖАТЬ НЕСКОЛЬКО ДРУГИХ';

  @override
  String get sheetObjective081 => 'ВСЁ, ЧЕМУ ВЫ НАУЧИЛИСЬ. НЕ ТОРОПИТЕСЬ';

  @override
  String get themeNameBlueprint => 'Чистый чертёж';

  @override
  String get themeNameWalnut => 'Ореховая мастерская';

  @override
  String get themeNameOcean => 'Морская бирюза';

  @override
  String get themeNameCopper => 'Тёплая медь';

  @override
  String get themeNameMidnight => 'Ночная мастерская';

  @override
  String get themeNamePastel => 'Пастельная студия';

  @override
  String sheetTitleNumbered(int number) {
    return 'Лист $number';
  }

  @override
  String get sheetTitle001 => 'Первый оборот';

  @override
  String get sheetTitle002 => 'Две точки';

  @override
  String get sheetTitle003 => 'Бок о бок';

  @override
  String get sheetTitle004 => 'Крышка';

  @override
  String get sheetTitle005 => 'Открытие';

  @override
  String get sheetTitle006 => 'День лотка';

  @override
  String get sheetTitle007 => 'Малый план';

  @override
  String get sheetTitle008 => 'Плотная посадка';

  @override
  String get sheetTitle009 => 'Круглый прокат';

  @override
  String get sheetTitle010 => 'Контрольная точка';

  @override
  String get sheetTitle011 => 'Третий слой';

  @override
  String get sheetTitle012 => 'Крестовина';

  @override
  String get sheetTitle013 => 'Освободи ячейку';

  @override
  String get sheetTitle014 => 'Два хода вперёд';

  @override
  String get sheetTitle015 => 'Крашеная сталь';

  @override
  String get sheetTitle016 => 'Верстак';

  @override
  String get sheetTitle017 => 'Соблазн';

  @override
  String get sheetTitle018 => 'Каскад';

  @override
  String get sheetTitle019 => 'Всего понемногу';

  @override
  String get sheetTitle020 => 'Сборка';

  @override
  String get sheetTitle021 => 'Стопка шайб';

  @override
  String get sheetTitle022 => 'Прокладка';

  @override
  String get sheetTitle023 => 'Крышка объектива';

  @override
  String get sheetTitle024 => 'Скрытый кронштейн';

  @override
  String get sheetTitle025 => 'Набор подкладок';

  @override
  String get sheetTitle026 => 'Ободок';

  @override
  String get sheetTitle027 => 'Люверс';

  @override
  String get sheetTitle028 => 'Передышка';

  @override
  String get sheetTitle029 => 'Фланец';

  @override
  String get sheetTitle030 => 'Иллюминатор';

  @override
  String get sheetTitle031 => 'Проставка';

  @override
  String get sheetTitle032 => 'Хомут';

  @override
  String get sheetTitle033 => 'Заглушка';

  @override
  String get sheetTitle034 => 'Тихая смена';

  @override
  String get sheetTitle035 => 'Переборка';

  @override
  String get sheetTitle036 => 'Смотровой люк';

  @override
  String get sheetTitle037 => 'Лицевая панель';

  @override
  String get sheetTitle038 => 'Лёгкий режим';

  @override
  String get sheetTitle039 => 'Розетка';

  @override
  String get sheetTitle040 => 'Слоёный торт';

  @override
  String get sheetTitle041 => 'Освободите место';

  @override
  String get sheetTitle042 => 'Место в ящике';

  @override
  String get sheetTitle043 => 'Переполнение';

  @override
  String get sheetTitle044 => 'Закуток';

  @override
  String get sheetTitle045 => 'Ящик с деталями';

  @override
  String get sheetTitle046 => 'Нехватка';

  @override
  String get sheetTitle047 => 'По полочкам';

  @override
  String get sheetTitle048 => 'Лёгкий выход';

  @override
  String get sheetTitle049 => 'Игровой автомат';

  @override
  String get sheetTitle050 => 'Аншлаг';

  @override
  String get sheetTitle051 => 'Завал';

  @override
  String get sheetTitle052 => 'Запасная ячейка';

  @override
  String get sheetTitle053 => 'Зазор';

  @override
  String get sheetTitle054 => 'Свободная посадка';

  @override
  String get sheetTitle055 => 'Инвентарь';

  @override
  String get sheetTitle056 => 'Припуск';

  @override
  String get sheetTitle057 => 'Допуск';

  @override
  String get sheetTitle058 => 'Выходной';

  @override
  String get sheetTitle059 => 'Запас высоты';

  @override
  String get sheetTitle060 => 'Склад';

  @override
  String get sheetTitle061 => 'Сцепка';

  @override
  String get sheetTitle062 => 'Косынка';

  @override
  String get sheetTitle063 => 'Замковый камень';

  @override
  String get sheetTitle064 => 'Внахлёст';

  @override
  String get sheetTitle065 => 'Накладка';

  @override
  String get sheetTitle066 => 'Ласточкин хвост';

  @override
  String get sheetTitle067 => 'Перемычка';

  @override
  String get sheetTitle068 => 'Обрезок';

  @override
  String get sheetTitle069 => 'Распорка';

  @override
  String get sheetTitle070 => 'Ферма';

  @override
  String get sheetTitle071 => 'Вилка';

  @override
  String get sheetTitle072 => 'Ярмо';

  @override
  String get sheetTitle073 => 'Седло';

  @override
  String get sheetTitle074 => 'Фундамент';

  @override
  String get sheetTitle075 => 'Пара кронштейнов';

  @override
  String get sheetTitle076 => 'Прижимная планка';

  @override
  String get sheetTitle077 => 'Стяжная пластина';

  @override
  String get sheetTitle078 => 'Простая панель';

  @override
  String get sheetTitle079 => 'Консоль';

  @override
  String get sheetTitle080 => 'Жёсткая рама';

  @override
  String get sheetTitle081 => 'Генеральный план';

  @override
  String get sheetTitle082 => 'Узел';

  @override
  String get sheetTitle083 => 'Вид в разнесении';

  @override
  String get sheetTitle084 => 'Проверка посадки';

  @override
  String get sheetTitle085 => 'Момент затяжки';

  @override
  String get sheetTitle086 => 'Кондуктор';

  @override
  String get sheetTitle087 => 'Оснастка';

  @override
  String get sheetTitle088 => 'Тихий верстак';

  @override
  String get sheetTitle089 => 'Редуктор';

  @override
  String get sheetTitle090 => 'Корпус';

  @override
  String get sheetTitle091 => 'Шасси';

  @override
  String get sheetTitle092 => 'Панельный отсек';

  @override
  String get sheetTitle093 => 'Набор крышек';

  @override
  String get sheetTitle094 => 'Лёгкая затяжка';

  @override
  String get sheetTitle095 => 'Опора двигателя';

  @override
  String get sheetTitle096 => 'Щитовая';

  @override
  String get sheetTitle097 => 'Блок управления';

  @override
  String get sheetTitle098 => 'Кульман';

  @override
  String get sheetTitle099 => 'Финальная проверка';

  @override
  String get sheetTitle100 => 'Подписано';
}
