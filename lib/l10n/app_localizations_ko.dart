// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Screw Out';

  @override
  String get pause => '일시 정지';

  @override
  String get back => '뒤로';

  @override
  String get settings => '설정';

  @override
  String get tray => '트레이';

  @override
  String get trayFull => '트레이 가득';

  @override
  String get undo => '되돌리기';

  @override
  String hintCount(String count) {
    return '힌트 · $count';
  }

  @override
  String get hintUnlimited => '∞';

  @override
  String get paused => '일시 정지';

  @override
  String pausedMeta(String code, int moves) {
    return '$code · $moves번째 수';
  }

  @override
  String get resume => '계속하기';

  @override
  String get sound => '소리';

  @override
  String get haptics => '햅틱';

  @override
  String get reducedMotion => '동작 줄이기';

  @override
  String get restart => '다시 시작';

  @override
  String get exitToSheets => '시트 목록으로';

  @override
  String get restartConfirmTitle => '이 시트를 다시 시작할까요?';

  @override
  String restartConfirmBody(int moves) {
    return '$moves수의 진행 상황이 사라집니다.';
  }

  @override
  String get cancel => '취소';

  @override
  String get stuckTitle => '빈 슬롯이 없습니다.';

  @override
  String stuckReasonHolding(String plate, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '나사 $count개',
    );
    return '$plate이(가) 아직 보드에서 $_temp0를 붙잡고 있습니다. 되돌리면 슬롯이 하나 빕니다.';
  }

  @override
  String get stuckReasonGeneric =>
      '모든 슬롯이 찼고 떨어질 수 있는 판이 없습니다. 되돌리면 슬롯이 하나 빕니다.';

  @override
  String get undoLastMove => '마지막 수 되돌리기';

  @override
  String rescueSlotCoins(int coins) {
    return '추가 슬롯 · $coins ¢';
  }

  @override
  String get rescueSlotAd => '추가 슬롯 · 동영상';

  @override
  String get rescueSlotPro => '추가 슬롯 · PRO';

  @override
  String get outOfHintsTitle => '힌트를 하나 더 받을까요?';

  @override
  String get hintsLeftZero => '힌트 · 0개 남음';

  @override
  String get outOfHintsBody =>
      '힌트는 다음에 쓸모 있는 나사 하나에 동그라미를 칩니다. 시트를 대신 풀어 주지는 않습니다.';

  @override
  String get watchVideo => '짧은 동영상 보기';

  @override
  String get watchVideoMeta => '선택 · 약 30초 · 힌트 +1';

  @override
  String useCoins(int coins) {
    return '코인 $coins개 사용';
  }

  @override
  String useCoinsMeta(int balance) {
    return '잔액 $balance ¢';
  }

  @override
  String get keepThinking => '더 생각해 보기';

  @override
  String get notEnoughCoins => '코인이 아직 부족합니다.';

  @override
  String get adUnavailable => '지금은 볼 수 있는 동영상이 없습니다.';

  @override
  String cleared(String code) {
    return '$code · 클리어';
  }

  @override
  String get disassembled => '분해 완료.';

  @override
  String get approved => '승인';

  @override
  String get statMoves => '이동';

  @override
  String get statTime => '시간';

  @override
  String get statMastery => '마스터';

  @override
  String nextSheet(String code) {
    return '다음 시트 · $code';
  }

  @override
  String get replay => '다시 하기';

  @override
  String get sheets => '시트';

  @override
  String get backHome => '홈으로';

  @override
  String chapterComplete(String chapter) {
    return '챕터 $chapter · 완료';
  }

  @override
  String get themeUnlocked => '테마 잠금 해제';

  @override
  String nextChapter(String chapter) {
    return '다음 · 챕터 $chapter';
  }

  @override
  String startChapter(String chapter) {
    return '챕터 $chapter 시작';
  }

  @override
  String equipTheme(String name) {
    return '$name 적용';
  }

  @override
  String get tutorialStep1 => '1단계 · 나사를 탭하세요';

  @override
  String get tutorialLands => '↓ 트레이에 들어갑니다';

  @override
  String get skipTutorial => '튜토리얼 건너뛰기';

  @override
  String get splashTagline => '겹겹이 쌓인 퍼즐';

  @override
  String get splashFooter => '개정 1.0 · 시트 001';

  @override
  String homeFigure(int plates, int screws) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '판 $plates개',
    );
    String _temp1 = intl.Intl.pluralLogic(
      screws,
      locale: localeName,
      other: '개의 체결구',
    );
    return '그림 1\n분해도\n$_temp0 · $screws\n$_temp1';
  }

  @override
  String chapterOf(String chapter, String total) {
    return '챕터 $chapter/$total';
  }

  @override
  String fastenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '체결구',
    );
    return '×$count $_temp0';
  }

  @override
  String get nextSheetLabel => '다음 시트';

  @override
  String chapterLabel(String chapter) {
    return '챕터 $chapter';
  }

  @override
  String get campaign => '캠페인';

  @override
  String campaignProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String continueSheet(String code) {
    return '계속 · $code';
  }

  @override
  String get daily => '데일리';

  @override
  String get themes => '테마';

  @override
  String get allCleared => '모든 시트 클리어';

  @override
  String sheetsCount(int done, int total) {
    return '$done / $total 시트';
  }

  @override
  String get fiveChapters => '5개의 챕터';

  @override
  String get chaptersTitle => '챕터';

  @override
  String chapterProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get lockedChapter => '잠김';

  @override
  String get downloadChapter => '다운로드';

  @override
  String get downloading => '다운로드 중…';

  @override
  String get comingSoon => '새 시트 곧 추가';

  @override
  String newMechanic(String mechanic) {
    return '신규: $mechanic';
  }

  @override
  String sheetMeta(int plates, int layers, int tray) {
    String _temp0 = intl.Intl.pluralLogic(
      plates,
      locale: localeName,
      other: '판 $plates개',
    );
    String _temp1 = intl.Intl.pluralLogic(
      layers,
      locale: localeName,
      other: '$layers층',
    );
    return '$_temp0 · $_temp1 · 트레이 $tray';
  }

  @override
  String get theCampaign => '캠페인';

  @override
  String get campaignFooter =>
      '이전 챕터를 마치면 다음 챕터가 열립니다. 마스터 마크는 선택 사항입니다. 힌트는 진행을 막지 않습니다.';

  @override
  String get chapterBonus => '챕터 보너스';

  @override
  String get dailySheet => '데일리 시트';

  @override
  String get dailyTitle => '제목';

  @override
  String get dailyPlates => '판';

  @override
  String get dailyReward => '보상';

  @override
  String dailyBody(int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      streak,
      locale: localeName,
      other: '$streak일 연속.',
      zero: '연속 기록을 시작해 보세요.',
    );
    return '오늘은 모두에게 같은 시트. 타이머 없음. $_temp0 하루 빠져도 잃는 건 없습니다.';
  }

  @override
  String get startDaily => '오늘의 시트 시작';

  @override
  String get dailyCompleted => '오늘은 완료 · 내일 또 만나요';

  @override
  String get replayDaily => '오늘의 시트 다시 하기';

  @override
  String get themesTitle => '테마';

  @override
  String get themesCaption => '외형만 변경 · 규칙은 그대로';

  @override
  String get equipped => '적용 중';

  @override
  String get owned => '보유';

  @override
  String priceCoins(int coins) {
    return '$coins ¢';
  }

  @override
  String get proIncluded => 'PRO';

  @override
  String get previewOnly => '미리 보기';

  @override
  String get settingsTitle => '설정';

  @override
  String get feedbackSection => '피드백';

  @override
  String get soundEffects => '효과음';

  @override
  String get music => '음악';

  @override
  String get hapticsRow => '햅틱';

  @override
  String get reducedMotionRow => '동작 줄이기';

  @override
  String get reducedMotionCaption => '이동 대신 페이드 효과';

  @override
  String get generalSection => '일반';

  @override
  String get highRefreshRate => '높은 화면 주사율';

  @override
  String highRefreshRateOn(int hz) {
    return '더 부드러운 움직임 · 최대 ${hz}Hz · 배터리 소모 증가';
  }

  @override
  String get highRefreshRateOff => '더 부드러운 움직임 · 배터리 소모 증가';

  @override
  String get highRefreshRateUnsupported => '이 화면은 단일 주사율만 지원합니다';

  @override
  String get highRefreshRateBattery => '지금은 절전 모드로 제한됨';

  @override
  String get highRefreshRateHeat => '기기가 뜨거워 제한됨';

  @override
  String highRefreshRateNow(int hz) {
    return '현재 ${hz}Hz';
  }

  @override
  String get language => '언어';

  @override
  String get notifications => '데일리 알림';

  @override
  String get notificationsCaption => '새 시트가 나오면 한 번 알려 드려요';

  @override
  String get accountSection => '계정';

  @override
  String get signInGoogle => 'Google로 로그인';

  @override
  String get signInApple => 'Apple로 로그인';

  @override
  String signedInAs(String name) {
    return '로그인됨 · $name';
  }

  @override
  String get guestCaption => '게스트로 플레이 중 · 로그인하면 진행 상황이 저장됩니다';

  @override
  String get signOut => '로그아웃';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get purchasesSection => '구매';

  @override
  String get removeAds => '광고 제거';

  @override
  String get restore => '복원';

  @override
  String get proTitle => 'Screw Out Pro';

  @override
  String proPerks(int coins) {
    return '광고 없음 · 힌트 무제한 · 모든 테마 · 무료 구조 · 매달 $coins ¢';
  }

  @override
  String get proMonthly => '월간';

  @override
  String get proYearly => '연간';

  @override
  String proTrialDays(int days) {
    return '$days일 무료';
  }

  @override
  String proThenPrice(String price) {
    return '이후 $price';
  }

  @override
  String get proTrialTerms =>
      '무료 체험이 끝나면 해지하지 않는 한 자동으로 갱신됩니다. 매월 코인은 첫 결제부터 지급됩니다.';

  @override
  String get proActive => 'PRO · 활성';

  @override
  String get adsRemoved => '광고 제거됨';

  @override
  String get coinPacks => '코인 팩';

  @override
  String get aboutSection => '정보';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get termsOfUse => '이용약관';

  @override
  String get refundPolicy => '환불 정책';

  @override
  String get privacyChoices => '개인정보 선택';

  @override
  String get licenses => '라이선스 및 크레딧';

  @override
  String versionFooter(String version, String build) {
    return 'SCREW OUT · 개정 $version ($build)';
  }

  @override
  String get notificationPrimerTitle => '데일리 시트 알림을 받을까요?';

  @override
  String get notificationPrimerBody =>
      '한동안 플레이하지 않았을 때 조용히 알려 드립니다. 하루에 한 번을 넘지 않아요.';

  @override
  String get allow => '허용';

  @override
  String get notNow => '나중에';

  @override
  String get somethingWentWrong => '문제가 발생했습니다.';

  @override
  String get purchaseThanks => '감사합니다! 구매가 적용되었습니다.';

  @override
  String get purchasePending => '구매 대기 중입니다. 확인되면 적용됩니다.';

  @override
  String get purchaseFailed => '구매가 완료되지 않았습니다.';

  @override
  String get restored => '구매 내역이 복원되었습니다.';

  @override
  String finishChapterFirst(String chapter) {
    return '챕터 $chapter을(를) 먼저 마치세요.';
  }

  @override
  String get moreSheetsTitle => '추가 시트';

  @override
  String get moreSheetsCaption => '새 도면 세트가 여기에 도착합니다';

  @override
  String get equip => '적용';

  @override
  String buyFor(int coins) {
    return '구매 · $coins ¢';
  }

  @override
  String get close => '닫기';

  @override
  String coinPackAmount(int coins) {
    return '+$coins ¢';
  }

  @override
  String get licensesTitle => '라이선스';

  @override
  String get licensesCaption => '오픈소스 고지';

  @override
  String playLevel(String code) {
    return '$code 플레이';
  }

  @override
  String lockedLevel(int number) {
    return '시트 $number, 잠김';
  }

  @override
  String platesScrews(int plates, int screws) {
    return '$plates · $screws';
  }

  @override
  String get leaderboardTitle => '리더보드';

  @override
  String get leaderboardCaption => '로그인한 플레이어 · 실시간';

  @override
  String get boardSheets => '시트';

  @override
  String get boardDaily => '데일리';

  @override
  String get boardStreak => '연속';

  @override
  String get boardWeekly => '주간';

  @override
  String get boardWeeklyHint => '이번 주 클리어한 시트 · 월요일 초기화';

  @override
  String get boardSheetsHint => '가장 많이 클리어한 시트';

  @override
  String get boardDailyHint => '오늘의 시트 · 최소 이동, 그다음 최단 시간';

  @override
  String get boardStreakHint => '데일리 시트 연속 플레이 일수';

  @override
  String boardMastered(int count) {
    return '$count ◆';
  }

  @override
  String boardMovesDetail(int count, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이동',
    );
    return '$_temp0 · $time';
  }

  @override
  String boardDaysDetail(int count, int best) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '일',
    );
    return '$_temp0 · 최고 $best';
  }

  @override
  String get boardYou => '나';

  @override
  String get boardYourRank => '내 순위';

  @override
  String get boardNotRanked => '아직 순위 없음';

  @override
  String boardOfPlayers(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '/ $countString명';
  }

  @override
  String get boardGuest => '로그인하면 리더보드에 이름이 올라갑니다. 진행 상황도 그대로 이어집니다.';

  @override
  String get boardEmpty => '아직 아무도 없습니다. 첫 번째가 되어 보세요.';

  @override
  String get boardOffline => '지금은 리더보드에 연결할 수 없습니다.';

  @override
  String get tryAgainCaps => '다시 시도';

  @override
  String get todaysBoard => '오늘의 리더보드';

  @override
  String get signedOutToast =>
      '로그아웃됨 · 이 기기의 데이터가 지워졌습니다. 다시 로그인하면 진행 상황을 되찾을 수 있습니다.';

  @override
  String get welcomeBack => '다시 오신 걸 환영해요';

  @override
  String welcomeBackName(String name) {
    return '$name님, 다시 오신 걸 환영해요';
  }

  @override
  String syncRestored(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '시트 $sheets개',
    );
    return '$who · $_temp0와 코인 $coins개가 복원되었습니다';
  }

  @override
  String syncRestoredEmpty(String who) {
    return '$who · 로그인되었고 진행 상황이 백업되어 있습니다';
  }

  @override
  String syncCombined(String who, int sheets, int coins) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '시트 $sheets개',
    );
    return '$who · 이 기기의 진행 상황을 계정에 추가했습니다: $_temp0, 코인 $coins개';
  }

  @override
  String syncSavedNew(String name) {
    return '$name(으)로 로그인됨 · 이제 진행 상황이 계정에 저장됩니다';
  }

  @override
  String get syncSavedNewPlain => '로그인됨 · 이제 진행 상황이 계정에 저장됩니다';

  @override
  String syncFromOtherDevice(int sheets) {
    String _temp0 = intl.Intl.pluralLogic(
      sheets,
      locale: localeName,
      other: '새 시트 $sheets개',
      zero: '진행 상황 업데이트',
    );
    return '다른 기기에서 동기화됨 · $_temp0';
  }

  @override
  String get syncRestoreFailed =>
      '저장된 진행 상황을 아직 불러오지 못했습니다 · 연결이 돌아오면 자동으로 동기화됩니다';

  @override
  String get signedInOffline => '로그인됨 · 다시 온라인이 되면 진행 상황이 동기화됩니다';

  @override
  String get proActivated => 'Pro 활성화 · 광고 없음, 모든 테마, 힌트 무제한';

  @override
  String get accountDeletedToast => '계정과 모든 데이터가 삭제되었습니다.';

  @override
  String accountDeletedProToast(String store) {
    return '계정이 삭제되었습니다. Pro는 $store에서 해지할 때까지 계속 청구됩니다.';
  }

  @override
  String streakBonusLine(int days, int coins) {
    return '$days일 연속 · 보너스 +$coins';
  }

  @override
  String get workshopRecord => '작업실 기록';

  @override
  String workshopRecordButton(int earned, int total) {
    return '작업실 기록 · $earned/$total';
  }

  @override
  String get recordCaption => '이정표';

  @override
  String recordEarned(int earned, int total) {
    return '$total개 중 $earned개 획득';
  }

  @override
  String get badgeEarnedLabel => '획득';

  @override
  String badgeEarnedToast(String name) {
    return '배지 획득 · $name';
  }

  @override
  String get badgeFirstTurn => '첫 회전';

  @override
  String get badgeApprentice => '견습공';

  @override
  String get badgeJourneyman => '숙련공';

  @override
  String get badgeCraftsman => '장인';

  @override
  String get badgeChiefEngineer => '수석 엔지니어';

  @override
  String get badgeCleanWork => '깔끔한 솜씨';

  @override
  String get badgePerfectionist => '완벽주의자';

  @override
  String get badgeRegular => '단골';

  @override
  String get badgeOnARoll => '상승세';

  @override
  String get badgeFullWeek => '꽉 찬 한 주';

  @override
  String get badgeFortnight => '2주 연속';

  @override
  String get badgeFirstDetail => '첫 시트 클리어';

  @override
  String badgeClearDetail(int n) {
    return '시트 $n개 클리어';
  }

  @override
  String badgeChapterDetail(int n) {
    return '챕터 $n 완료';
  }

  @override
  String badgeMasterDetail(int n) {
    return '시트 $n개에서 ◆ 획득';
  }

  @override
  String badgeDailyDetail(int n) {
    return '데일리 시트 $n회 플레이';
  }

  @override
  String badgeStreakDetail(int n) {
    return '$n일 연속 달성';
  }

  @override
  String get share => '공유';

  @override
  String get shareResult => '결과 공유';

  @override
  String shareDailyTitle(String code) {
    return 'Screw Out · $code';
  }

  @override
  String shareDailyMoves(int moves, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      moves,
      locale: localeName,
      other: '$moves수',
    );
    return '$_temp0 · $time';
  }

  @override
  String shareDailyStreak(int days) {
    return '$days일 연속';
  }

  @override
  String get signOutSheetTitle => '로그아웃할까요?';

  @override
  String get signOutSheetBody =>
      '로그아웃하면 이 기기에서 진행 상황이 지워집니다. 이미 백업된 내용은 다시 로그인하면 돌아오지만, 아직 동기화되지 않은 내용(예: 오프라인으로 플레이한 시트)은 사라집니다.';

  @override
  String get staySignedIn => '로그인 유지';

  @override
  String get signOutConfirm => '로그아웃';

  @override
  String get rateApp => 'Screw Out 평가하기';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get replayTutorial => '튜토리얼 다시 보기';

  @override
  String feedbackNoEmailApp(String email) {
    return '이메일 앱이 없습니다. $email(으)로 연락해 주세요';
  }

  @override
  String get updateChip => '업데이트';

  @override
  String get updateReadyRestart => '업데이트가 다운로드되었습니다. 다시 시작하면 설치됩니다.';

  @override
  String get deleteSheetTitle => '계정을 삭제할까요?';

  @override
  String get deleteSheetBody =>
      '계정과 함께 저장된 모든 내용이 영구적으로 삭제됩니다: 모든 시트의 진행 상황, 코인, 테마, 데일리 연속 기록, 리더보드 순위. 되돌릴 수 없습니다.';

  @override
  String deleteSheetPro(String store) {
    return 'Screw Out Pro를 이용 중입니다. 계정을 삭제해도 구독은 해지되지 않습니다. $store에서 구독을 해지하지 않으면 계속 청구됩니다.';
  }

  @override
  String get manageSubscription => '구독 관리';

  @override
  String get deleteForever => '계정 삭제';

  @override
  String get deleting => '삭제 중…';

  @override
  String get keepAccount => '계정 유지';

  @override
  String get deleteOffline => '오프라인 상태입니다. 계정을 삭제하려면 인터넷에 연결하세요.';

  @override
  String get deleteFailed => '계정을 삭제하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get restoreNothing => '이 계정에는 복원할 항목이 없습니다.';

  @override
  String hintBoughtToast(int coins) {
    return '−$coins ¢ · 힌트 +1';
  }

  @override
  String get hintEarnedToast => '힌트 +1 · 시청해 주셔서 감사합니다';

  @override
  String get rescueToast => '이 시트에서 트레이 슬롯 +1';

  @override
  String rescuePaidToast(int coins) {
    return '−$coins ¢ · 트레이 슬롯 +1';
  }

  @override
  String get adNotCompleted => '동영상이 끝나지 않아 이번에는 보상이 없습니다.';

  @override
  String themeEquippedToast(String name) {
    return '$name 적용됨';
  }

  @override
  String chapterDownloadedToast(String chapter) {
    return '챕터 $chapter 준비 완료';
  }

  @override
  String get signInFailed => '로그인이 완료되지 않았습니다.';

  @override
  String get themePurchased => '테마가 잠금 해제되었습니다.';

  @override
  String themeBuyStore(String price) {
    return '또는 구매 · $price';
  }

  @override
  String get themesBundleTitle => '모든 테마';

  @override
  String get themesBundleBody => '모든 유료 테마를 영구 소장하세요. Pro에도 포함되어 있습니다.';

  @override
  String themesBundleBuy(String price) {
    return '구매 · $price';
  }

  @override
  String get dailyWeekDone => '완료';

  @override
  String masteredCount(int count) {
    return '마스터 $count개';
  }

  @override
  String get reminderTitle => '오늘의 시트가 준비되었습니다';

  @override
  String get reminderBody => '새 도면 한 장, 모두에게 같은 문제. 타이머 없음.';

  @override
  String get comebackReminderTitle => '다음 시트가 작업대에서 기다려요';

  @override
  String get comebackReminderBody => '차분한 몇 분, 나사 몇 개. 멈춘 곳에서 이어서 해 보세요.';

  @override
  String get signInEmail => '이메일로 계속하기';

  @override
  String get emailSignInTitle => '로그인';

  @override
  String get emailCreateTitle => '계정 만들기';

  @override
  String get emailTabSignIn => '로그인';

  @override
  String get emailTabCreate => '계정 만들기';

  @override
  String get emailSheetBody => '이 기기의 진행 상황도 함께 이어집니다.';

  @override
  String get emailLabel => '이메일';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get showPassword => '비밀번호 표시';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String passwordHint(int min) {
    return '$min자 이상';
  }

  @override
  String get emailRequired => '이메일을 입력하세요.';

  @override
  String get emailInvalid => '이메일 주소가 올바르지 않은 것 같습니다.';

  @override
  String get passwordRequired => '비밀번호를 입력하세요.';

  @override
  String passwordTooShort(int min) {
    return '$min자 이상 입력하세요.';
  }

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get forgotNeedsEmail => '위에 이메일을 입력한 다음 \'비밀번호를 잊으셨나요?\'를 탭하세요.';

  @override
  String resetSent(String email) {
    return '$email 계정이 있다면 재설정 링크가 발송되었습니다.';
  }

  @override
  String get emailWorking => '잠시만요…';

  @override
  String get authErrWrongCredentials => '이메일 또는 비밀번호가 틀렸습니다.';

  @override
  String get authErrEmailInUse => '이미 계정이 있는 이메일입니다. 로그인해 주세요.';

  @override
  String get authErrWeakPassword => '더 강력한 비밀번호를 사용하세요.';

  @override
  String get authErrDisabled => '비활성화된 계정입니다.';

  @override
  String get authErrNotEnabled => '지금은 이메일 로그인을 사용할 수 없습니다.';

  @override
  String get authErrTooMany => '시도 횟수가 너무 많습니다. 잠시 후 다시 시도하세요.';

  @override
  String get authErrNetwork => '연결이 없습니다. 인터넷을 확인하고 다시 시도하세요.';

  @override
  String get authErrGeneric => '로그인하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get deletePasswordBody => '본인 확인을 위해 비밀번호를 입력하세요.';

  @override
  String get deleteWrongPassword => '비밀번호가 이 계정과 일치하지 않습니다.';

  @override
  String get purchaseSaveTitle => '구매 내역 지키기';

  @override
  String get purchaseSaveBody =>
      '선택 사항: 로그인하면 모든 기기에서 구매 내역과 진행 상황을 유지할 수 있습니다. 이 기기에서는 이미 구매가 적용되어 있습니다.';

  @override
  String get purchaseNeedsConnection => '서버에 연결할 수 없습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get languageSystemDefault => '시스템 기본값';

  @override
  String get startupFailed => '시작하는 중 문제가 발생했습니다.\n앱을 닫고 다시 열어 주세요.';

  @override
  String get notificationChannelDescription => '데일리 시트 알림 및 계정 안내';

  @override
  String get storeAppStore => 'App Store';

  @override
  String get storeGooglePlay => 'Google Play';

  @override
  String a11yScrew(String plate) {
    return '나사, 판 $plate';
  }

  @override
  String a11yScrewBlocked(String plate, String blocker) {
    return '나사, 판 $plate, $blocker에 막힘';
  }

  @override
  String a11yTray(String label, int filled, int total) {
    return '$label $total칸 중 $filled칸';
  }

  @override
  String get chapterName1 => '작업실 기초';

  @override
  String get chapterName2 => '한 겹씩';

  @override
  String get chapterName3 => '공간 만들기';

  @override
  String get chapterName4 => '맞물림';

  @override
  String get chapterName5 => '마스터 빌더';

  @override
  String get chapterGoal1 => '탭하고, 빼고, 풀어내기';

  @override
  String get chapterGoal2 => '겹침과 드러나는 순서';

  @override
  String get chapterGoal3 => '좁은 트레이로 계획하기';

  @override
  String get chapterGoal4 => '함께 받치는 지지대';

  @override
  String get chapterGoal5 => '모든 것을, 공정하게';

  @override
  String get chapterPitch1 => '나사를 탭하고, 판을 떨어뜨리세요. 규칙은 그게 전부입니다.';

  @override
  String get chapterPitch2 => '판이 판을 가립니다. 위에서부터 차례로.';

  @override
  String get chapterPitch3 => '더 좁아진 트레이. 어떤 나사부터 뺄지 계획하세요.';

  @override
  String get chapterPitch4 => '판 하나가 여러 장을 누릅니다. 핵심 조각을 찾으세요.';

  @override
  String get chapterPitch5 => '깊은 겹침, 모든 아이디어를 한꺼번에. 천천히 하세요.';

  @override
  String chapterNameDrawingSet(String number) {
    return '도면 세트 $number';
  }

  @override
  String get chapterGoalDownloaded => '마스터 난도의 시트';

  @override
  String get chapterPitchDownloaded => '더 많은 시트, 변함없이 공정한 규칙.';

  @override
  String get mechanicOverlap => '겹침';

  @override
  String get mechanicTray => '트레이';

  @override
  String get mechanicLayers => '여러 층';

  @override
  String get mechanicCircles => '원형';

  @override
  String get mechanicTraps => '함정';

  @override
  String get mechanicSupports => '지지대';

  @override
  String get sheetObjective004 => '위 판을 들어 올려 아래 나사에 닿으세요';

  @override
  String get sheetObjective006 => '트레이는 3칸. 풀린 판은 슬롯을 비워 줍니다';

  @override
  String get sheetObjective011 => '세 겹. 위에서부터 차례로';

  @override
  String get sheetObjective012 => '아래 판보다 PL-04를 먼저 들어 올리세요';

  @override
  String get sheetObjective017 => '솔깃한 한 수가 트레이를 채웁니다';

  @override
  String get sheetObjective021 => '둥근 판도 똑같이 가립니다';

  @override
  String get sheetObjective024 => 'PL-04를 빼서 모서리에 닿으세요';

  @override
  String get sheetObjective041 => '좁은 트레이. 차기 전에 판을 풀어내세요';

  @override
  String get sheetObjective061 => '판 하나가 여러 장을 누를 수 있습니다';

  @override
  String get sheetObjective081 => '지금까지 배운 모든 것. 천천히 하세요';

  @override
  String get themeNameBlueprint => '깔끔한 설계도';

  @override
  String get themeNameWalnut => '월넛 작업실';

  @override
  String get themeNameOcean => '오션 틸';

  @override
  String get themeNameCopper => '따뜻한 구리';

  @override
  String get themeNameMidnight => '한밤의 작업실';

  @override
  String get themeNamePastel => '파스텔 스튜디오';

  @override
  String sheetTitleNumbered(int number) {
    return '시트 $number';
  }

  @override
  String get sheetTitle001 => '첫 회전';

  @override
  String get sheetTitle002 => '두 점 고정';

  @override
  String get sheetTitle003 => '나란히';

  @override
  String get sheetTitle004 => '덮개 판';

  @override
  String get sheetTitle005 => '드러내기';

  @override
  String get sheetTitle006 => '트레이의 날';

  @override
  String get sheetTitle007 => '작은 계획';

  @override
  String get sheetTitle008 => '꽉 끼는 맞춤';

  @override
  String get sheetTitle009 => '환봉';

  @override
  String get sheetTitle010 => '체크포인트';

  @override
  String get sheetTitle011 => '세 번째 층';

  @override
  String get sheetTitle012 => '가새';

  @override
  String get sheetTitle013 => '한 칸 비우기';

  @override
  String get sheetTitle014 => '두 수 앞';

  @override
  String get sheetTitle015 => '도장 강판';

  @override
  String get sheetTitle016 => '작업대';

  @override
  String get sheetTitle017 => '솔깃한 수';

  @override
  String get sheetTitle018 => '연쇄';

  @override
  String get sheetTitle019 => '작업실 믹스';

  @override
  String get sheetTitle020 => '조립';

  @override
  String get sheetTitle021 => '와셔 더미';

  @override
  String get sheetTitle022 => '개스킷';

  @override
  String get sheetTitle023 => '렌즈 캡';

  @override
  String get sheetTitle024 => '숨은 브래킷';

  @override
  String get sheetTitle025 => '심 세트';

  @override
  String get sheetTitle026 => '베젤';

  @override
  String get sheetTitle027 => '그로밋';

  @override
  String get sheetTitle028 => '숨 돌리기';

  @override
  String get sheetTitle029 => '플랜지 링';

  @override
  String get sheetTitle030 => '둥근 창';

  @override
  String get sheetTitle031 => '스페이서';

  @override
  String get sheetTitle032 => '축 칼라';

  @override
  String get sheetTitle033 => '엔드 캡';

  @override
  String get sheetTitle034 => '조용한 근무';

  @override
  String get sheetTitle035 => '격벽';

  @override
  String get sheetTitle036 => '점검구';

  @override
  String get sheetTitle037 => '전면판';

  @override
  String get sheetTitle038 => '가벼운 작업';

  @override
  String get sheetTitle039 => '로제트';

  @override
  String get sheetTitle040 => '레이어 케이크';

  @override
  String get sheetTitle041 => '공간 만들기';

  @override
  String get sheetTitle042 => '상자 공간';

  @override
  String get sheetTitle043 => '넘침';

  @override
  String get sheetTitle044 => '작은 칸';

  @override
  String get sheetTitle045 => '부품함';

  @override
  String get sheetTitle046 => '재고 부족';

  @override
  String get sheetTitle047 => '칸막이 선반';

  @override
  String get sheetTitle048 => '쉬운 탈출';

  @override
  String get sheetTitle049 => '슬롯머신';

  @override
  String get sheetTitle050 => '풀하우스';

  @override
  String get sheetTitle051 => '밀린 일';

  @override
  String get sheetTitle052 => '여분 칸';

  @override
  String get sheetTitle053 => '여유 간격';

  @override
  String get sheetTitle054 => '헐거운 맞춤';

  @override
  String get sheetTitle055 => '재고 조사';

  @override
  String get sheetTitle056 => '여유 치수';

  @override
  String get sheetTitle057 => '공차';

  @override
  String get sheetTitle058 => '쉬는 날';

  @override
  String get sheetTitle059 => '머리 위 여유';

  @override
  String get sheetTitle060 => '수납';

  @override
  String get sheetTitle061 => '맞물림';

  @override
  String get sheetTitle062 => '거셋';

  @override
  String get sheetTitle063 => '쐐기돌';

  @override
  String get sheetTitle064 => '겹이음';

  @override
  String get sheetTitle065 => '이음판';

  @override
  String get sheetTitle066 => '주먹장';

  @override
  String get sheetTitle067 => '인방';

  @override
  String get sheetTitle068 => '자투리';

  @override
  String get sheetTitle069 => '버팀대';

  @override
  String get sheetTitle070 => '트러스';

  @override
  String get sheetTitle071 => '클레비스';

  @override
  String get sheetTitle072 => '요크';

  @override
  String get sheetTitle073 => '새들';

  @override
  String get sheetTitle074 => '기초';

  @override
  String get sheetTitle075 => '브래킷 한 쌍';

  @override
  String get sheetTitle076 => '클램프 바';

  @override
  String get sheetTitle077 => '연결판';

  @override
  String get sheetTitle078 => '민무늬 패널';

  @override
  String get sheetTitle079 => '캔틸레버';

  @override
  String get sheetTitle080 => '모멘트 골조';

  @override
  String get sheetTitle081 => '마스터플랜';

  @override
  String get sheetTitle082 => '하위 조립품';

  @override
  String get sheetTitle083 => '분해도';

  @override
  String get sheetTitle084 => '맞춤 확인';

  @override
  String get sheetTitle085 => '토크 사양';

  @override
  String get sheetTitle086 => '지그';

  @override
  String get sheetTitle087 => '고정구';

  @override
  String get sheetTitle088 => '고요한 작업대';

  @override
  String get sheetTitle089 => '기어박스';

  @override
  String get sheetTitle090 => '하우징';

  @override
  String get sheetTitle091 => '섀시';

  @override
  String get sheetTitle092 => '패널 베이';

  @override
  String get sheetTitle093 => '커버 세트';

  @override
  String get sheetTitle094 => '가벼운 토크';

  @override
  String get sheetTitle095 => '엔진 마운트';

  @override
  String get sheetTitle096 => '배전반';

  @override
  String get sheetTitle097 => '제어함';

  @override
  String get sheetTitle098 => '제도대';

  @override
  String get sheetTitle099 => '최종 검사';

  @override
  String get sheetTitle100 => '최종 승인';
}
