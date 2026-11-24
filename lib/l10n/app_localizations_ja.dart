// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => '一時停止';

  @override
  String get back => '戻る';

  @override
  String get settings => '設定';

  @override
  String get tray => 'トレイ';

  @override
  String get trayFull => 'トレイ満杯';

  @override
  String get undo => '戻す';

  @override
  String hintCount(String count) {
    return 'ヒント · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => '一時停止中';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · $moves手目';
  }

  @override
  String get resume => '再開';

  @override
  String get sound => 'サウンド';

  @override
  String get haptics => '振動';

  @override
  String get reducedMotion => 'モーション軽減';

  @override
  String get restart => 'やり直す';

  @override
  String get exitToSheets => 'シート一覧へ';

  @override
  String get restartConfirmTitle => 'このシートをやり直しますか？';

  @override
  String restartConfirmBody(int moves) {
    return '$moves手分の進行が失われます。';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get stuckTitle => '空きスロットがありません。';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count本のネジ',
    );
    return '$plateがまだ盤上で$_temp0を留めています。戻すとスロットが空きます。';
  }

  @override
  String get stuckReasonGeneric => 'スロットはすべて埋まり、外せるプレートもありません。戻すとスロットが空きます。';

  @override
  String get undoLastMove => '最後の一手を戻す';

  @override
  String rescueSlotCoins(int coins) {
    return '追加スロット · $coins ¢';
  }

  @override
  String get rescueSlotAd => '追加スロット · 動画';

  @override
  String get rescueSlotPro => '追加スロット · PRO';

  @override
  String get outOfHintsTitle => 'ヒントをもうひとつ？';

  @override
  String get hintsLeftZero => 'ヒント · 残り0';

  @override
  String get outOfHintsBody => 'ヒントは次に役立つネジをひとつ丸で示します。答えまでは教えません。';

  @override
  String get watchVideo => '短い動画を見る';

  @override
  String get watchVideoMeta => '任意 · 約30秒 · ヒント+1';

  @override
  String useCoins(int coins) {
    return '$coinsコインを使う';
  }

  @override
  String useCoinsMeta(int balance) {
    return '残高 $balance ¢';
  }

  @override
  String get keepThinking => 'もう少し考える';

  @override
  String get notEnoughCoins => 'コインが足りません。';

  @override
  String get adUnavailable => '現在視聴できる動画がありません。';

  @override
  String cleared(String code) {
    return '$code · クリア';
  }

  @override
  String get disassembled => '分解完了。';

  @override
  String get approved => '承認';

  @override
  String get statMoves => '手数';

  @override
  String get statTime => 'タイム';

  @override
  String get statMastery => 'マスター';

  @override
  String nextSheet(String code) {
    return '次のシート · $code';
  }

  @override
  String get replay => 'もう一度';

  @override
  String get sheets => 'シート';

  @override
  String get backHome => 'ホームへ';

  @override
  String chapterComplete(String chapter) {
    return 'チャプター$chapter · 完了';
  }

  @override
  String get themeUnlocked => 'テーマ解放';

  @override
  String nextChapter(String chapter) {
    return '次 · チャプター$chapter';
  }

  @override
  String startChapter(String chapter) {
    return 'チャプター$chapterを始める';
  }

  @override
  String equipTheme(String name) {
    return '$nameを装備';
  }

  @override
  String get tutorialStep1 => 'ステップ1 · ネジをタップ';

  @override
  String get tutorialLands => '↓ トレイに入ります';

  @override
  String get skipTutorial => 'チュートリアルを飛ばす';

  @override
  String get splashTagline => '重なりを解くパズル';

  @override
  String get splashFooter => '改訂 1.0 · シート 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: 'プレート $plates枚',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: '本の留め具',
    );
    return '図 1\n分解図\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return 'チャプター $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '本の留め具',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => '次のシート';

  @override
  String chapterLabel(String chapter) {
    return 'チャプター$chapter';
  }

  @override
  String get campaign => 'キャンペーン';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return '続ける · $code';
  }

  @override
  String get daily => 'デイリー';

  @override
  String get themes => 'テーマ';

  @override
  String get allCleared => '全シートクリア';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total シート';
  }

  @override
  String get fiveChapters => '5つのチャプター';

  @override
  String get chaptersTitle => 'チャプター';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => 'ロック中';

  @override
  String get downloadChapter => 'ダウンロード';

  @override
  String get downloading => 'ダウンロード中…';

  @override
  String get comingSoon => '新しいシートは近日公開';

  @override
  String newMechanic(String mechanic) {
    return '新要素：$mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: 'プレート$plates枚',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers層',
    );
    return '$_temp0 · $_temp1 · トレイ $tray';
  }

  @override
  String get theCampaign => 'キャンペーン';

  @override
  String get campaignFooter =>
      '前のチャプターをクリアすると次が解放されます。マスターマークは任意です。ヒントで進行が妨げられることはありません。';

  @override
  String get chapterBonus => 'チャプターボーナス';

  @override
  String get dailySheet => 'デイリーシート';

  @override
  String get dailyTitle => '名称';

  @override
  String get dailyPlates => 'プレート';

  @override
  String get dailyReward => '報酬';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak日連続。',
      zero: '連続記録を始めましょう。',
    );
    return '今日は全員が同じシート。制限時間なし。${_temp0}1日休んでも何も失いません。';
  }

  @override
  String get startDaily => '今日のシートを始める';

  @override
  String get dailyCompleted => '今日は完了 · また明日';

  @override
  String get replayDaily => '今日のシートをもう一度';

  @override
  String get themesTitle => 'テーマ';

  @override
  String get themesCaption => '見た目だけ · ルールは不変';

  @override
  String get equipped => '装備中';

  @override
  String get owned => '所持';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => 'プレビュー';

  @override
  String get settingsTitle => '設定';

  @override
  String get feedbackSection => 'フィードバック';

  @override
  String get soundEffects => '効果音';

  @override
  String get music => '音楽';

  @override
  String get hapticsRow => '振動';

  @override
  String get reducedMotionRow => 'モーション軽減';

  @override
  String get reducedMotionCaption => '移動の代わりにフェード';

  @override
  String get generalSection => '一般';

  @override
  String get highRefreshRate => '高リフレッシュレート';

  @override
  String highRefreshRateOn(int hz) {
    return 'なめらかな動き · 最大$hz Hz · バッテリー消費増';
  }

  @override
  String get highRefreshRateOff => 'なめらかな動き · バッテリー消費増';

  @override
  String get highRefreshRateUnsupported => 'この画面は単一のリフレッシュレートです';

  @override
  String get highRefreshRateBattery => '現在バッテリーセーバーで制限中';

  @override
  String get highRefreshRateHeat => '端末が熱いため制限中';

  @override
  String highRefreshRateNow(int hz) {
    return '現在 $hz Hz';
  }

  @override
  String get language => '言語';

  @override
  String get notifications => 'デイリーリマインダー';

  @override
  String get notificationsCaption => '新しいシートが出たら一度だけお知らせ';

  @override
  String get accountSection => 'アカウント';

  @override
  String get signInGoogle => 'Googleでログイン';

  @override
  String get signInApple => 'Appleでサインイン';

  @override
  String signedInAs(String name) {
    return 'ログイン中 · $name';
  }

  @override
  String get guestCaption => 'ゲストでプレイ中 · ログインして進行を保存';

  @override
  String get signOut => 'ログアウト';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get purchasesSection => '購入';

  @override
  String get removeAds => '広告を削除';

  @override
  String get restore => '復元';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return '広告なし · ヒント無制限 · 全テーマ · 救済無料 · 毎月$coins ¢';
  }

  @override
  String get proMonthly => '月額';

  @override
  String get proYearly => '年額';

  @override
  String proTrialDays(int days) {
    return '$days日間無料';
  }

  @override
  String proThenPrice(String price) {
    return '以降 $price';
  }

  @override
  String get proTrialTerms =>
      '無料トライアル終了後、解約しない限り自動更新されます。毎月のコインは初回のお支払いから付与されます。';

  @override
  String get proActive => 'PRO · 有効';

  @override
  String get adsRemoved => '広告削除済み';

  @override
  String get coinPacks => 'コインパック';

  @override
  String get aboutSection => '情報';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfUse => '利用規約';

  @override
  String get refundPolicy => '返金ポリシー';

  @override
  String get privacyChoices => 'プライバシー設定';

  @override
  String get licenses => 'ライセンスとクレジット';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · 改訂 $version ($build)';
  }

  @override
  String get notificationPrimerTitle => 'デイリーシートをお知らせしますか？';

  @override
  String get notificationPrimerBody => 'しばらく遊んでいないときに、控えめにお知らせします。1日1回までです。';

  @override
  String get allow => '許可';

  @override
  String get notNow => '今はしない';

  @override
  String get somethingWentWrong => '問題が発生しました。';

  @override
  String get purchaseThanks => 'ありがとうございます！購入が反映されました。';

  @override
  String get purchasePending => '購入処理中です。確認後に反映されます。';

  @override
  String get purchaseFailed => '購入が完了しませんでした。';

  @override
  String get restored => '購入を復元しました。';

  @override
  String finishChapterFirst(String chapter) {
    return '先にチャプター$chapterをクリアしてください。';
  }

  @override
  String get moreSheetsTitle => '追加シート';

  @override
  String get moreSheetsCaption => '新しい図面セットはここに届きます';

  @override
  String get equip => '装備';

  @override
  String buyFor(int coins) {
    return '購入 · $coins ¢';
  }

  @override
  String get close => '閉じる';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => 'ライセンス';

  @override
  String get licensesCaption => 'オープンソースの表記';

  @override
  String playLevel(String code) {
    return '$codeをプレイ';
  }

  @override
  String lockedLevel(int number) {
    return 'シート$number、ロック中';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => 'ランキング';

  @override
  String get leaderboardCaption => 'ログイン中のプレイヤー · ライブ';

  @override
  String get boardSheets => 'シート';

  @override
  String get boardDaily => 'デイリー';

  @override
  String get boardStreak => '連続';

  @override
  String get boardWeekly => '週間';

  @override
  String get boardWeeklyHint => '今週クリアしたシート · 月曜リセット';

  @override
  String get boardSheetsHint => 'クリアしたシート数';

  @override
  String get boardDailyHint => '今日のシート · 手数が少ない順、次にタイム';

  @override
  String get boardStreakHint => 'デイリーシートの連続日数';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '手',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '日',
    );
    return '$_temp0 · 最高 $best';
  }

  @override
  String get boardYou => 'あなた';

  @override
  String get boardYourRank => 'あなたの順位';

  @override
  String get boardNotRanked => 'まだ順位がありません';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '/ $countString人';
  }

  @override
  String get boardGuest => 'ログインするとランキングに名前が載ります。進行状況も引き継がれます。';

  @override
  String get boardEmpty => 'まだ誰もいません。一番乗りしましょう。';

  @override
  String get boardOffline => '現在ランキングに接続できません。';

  @override
  String get tryAgainCaps => '再試行';

  @override
  String get todaysBoard => '今日のランキング';

  @override
  String get signedOutToast =>
      'ログアウトしました · この端末のデータは消去されました。再度ログインすると進行状況が戻ります。';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String welcomeBackName(String name) {
    return 'おかえりなさい、$nameさん';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheetsシート',
    );
    return '$who · $_temp0と$coinsコインを復元しました';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · ログイン済みで、進行状況はバックアップされています';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '$sheetsシート',
    );
    return '$who · この端末の進行状況をアカウントに追加しました：$_temp0、$coinsコイン';
  }

  @override
  String syncSavedNew(String name) {
    return '$nameとしてログイン · 進行状況はアカウントに保存されます';
  }

  @override
  String get syncSavedNewPlain => 'ログインしました · 進行状況はアカウントに保存されます';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '新しいシート$sheets枚',
      zero: '進行状況を更新',
    );
    return '別の端末から同期しました · $_temp0';
  }

  @override
  String get syncRestoreFailed => '保存した進行状況をまだ読み込めません · 接続が戻ると自動で同期されます';

  @override
  String get signedInOffline => 'ログインしました · オンラインに戻ると進行状況が同期されます';

  @override
  String get proActivated => 'Proが有効です · 広告なし、全テーマ、ヒント無制限';

  @override
  String get accountDeletedToast => 'アカウントとすべてのデータを削除しました。';

  @override
  String accountDeletedProToast(String store) {
    return 'アカウントを削除しました。Proは$storeで解約するまで請求が続きます。';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days日連続 · ボーナス+$coins';
  }

  @override
  String get workshopRecord => '工房の記録';

  @override
  String workshopRecordButton(int earned, int total) {
    return '工房の記録 · $earned/$total';
  }

  @override
  String get recordCaption => 'マイルストーン';

  @override
  String recordEarned(int earned, int total) {
    return '$total個中$earned個獲得';
  }

  @override
  String get badgeEarnedLabel => '獲得';

  @override
  String badgeEarnedToast(String name) {
    return 'バッジ獲得 · $name';
  }

  @override
  String get badgeFirstTurn => '最初のひと回し';

  @override
  String get badgeApprentice => '見習い';

  @override
  String get badgeJourneyman => '一人前';

  @override
  String get badgeCraftsman => '熟練工';

  @override
  String get badgeChiefEngineer => '技師長';

  @override
  String get badgeCleanWork => 'きれいな仕事';

  @override
  String get badgePerfectionist => '完璧主義者';

  @override
  String get badgeRegular => '常連';

  @override
  String get badgeOnARoll => '絶好調';

  @override
  String get badgeFullWeek => 'まる一週間';

  @override
  String get badgeFortnight => '二週間';

  @override
  String get badgeFirstDetail => '初めてシートをクリア';

  @override
  String badgeClearDetail(int n) {
    return 'シートを$n枚クリア';
  }

  @override
  String badgeChapterDetail(int n) {
    return 'チャプター$nをクリア';
  }

  @override
  String badgeMasterDetail(int n) {
    return '$n枚のシートで◆を獲得';
  }

  @override
  String badgeDailyDetail(int n) {
    return 'デイリーシートを$n回プレイ';
  }

  @override
  String badgeStreakDetail(int n) {
    return '$n日連続を達成';
  }

  @override
  String get share => '共有';

  @override
  String get shareResult => '結果を共有';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves手',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days日連続';
  }

  @override
  String get signOutSheetTitle => 'ログアウトしますか？';

  @override
  String get signOutSheetBody =>
      'ログアウトすると、この端末から進行状況が消去されます。バックアップ済みのものは再度ログインすると戻りますが、まだ同期されていないもの（オフラインで遊んだシートなど）は失われます。';

  @override
  String get staySignedIn => 'ログインしたままにする';

  @override
  String get signOutConfirm => 'ログアウト';

  @override
  String get rateApp => 'Screw Outを評価';

  @override
  String get sendFeedback => 'フィードバックを送る';

  @override
  String get replayTutorial => 'チュートリアルを再生';

  @override
  String feedbackNoEmailApp(String email) {
    return 'メールアプリが見つかりません。$email までご連絡ください';
  }

  @override
  String get updateChip => '更新';

  @override
  String get updateReadyRestart => 'アップデートをダウンロードしました。再起動してインストールしてください。';

  @override
  String get deleteSheetTitle => 'アカウントを削除しますか？';

  @override
  String get deleteSheetBody =>
      'アカウントと、保存されたすべてのデータが完全に削除されます：全シートの進行状況、コイン、テーマ、デイリーの連続記録、ランキングの順位。元に戻すことはできません。';

  @override
  String deleteSheetPro(String store) {
    return 'Screw Out Proに加入中です。アカウントを削除してもサブスクリプションは解約されません。$storeで解約しないと請求が続きます。';
  }

  @override
  String get manageSubscription => 'サブスクリプション管理';

  @override
  String get deleteForever => 'アカウントを削除';

  @override
  String get deleting => '削除中…';

  @override
  String get keepAccount => 'アカウントを残す';

  @override
  String get deleteOffline => 'オフラインです。アカウントを削除するにはインターネットに接続してください。';

  @override
  String get deleteFailed => 'アカウントを削除できませんでした。もう一度お試しください。';

  @override
  String get restoreNothing => 'このアカウントに復元できる購入はありません。';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · ヒント+1';
  }

  @override
  String get hintEarnedToast => 'ヒント+1 · ご視聴ありがとうございます';

  @override
  String get rescueToast => 'このシートのトレイスロット+1';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · トレイスロット+1';
  }

  @override
  String get adNotCompleted => '動画が最後まで再生されなかったため、今回は報酬がありません。';

  @override
  String themeEquippedToast(String name) {
    return '$nameを装備しました';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return 'チャプター$chapterの準備ができました';
  }

  @override
  String get signInFailed => 'ログインが完了しませんでした。';

  @override
  String get themePurchased => 'テーマを解放しました。';

  @override
  String themeBuyStore(String price) {
    return 'または購入 · $price';
  }

  @override
  String get themesBundleTitle => '全テーマ';

  @override
  String get themesBundleBody => '有料テーマがすべてずっと使えます。Proにも含まれています。';

  @override
  String themesBundleBuy(String price) {
    return '購入 · $price';
  }

  @override
  String get dailyWeekDone => '完了';

  @override
  String masteredCount(int count) {
    return 'マスター $count';
  }

  @override
  String get reminderTitle => '今日のシートが届きました';

  @override
  String get reminderBody => '新しい図面が1枚、全員共通です。制限時間なし。';

  @override
  String get comebackReminderTitle => '次のシートが作業台で待っています';

  @override
  String get comebackReminderBody => '静かな数分と、数本のネジ。続きから始めましょう。';

  @override
  String get signInEmail => 'メールで続ける';

  @override
  String get emailSignInTitle => 'ログイン';

  @override
  String get emailCreateTitle => 'アカウント作成';

  @override
  String get emailTabSignIn => 'ログイン';

  @override
  String get emailTabCreate => 'アカウント作成';

  @override
  String get emailSheetBody => 'この端末の進行状況も引き継がれます。';

  @override
  String get emailLabel => 'メール';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを隠す';

  @override
  String passwordHint(int min) {
    return '$min文字以上';
  }

  @override
  String get emailRequired => 'メールアドレスを入力してください。';

  @override
  String get emailInvalid => 'メールアドレスの形式が正しくないようです。';

  @override
  String get passwordRequired => 'パスワードを入力してください。';

  @override
  String passwordTooShort(int min) {
    return '$min文字以上にしてください。';
  }

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get forgotNeedsEmail => '上にメールアドレスを入力してから「パスワードをお忘れですか？」をタップしてください。';

  @override
  String resetSent(String email) {
    return '$email のアカウントが存在する場合、リセット用のリンクを送信しました。';
  }

  @override
  String get emailWorking => '少々お待ちください…';

  @override
  String get authErrWrongCredentials => 'メールアドレスまたはパスワードが違います。';

  @override
  String get authErrEmailInUse => 'このメールアドレスは登録済みです。ログインしてください。';

  @override
  String get authErrWeakPassword => 'より強力なパスワードを設定してください。';

  @override
  String get authErrDisabled => 'このアカウントは無効化されています。';

  @override
  String get authErrNotEnabled => '現在メールでのログインはご利用いただけません。';

  @override
  String get authErrTooMany => '試行回数が多すぎます。しばらく待ってから再度お試しください。';

  @override
  String get authErrNetwork => '接続がありません。インターネット接続を確認して再度お試しください。';

  @override
  String get authErrGeneric => 'ログインできませんでした。もう一度お試しください。';

  @override
  String get deletePasswordBody => '本人確認のためパスワードを入力してください。';

  @override
  String get deleteWrongPassword => 'パスワードがこのアカウントと一致しません。';

  @override
  String get purchaseSaveTitle => '購入を保存しましょう';

  @override
  String get purchaseSaveBody =>
      '任意：ログインすると、購入と進行状況をすべての端末で使えます。この端末ではすでに購入が有効です。';

  @override
  String get purchaseNeedsConnection => 'サーバーに接続できませんでした。接続を確認して再度お試しください。';

  @override
  String get languageSystemDefault => 'システムのデフォルト';

  @override
  String get startupFailed => '起動中に問題が発生しました。\nアプリを閉じて、もう一度開いてください。';

  @override
  String get notificationChannelDescription => 'デイリーシートのリマインダーとアカウントのお知らせ';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return 'ネジ、プレート$plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return 'ネジ、プレート$plate、$blockerにふさがれています';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $total個中$filled個';
  }

  @override
  String get chapterName1 => '工房の基本';

  @override
  String get chapterName2 => '一層ずつ';

  @override
  String get chapterName3 => '場所をあけよう';

  @override
  String get chapterName4 => 'インターロック';

  @override
  String get chapterName5 => 'マスタービルダー';

  @override
  String get chapterGoal1 => 'タップして、外して、解放';

  @override
  String get chapterGoal2 => '重なりと見える順番';

  @override
  String get chapterGoal3 => '狭いトレイで計画を';

  @override
  String get chapterGoal4 => '共有された支え';

  @override
  String get chapterGoal5 => 'すべてを、公平に';

  @override
  String get chapterPitch1 => 'ネジをタップ。プレートを落とす。ルールはそれだけ。';

  @override
  String get chapterPitch2 => 'プレートの下にプレート。上から順に。';

  @override
  String get chapterPitch3 => 'トレイはさらに狭く。抜くネジの順番を考えて。';

  @override
  String get chapterPitch4 => '1枚のプレートが何枚も押さえる。要の1枚を探そう。';

  @override
  String get chapterPitch5 => '深い重なり、全アイデアの総仕上げ。じっくりどうぞ。';

  @override
  String chapterNameDrawingSet(String number) {
    return '図面セット$number';
  }

  @override
  String get chapterGoalDownloaded => 'マスター級のシート';

  @override
  String get chapterPitchDownloaded => 'シートが増えても、ルールは同じく公平。';

  @override
  String get mechanicOverlap => '重なり';

  @override
  String get mechanicTray => 'トレイ';

  @override
  String get mechanicLayers => '多層';

  @override
  String get mechanicCircles => '円形';

  @override
  String get mechanicTraps => 'ワナ';

  @override
  String get mechanicSupports => '支え';

  @override
  String get sheetObjective004 => '上のプレートを外して下のネジへ';

  @override
  String get sheetObjective006 => 'トレイは3つ。外れたプレートの分は空く';

  @override
  String get sheetObjective011 => '3層構造。上から順に';

  @override
  String get sheetObjective012 => '下のプレートより先にPL-04を外す';

  @override
  String get sheetObjective017 => '誘惑の一手がトレイを埋める';

  @override
  String get sheetObjective021 => '丸いプレートも同じように覆う';

  @override
  String get sheetObjective024 => 'PL-04を外して角へ';

  @override
  String get sheetObjective041 => '狭いトレイ。埋まる前にプレートを外す';

  @override
  String get sheetObjective061 => '1枚のプレートが何枚も押さえることがある';

  @override
  String get sheetObjective081 => '学んだことのすべて。じっくりどうぞ';

  @override
  String get themeNameBlueprint => 'クリーン設計図';

  @override
  String get themeNameWalnut => 'ウォルナット工房';

  @override
  String get themeNameOcean => 'オーシャンティール';

  @override
  String get themeNameCopper => 'ウォームカッパー';

  @override
  String get themeNameMidnight => '真夜中の工房';

  @override
  String get themeNamePastel => 'パステルスタジオ';

  @override
  String sheetTitleNumbered(int number) {
    return 'シート$number';
  }

  @override
  String get sheetTitle001 => '最初のひと回し';

  @override
  String get sheetTitle002 => '2点留め';

  @override
  String get sheetTitle003 => '横並び';

  @override
  String get sheetTitle004 => 'カバープレート';

  @override
  String get sheetTitle005 => 'あらわに';

  @override
  String get sheetTitle006 => 'トレイの日';

  @override
  String get sheetTitle007 => '小さな計画';

  @override
  String get sheetTitle008 => 'きつめのはめ合い';

  @override
  String get sheetTitle009 => '丸棒';

  @override
  String get sheetTitle010 => 'チェックポイント';

  @override
  String get sheetTitle011 => '第三層';

  @override
  String get sheetTitle012 => '筋交い';

  @override
  String get sheetTitle013 => '一枠あける';

  @override
  String get sheetTitle014 => '二手先';

  @override
  String get sheetTitle015 => '塗装鋼板';

  @override
  String get sheetTitle016 => '作業台';

  @override
  String get sheetTitle017 => '誘惑の一手';

  @override
  String get sheetTitle018 => '連鎖';

  @override
  String get sheetTitle019 => '工房ミックス';

  @override
  String get sheetTitle020 => '組立';

  @override
  String get sheetTitle021 => '座金の山';

  @override
  String get sheetTitle022 => 'ガスケット';

  @override
  String get sheetTitle023 => 'レンズキャップ';

  @override
  String get sheetTitle024 => '隠れブラケット';

  @override
  String get sheetTitle025 => 'シムセット';

  @override
  String get sheetTitle026 => 'ベゼル';

  @override
  String get sheetTitle027 => 'グロメット';

  @override
  String get sheetTitle028 => 'ひと息';

  @override
  String get sheetTitle029 => 'フランジリング';

  @override
  String get sheetTitle030 => '丸窓';

  @override
  String get sheetTitle031 => 'スペーサー';

  @override
  String get sheetTitle032 => 'シャフトカラー';

  @override
  String get sheetTitle033 => 'エンドキャップ';

  @override
  String get sheetTitle034 => '静かな当番';

  @override
  String get sheetTitle035 => '隔壁';

  @override
  String get sheetTitle036 => '点検口';

  @override
  String get sheetTitle037 => '面板';

  @override
  String get sheetTitle038 => '軽作業';

  @override
  String get sheetTitle039 => 'ロゼット';

  @override
  String get sheetTitle040 => 'ミルフィーユ';

  @override
  String get sheetTitle041 => '場所をあけよう';

  @override
  String get sheetTitle042 => '箱のすき間';

  @override
  String get sheetTitle043 => 'あふれ';

  @override
  String get sheetTitle044 => '小さな棚';

  @override
  String get sheetTitle045 => '部品箱';

  @override
  String get sheetTitle046 => '在庫わずか';

  @override
  String get sheetTitle047 => '整理棚';

  @override
  String get sheetTitle048 => '楽な抜け道';

  @override
  String get sheetTitle049 => 'スロットマシン';

  @override
  String get sheetTitle050 => '満員御礼';

  @override
  String get sheetTitle051 => '積み残し';

  @override
  String get sheetTitle052 => '予備の枠';

  @override
  String get sheetTitle053 => 'すき間';

  @override
  String get sheetTitle054 => 'ゆるめのはめ合い';

  @override
  String get sheetTitle055 => '棚卸し';

  @override
  String get sheetTitle056 => '余裕代';

  @override
  String get sheetTitle057 => '公差';

  @override
  String get sheetTitle058 => '休みの日';

  @override
  String get sheetTitle059 => '頭上の余裕';

  @override
  String get sheetTitle060 => '収納';

  @override
  String get sheetTitle061 => 'インターロック';

  @override
  String get sheetTitle062 => 'ガセット';

  @override
  String get sheetTitle063 => '要石';

  @override
  String get sheetTitle064 => '重ね継ぎ';

  @override
  String get sheetTitle065 => '添え板';

  @override
  String get sheetTitle066 => 'アリ継ぎ';

  @override
  String get sheetTitle067 => 'まぐさ';

  @override
  String get sheetTitle068 => '端材';

  @override
  String get sheetTitle069 => '支柱';

  @override
  String get sheetTitle070 => 'トラス';

  @override
  String get sheetTitle071 => 'クレビス';

  @override
  String get sheetTitle072 => 'ヨーク';

  @override
  String get sheetTitle073 => 'サドル';

  @override
  String get sheetTitle074 => '基礎';

  @override
  String get sheetTitle075 => 'ブラケット一対';

  @override
  String get sheetTitle076 => 'クランプバー';

  @override
  String get sheetTitle077 => '継ぎ板';

  @override
  String get sheetTitle078 => '無地のパネル';

  @override
  String get sheetTitle079 => '片持ち梁';

  @override
  String get sheetTitle080 => 'ラーメン構造';

  @override
  String get sheetTitle081 => '基本計画';

  @override
  String get sheetTitle082 => '部分組立';

  @override
  String get sheetTitle083 => '分解図';

  @override
  String get sheetTitle084 => 'はめ合い確認';

  @override
  String get sheetTitle085 => 'トルク規定';

  @override
  String get sheetTitle086 => '治具';

  @override
  String get sheetTitle087 => '固定具';

  @override
  String get sheetTitle088 => '静かな作業台';

  @override
  String get sheetTitle089 => 'ギアボックス';

  @override
  String get sheetTitle090 => 'ハウジング';

  @override
  String get sheetTitle091 => 'シャーシ';

  @override
  String get sheetTitle092 => 'パネル区画';

  @override
  String get sheetTitle093 => 'カバー一式';

  @override
  String get sheetTitle094 => '軽いトルク';

  @override
  String get sheetTitle095 => 'エンジンマウント';

  @override
  String get sheetTitle096 => '配電盤';

  @override
  String get sheetTitle097 => '制御盤';

  @override
  String get sheetTitle098 => '製図台';

  @override
  String get sheetTitle099 => '最終検査';

  @override
  String get sheetTitle100 => '承認サイン';
}
