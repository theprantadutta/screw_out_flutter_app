// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => '暫停';

  @override
  String get back => '返回';

  @override
  String get settings => '設定';

  @override
  String get tray => '托盤';

  @override
  String get trayFull => '托盤已滿';

  @override
  String get undo => '復原';

  @override
  String hintCount(String count) {
    return '提示 · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => '已暫停';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · 第 $moves 步';
  }

  @override
  String get resume => '繼續';

  @override
  String get sound => '音效';

  @override
  String get haptics => '震動';

  @override
  String get reducedMotion => '減少動態效果';

  @override
  String get restart => '重新開始';

  @override
  String get exitToSheets => '返回圖紙列表';

  @override
  String get restartConfirmTitle => '要重新開始這張圖紙嗎？';

  @override
  String restartConfirmBody(int moves) {
    return '你將失去 $moves 步的進度。';
  }

  @override
  String get cancel => '取消';

  @override
  String get stuckTitle => '沒有空格了。';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' $count 顆螺絲',
    );
    return '$plate 還在盤面上固定著$_temp0。復原可以騰出一格。';
  }

  @override
  String get stuckReasonGeneric => '所有格子都滿了，也沒有板子能掉落。復原可以騰出一格。';

  @override
  String get undoLastMove => '復原上一步';

  @override
  String rescueSlotCoins(int coins) {
    return '額外格子 · $coins ¢';
  }

  @override
  String get rescueSlotAd => '額外格子 · 影片';

  @override
  String get rescueSlotPro => '額外格子 · PRO';

  @override
  String get outOfHintsTitle => '還想要一個提示嗎？';

  @override
  String get hintsLeftZero => '提示 · 剩 0 個';

  @override
  String get outOfHintsBody => '提示會圈出下一顆有用的螺絲，但絕不會替你解開圖紙。';

  @override
  String get watchVideo => '觀看短片';

  @override
  String get watchVideoMeta => '自由選擇 · 約 30 秒 · 提示 +1';

  @override
  String useCoins(int coins) {
    return '使用 $coins 金幣';
  }

  @override
  String useCoinsMeta(int balance) {
    return '餘額 $balance ¢';
  }

  @override
  String get keepThinking => '再想想';

  @override
  String get notEnoughCoins => '金幣還不夠。';

  @override
  String get adUnavailable => '目前沒有可觀看的影片。';

  @override
  String cleared(String code) {
    return '$code · 完成';
  }

  @override
  String get disassembled => '拆解完成。';

  @override
  String get approved => '核准';

  @override
  String get statMoves => '步數';

  @override
  String get statTime => '時間';

  @override
  String get statMastery => '精通';

  @override
  String nextSheet(String code) {
    return '下一張 · $code';
  }

  @override
  String get replay => '重玩';

  @override
  String get sheets => '圖紙';

  @override
  String get backHome => '回到首頁';

  @override
  String chapterComplete(String chapter) {
    return '第 $chapter 章 · 完成';
  }

  @override
  String get themeUnlocked => '解鎖主題';

  @override
  String nextChapter(String chapter) {
    return '下一章 · 第 $chapter 章';
  }

  @override
  String startChapter(String chapter) {
    return '開始第 $chapter 章';
  }

  @override
  String equipTheme(String name) {
    return '套用$name';
  }

  @override
  String get tutorialStep1 => '步驟 1 · 點一下螺絲';

  @override
  String get tutorialLands => '↓ 它會落進托盤';

  @override
  String get skipTutorial => '略過教學';

  @override
  String get splashTagline => '層層拆解的謎題';

  @override
  String get splashFooter => '版次 1.0 · 圖紙 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates 塊板子',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: '個緊固件',
    );
    return '圖 1\n爆炸圖\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return '第 $chapter/$total 章';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '緊固件',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => '下一張圖紙';

  @override
  String chapterLabel(String chapter) {
    return '第 $chapter 章';
  }

  @override
  String get campaign => '主線關卡';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return '繼續 · $code';
  }

  @override
  String get daily => '每日';

  @override
  String get themes => '主題';

  @override
  String get allCleared => '所有圖紙已完成';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total 張圖紙';
  }

  @override
  String get fiveChapters => '五個章節';

  @override
  String get chaptersTitle => '章節';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => '未解鎖';

  @override
  String get downloadChapter => '下載';

  @override
  String get downloading => '下載中…';

  @override
  String get comingSoon => '更多圖紙即將推出';

  @override
  String newMechanic(String mechanic) {
    return '新機制：$mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '$plates 塊板子',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers 層',
    );
    return '$_temp0 · $_temp1 · 托盤 $tray';
  }

  @override
  String get theCampaign => '主線關卡';

  @override
  String get campaignFooter => '完成前一章即可解鎖下一章。精通標記可自由挑戰。提示絕不會阻礙進度。';

  @override
  String get chapterBonus => '章節獎勵';

  @override
  String get dailySheet => '每日圖紙';

  @override
  String get dailyTitle => '名稱';

  @override
  String get dailyPlates => '板子';

  @override
  String get dailyReward => '獎勵';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '已連續 $streak 天。',
      zero: '開始累積連續紀錄吧。',
    );
    return '今天所有人都玩同一張圖紙。沒有計時。$_temp0錯過一天也沒有任何損失。';
  }

  @override
  String get startDaily => '開始今日圖紙';

  @override
  String get dailyCompleted => '今天已完成 · 明天再來';

  @override
  String get replayDaily => '重玩今日圖紙';

  @override
  String get themesTitle => '主題';

  @override
  String get themesCaption => '純外觀 · 不影響規則';

  @override
  String get equipped => '使用中';

  @override
  String get owned => '已擁有';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => '預覽';

  @override
  String get settingsTitle => '設定';

  @override
  String get feedbackSection => '回饋';

  @override
  String get soundEffects => '音效';

  @override
  String get music => '音樂';

  @override
  String get hapticsRow => '震動回饋';

  @override
  String get reducedMotionRow => '減少動態效果';

  @override
  String get reducedMotionCaption => '以淡入淡出取代移動';

  @override
  String get generalSection => '一般';

  @override
  String get highRefreshRate => '高螢幕更新率';

  @override
  String highRefreshRateOn(int hz) {
    return '動畫更流暢 · 最高 $hz Hz · 較耗電';
  }

  @override
  String get highRefreshRateOff => '動畫更流暢 · 較耗電';

  @override
  String get highRefreshRateUnsupported => '此螢幕僅支援單一更新率';

  @override
  String get highRefreshRateBattery => '目前受省電模式限制';

  @override
  String get highRefreshRateHeat => '手機過熱，暫時受限';

  @override
  String highRefreshRateNow(int hz) {
    return '目前 $hz Hz';
  }

  @override
  String get language => '語言';

  @override
  String get notifications => '每日提醒';

  @override
  String get notificationsCaption => '新圖紙上架時提醒你一次';

  @override
  String get accountSection => '帳戶';

  @override
  String get signInGoogle => '使用 Google 帳戶登入';

  @override
  String get signInApple => '透過 Apple 登入';

  @override
  String signedInAs(String name) {
    return '已登入 · $name';
  }

  @override
  String get guestCaption => '以訪客身分遊玩 · 登入即可儲存進度';

  @override
  String get signOut => '登出';

  @override
  String get deleteAccount => '刪除帳戶';

  @override
  String get purchasesSection => '購買';

  @override
  String get removeAds => '移除廣告';

  @override
  String get restore => '恢復購買';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return '無廣告 · 無限提示 · 所有主題 · 免費救援 · 每月 $coins ¢';
  }

  @override
  String get proMonthly => '月訂閱';

  @override
  String get proYearly => '年訂閱';

  @override
  String proTrialDays(int days) {
    return '免費 $days 天';
  }

  @override
  String proThenPrice(String price) {
    return '之後 $price';
  }

  @override
  String get proTrialTerms => '免費試用結束後將自動續訂，除非你取消。每月金幣從首次付款起發放。';

  @override
  String get proActive => 'PRO · 已啟用';

  @override
  String get adsRemoved => '已移除廣告';

  @override
  String get coinPacks => '金幣包';

  @override
  String get aboutSection => '關於';

  @override
  String get privacyPolicy => '隱私權政策';

  @override
  String get termsOfUse => '使用條款';

  @override
  String get refundPolicy => '退款政策';

  @override
  String get privacyChoices => '隱私權選項';

  @override
  String get licenses => '授權與致謝';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · 版次 $version ($build)';
  }

  @override
  String get notificationPrimerTitle => '要提醒你每日圖紙嗎？';

  @override
  String get notificationPrimerBody => '當你一陣子沒玩時，安靜地提醒你一下。每天最多一次。';

  @override
  String get allow => '允許';

  @override
  String get notNow => '稍後再說';

  @override
  String get somethingWentWrong => '發生錯誤。';

  @override
  String get purchaseThanks => '謝謝你！購買已生效。';

  @override
  String get purchasePending => '購買處理中，確認後即會生效。';

  @override
  String get purchaseFailed => '購買未完成。';

  @override
  String get restored => '已恢復購買項目。';

  @override
  String finishChapterFirst(String chapter) {
    return '請先完成第 $chapter 章。';
  }

  @override
  String get moreSheetsTitle => '更多圖紙';

  @override
  String get moreSheetsCaption => '新的圖紙組會出現在這裡';

  @override
  String get equip => '套用';

  @override
  String buyFor(int coins) {
    return '購買 · $coins ¢';
  }

  @override
  String get close => '關閉';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => '授權';

  @override
  String get licensesCaption => '開放原始碼聲明';

  @override
  String playLevel(String code) {
    return '開始 $code';
  }

  @override
  String lockedLevel(int number) {
    return '圖紙 $number，未解鎖';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => '排行榜';

  @override
  String get leaderboardCaption => '已登入玩家 · 即時';

  @override
  String get boardSheets => '圖紙';

  @override
  String get boardDaily => '每日';

  @override
  String get boardStreak => '連續';

  @override
  String get boardWeekly => '本週';

  @override
  String get boardWeeklyHint => '本週完成的圖紙 · 每週一重設';

  @override
  String get boardSheetsHint => '完成最多圖紙';

  @override
  String get boardDailyHint => '今日圖紙 · 步數最少，其次最快';

  @override
  String get boardStreakHint => '連續完成每日圖紙的天數';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '步',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
    );
    return '$_temp0 · 最佳 $best';
  }

  @override
  String get boardYou => '你';

  @override
  String get boardYourRank => '你的排名';

  @override
  String get boardNotRanked => '尚無排名';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '/ $countString 人';
  }

  @override
  String get boardGuest => '登入後，你的名字就能登上排行榜，進度也會跟著你。';

  @override
  String get boardEmpty => '這裡還沒有人。搶當第一吧。';

  @override
  String get boardOffline => '目前無法連線到排行榜。';

  @override
  String get tryAgainCaps => '再試一次';

  @override
  String get todaysBoard => '今日排行榜';

  @override
  String get signedOutToast => '已登出 · 此裝置的資料已清除。重新登入即可取回進度。';

  @override
  String get welcomeBack => '歡迎回來';

  @override
  String welcomeBackName(String name) {
    return '歡迎回來，$name';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: ' $sheets 張圖紙',
    );
    return '$who · 已恢復$_temp0和 $coins 金幣';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · 你已登入，進度已備份';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets 張圖紙',
    );
    return '$who · 此裝置的進度已加入你的帳戶：$_temp0、$coins 金幣';
  }

  @override
  String syncSavedNew(String name) {
    return '已以 $name 登入 · 你的進度現在會儲存到帳戶';
  }

  @override
  String get syncSavedNewPlain => '已登入 · 你的進度現在會儲存到帳戶';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheets 張新圖紙',
      zero: '進度已更新',
    );
    return '已從你的其他裝置同步 · $_temp0';
  }

  @override
  String get syncRestoreFailed => '暫時無法載入已儲存的進度 · 恢復連線後會自動同步';

  @override
  String get signedInOffline => '已登入 · 恢復連線後進度會自動同步';

  @override
  String get proActivated => 'Pro 已啟用 · 無廣告、所有主題與無限提示';

  @override
  String get accountDeletedToast => '你的帳戶與所有資料已刪除。';

  @override
  String accountDeletedProToast(String store) {
    return '帳戶已刪除。在你於 $store 取消前，Pro 仍會持續收費。';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '連續 $days 天 · 獎勵 +$coins';
  }

  @override
  String get workshopRecord => '工坊紀錄';

  @override
  String workshopRecordButton(int earned, int total) {
    return '工坊紀錄 · $earned/$total';
  }

  @override
  String get recordCaption => '里程碑';

  @override
  String recordEarned(int earned, int total) {
    return '已獲得 $earned/$total';
  }

  @override
  String get badgeEarnedLabel => '已獲得';

  @override
  String badgeEarnedToast(String name) {
    return '獲得徽章 · $name';
  }

  @override
  String get badgeFirstTurn => '第一圈';

  @override
  String get badgeApprentice => '學徒';

  @override
  String get badgeJourneyman => '熟手';

  @override
  String get badgeCraftsman => '工匠';

  @override
  String get badgeChiefEngineer => '總工程師';

  @override
  String get badgeCleanWork => '乾淨俐落';

  @override
  String get badgePerfectionist => '完美主義者';

  @override
  String get badgeRegular => '常客';

  @override
  String get badgeOnARoll => '手感正熱';

  @override
  String get badgeFullWeek => '滿滿一週';

  @override
  String get badgeFortnight => '連續兩週';

  @override
  String get badgeFirstDetail => '完成第一張圖紙';

  @override
  String badgeClearDetail(int n) {
    return '完成 $n 張圖紙';
  }

  @override
  String badgeChapterDetail(int n) {
    return '完成第 $n 章';
  }

  @override
  String badgeMasterDetail(int n) {
    return '在 $n 張圖紙獲得 ◆';
  }

  @override
  String badgeDailyDetail(int n) {
    return '玩 $n 張每日圖紙';
  }

  @override
  String badgeStreakDetail(int n) {
    return '達成連續 $n 天';
  }

  @override
  String get share => '分享';

  @override
  String get shareResult => '分享成績';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves 步',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '連續 $days 天';
  }

  @override
  String get signOutSheetTitle => '要登出嗎？';

  @override
  String get signOutSheetBody =>
      '登出會清除此裝置上的進度。已備份的內容在重新登入後會回來，但尚未同步的內容（例如離線玩的圖紙）將會遺失。';

  @override
  String get staySignedIn => '保持登入';

  @override
  String get signOutConfirm => '登出';

  @override
  String get rateApp => '為 Screw Out 評分';

  @override
  String get sendFeedback => '提供意見';

  @override
  String get replayTutorial => '重看教學';

  @override
  String feedbackNoEmailApp(String email) {
    return '找不到電子郵件 App。請寫信到 $email';
  }

  @override
  String get updateChip => '更新';

  @override
  String get updateReadyRestart => '更新已下載，重新啟動即可安裝。';

  @override
  String get deleteSheetTitle => '要刪除你的帳戶嗎？';

  @override
  String get deleteSheetBody =>
      '這會永久刪除你的帳戶與所有相關資料：每張圖紙的進度、金幣、主題、每日連續紀錄與排行榜名次。此動作無法復原。';

  @override
  String deleteSheetPro(String store) {
    return '你已訂閱 Screw Out Pro。刪除帳戶不會取消訂閱：請在 $store 取消訂閱，否則將持續收費。';
  }

  @override
  String get manageSubscription => '管理訂閱';

  @override
  String get deleteForever => '刪除我的帳戶';

  @override
  String get deleting => '刪除中…';

  @override
  String get keepAccount => '保留我的帳戶';

  @override
  String get deleteOffline => '你目前離線。請連上網路後再刪除帳戶。';

  @override
  String get deleteFailed => '無法刪除你的帳戶，請再試一次。';

  @override
  String get restoreNothing => '此帳戶沒有可恢復的項目。';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · 提示 +1';
  }

  @override
  String get hintEarnedToast => '提示 +1 · 感謝觀看';

  @override
  String get rescueToast => '本張圖紙托盤格子 +1';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · 托盤格子 +1';
  }

  @override
  String get adNotCompleted => '影片沒有看完，這次沒有獎勵。';

  @override
  String themeEquippedToast(String name) {
    return '已套用$name';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return '第 $chapter 章已就緒';
  }

  @override
  String get signInFailed => '登入未完成。';

  @override
  String get themePurchased => '主題已解鎖。';

  @override
  String themeBuyStore(String price) {
    return '或購買 · $price';
  }

  @override
  String get themesBundleTitle => '所有主題';

  @override
  String get themesBundleBody => '所有付費主題，永久擁有。Pro 也包含這些主題。';

  @override
  String themesBundleBuy(String price) {
    return '購買 · $price';
  }

  @override
  String get dailyWeekDone => '已完成';

  @override
  String masteredCount(int count) {
    return '精通 $count 張';
  }

  @override
  String get reminderTitle => '今日圖紙已準備好';

  @override
  String get reminderBody => '一張全新圖紙，所有人都一樣。沒有計時。';

  @override
  String get comebackReminderTitle => '你的下一張圖紙正在工作檯上等你';

  @override
  String get comebackReminderBody => '幾分鐘的平靜，幾顆螺絲。從上次停下的地方繼續吧。';

  @override
  String get signInEmail => '使用電子郵件繼續';

  @override
  String get emailSignInTitle => '登入';

  @override
  String get emailCreateTitle => '建立帳戶';

  @override
  String get emailTabSignIn => '登入';

  @override
  String get emailTabCreate => '建立帳戶';

  @override
  String get emailSheetBody => '你在此裝置上的進度會跟著你。';

  @override
  String get emailLabel => '電子郵件';

  @override
  String get passwordLabel => '密碼';

  @override
  String get showPassword => '顯示密碼';

  @override
  String get hidePassword => '隱藏密碼';

  @override
  String passwordHint(int min) {
    return '至少 $min 個字元';
  }

  @override
  String get emailRequired => '請輸入電子郵件。';

  @override
  String get emailInvalid => '這個電子郵件地址看起來不正確。';

  @override
  String get passwordRequired => '請輸入密碼。';

  @override
  String passwordTooShort(int min) {
    return '請使用至少 $min 個字元。';
  }

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get forgotNeedsEmail => '請先在上方輸入電子郵件，再點一下「忘記密碼？」。';

  @override
  String resetSent(String email) {
    return '如果 $email 有帳戶，重設連結已寄出。';
  }

  @override
  String get emailWorking => '請稍候…';

  @override
  String get authErrWrongCredentials => '電子郵件或密碼錯誤。';

  @override
  String get authErrEmailInUse => '此電子郵件已有帳戶，請直接登入。';

  @override
  String get authErrWeakPassword => '請設定更強的密碼。';

  @override
  String get authErrDisabled => '此帳戶已停用。';

  @override
  String get authErrNotEnabled => '目前無法使用電子郵件登入。';

  @override
  String get authErrTooMany => '嘗試次數過多，請稍候再試。';

  @override
  String get authErrNetwork => '沒有網路連線。請檢查網路後再試一次。';

  @override
  String get authErrGeneric => '無法登入，請再試一次。';

  @override
  String get deletePasswordBody => '請輸入密碼以確認是你本人。';

  @override
  String get deleteWrongPassword => '密碼與此帳戶不符。';

  @override
  String get purchaseSaveTitle => '保留你的購買項目';

  @override
  String get purchaseSaveBody => '自由選擇：登入後，你的購買項目與進度可以在所有裝置上保留。購買在這台裝置上已經生效。';

  @override
  String get purchaseNeedsConnection => '無法連線到伺服器。請檢查網路連線後再試一次。';

  @override
  String get languageSystemDefault => '系統預設';

  @override
  String get startupFailed => '啟動時發生錯誤。\n請關閉 App 後重新開啟。';

  @override
  String get notificationChannelDescription => '每日圖紙提醒與帳戶通知';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return '螺絲，板子 $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return '螺絲，板子 $plate，被 $blocker 擋住';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $filled/$total';
  }

  @override
  String get chapterName1 => '工坊基礎';

  @override
  String get chapterName2 => '一層一層';

  @override
  String get chapterName3 => '騰出空間';

  @override
  String get chapterName4 => '環環相扣';

  @override
  String get chapterName5 => '建造大師';

  @override
  String get chapterGoal1 => '點擊、取下、鬆開';

  @override
  String get chapterGoal2 => '層疊與揭開的順序';

  @override
  String get chapterGoal3 => '在狹小托盤中規劃';

  @override
  String get chapterGoal4 => '共用的支撐';

  @override
  String get chapterGoal5 => '集大成，公平依舊';

  @override
  String get chapterPitch1 => '點一下螺絲，讓板子落下。規則就這麼簡單。';

  @override
  String get chapterPitch2 => '板子壓著板子。由上往下拆。';

  @override
  String get chapterPitch3 => '托盤更小了。先規劃要取下哪些螺絲。';

  @override
  String get chapterPitch4 => '一塊板子壓住好幾塊。找出關鍵那一塊。';

  @override
  String get chapterPitch5 => '層層深疊，所有概念一次登場。慢慢來。';

  @override
  String chapterNameDrawingSet(String number) {
    return '圖紙組 $number';
  }

  @override
  String get chapterGoalDownloaded => '大師級圖紙';

  @override
  String get chapterPitchDownloaded => '更多圖紙，規則同樣公平。';

  @override
  String get mechanicOverlap => '重疊';

  @override
  String get mechanicTray => '托盤';

  @override
  String get mechanicLayers => '多層';

  @override
  String get mechanicCircles => '圓形';

  @override
  String get mechanicTraps => '陷阱';

  @override
  String get mechanicSupports => '支撐';

  @override
  String get sheetObjective004 => '拿起上層板子，就能碰到下面的螺絲';

  @override
  String get sheetObjective006 => '托盤可放 3 顆。板子鬆開後會空出格子';

  @override
  String get sheetObjective011 => '三層。由上往下拆';

  @override
  String get sheetObjective012 => '先拿起 PL-04，再處理下方的板子';

  @override
  String get sheetObjective017 => '有一步很誘人，但會塞滿托盤';

  @override
  String get sheetObjective021 => '圓形板子一樣會遮住下方';

  @override
  String get sheetObjective024 => '移除 PL-04 才能碰到角落';

  @override
  String get sheetObjective041 => '托盤很小。在塞滿前先鬆開一塊板子';

  @override
  String get sheetObjective061 => '一塊板子可以壓住好幾塊';

  @override
  String get sheetObjective081 => '學過的一切全都用上。慢慢來';

  @override
  String get themeNameBlueprint => '簡潔藍圖';

  @override
  String get themeNameWalnut => '胡桃木工坊';

  @override
  String get themeNameOcean => '海洋青';

  @override
  String get themeNameCopper => '暖銅';

  @override
  String get themeNameMidnight => '午夜工坊';

  @override
  String get themeNamePastel => '粉彩工作室';

  @override
  String sheetTitleNumbered(int number) {
    return '圖紙 $number';
  }

  @override
  String get sheetTitle001 => '第一圈';

  @override
  String get sheetTitle002 => '兩點固定';

  @override
  String get sheetTitle003 => '並排';

  @override
  String get sheetTitle004 => '蓋板';

  @override
  String get sheetTitle005 => '揭開';

  @override
  String get sheetTitle006 => '托盤日';

  @override
  String get sheetTitle007 => '小小計畫';

  @override
  String get sheetTitle008 => '緊配合';

  @override
  String get sheetTitle009 => '圓棒料';

  @override
  String get sheetTitle010 => '檢查點';

  @override
  String get sheetTitle011 => '第三層';

  @override
  String get sheetTitle012 => '交叉支撐';

  @override
  String get sheetTitle013 => '騰出一格';

  @override
  String get sheetTitle014 => '先想兩步';

  @override
  String get sheetTitle015 => '烤漆鋼板';

  @override
  String get sheetTitle016 => '工作檯';

  @override
  String get sheetTitle017 => '誘惑';

  @override
  String get sheetTitle018 => '連鎖';

  @override
  String get sheetTitle019 => '工坊綜合';

  @override
  String get sheetTitle020 => '組裝';

  @override
  String get sheetTitle021 => '墊圈疊';

  @override
  String get sheetTitle022 => '密封墊';

  @override
  String get sheetTitle023 => '鏡頭蓋';

  @override
  String get sheetTitle024 => '隱藏支架';

  @override
  String get sheetTitle025 => '調整墊片組';

  @override
  String get sheetTitle026 => '外框';

  @override
  String get sheetTitle027 => '護線環';

  @override
  String get sheetTitle028 => '喘口氣';

  @override
  String get sheetTitle029 => '法蘭環';

  @override
  String get sheetTitle030 => '舷窗';

  @override
  String get sheetTitle031 => '間隔環';

  @override
  String get sheetTitle032 => '軸環';

  @override
  String get sheetTitle033 => '端蓋';

  @override
  String get sheetTitle034 => '安靜的班';

  @override
  String get sheetTitle035 => '隔艙壁';

  @override
  String get sheetTitle036 => '檢修口';

  @override
  String get sheetTitle037 => '面板';

  @override
  String get sheetTitle038 => '輕型作業';

  @override
  String get sheetTitle039 => '玫瑰飾';

  @override
  String get sheetTitle040 => '千層蛋糕';

  @override
  String get sheetTitle041 => '騰出空間';

  @override
  String get sheetTitle042 => '料箱空間';

  @override
  String get sheetTitle043 => '滿溢';

  @override
  String get sheetTitle044 => '小格櫃';

  @override
  String get sheetTitle045 => '零件盒';

  @override
  String get sheetTitle046 => '庫存不足';

  @override
  String get sheetTitle047 => '分類格';

  @override
  String get sheetTitle048 => '輕鬆脫身';

  @override
  String get sheetTitle049 => '拉霸機';

  @override
  String get sheetTitle050 => '客滿';

  @override
  String get sheetTitle051 => '積壓工作';

  @override
  String get sheetTitle052 => '備用格';

  @override
  String get sheetTitle053 => '間隙';

  @override
  String get sheetTitle054 => '鬆配合';

  @override
  String get sheetTitle055 => '盤點';

  @override
  String get sheetTitle056 => '裕度';

  @override
  String get sheetTitle057 => '公差';

  @override
  String get sheetTitle058 => '休假日';

  @override
  String get sheetTitle059 => '頭頂空間';

  @override
  String get sheetTitle060 => '收納';

  @override
  String get sheetTitle061 => '互鎖';

  @override
  String get sheetTitle062 => '角撐板';

  @override
  String get sheetTitle063 => '拱心石';

  @override
  String get sheetTitle064 => '搭接';

  @override
  String get sheetTitle065 => '拼接板';

  @override
  String get sheetTitle066 => '鳩尾榫';

  @override
  String get sheetTitle067 => '楣梁';

  @override
  String get sheetTitle068 => '邊角料';

  @override
  String get sheetTitle069 => '支柱';

  @override
  String get sheetTitle070 => '桁架';

  @override
  String get sheetTitle071 => 'U 形夾';

  @override
  String get sheetTitle072 => '軛';

  @override
  String get sheetTitle073 => '鞍座';

  @override
  String get sheetTitle074 => '基腳';

  @override
  String get sheetTitle075 => '成對支架';

  @override
  String get sheetTitle076 => '夾桿';

  @override
  String get sheetTitle077 => '繫板';

  @override
  String get sheetTitle078 => '素面板';

  @override
  String get sheetTitle079 => '懸臂';

  @override
  String get sheetTitle080 => '剛構架';

  @override
  String get sheetTitle081 => '總體規劃';

  @override
  String get sheetTitle082 => '次組件';

  @override
  String get sheetTitle083 => '爆炸圖';

  @override
  String get sheetTitle084 => '配合檢查';

  @override
  String get sheetTitle085 => '扭力規格';

  @override
  String get sheetTitle086 => '治具';

  @override
  String get sheetTitle087 => '夾具';

  @override
  String get sheetTitle088 => '安靜工作檯';

  @override
  String get sheetTitle089 => '齒輪箱';

  @override
  String get sheetTitle090 => '外殼';

  @override
  String get sheetTitle091 => '底盤';

  @override
  String get sheetTitle092 => '面板艙';

  @override
  String get sheetTitle093 => '蓋板組';

  @override
  String get sheetTitle094 => '輕鬆扭力';

  @override
  String get sheetTitle095 => '引擎腳架';

  @override
  String get sheetTitle096 => '開關設備';

  @override
  String get sheetTitle097 => '控制箱';

  @override
  String get sheetTitle098 => '製圖桌';

  @override
  String get sheetTitle099 => '最終檢驗';

  @override
  String get sheetTitle100 => '簽核';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');
}
