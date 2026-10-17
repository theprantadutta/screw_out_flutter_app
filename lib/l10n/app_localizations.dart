import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Screw Out'**
  String get appName;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @coinsBalance.
  ///
  /// In en, this message translates to:
  /// **'{coins} coins'**
  String coinsBalance(int coins);

  /// No description provided for @tray.
  ///
  /// In en, this message translates to:
  /// **'TRAY'**
  String get tray;

  /// No description provided for @trayFull.
  ///
  /// In en, this message translates to:
  /// **'TRAY FULL'**
  String get trayFull;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @hintCount.
  ///
  /// In en, this message translates to:
  /// **'HINT · {count}'**
  String hintCount(String count);

  /// No description provided for @hintUnlimited.
  ///
  /// In en, this message translates to:
  /// **'∞'**
  String get hintUnlimited;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @pausedMeta.
  ///
  /// In en, this message translates to:
  /// **'{code} · MOVE {moves}'**
  String pausedMeta(String code, int moves);

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'SOUND'**
  String get sound;

  /// No description provided for @haptics.
  ///
  /// In en, this message translates to:
  /// **'HAPTICS'**
  String get haptics;

  /// No description provided for @reducedMotion.
  ///
  /// In en, this message translates to:
  /// **'REDUCED MOTION'**
  String get reducedMotion;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'RESTART'**
  String get restart;

  /// No description provided for @exitToSheets.
  ///
  /// In en, this message translates to:
  /// **'EXIT TO SHEETS'**
  String get exitToSheets;

  /// No description provided for @restartConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart this sheet?'**
  String get restartConfirmTitle;

  /// No description provided for @restartConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose {moves} moves of progress.'**
  String restartConfirmBody(int moves);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @stuckTitle.
  ///
  /// In en, this message translates to:
  /// **'No open slots left.'**
  String get stuckTitle;

  /// No description provided for @stuckRescueTitle.
  ///
  /// In en, this message translates to:
  /// **'OR BUY ONE EXTRA SLOT FOR THIS SHEET'**
  String get stuckRescueTitle;

  /// No description provided for @stuckReasonHolding.
  ///
  /// In en, this message translates to:
  /// **'{plate} still holds {count, plural, =1{one screw} other{{count} screws}} on the board. Undo frees a slot.'**
  String stuckReasonHolding(String plate, int count);

  /// No description provided for @stuckReasonGeneric.
  ///
  /// In en, this message translates to:
  /// **'Every slot is taken and no plate can drop. Undo frees a slot.'**
  String get stuckReasonGeneric;

  /// No description provided for @undoLastMove.
  ///
  /// In en, this message translates to:
  /// **'Undo last move'**
  String get undoLastMove;

  /// No description provided for @hint.
  ///
  /// In en, this message translates to:
  /// **'HINT'**
  String get hint;

  /// No description provided for @rescueSlot.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT'**
  String get rescueSlot;

  /// No description provided for @rescueSlotCoins.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · {coins} ¢'**
  String rescueSlotCoins(int coins);

  /// No description provided for @rescueSlotAd.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · VIDEO'**
  String get rescueSlotAd;

  /// No description provided for @rescueSlotPro.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · PRO'**
  String get rescueSlotPro;

  /// No description provided for @outOfHintsTitle.
  ///
  /// In en, this message translates to:
  /// **'Want one more hint?'**
  String get outOfHintsTitle;

  /// No description provided for @hintsLeftZero.
  ///
  /// In en, this message translates to:
  /// **'HINTS · 0 LEFT'**
  String get hintsLeftZero;

  /// No description provided for @outOfHintsBody.
  ///
  /// In en, this message translates to:
  /// **'A hint rings one useful next screw. It never solves the sheet.'**
  String get outOfHintsBody;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch a short video'**
  String get watchVideo;

  /// No description provided for @watchVideoMeta.
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL · ~30 S · +1 HINT'**
  String get watchVideoMeta;

  /// No description provided for @useCoins.
  ///
  /// In en, this message translates to:
  /// **'Use {coins} coins'**
  String useCoins(int coins);

  /// No description provided for @useCoinsMeta.
  ///
  /// In en, this message translates to:
  /// **'BALANCE {balance} ¢'**
  String useCoinsMeta(int balance);

  /// No description provided for @keepThinking.
  ///
  /// In en, this message translates to:
  /// **'Keep thinking'**
  String get keepThinking;

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins yet.'**
  String get notEnoughCoins;

  /// No description provided for @adUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No video available right now.'**
  String get adUnavailable;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'{code} · CLEARED'**
  String cleared(String code);

  /// No description provided for @disassembled.
  ///
  /// In en, this message translates to:
  /// **'Disassembled.'**
  String get disassembled;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get approved;

  /// No description provided for @statMoves.
  ///
  /// In en, this message translates to:
  /// **'MOVES'**
  String get statMoves;

  /// No description provided for @statTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get statTime;

  /// No description provided for @statMastery.
  ///
  /// In en, this message translates to:
  /// **'MASTERY'**
  String get statMastery;

  /// No description provided for @nextSheet.
  ///
  /// In en, this message translates to:
  /// **'Next sheet · {code}'**
  String nextSheet(String code);

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'REPLAY'**
  String get replay;

  /// No description provided for @sheets.
  ///
  /// In en, this message translates to:
  /// **'SHEETS'**
  String get sheets;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get home;

  /// No description provided for @dailyDone.
  ///
  /// In en, this message translates to:
  /// **'Daily sheet done'**
  String get dailyDone;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHome;

  /// No description provided for @chapterComplete.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter} · COMPLETE'**
  String chapterComplete(String chapter);

  /// No description provided for @chapterSheetsMastered.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} SHEETS · {mastered} MASTERED ◆'**
  String chapterSheetsMastered(int done, int total, int mastered);

  /// No description provided for @rewardCoins.
  ///
  /// In en, this message translates to:
  /// **'COINS'**
  String get rewardCoins;

  /// No description provided for @themeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'THEME UNLOCKED'**
  String get themeUnlocked;

  /// No description provided for @nextChapter.
  ///
  /// In en, this message translates to:
  /// **'NEXT · CHAPTER {chapter}'**
  String nextChapter(String chapter);

  /// No description provided for @startChapter.
  ///
  /// In en, this message translates to:
  /// **'Start Chapter {chapter}'**
  String startChapter(String chapter);

  /// No description provided for @equipTheme.
  ///
  /// In en, this message translates to:
  /// **'EQUIP {name}'**
  String equipTheme(String name);

  /// No description provided for @tutorialStep1.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 · TAP THE SCREW'**
  String get tutorialStep1;

  /// No description provided for @tutorialLands.
  ///
  /// In en, this message translates to:
  /// **'↓ IT LANDS IN THE TRAY'**
  String get tutorialLands;

  /// No description provided for @skipTutorial.
  ///
  /// In en, this message translates to:
  /// **'SKIP TUTORIAL'**
  String get skipTutorial;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'A PUZZLE OF LAYERS'**
  String get splashTagline;

  /// No description provided for @splashFooter.
  ///
  /// In en, this message translates to:
  /// **'REV 1.0 · SHEET 001'**
  String get splashFooter;

  /// No description provided for @homeFigure.
  ///
  /// In en, this message translates to:
  /// **'FIG. 1\nEXPLODED VIEW\n{plates, plural, =1{1 PLATE} other{{plates} PLATES}} · {screws}\n{screws, plural, =1{FASTENER} other{FASTENERS}}'**
  String homeFigure(int plates, int screws);

  /// No description provided for @chapterOf.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter}/{total}'**
  String chapterOf(String chapter, String total);

  /// No description provided for @fastenerCount.
  ///
  /// In en, this message translates to:
  /// **'×{count} {count, plural, =1{FASTENER} other{FASTENERS}}'**
  String fastenerCount(int count);

  /// No description provided for @nextSheetLabel.
  ///
  /// In en, this message translates to:
  /// **'NEXT SHEET'**
  String get nextSheetLabel;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter}'**
  String chapterLabel(String chapter);

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'CAMPAIGN'**
  String get campaign;

  /// No description provided for @campaignProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total}'**
  String campaignProgress(int done, int total);

  /// No description provided for @continueSheet.
  ///
  /// In en, this message translates to:
  /// **'Continue · {code}'**
  String continueSheet(String code);

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get daily;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'THEMES'**
  String get themes;

  /// No description provided for @allCleared.
  ///
  /// In en, this message translates to:
  /// **'All sheets cleared'**
  String get allCleared;

  /// No description provided for @sheetsCount.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} SHEETS'**
  String sheetsCount(int done, int total);

  /// No description provided for @fiveChapters.
  ///
  /// In en, this message translates to:
  /// **'Five chapters'**
  String get fiveChapters;

  /// No description provided for @chaptersTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chaptersTitle;

  /// No description provided for @masteryNote.
  ///
  /// In en, this message translates to:
  /// **'◆ MASTERY = CLEARED WITHOUT A HINT OR RESTART. PURELY COSMETIC, NEVER NEEDED TO PROGRESS.'**
  String get masteryNote;

  /// No description provided for @chapterProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String chapterProgress(int done, int total);

  /// No description provided for @lockedChapter.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get lockedChapter;

  /// No description provided for @downloadChapter.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD'**
  String get downloadChapter;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOADING…'**
  String get downloading;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'MORE SHEETS SOON'**
  String get comingSoon;

  /// No description provided for @newMechanic.
  ///
  /// In en, this message translates to:
  /// **'NEW: {mechanic}'**
  String newMechanic(String mechanic);

  /// No description provided for @sheetMeta.
  ///
  /// In en, this message translates to:
  /// **'{plates, plural, =1{1 plate} other{{plates} plates}} · {layers, plural, =1{1 layer} other{{layers} layers}} · tray {tray}'**
  String sheetMeta(int plates, int layers, int tray);

  /// No description provided for @theCampaign.
  ///
  /// In en, this message translates to:
  /// **'THE CAMPAIGN'**
  String get theCampaign;

  /// No description provided for @campaignFooter.
  ///
  /// In en, this message translates to:
  /// **'Chapters unlock by finishing the one before. Mastery marks are optional. Hints never block progress.'**
  String get campaignFooter;

  /// No description provided for @chapterBonus.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER BONUS'**
  String get chapterBonus;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @dailySheet.
  ///
  /// In en, this message translates to:
  /// **'DAILY SHEET'**
  String get dailySheet;

  /// No description provided for @dailyTitle.
  ///
  /// In en, this message translates to:
  /// **'TITLE'**
  String get dailyTitle;

  /// No description provided for @dailyPlates.
  ///
  /// In en, this message translates to:
  /// **'PLATES'**
  String get dailyPlates;

  /// No description provided for @dailyReward.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get dailyReward;

  /// No description provided for @dailyBody.
  ///
  /// In en, this message translates to:
  /// **'Same sheet for everyone today. No timer. {streak, plural, =0{Start a streak.} =1{1-day streak.} other{{streak}-day streak.}} Missing a day costs nothing.'**
  String dailyBody(int streak);

  /// No description provided for @startDaily.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s sheet'**
  String get startDaily;

  /// No description provided for @dailyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done for today · back tomorrow'**
  String get dailyCompleted;

  /// No description provided for @replayDaily.
  ///
  /// In en, this message translates to:
  /// **'Replay today\'s sheet'**
  String get replayDaily;

  /// No description provided for @themesTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themesTitle;

  /// No description provided for @themesCaption.
  ///
  /// In en, this message translates to:
  /// **'COSMETIC · NEVER CHANGES RULES'**
  String get themesCaption;

  /// No description provided for @equipped.
  ///
  /// In en, this message translates to:
  /// **'EQUIPPED'**
  String get equipped;

  /// No description provided for @owned.
  ///
  /// In en, this message translates to:
  /// **'OWNED'**
  String get owned;

  /// No description provided for @priceCoins.
  ///
  /// In en, this message translates to:
  /// **'{coins} ¢'**
  String priceCoins(int coins);

  /// No description provided for @proIncluded.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proIncluded;

  /// No description provided for @previewOnly.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get previewOnly;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @feedbackSection.
  ///
  /// In en, this message translates to:
  /// **'FEEDBACK'**
  String get feedbackSection;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @hapticsRow.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get hapticsRow;

  /// No description provided for @reducedMotionRow.
  ///
  /// In en, this message translates to:
  /// **'Reduced motion'**
  String get reducedMotionRow;

  /// No description provided for @reducedMotionCaption.
  ///
  /// In en, this message translates to:
  /// **'Fades instead of travel'**
  String get reducedMotionCaption;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get generalSection;

  /// No description provided for @highRefreshRate.
  ///
  /// In en, this message translates to:
  /// **'High refresh rate'**
  String get highRefreshRate;

  /// No description provided for @highRefreshRateOn.
  ///
  /// In en, this message translates to:
  /// **'Smoother motion · up to {hz} Hz · uses more battery'**
  String highRefreshRateOn(int hz);

  /// No description provided for @highRefreshRateOff.
  ///
  /// In en, this message translates to:
  /// **'Smoother motion · uses more battery'**
  String get highRefreshRateOff;

  /// No description provided for @highRefreshRateUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This screen runs at a single rate'**
  String get highRefreshRateUnsupported;

  /// No description provided for @highRefreshRateBattery.
  ///
  /// In en, this message translates to:
  /// **'Limited by battery saver right now'**
  String get highRefreshRateBattery;

  /// No description provided for @highRefreshRateHeat.
  ///
  /// In en, this message translates to:
  /// **'Limited while the phone is warm'**
  String get highRefreshRateHeat;

  /// No description provided for @highRefreshRateNow.
  ///
  /// In en, this message translates to:
  /// **'Now {hz} Hz'**
  String highRefreshRateNow(int hz);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get notifications;

  /// No description provided for @notificationsCaption.
  ///
  /// In en, this message translates to:
  /// **'One nudge when a new sheet is up'**
  String get notificationsCaption;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGoogle;

  /// No description provided for @signInApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInApple;

  /// No description provided for @signedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in · {name}'**
  String signedInAs(String name);

  /// No description provided for @guestCaption.
  ///
  /// In en, this message translates to:
  /// **'PLAYING AS GUEST · SIGN IN TO SAVE PROGRESS'**
  String get guestCaption;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'SIGN OUT'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'DELETE ACCOUNT'**
  String get deleteAccount;

  /// No description provided for @purchasesSection.
  ///
  /// In en, this message translates to:
  /// **'PURCHASES'**
  String get purchasesSection;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get restore;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Screw Out Pro'**
  String get proTitle;

  /// No description provided for @proPerks.
  ///
  /// In en, this message translates to:
  /// **'NO ADS · UNLIMITED HINTS · ALL THEMES · FREE RESCUES · {coins} ¢ MONTHLY'**
  String proPerks(int coins);

  /// No description provided for @proMonthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get proMonthly;

  /// No description provided for @proYearly.
  ///
  /// In en, this message translates to:
  /// **'YEARLY'**
  String get proYearly;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'PRO · ACTIVE'**
  String get proActive;

  /// No description provided for @adsRemoved.
  ///
  /// In en, this message translates to:
  /// **'ADS REMOVED'**
  String get adsRemoved;

  /// No description provided for @coinPacks.
  ///
  /// In en, this message translates to:
  /// **'COIN PACKS'**
  String get coinPacks;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @refundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get refundPolicy;

  /// No description provided for @privacyChoices.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get privacyChoices;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses & credits'**
  String get licenses;

  /// No description provided for @versionFooter.
  ///
  /// In en, this message translates to:
  /// **'SCREW OUT · REV {version} ({build})'**
  String versionFooter(String version, String build);

  /// No description provided for @notificationPrimerTitle.
  ///
  /// In en, this message translates to:
  /// **'A nudge for the daily sheet?'**
  String get notificationPrimerTitle;

  /// No description provided for @notificationPrimerBody.
  ///
  /// In en, this message translates to:
  /// **'One quiet reminder in the evening when you haven\'t played. Never more.'**
  String get notificationPrimerBody;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'ALLOW'**
  String get allow;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'NOT NOW'**
  String get notNow;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get offline;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @purchaseThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Purchase applied.'**
  String get purchaseThanks;

  /// No description provided for @purchasePending.
  ///
  /// In en, this message translates to:
  /// **'Purchase pending. It will apply once confirmed.'**
  String get purchasePending;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase didn\'t go through.'**
  String get purchaseFailed;

  /// No description provided for @signInToPurchase.
  ///
  /// In en, this message translates to:
  /// **'Sign in first so your purchase follows you.'**
  String get signInToPurchase;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored.'**
  String get restored;

  /// No description provided for @finishChapterFirst.
  ///
  /// In en, this message translates to:
  /// **'Finish Chapter {chapter} first.'**
  String finishChapterFirst(String chapter);

  /// No description provided for @moreSheetsTitle.
  ///
  /// In en, this message translates to:
  /// **'More sheets'**
  String get moreSheetsTitle;

  /// No description provided for @moreSheetsCaption.
  ///
  /// In en, this message translates to:
  /// **'New drawing sets arrive here'**
  String get moreSheetsCaption;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @equip.
  ///
  /// In en, this message translates to:
  /// **'EQUIP'**
  String get equip;

  /// No description provided for @buyFor.
  ///
  /// In en, this message translates to:
  /// **'BUY · {coins} ¢'**
  String buyFor(int coins);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @coinPackAmount.
  ///
  /// In en, this message translates to:
  /// **'+{coins} ¢'**
  String coinPackAmount(int coins);

  /// No description provided for @licensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licensesTitle;

  /// No description provided for @licensesCaption.
  ///
  /// In en, this message translates to:
  /// **'OPEN-SOURCE NOTICES'**
  String get licensesCaption;

  /// No description provided for @playLevel.
  ///
  /// In en, this message translates to:
  /// **'Play {code}'**
  String playLevel(String code);

  /// No description provided for @lockedLevel.
  ///
  /// In en, this message translates to:
  /// **'Sheet {number}, locked'**
  String lockedLevel(int number);

  /// No description provided for @platesScrews.
  ///
  /// In en, this message translates to:
  /// **'{plates} · {screws}'**
  String platesScrews(int plates, int screws);

  /// No description provided for @leaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Leaderboards'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardCaption.
  ///
  /// In en, this message translates to:
  /// **'SIGNED-IN PLAYERS · LIVE'**
  String get leaderboardCaption;

  /// No description provided for @boardSheets.
  ///
  /// In en, this message translates to:
  /// **'SHEETS'**
  String get boardSheets;

  /// No description provided for @boardDaily.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get boardDaily;

  /// No description provided for @boardStreak.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get boardStreak;

  /// No description provided for @boardSheetsHint.
  ///
  /// In en, this message translates to:
  /// **'MOST SHEETS CLEARED'**
  String get boardSheetsHint;

  /// No description provided for @boardDailyHint.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S SHEET · FEWEST MOVES, THEN FASTEST'**
  String get boardDailyHint;

  /// No description provided for @boardStreakHint.
  ///
  /// In en, this message translates to:
  /// **'DAYS IN A ROW ON THE DAILY SHEET'**
  String get boardStreakHint;

  /// No description provided for @boardMastered.
  ///
  /// In en, this message translates to:
  /// **'{count} ◆'**
  String boardMastered(int count);

  /// No description provided for @boardMovesDetail.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{MOVE} other{MOVES}} · {time}'**
  String boardMovesDetail(int count, String time);

  /// No description provided for @boardDaysDetail.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{DAY} other{DAYS}} · BEST {best}'**
  String boardDaysDetail(int count, int best);

  /// No description provided for @boardYou.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get boardYou;

  /// No description provided for @boardYourRank.
  ///
  /// In en, this message translates to:
  /// **'YOUR RANK'**
  String get boardYourRank;

  /// No description provided for @boardNotRanked.
  ///
  /// In en, this message translates to:
  /// **'Not ranked yet'**
  String get boardNotRanked;

  /// No description provided for @boardOfPlayers.
  ///
  /// In en, this message translates to:
  /// **'OF {count}'**
  String boardOfPlayers(int count);

  /// No description provided for @boardGuest.
  ///
  /// In en, this message translates to:
  /// **'Sign in to put your name on the board. Your progress comes with you.'**
  String get boardGuest;

  /// No description provided for @boardEmpty.
  ///
  /// In en, this message translates to:
  /// **'No one here yet. Be the first.'**
  String get boardEmpty;

  /// No description provided for @boardOffline.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the leaderboard right now.'**
  String get boardOffline;

  /// No description provided for @tryAgainCaps.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgainCaps;

  /// No description provided for @todaysBoard.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S BOARD'**
  String get todaysBoard;

  /// No description provided for @signedOutToast.
  ///
  /// In en, this message translates to:
  /// **'Signed out · this device was cleared. Sign in again to get your progress back.'**
  String get signedOutToast;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackName(String name);

  /// No description provided for @syncRestored.
  ///
  /// In en, this message translates to:
  /// **'{who} · {sheets, plural, =1{1 sheet} other{{sheets} sheets}} and {coins} coins restored'**
  String syncRestored(String who, int sheets, int coins);

  /// No description provided for @syncRestoredEmpty.
  ///
  /// In en, this message translates to:
  /// **'{who} · you\'re signed in and progress is backed up'**
  String syncRestoredEmpty(String who);

  /// No description provided for @syncCombined.
  ///
  /// In en, this message translates to:
  /// **'{who} · this device\'s progress was added to your account: {sheets, plural, =1{1 sheet} other{{sheets} sheets}}, {coins} coins'**
  String syncCombined(String who, int sheets, int coins);

  /// No description provided for @syncSavedNew.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name} · your progress is now saved to your account'**
  String syncSavedNew(String name);

  /// No description provided for @syncSavedNewPlain.
  ///
  /// In en, this message translates to:
  /// **'Signed in · your progress is now saved to your account'**
  String get syncSavedNewPlain;

  /// No description provided for @syncFromOtherDevice.
  ///
  /// In en, this message translates to:
  /// **'Synced from your other device · {sheets, plural, =0{progress updated} =1{1 new sheet} other{{sheets} new sheets}}'**
  String syncFromOtherDevice(int sheets);

  /// No description provided for @syncRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved progress yet · it will sync automatically when the connection is back'**
  String get syncRestoreFailed;

  /// No description provided for @signedInOffline.
  ///
  /// In en, this message translates to:
  /// **'Signed in · your progress will sync when you\'re back online'**
  String get signedInOffline;

  /// No description provided for @proActivated.
  ///
  /// In en, this message translates to:
  /// **'Pro is active · no ads, every theme and unlimited hints'**
  String get proActivated;

  /// No description provided for @accountDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Your account and all its data were deleted.'**
  String get accountDeletedToast;

  /// No description provided for @accountDeletedProToast.
  ///
  /// In en, this message translates to:
  /// **'Account deleted. Pro is still billed until you cancel it in {store}.'**
  String accountDeletedProToast(String store);

  /// No description provided for @deleteSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteSheetTitle;

  /// No description provided for @deleteSheetBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and everything saved with it: progress on every sheet, coins, themes, your daily streak and leaderboard places. It can\'t be undone.'**
  String get deleteSheetBody;

  /// No description provided for @deleteSheetPro.
  ///
  /// In en, this message translates to:
  /// **'You have Screw Out Pro. Deleting your account does not cancel it: cancel the subscription in {store} or you\'ll keep being billed.'**
  String deleteSheetPro(String store);

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// No description provided for @deleteForever.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteForever;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get deleting;

  /// No description provided for @keepAccount.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get keepAccount;

  /// No description provided for @deleteOffline.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Connect to the internet to delete your account.'**
  String get deleteOffline;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account. Please try again.'**
  String get deleteFailed;

  /// No description provided for @restoreNothing.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore on this account.'**
  String get restoreNothing;

  /// No description provided for @hintBoughtToast.
  ///
  /// In en, this message translates to:
  /// **'−{coins} ¢ · +1 hint'**
  String hintBoughtToast(int coins);

  /// No description provided for @hintEarnedToast.
  ///
  /// In en, this message translates to:
  /// **'+1 hint · thanks for watching'**
  String get hintEarnedToast;

  /// No description provided for @rescueToast.
  ///
  /// In en, this message translates to:
  /// **'+1 tray slot for this sheet'**
  String get rescueToast;

  /// No description provided for @rescuePaidToast.
  ///
  /// In en, this message translates to:
  /// **'−{coins} ¢ · +1 tray slot'**
  String rescuePaidToast(int coins);

  /// No description provided for @adNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Video didn\'t finish, so no reward this time.'**
  String get adNotCompleted;

  /// No description provided for @themeEquippedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} equipped'**
  String themeEquippedToast(String name);

  /// No description provided for @chapterDownloadedToast.
  ///
  /// In en, this message translates to:
  /// **'Chapter {chapter} is ready'**
  String chapterDownloadedToast(String chapter);

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in didn\'t complete.'**
  String get signInFailed;

  /// No description provided for @themePurchased.
  ///
  /// In en, this message translates to:
  /// **'Theme unlocked.'**
  String get themePurchased;

  /// No description provided for @proPerYear.
  ///
  /// In en, this message translates to:
  /// **'/ YEAR'**
  String get proPerYear;

  /// No description provided for @proPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ MONTH'**
  String get proPerMonth;

  /// No description provided for @sheetsTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} SHEETS'**
  String sheetsTotal(int count);

  /// No description provided for @dailyWeekDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dailyWeekDone;

  /// No description provided for @masteredCount.
  ///
  /// In en, this message translates to:
  /// **'{count} MASTERED'**
  String masteredCount(int count);

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sheet is ready'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'One fresh drawing, same for everyone. No timer.'**
  String get reminderBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
