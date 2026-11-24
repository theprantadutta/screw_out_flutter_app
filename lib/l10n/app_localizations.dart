import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// App name (brand). Used as the accessibility label of the home wordmark. Usually left untranslated.
  ///
  /// In en, this message translates to:
  /// **'Screw Out'**
  String get appName;

  /// Accessibility label of the pause button in the gameplay header.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Accessibility label of the back arrow button at the top left of every screen.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Accessibility label of the gear button on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Header above the tray of collected screws during gameplay. Max ~12 characters.
  ///
  /// In en, this message translates to:
  /// **'TRAY'**
  String get tray;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tray header when every slot is taken (warning state). Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'TRAY FULL'**
  String get trayFull;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Undo button under the board during gameplay; also its accessibility label.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Hint button under the board, showing how many hints are left.
  ///
  /// In en, this message translates to:
  /// **'HINT · {count}'**
  String hintCount(String count);

  /// Infinity sign shown instead of a number on the hint button for Pro players. Normally keep as is.
  ///
  /// In en, this message translates to:
  /// **'∞'**
  String get hintUnlimited;

  /// Title of the pause sheet during gameplay.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the pause sheet: sheet code and move count.
  ///
  /// In en, this message translates to:
  /// **'{code} · MOVE {moves}'**
  String pausedMeta(String code, int moves);

  /// Button/chip label: keep it short (about 20 characters max; longer text is scaled down). Main button on the pause sheet that returns to the game.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Toggle label on the pause sheet (sound on/off). Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'SOUND'**
  String get sound;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Toggle label on the pause sheet (vibration feedback on/off). Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'HAPTICS'**
  String get haptics;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Toggle label on the pause sheet (fewer animations). Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'REDUCED MOTION'**
  String get reducedMotion;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button to restart the current sheet (pause sheet, stuck sheet, restart confirmation).
  ///
  /// In en, this message translates to:
  /// **'RESTART'**
  String get restart;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 16 characters max; longer text is scaled down). Pause sheet button that leaves the game and returns to the sheet list.
  ///
  /// In en, this message translates to:
  /// **'EXIT TO SHEETS'**
  String get exitToSheets;

  /// Title of the confirmation sheet before restarting a sheet.
  ///
  /// In en, this message translates to:
  /// **'Restart this sheet?'**
  String get restartConfirmTitle;

  /// Body of the restart confirmation sheet.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose {moves} moves of progress.'**
  String restartConfirmBody(int moves);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Cancel button on confirmation sheets.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Title of the sheet shown when the tray is full and no move is possible.
  ///
  /// In en, this message translates to:
  /// **'No open slots left.'**
  String get stuckTitle;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Explains why the player is stuck, naming the plate that still holds screws.
  ///
  /// In en, this message translates to:
  /// **'{plate} still holds {count, plural, =1{one screw} other{{count} screws}} on the board. Undo frees a slot.'**
  String stuckReasonHolding(String plate, int count);

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Generic explanation on the stuck sheet when no single plate is to blame.
  ///
  /// In en, this message translates to:
  /// **'Every slot is taken and no plate can drop. Undo frees a slot.'**
  String get stuckReasonGeneric;

  /// Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Main button on the stuck sheet that undoes the last move.
  ///
  /// In en, this message translates to:
  /// **'Undo last move'**
  String get undoLastMove;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Stuck sheet button: buy one extra tray slot for coins. The cent sign stands for coins.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · {coins} ¢'**
  String rescueSlotCoins(int coins);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Stuck sheet button: get one extra tray slot by watching a video ad.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · VIDEO'**
  String get rescueSlotAd;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Stuck sheet button: free extra tray slot for Pro subscribers.
  ///
  /// In en, this message translates to:
  /// **'EXTRA SLOT · PRO'**
  String get rescueSlotPro;

  /// Title of the sheet offering another hint when none are left.
  ///
  /// In en, this message translates to:
  /// **'Want one more hint?'**
  String get outOfHintsTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the out-of-hints sheet.
  ///
  /// In en, this message translates to:
  /// **'HINTS · 0 LEFT'**
  String get hintsLeftZero;

  /// Body of the out-of-hints sheet. "Rings" means the hint draws a ring around one screw.
  ///
  /// In en, this message translates to:
  /// **'A hint rings one useful next screw. It never solves the sheet.'**
  String get outOfHintsBody;

  /// Option title on the out-of-hints sheet: watch a rewarded video ad for a hint.
  ///
  /// In en, this message translates to:
  /// **'Watch a short video'**
  String get watchVideo;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption under "Watch a short video": optional, about 30 seconds, gives one hint. "S" = seconds.
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL · ~30 S · +1 HINT'**
  String get watchVideoMeta;

  /// Option title on the out-of-hints sheet: pay coins for a hint.
  ///
  /// In en, this message translates to:
  /// **'Use {coins} coins'**
  String useCoins(int coins);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption showing the coin balance. The cent sign stands for coins.
  ///
  /// In en, this message translates to:
  /// **'BALANCE {balance} ¢'**
  String useCoinsMeta(int balance);

  /// Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Button that closes the out-of-hints sheet without buying.
  ///
  /// In en, this message translates to:
  /// **'Keep thinking'**
  String get keepThinking;

  /// Toast shown when the player cannot afford a hint or slot.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins yet.'**
  String get notEnoughCoins;

  /// Toast shown when no video ad can be loaded.
  ///
  /// In en, this message translates to:
  /// **'No video available right now.'**
  String get adUnavailable;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption on the result card after finishing a sheet.
  ///
  /// In en, this message translates to:
  /// **'{code} · CLEARED'**
  String cleared(String code);

  /// Big title on the result card when a sheet is solved (everything taken apart). Keep it one short word if possible.
  ///
  /// In en, this message translates to:
  /// **'Disassembled.'**
  String get disassembled;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Rubber stamp text on the result card, like an approval stamp on a technical drawing. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get approved;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Stat label on the result card. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'MOVES'**
  String get statMoves;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Stat label on the result card. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get statTime;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Stat label on the result card: whether the sheet was cleared without hints or restarts. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'MASTERY'**
  String get statMastery;

  /// Button/chip label: keep it short (about 26 characters max; longer text is scaled down). Main button on the result card that opens the next sheet.
  ///
  /// In en, this message translates to:
  /// **'Next sheet · {code}'**
  String nextSheet(String code);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Result card button that replays the same sheet.
  ///
  /// In en, this message translates to:
  /// **'REPLAY'**
  String get replay;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Button that returns to the list of sheets (result card, chapter complete).
  ///
  /// In en, this message translates to:
  /// **'SHEETS'**
  String get sheets;

  /// Button/chip label: keep it short (about 22 characters max; longer text is scaled down). Main button on the daily sheet result card, returns to the home screen.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHome;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption at the top of the chapter complete screen.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter} · COMPLETE'**
  String chapterComplete(String chapter);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the chapter complete screen above a newly unlocked board theme.
  ///
  /// In en, this message translates to:
  /// **'THEME UNLOCKED'**
  String get themeUnlocked;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the chapter complete screen introducing the next chapter.
  ///
  /// In en, this message translates to:
  /// **'NEXT · CHAPTER {chapter}'**
  String nextChapter(String chapter);

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Main button on the chapter complete screen.
  ///
  /// In en, this message translates to:
  /// **'Start Chapter {chapter}'**
  String startChapter(String chapter);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Chapter complete button that equips the theme just unlocked.
  ///
  /// In en, this message translates to:
  /// **'EQUIP {name}'**
  String equipTheme(String name);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tutorial callout on the very first sheet, pointing at the only screw.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 · TAP THE SCREW'**
  String get tutorialStep1;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tutorial callout pointing down at the tray. Keep the down arrow.
  ///
  /// In en, this message translates to:
  /// **'↓ IT LANDS IN THE TRAY'**
  String get tutorialLands;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 16 characters max; longer text is scaled down). Link at the bottom of the tutorial.
  ///
  /// In en, this message translates to:
  /// **'SKIP TUTORIAL'**
  String get skipTutorial;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tagline under the logo on the splash screen.
  ///
  /// In en, this message translates to:
  /// **'A PUZZLE OF LAYERS'**
  String get splashTagline;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Decorative footer on the splash screen, styled like a drawing title block (revision and sheet number).
  ///
  /// In en, this message translates to:
  /// **'REV 1.0 · SHEET 001'**
  String get splashFooter;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Decorative figure caption on the home screen next to the exploded drawing, four short lines. Keep the line breaks.
  ///
  /// In en, this message translates to:
  /// **'FIG. 1\nEXPLODED VIEW\n{plates, plural, =1{1 PLATE} other{{plates} PLATES}} · {screws}\n{screws, plural, =1{FASTENER} other{FASTENERS}}'**
  String homeFigure(int plates, int screws);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Dimension-line label on the home screen.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter}/{total}'**
  String chapterOf(String chapter, String total);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small callout next to a plate in the home drawing: how many screws hold it.
  ///
  /// In en, this message translates to:
  /// **'×{count} {count, plural, =1{FASTENER} other{FASTENERS}}'**
  String fastenerCount(int count);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the home screen card for the next sheet.
  ///
  /// In en, this message translates to:
  /// **'NEXT SHEET'**
  String get nextSheetLabel;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption above a chapter name (home, chapter map).
  ///
  /// In en, this message translates to:
  /// **'CHAPTER {chapter}'**
  String chapterLabel(String chapter);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption on the home screen progress bar.
  ///
  /// In en, this message translates to:
  /// **'CAMPAIGN'**
  String get campaign;

  /// Progress count on the home screen, sheets done of total. Usually only reorder if needed.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total}'**
  String campaignProgress(int done, int total);

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Main home screen button that opens the current sheet.
  ///
  /// In en, this message translates to:
  /// **'Continue · {code}'**
  String continueSheet(String code);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Home screen button that opens the daily sheet.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get daily;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Home screen button that opens the board themes.
  ///
  /// In en, this message translates to:
  /// **'THEMES'**
  String get themes;

  /// Shown on the home screen instead of the next sheet when every sheet is cleared.
  ///
  /// In en, this message translates to:
  /// **'All sheets cleared'**
  String get allCleared;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption with sheets cleared of total (campaign, chapter map, chapter complete).
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} SHEETS'**
  String sheetsCount(int done, int total);

  /// Title of the campaign screen when exactly five chapters exist.
  ///
  /// In en, this message translates to:
  /// **'Five chapters'**
  String get fiveChapters;

  /// Title of the campaign screen when more chapters were downloaded.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chaptersTitle;

  /// Compact progress on a chapter card, cleared of total.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total}'**
  String chapterProgress(int done, int total);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status on a locked chapter card. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get lockedChapter;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button that downloads a new chapter.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD'**
  String get downloadChapter;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 14 characters max; longer text is scaled down). Download button while a chapter downloads.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOADING…'**
  String get downloading;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption on the "More sheets" card when nothing new is available yet.
  ///
  /// In en, this message translates to:
  /// **'MORE SHEETS SOON'**
  String get comingSoon;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tag on the chapter map preview when a sheet introduces a new idea.
  ///
  /// In en, this message translates to:
  /// **'NEW: {mechanic}'**
  String newMechanic(String mechanic);

  /// Details line under a sheet title on the chapter map: plates, layers and tray size.
  ///
  /// In en, this message translates to:
  /// **'{plates, plural, =1{1 plate} other{{plates} plates}} · {layers, plural, =1{1 layer} other{{layers} layers}} · tray {tray}'**
  String sheetMeta(int plates, int layers, int tray);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption above the campaign screen title.
  ///
  /// In en, this message translates to:
  /// **'THE CAMPAIGN'**
  String get theCampaign;

  /// Footer text on the campaign screen.
  ///
  /// In en, this message translates to:
  /// **'Chapters unlock by finishing the one before. Mastery marks are optional. Hints never block progress.'**
  String get campaignFooter;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption above the coin reward on the chapter complete screen.
  ///
  /// In en, this message translates to:
  /// **'CHAPTER BONUS'**
  String get chapterBonus;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption at the top of the daily screen.
  ///
  /// In en, this message translates to:
  /// **'DAILY SHEET'**
  String get dailySheet;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Cell label in the daily sheet title block: the sheet name. Max ~8 characters.
  ///
  /// In en, this message translates to:
  /// **'TITLE'**
  String get dailyTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Cell label in the daily sheet title block: plates and screws. Max ~8 characters.
  ///
  /// In en, this message translates to:
  /// **'PLATES'**
  String get dailyPlates;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Cell label in the daily sheet title block: coin reward. Max ~8 characters.
  ///
  /// In en, this message translates to:
  /// **'REWARD'**
  String get dailyReward;

  /// Body text on the daily screen.
  ///
  /// In en, this message translates to:
  /// **'Same sheet for everyone today. No timer. {streak, plural, =0{Start a streak.} =1{1-day streak.} other{{streak}-day streak.}} Missing a day costs nothing.'**
  String dailyBody(int streak);

  /// Button/chip label: keep it short (about 26 characters max; longer text is scaled down). Main button on the daily screen.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s sheet'**
  String get startDaily;

  /// Line on the daily screen after today's sheet is done.
  ///
  /// In en, this message translates to:
  /// **'Done for today · back tomorrow'**
  String get dailyCompleted;

  /// Button/chip label: keep it short (about 26 characters max; longer text is scaled down). Main daily screen button after today's sheet is done.
  ///
  /// In en, this message translates to:
  /// **'Replay today\'s sheet'**
  String get replayDaily;

  /// Title of the board themes screen.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themesTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption on the themes screen: themes only change colours, never the rules.
  ///
  /// In en, this message translates to:
  /// **'COSMETIC · NEVER CHANGES RULES'**
  String get themesCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status/button on the theme currently in use. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'EQUIPPED'**
  String get equipped;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status on a theme card the player owns. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'OWNED'**
  String get owned;

  /// Coin price on a theme card. The cent sign stands for coins; keep the no-break space.
  ///
  /// In en, this message translates to:
  /// **'{coins} ¢'**
  String priceCoins(int coins);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status on a theme card included with Pro. Usually left as "PRO".
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proIncluded;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption on the theme preview sheet for a theme not owned yet. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get previewOnly;

  /// Title of the settings screen.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings section header for sound, music and vibration.
  ///
  /// In en, this message translates to:
  /// **'FEEDBACK'**
  String get feedbackSection;

  /// Settings toggle row.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// Settings toggle row.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// Settings toggle row: vibration feedback.
  ///
  /// In en, this message translates to:
  /// **'Haptics'**
  String get hapticsRow;

  /// Settings toggle row: fewer animations.
  ///
  /// In en, this message translates to:
  /// **'Reduced motion'**
  String get reducedMotionRow;

  /// Caption under the reduced motion toggle: pieces fade instead of flying across the screen.
  ///
  /// In en, this message translates to:
  /// **'Fades instead of travel'**
  String get reducedMotionCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings section header.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get generalSection;

  /// Settings toggle row: use the screen's higher refresh rate (90/120 Hz).
  ///
  /// In en, this message translates to:
  /// **'High refresh rate'**
  String get highRefreshRate;

  /// Caption under the high refresh rate toggle.
  ///
  /// In en, this message translates to:
  /// **'Smoother motion · up to {hz} Hz · uses more battery'**
  String highRefreshRateOn(int hz);

  /// Caption under the high refresh rate toggle when the maximum rate is unknown.
  ///
  /// In en, this message translates to:
  /// **'Smoother motion · uses more battery'**
  String get highRefreshRateOff;

  /// Caption under the high refresh rate toggle when the screen has one rate only.
  ///
  /// In en, this message translates to:
  /// **'This screen runs at a single rate'**
  String get highRefreshRateUnsupported;

  /// Caption under the high refresh rate toggle while battery saver caps it.
  ///
  /// In en, this message translates to:
  /// **'Limited by battery saver right now'**
  String get highRefreshRateBattery;

  /// Caption under the high refresh rate toggle while the phone is too warm.
  ///
  /// In en, this message translates to:
  /// **'Limited while the phone is warm'**
  String get highRefreshRateHeat;

  /// Appended to the refresh rate caption: the current rate.
  ///
  /// In en, this message translates to:
  /// **'Now {hz} Hz'**
  String highRefreshRateNow(int hz);

  /// Settings row that opens the language picker; also the picker title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Settings toggle row: the daily reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get notifications;

  /// Caption under the daily reminder toggle.
  ///
  /// In en, this message translates to:
  /// **'One nudge when a new sheet is up'**
  String get notificationsCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings section header.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get accountSection;

  /// Sign-in button (follow Google's official wording for your language if it exists).
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGoogle;

  /// Sign-in button (follow Apple's official "Sign in with Apple" wording for your language).
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInApple;

  /// Settings row showing the signed-in player.
  ///
  /// In en, this message translates to:
  /// **'Signed in · {name}'**
  String signedInAs(String name);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings caption for players who are not signed in.
  ///
  /// In en, this message translates to:
  /// **'PLAYING AS GUEST · SIGN IN TO SAVE PROGRESS'**
  String get guestCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 14 characters max; longer text is scaled down). Settings button.
  ///
  /// In en, this message translates to:
  /// **'SIGN OUT'**
  String get signOut;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 18 characters max; longer text is scaled down). Settings button that opens the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'DELETE ACCOUNT'**
  String get deleteAccount;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings section header.
  ///
  /// In en, this message translates to:
  /// **'PURCHASES'**
  String get purchasesSection;

  /// Settings purchase row title (one-time purchase that removes ads).
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Settings button that restores earlier purchases.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get restore;

  /// Name of the subscription. "Pro" is normally kept as is.
  ///
  /// In en, this message translates to:
  /// **'Screw Out Pro'**
  String get proTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small caption listing the Pro benefits. The cent sign stands for coins.
  ///
  /// In en, this message translates to:
  /// **'NO ADS · UNLIMITED HINTS · ALL THEMES · FREE RESCUES · {coins} ¢ MONTHLY'**
  String proPerks(int coins);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Monthly plan button label.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get proMonthly;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Yearly plan button label.
  ///
  /// In en, this message translates to:
  /// **'YEARLY'**
  String get proYearly;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Small note on a plan button about the free trial.
  ///
  /// In en, this message translates to:
  /// **'{days} DAYS FREE'**
  String proTrialDays(int days);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Price line on a plan button after the free trial.
  ///
  /// In en, this message translates to:
  /// **'THEN {price}'**
  String proThenPrice(String price);

  /// Legal note under the Pro plans.
  ///
  /// In en, this message translates to:
  /// **'Renews automatically after the free trial unless you cancel. Monthly coins start with your first payment.'**
  String get proTrialTerms;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status shown when Pro is active.
  ///
  /// In en, this message translates to:
  /// **'PRO · ACTIVE'**
  String get proActive;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status on the Remove ads row once bought.
  ///
  /// In en, this message translates to:
  /// **'ADS REMOVED'**
  String get adsRemoved;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings caption above the coin pack buttons.
  ///
  /// In en, this message translates to:
  /// **'COIN PACKS'**
  String get coinPacks;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Settings section header.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// Settings link row.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// Settings link row.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// Settings link row.
  ///
  /// In en, this message translates to:
  /// **'Refund policy'**
  String get refundPolicy;

  /// Settings link row that opens the ad consent options.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get privacyChoices;

  /// Settings link row that opens the open-source licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses & credits'**
  String get licenses;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Version footer at the bottom of settings. "REV" means revision (drawing style).
  ///
  /// In en, this message translates to:
  /// **'SCREW OUT · REV {version} ({build})'**
  String versionFooter(String version, String build);

  /// Title of the sheet asking whether the player wants the daily reminder.
  ///
  /// In en, this message translates to:
  /// **'A nudge for the daily sheet?'**
  String get notificationPrimerTitle;

  /// Body of the notification permission sheet.
  ///
  /// In en, this message translates to:
  /// **'A quiet reminder when you haven\'t played. Never more than one a day.'**
  String get notificationPrimerBody;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button on the notification permission sheet.
  ///
  /// In en, this message translates to:
  /// **'ALLOW'**
  String get allow;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button that dismisses a sheet without acting.
  ///
  /// In en, this message translates to:
  /// **'NOT NOW'**
  String get notNow;

  /// Generic error toast.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// Toast after a successful purchase.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Purchase applied.'**
  String get purchaseThanks;

  /// Toast when a purchase is waiting for the store (for example cash payments).
  ///
  /// In en, this message translates to:
  /// **'Purchase pending. It will apply once confirmed.'**
  String get purchasePending;

  /// Toast when a purchase fails or is cancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase didn\'t go through.'**
  String get purchaseFailed;

  /// Toast after purchases are restored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored.'**
  String get restored;

  /// Toast when the player taps a locked chapter.
  ///
  /// In en, this message translates to:
  /// **'Finish Chapter {chapter} first.'**
  String finishChapterFirst(String chapter);

  /// Title of the card at the end of the campaign list where new chapters appear.
  ///
  /// In en, this message translates to:
  /// **'More sheets'**
  String get moreSheetsTitle;

  /// Caption on the "More sheets" card when a new chapter can be downloaded.
  ///
  /// In en, this message translates to:
  /// **'New drawing sets arrive here'**
  String get moreSheetsCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button on the theme preview sheet.
  ///
  /// In en, this message translates to:
  /// **'EQUIP'**
  String get equip;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 16 characters max; longer text is scaled down). Button that buys a theme for coins. The cent sign stands for coins.
  ///
  /// In en, this message translates to:
  /// **'BUY · {coins} ¢'**
  String buyFor(int coins);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Button that closes a sheet.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// Coins in a coin pack on its buy button. Usually left as is.
  ///
  /// In en, this message translates to:
  /// **'+{coins} ¢'**
  String coinPackAmount(int coins);

  /// Title of the licenses screen.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licensesTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption above the licenses screen title.
  ///
  /// In en, this message translates to:
  /// **'OPEN-SOURCE NOTICES'**
  String get licensesCaption;

  /// Accessibility label of the play button on the chapter map.
  ///
  /// In en, this message translates to:
  /// **'Play {code}'**
  String playLevel(String code);

  /// Accessibility label of a locked sheet on the chapter map.
  ///
  /// In en, this message translates to:
  /// **'Sheet {number}, locked'**
  String lockedLevel(int number);

  /// Value in the daily title block: plates and screws. Usually left as is.
  ///
  /// In en, this message translates to:
  /// **'{plates} · {screws}'**
  String platesScrews(int plates, int screws);

  /// Title of the leaderboard screen; also the accessibility label of its home button.
  ///
  /// In en, this message translates to:
  /// **'Leaderboards'**
  String get leaderboardTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption above the leaderboard title.
  ///
  /// In en, this message translates to:
  /// **'SIGNED-IN PLAYERS · LIVE'**
  String get leaderboardCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 8 characters max; longer text is scaled down). Leaderboard tab: most sheets cleared. Four tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'SHEETS'**
  String get boardSheets;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 8 characters max; longer text is scaled down). Leaderboard tab: today's daily sheet. Four tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get boardDaily;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 8 characters max; longer text is scaled down). Leaderboard tab: daily streaks. Four tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get boardStreak;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 8 characters max; longer text is scaled down). Leaderboard tab: this week. Four tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'WEEK'**
  String get boardWeekly;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption explaining the weekly leaderboard.
  ///
  /// In en, this message translates to:
  /// **'SHEETS CLEARED THIS WEEK · RESETS MONDAY'**
  String get boardWeeklyHint;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption explaining the sheets leaderboard.
  ///
  /// In en, this message translates to:
  /// **'MOST SHEETS CLEARED'**
  String get boardSheetsHint;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption explaining the daily leaderboard ranking.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S SHEET · FEWEST MOVES, THEN FASTEST'**
  String get boardDailyHint;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption explaining the streak leaderboard.
  ///
  /// In en, this message translates to:
  /// **'DAYS IN A ROW ON THE DAILY SHEET'**
  String get boardStreakHint;

  /// Leaderboard row detail: sheets mastered, with the diamond mastery mark. Usually left as is.
  ///
  /// In en, this message translates to:
  /// **'{count} ◆'**
  String boardMastered(int count);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Leaderboard row detail on the daily board, after the move count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{MOVE} other{MOVES}} · {time}'**
  String boardMovesDetail(int count, String time);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Leaderboard row detail on the streak board, after the day count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{DAY} other{DAYS}} · BEST {best}'**
  String boardDaysDetail(int count, int best);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Tiny tag on the player's own leaderboard row. Max ~5 characters.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get boardYou;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Label of the player's rank bar at the bottom of the leaderboard.
  ///
  /// In en, this message translates to:
  /// **'YOUR RANK'**
  String get boardYourRank;

  /// Shown in the rank bar when the player has no rank yet.
  ///
  /// In en, this message translates to:
  /// **'Not ranked yet'**
  String get boardNotRanked;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. After the player's rank: out of how many players.
  ///
  /// In en, this message translates to:
  /// **'OF {count}'**
  String boardOfPlayers(int count);

  /// Leaderboard message for players who are not signed in.
  ///
  /// In en, this message translates to:
  /// **'Sign in to put your name on the board. Your progress comes with you.'**
  String get boardGuest;

  /// Leaderboard message when nobody is ranked yet.
  ///
  /// In en, this message translates to:
  /// **'No one here yet. Be the first.'**
  String get boardEmpty;

  /// Leaderboard message when it cannot load.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the leaderboard right now.'**
  String get boardOffline;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 12 characters max; longer text is scaled down). Retry button on the leaderboard.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgainCaps;

  /// Accessibility label of the leaderboard button on the daily screen.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S BOARD'**
  String get todaysBoard;

  /// Toast after signing out.
  ///
  /// In en, this message translates to:
  /// **'Signed out · this device was cleared. Sign in again to get your progress back.'**
  String get signedOutToast;

  /// Greeting used at the start of sync toasts when the name is unknown.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Greeting used at the start of sync toasts.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBackName(String name);

  /// Toast after sign-in restored saved progress.
  ///
  /// In en, this message translates to:
  /// **'{who} · {sheets, plural, =1{1 sheet} other{{sheets} sheets}} and {coins} coins restored'**
  String syncRestored(String who, int sheets, int coins);

  /// Toast after sign-in when there was nothing to restore.
  ///
  /// In en, this message translates to:
  /// **'{who} · you\'re signed in and progress is backed up'**
  String syncRestoredEmpty(String who);

  /// Toast after sign-in merged this device's progress into the account.
  ///
  /// In en, this message translates to:
  /// **'{who} · this device\'s progress was added to your account: {sheets, plural, =1{1 sheet} other{{sheets} sheets}}, {coins} coins'**
  String syncCombined(String who, int sheets, int coins);

  /// Toast after the first sign-in on a new account.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name} · your progress is now saved to your account'**
  String syncSavedNew(String name);

  /// Toast after the first sign-in when the name is unknown.
  ///
  /// In en, this message translates to:
  /// **'Signed in · your progress is now saved to your account'**
  String get syncSavedNewPlain;

  /// Toast when progress from another device arrives.
  ///
  /// In en, this message translates to:
  /// **'Synced from your other device · {sheets, plural, =0{progress updated} =1{1 new sheet} other{{sheets} new sheets}}'**
  String syncFromOtherDevice(int sheets);

  /// Toast when saved progress could not be loaded yet.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your saved progress yet · it will sync automatically when the connection is back'**
  String get syncRestoreFailed;

  /// Toast after signing in without a connection.
  ///
  /// In en, this message translates to:
  /// **'Signed in · your progress will sync when you\'re back online'**
  String get signedInOffline;

  /// Toast when a Pro subscription becomes active (after buying or restoring).
  ///
  /// In en, this message translates to:
  /// **'Pro is active · no ads, every theme and unlimited hints'**
  String get proActivated;

  /// Toast after the account is deleted.
  ///
  /// In en, this message translates to:
  /// **'Your account and all its data were deleted.'**
  String get accountDeletedToast;

  /// Toast after the account is deleted while a Pro subscription is still running.
  ///
  /// In en, this message translates to:
  /// **'Account deleted. Pro is still billed until you cancel it in {store}.'**
  String accountDeletedProToast(String store);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Line on the daily result card about the streak bonus.
  ///
  /// In en, this message translates to:
  /// **'{days}-DAY STREAK · +{coins} BONUS'**
  String streakBonusLine(int days, int coins);

  /// Title of the achievements (badges) screen.
  ///
  /// In en, this message translates to:
  /// **'Workshop record'**
  String get workshopRecord;

  /// Button on the campaign screen that opens the achievements screen.
  ///
  /// In en, this message translates to:
  /// **'Workshop record · {earned}/{total}'**
  String workshopRecordButton(int earned, int total);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption above the achievements screen title.
  ///
  /// In en, this message translates to:
  /// **'MILESTONES'**
  String get recordCaption;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Progress line on the achievements screen.
  ///
  /// In en, this message translates to:
  /// **'{earned} OF {total} EARNED'**
  String recordEarned(int earned, int total);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Status on an earned badge. Max ~10 characters.
  ///
  /// In en, this message translates to:
  /// **'EARNED'**
  String get badgeEarnedLabel;

  /// Toast when a badge is earned.
  ///
  /// In en, this message translates to:
  /// **'Badge earned · {name}'**
  String badgeEarnedToast(String name);

  /// Badge name: first sheet cleared. Workshop rank theme.
  ///
  /// In en, this message translates to:
  /// **'First Turn'**
  String get badgeFirstTurn;

  /// Badge name: 10 sheets cleared. Workshop rank theme (apprentice, journeyman, craftsman, chief engineer).
  ///
  /// In en, this message translates to:
  /// **'Apprentice'**
  String get badgeApprentice;

  /// Badge name: 25 sheets cleared. Workshop rank theme.
  ///
  /// In en, this message translates to:
  /// **'Journeyman'**
  String get badgeJourneyman;

  /// Badge name: 50 sheets cleared. Workshop rank theme.
  ///
  /// In en, this message translates to:
  /// **'Craftsman'**
  String get badgeCraftsman;

  /// Badge name: 100 sheets cleared. Highest workshop rank.
  ///
  /// In en, this message translates to:
  /// **'Chief Engineer'**
  String get badgeChiefEngineer;

  /// Badge name: mastery on 10 sheets (cleared without hints or restarts).
  ///
  /// In en, this message translates to:
  /// **'Clean Work'**
  String get badgeCleanWork;

  /// Badge name: mastery on 50 sheets.
  ///
  /// In en, this message translates to:
  /// **'Perfectionist'**
  String get badgePerfectionist;

  /// Badge name: played 7 daily sheets.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get badgeRegular;

  /// Badge name: 3-day daily streak.
  ///
  /// In en, this message translates to:
  /// **'On a Roll'**
  String get badgeOnARoll;

  /// Badge name: 7-day daily streak.
  ///
  /// In en, this message translates to:
  /// **'Full Week'**
  String get badgeFullWeek;

  /// Badge name: 14-day daily streak.
  ///
  /// In en, this message translates to:
  /// **'Fortnight'**
  String get badgeFortnight;

  /// Badge requirement line.
  ///
  /// In en, this message translates to:
  /// **'Clear your first sheet'**
  String get badgeFirstDetail;

  /// Badge requirement line.
  ///
  /// In en, this message translates to:
  /// **'Clear {n} sheets'**
  String badgeClearDetail(int n);

  /// Badge requirement line. Chapter badges are named after the chapter.
  ///
  /// In en, this message translates to:
  /// **'Finish chapter {n}'**
  String badgeChapterDetail(int n);

  /// Badge requirement line. The diamond is the mastery mark.
  ///
  /// In en, this message translates to:
  /// **'Earn ◆ on {n} sheets'**
  String badgeMasterDetail(int n);

  /// Badge requirement line.
  ///
  /// In en, this message translates to:
  /// **'Play {n} daily sheets'**
  String badgeDailyDetail(int n);

  /// Badge requirement line.
  ///
  /// In en, this message translates to:
  /// **'Reach a {n}-day streak'**
  String badgeStreakDetail(int n);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Share button on the daily result card.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get share;

  /// Daily screen button that shares today's result.
  ///
  /// In en, this message translates to:
  /// **'Share result'**
  String get shareResult;

  /// First line of the shared daily result text (sent to other apps). Keep the brand.
  ///
  /// In en, this message translates to:
  /// **'Screw Out · {code}'**
  String shareDailyTitle(String code);

  /// Second line of the shared daily result text.
  ///
  /// In en, this message translates to:
  /// **'{moves, plural, =1{1 move} other{{moves} moves}} · {time}'**
  String shareDailyMoves(int moves, String time);

  /// Optional line of the shared daily result text.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String shareDailyStreak(int days);

  /// Title of the sign-out confirmation sheet.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutSheetTitle;

  /// Body of the sign-out confirmation sheet.
  ///
  /// In en, this message translates to:
  /// **'Signing out clears your progress from this device. Everything already backed up comes back when you sign in again, but anything not synced yet (for example, sheets played offline) would be lost.'**
  String get signOutSheetBody;

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Main (safe) button on the sign-out sheet.
  ///
  /// In en, this message translates to:
  /// **'Stay signed in'**
  String get staySignedIn;

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Secondary button on the sign-out sheet that signs out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutConfirm;

  /// Settings link row that opens the store listing.
  ///
  /// In en, this message translates to:
  /// **'Rate Screw Out'**
  String get rateApp;

  /// Settings link row that opens an email to the developer.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// Settings link row that replays the first-sheet tutorial.
  ///
  /// In en, this message translates to:
  /// **'Replay tutorial'**
  String get replayTutorial;

  /// Toast when no email app is installed.
  ///
  /// In en, this message translates to:
  /// **'No email app found. Write to us at {email}'**
  String feedbackNoEmailApp(String email);

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 10 characters max; longer text is scaled down). Chip on the home screen when an app update is downloaded.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get updateChip;

  /// Accessibility label of the update chip.
  ///
  /// In en, this message translates to:
  /// **'Update downloaded. Restart to install it.'**
  String get updateReadyRestart;

  /// Title of the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteSheetTitle;

  /// Body of the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your account and everything saved with it: progress on every sheet, coins, themes, your daily streak and leaderboard places. It can\'t be undone.'**
  String get deleteSheetBody;

  /// Warning on the delete account sheet for Pro subscribers.
  ///
  /// In en, this message translates to:
  /// **'You have Screw Out Pro. Deleting your account does not cancel it: cancel the subscription in {store} or you\'ll keep being billed.'**
  String deleteSheetPro(String store);

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Button on the delete account sheet that opens the store subscription page.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Destructive button on the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteForever;

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Delete button while deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get deleting;

  /// Button/chip label: keep it short (about 24 characters max; longer text is scaled down). Main (safe) button on the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'Keep my account'**
  String get keepAccount;

  /// Toast when deleting the account without a connection.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Connect to the internet to delete your account.'**
  String get deleteOffline;

  /// Toast when deleting the account fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account. Please try again.'**
  String get deleteFailed;

  /// Toast when there is nothing to restore.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore on this account.'**
  String get restoreNothing;

  /// Toast after buying a hint with coins. The cent sign stands for coins.
  ///
  /// In en, this message translates to:
  /// **'−{coins} ¢ · +1 hint'**
  String hintBoughtToast(int coins);

  /// Toast after watching a video for a hint.
  ///
  /// In en, this message translates to:
  /// **'+1 hint · thanks for watching'**
  String get hintEarnedToast;

  /// Toast after getting an extra tray slot.
  ///
  /// In en, this message translates to:
  /// **'+1 tray slot for this sheet'**
  String get rescueToast;

  /// Toast after buying an extra tray slot with coins.
  ///
  /// In en, this message translates to:
  /// **'−{coins} ¢ · +1 tray slot'**
  String rescuePaidToast(int coins);

  /// Toast when a rewarded video was closed early.
  ///
  /// In en, this message translates to:
  /// **'Video didn\'t finish, so no reward this time.'**
  String get adNotCompleted;

  /// Toast after equipping a board theme.
  ///
  /// In en, this message translates to:
  /// **'{name} equipped'**
  String themeEquippedToast(String name);

  /// Toast after a chapter download finishes.
  ///
  /// In en, this message translates to:
  /// **'Chapter {chapter} is ready'**
  String chapterDownloadedToast(String chapter);

  /// Toast when sign-in did not complete.
  ///
  /// In en, this message translates to:
  /// **'Sign-in didn\'t complete.'**
  String get signInFailed;

  /// Toast after buying a theme.
  ///
  /// In en, this message translates to:
  /// **'Theme unlocked.'**
  String get themePurchased;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 18 characters max; longer text is scaled down). Secondary button: buy a theme pack with real money.
  ///
  /// In en, this message translates to:
  /// **'OR BUY · {price}'**
  String themeBuyStore(String price);

  /// Title of the card that sells every theme at once.
  ///
  /// In en, this message translates to:
  /// **'All themes'**
  String get themesBundleTitle;

  /// Body of the all-themes card.
  ///
  /// In en, this message translates to:
  /// **'Every paid theme, yours to keep. Pro includes them too.'**
  String get themesBundleBody;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 16 characters max; longer text is scaled down). Buy button on the all-themes card.
  ///
  /// In en, this message translates to:
  /// **'BUY · {price}'**
  String themesBundleBuy(String price);

  /// Appended to a weekday in accessibility labels of the daily week strip when that day was played.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dailyWeekDone;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Caption on the chapter complete screen.
  ///
  /// In en, this message translates to:
  /// **'{count} MASTERED'**
  String masteredCount(int count);

  /// Title of the daily reminder notification.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sheet is ready'**
  String get reminderTitle;

  /// Body of the daily reminder notification.
  ///
  /// In en, this message translates to:
  /// **'One fresh drawing, same for everyone. No timer.'**
  String get reminderBody;

  /// Title of the reminder notification for players who have not played for a while.
  ///
  /// In en, this message translates to:
  /// **'Your next sheet is on the bench'**
  String get comebackReminderTitle;

  /// Body of the comeback reminder notification.
  ///
  /// In en, this message translates to:
  /// **'A few calm minutes, a few screws. Pick up where you left off.'**
  String get comebackReminderBody;

  /// Sign-in button that opens the email form.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get signInEmail;

  /// Title and submit button of the email sign-in sheet.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get emailSignInTitle;

  /// Title and submit button of the email sheet in create-account mode.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get emailCreateTitle;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 14 characters max; longer text is scaled down). Tab on the email sheet. Two tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get emailTabSignIn;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Button/chip label: keep it short (about 16 characters max; longer text is scaled down). Tab on the email sheet. Two tabs share one row.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get emailTabCreate;

  /// Body of the email sign-in sheet.
  ///
  /// In en, this message translates to:
  /// **'Your progress on this device comes with you.'**
  String get emailSheetBody;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Field label on the email sheet.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailLabel;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Field label for the password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// Tooltip of the eye button in the password field.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// Tooltip of the eye button in the password field.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// Helper text under the password field when creating an account.
  ///
  /// In en, this message translates to:
  /// **'At least {min} characters'**
  String passwordHint(int min);

  /// Field error.
  ///
  /// In en, this message translates to:
  /// **'Enter your email.'**
  String get emailRequired;

  /// Field error.
  ///
  /// In en, this message translates to:
  /// **'That email address doesn\'t look right.'**
  String get emailInvalid;

  /// Field error.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// Field error.
  ///
  /// In en, this message translates to:
  /// **'Use at least {min} characters.'**
  String passwordTooShort(int min);

  /// Link on the email sign-in sheet.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Error when Forgot password is tapped without an email. Match the wording of forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email above, then tap Forgot password.'**
  String get forgotNeedsEmail;

  /// Info after a password reset is requested.
  ///
  /// In en, this message translates to:
  /// **'If {email} has an account, a reset link is on its way.'**
  String resetSent(String email);

  /// Submit button text while the email sheet is busy.
  ///
  /// In en, this message translates to:
  /// **'One moment…'**
  String get emailWorking;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password.'**
  String get authErrWrongCredentials;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account. Sign in instead.'**
  String get authErrEmailInUse;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Pick a stronger password.'**
  String get authErrWeakPassword;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authErrDisabled;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Email sign-in isn\'t available right now.'**
  String get authErrNotEnabled;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Too many tries. Wait a moment and try again.'**
  String get authErrTooMany;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get authErrNetwork;

  /// Sign-in error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in. Please try again.'**
  String get authErrGeneric;

  /// Line on the delete account sheet asking for the password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm it\'s you.'**
  String get deletePasswordBody;

  /// Field error on the delete account sheet.
  ///
  /// In en, this message translates to:
  /// **'That password doesn\'t match this account.'**
  String get deleteWrongPassword;

  /// Title of the sheet suggesting sign-in after a purchase.
  ///
  /// In en, this message translates to:
  /// **'Keep your purchase'**
  String get purchaseSaveTitle;

  /// Body of the sheet suggesting sign-in after a purchase.
  ///
  /// In en, this message translates to:
  /// **'Optional: sign in to keep your purchases and progress on all your devices. Your purchase already works on this one.'**
  String get purchaseSaveBody;

  /// Toast when a purchase cannot be verified with the server.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your connection and try again.'**
  String get purchaseNeedsConnection;

  /// Language picker option (and Settings row value) that follows the device language.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Recovery screen shown if the app fails to start. Keep the line break.
  ///
  /// In en, this message translates to:
  /// **'SOMETHING WENT WRONG WHILE STARTING.\nCLOSE THE APP AND OPEN IT AGAIN.'**
  String get startupFailed;

  /// Description of the app's notification channel, shown in the Android system notification settings.
  ///
  /// In en, this message translates to:
  /// **'Daily sheet reminders and account notices'**
  String get notificationChannelDescription;

  /// Name of Apple's store as it fits inside deleteSheetPro and accountDeletedProToast ("cancel it in {store}"). Include an article only if your grammar needs it there.
  ///
  /// In en, this message translates to:
  /// **'the App Store'**
  String get storeAppStore;

  /// Name of Google's store as it fits inside deleteSheetPro and accountDeletedProToast ("cancel it in {store}").
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get storeGooglePlay;

  /// Screen reader label of a screw on the board.
  ///
  /// In en, this message translates to:
  /// **'Screw, plate {plate}'**
  String a11yScrew(String plate);

  /// Screen reader label of a screw that another plate covers.
  ///
  /// In en, this message translates to:
  /// **'Screw, plate {plate}, blocked by {blocker}'**
  String a11yScrewBlocked(String plate, String blocker);

  /// Screen reader label of the tray: how many slots are filled.
  ///
  /// In en, this message translates to:
  /// **'{label} {filled} of {total}'**
  String a11yTray(String label, int filled, int total);

  /// Name of chapter 1 of the campaign. Shown as a title on the home screen, campaign card, chapter map and chapter complete screen (very large there, followed by a full stop). Also the name of the chapter 1 badge. Keep it short (max ~18 characters).
  ///
  /// In en, this message translates to:
  /// **'Workshop Basics'**
  String get chapterName1;

  /// Name of chapter 2 of the campaign. Shown as a title on the home screen, campaign card, chapter map and chapter complete screen (very large there, followed by a full stop). Also the name of the chapter 2 badge. Keep it short (max ~18 characters).
  ///
  /// In en, this message translates to:
  /// **'Layer by Layer'**
  String get chapterName2;

  /// Name of chapter 3 of the campaign. Shown as a title on the home screen, campaign card, chapter map and chapter complete screen (very large there, followed by a full stop). Also the name of the chapter 3 badge. Keep it short (max ~18 characters).
  ///
  /// In en, this message translates to:
  /// **'Make Room'**
  String get chapterName3;

  /// Name of chapter 4 of the campaign. Shown as a title on the home screen, campaign card, chapter map and chapter complete screen (very large there, followed by a full stop). Also the name of the chapter 4 badge. Keep it short (max ~18 characters).
  ///
  /// In en, this message translates to:
  /// **'Interlocking'**
  String get chapterName4;

  /// Name of chapter 5 of the campaign. Shown as a title on the home screen, campaign card, chapter map and chapter complete screen (very large there, followed by a full stop). Also the name of the chapter 5 badge. Keep it short (max ~18 characters).
  ///
  /// In en, this message translates to:
  /// **'Master Builder'**
  String get chapterName5;

  /// One-line caption under the chapter 1 name ("Workshop Basics") on its campaign card. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Tap, remove, release'**
  String get chapterGoal1;

  /// One-line caption under the chapter 2 name ("Layer by Layer") on its campaign card. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Overlap & reveal order'**
  String get chapterGoal2;

  /// One-line caption under the chapter 3 name ("Make Room") on its campaign card. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Plan around a tight tray'**
  String get chapterGoal3;

  /// One-line caption under the chapter 4 name ("Interlocking") on its campaign card. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Shared supports'**
  String get chapterGoal4;

  /// One-line caption under the chapter 5 name ("Master Builder") on its campaign card. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Everything, fairly'**
  String get chapterGoal5;

  /// One-line teaser for chapter 1 ("Workshop Basics"), shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'Tap a screw. Drop a plate. That is the whole rule.'**
  String get chapterPitch1;

  /// One-line teaser for chapter 2 ("Layer by Layer"), shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'Plates hide plates. Work from the top down.'**
  String get chapterPitch2;

  /// One-line teaser for chapter 3 ("Make Room"), shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'Tighter trays. Plan which screws to pull first.'**
  String get chapterPitch3;

  /// One-line teaser for chapter 4 ("Interlocking"), shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'One plate pins several. Find the key piece.'**
  String get chapterPitch4;

  /// One-line teaser for chapter 5 ("Master Builder"), shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'Deep stacks, every idea at once. Take your time.'**
  String get chapterPitch5;

  /// Name of a downloaded chapter beyond the first five (a "drawing set" is a set of technical drawings).
  ///
  /// In en, this message translates to:
  /// **'Drawing Set {number}'**
  String chapterNameDrawingSet(String number);

  /// Caption on the campaign card of a downloaded chapter. Max ~28 characters.
  ///
  /// In en, this message translates to:
  /// **'Master-level sheets'**
  String get chapterGoalDownloaded;

  /// Teaser for a downloaded chapter, shown on the previous chapter's completion screen.
  ///
  /// In en, this message translates to:
  /// **'More sheets, same fair rules.'**
  String get chapterPitchDownloaded;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (plates overlap each other), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'OVERLAP'**
  String get mechanicOverlap;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (the tray of collected screws), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'TRAY'**
  String get mechanicTray;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (several stacked layers of plates), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'LAYERS'**
  String get mechanicLayers;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (round plates), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'CIRCLES'**
  String get mechanicCircles;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (a tempting move that fills the tray), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'TRAPS'**
  String get mechanicTraps;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Short tag for a puzzle mechanic (one plate holds down others), shown as "NEW: ..." on the chapter map. Max ~14 characters.
  ///
  /// In en, this message translates to:
  /// **'SUPPORTS'**
  String get mechanicSupports;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 4 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'LIFT THE TOP PLATE TO REACH THE SCREW BELOW'**
  String get sheetObjective004;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 6 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'THE TRAY HOLDS 3. A RELEASED PLATE FREES ITS SLOTS'**
  String get sheetObjective006;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 11 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'THREE LAYERS. WORK FROM THE TOP DOWN'**
  String get sheetObjective011;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 12 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'LIFT PL-04 BEFORE THE PLATES BELOW'**
  String get sheetObjective012;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 17 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'ONE TEMPTING MOVE FILLS THE TRAY'**
  String get sheetObjective017;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 21 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'ROUND PLATES COVER LIKE ANY OTHER'**
  String get sheetObjective021;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 24 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'REMOVE PL-04 TO REACH THE CORNER'**
  String get sheetObjective024;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 41 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'TIGHT TRAY. FREE A PLATE BEFORE IT FILLS'**
  String get sheetObjective041;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 61 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'ONE PLATE CAN HOLD DOWN SEVERAL OTHERS'**
  String get sheetObjective061;

  /// Shown in UPPERCASE in a monospace font; translate in capitals where the script has them. Objective chip shown above the board on sheet 81 until the first move (the app adds an arrow in front). Plate tags like PL-04 must stay as is. Max ~48 characters.
  ///
  /// In en, this message translates to:
  /// **'EVERYTHING YOU HAVE LEARNED. TAKE YOUR TIME'**
  String get sheetObjective081;

  /// Name of a cosmetic board theme (default blue technical-drawing look). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Clean Blueprint'**
  String get themeNameBlueprint;

  /// Name of a cosmetic board theme (warm wood colours). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Walnut Workshop'**
  String get themeNameWalnut;

  /// Name of a cosmetic board theme (teal and grey colours). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Ocean Teal'**
  String get themeNameOcean;

  /// Name of a cosmetic board theme (copper and dark brown colours). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Warm Copper'**
  String get themeNameCopper;

  /// Name of a cosmetic board theme (dark colours with red accents). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Midnight Workshop'**
  String get themeNameMidnight;

  /// Name of a cosmetic board theme (soft pastel colours). Shown on the themes screen, chapter complete screen and toasts. Max ~20 characters.
  ///
  /// In en, this message translates to:
  /// **'Pastel Studio'**
  String get themeNamePastel;

  /// Fallback title for a downloaded sheet that has no name.
  ///
  /// In en, this message translates to:
  /// **'Sheet {number}'**
  String sheetTitleNumbered(int number);

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 1 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'First Turn'**
  String get sheetTitle001;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 2 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Two Point'**
  String get sheetTitle002;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 3 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Side by Side'**
  String get sheetTitle003;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 4 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cover Plate'**
  String get sheetTitle004;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 5 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get sheetTitle005;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 6 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Tray Day'**
  String get sheetTitle006;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 7 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Small Plan'**
  String get sheetTitle007;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 8 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Tight Fit'**
  String get sheetTitle008;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 9 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Round Stock'**
  String get sheetTitle009;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 10 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Checkpoint'**
  String get sheetTitle010;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 11 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Third Layer'**
  String get sheetTitle011;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 12 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cross Brace'**
  String get sheetTitle012;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 13 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Free a Slot'**
  String get sheetTitle013;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 14 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Two Ahead'**
  String get sheetTitle014;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 15 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Painted Steel'**
  String get sheetTitle015;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 16 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Workbench'**
  String get sheetTitle016;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 17 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Tempting'**
  String get sheetTitle017;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 18 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cascade'**
  String get sheetTitle018;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 19 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Shop Mix'**
  String get sheetTitle019;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 20 (chapter 1), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get sheetTitle020;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 21 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Washer Stack'**
  String get sheetTitle021;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 22 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Gasket'**
  String get sheetTitle022;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 23 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Lens Cap'**
  String get sheetTitle023;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 24 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Hidden Bracket'**
  String get sheetTitle024;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 25 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Shim Set'**
  String get sheetTitle025;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 26 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Bezel'**
  String get sheetTitle026;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 27 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Grommet'**
  String get sheetTitle027;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 28 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Breather'**
  String get sheetTitle028;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 29 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Flange Ring'**
  String get sheetTitle029;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 30 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Porthole'**
  String get sheetTitle030;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 31 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Spacer'**
  String get sheetTitle031;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 32 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Collar'**
  String get sheetTitle032;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 33 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'End Cap'**
  String get sheetTitle033;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 34 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Quiet Shift'**
  String get sheetTitle034;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 35 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Bulkhead'**
  String get sheetTitle035;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 36 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Inspection Port'**
  String get sheetTitle036;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 37 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Faceplate'**
  String get sheetTitle037;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 38 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Light Duty'**
  String get sheetTitle038;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 39 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Rosette'**
  String get sheetTitle039;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 40 (chapter 2), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Layer Cake'**
  String get sheetTitle040;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 41 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Make Room'**
  String get sheetTitle041;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 42 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Bin Space'**
  String get sheetTitle042;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 43 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Overflow'**
  String get sheetTitle043;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 44 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cubby'**
  String get sheetTitle044;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 45 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Parts Bin'**
  String get sheetTitle045;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 46 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Short Stock'**
  String get sheetTitle046;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 47 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Pigeonhole'**
  String get sheetTitle047;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 48 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Easy Out'**
  String get sheetTitle048;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 49 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Slot Machine'**
  String get sheetTitle049;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 50 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Full House'**
  String get sheetTitle050;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 51 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Backlog'**
  String get sheetTitle051;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 52 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Spare Slot'**
  String get sheetTitle052;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 53 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Clearance'**
  String get sheetTitle053;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 54 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Loose Fit'**
  String get sheetTitle054;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 55 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get sheetTitle055;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 56 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Allowance'**
  String get sheetTitle056;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 57 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get sheetTitle057;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 58 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Day Off'**
  String get sheetTitle058;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 59 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Head Room'**
  String get sheetTitle059;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 60 (chapter 3), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get sheetTitle060;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 61 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Interlock'**
  String get sheetTitle061;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 62 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Gusset'**
  String get sheetTitle062;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 63 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Keystone'**
  String get sheetTitle063;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 64 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Lap Joint'**
  String get sheetTitle064;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 65 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Splice Plate'**
  String get sheetTitle065;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 66 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Dovetail'**
  String get sheetTitle066;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 67 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Lintel'**
  String get sheetTitle067;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 68 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Off Cut'**
  String get sheetTitle068;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 69 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Strut'**
  String get sheetTitle069;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 70 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Truss'**
  String get sheetTitle070;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 71 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Clevis'**
  String get sheetTitle071;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 72 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Yoke'**
  String get sheetTitle072;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 73 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Saddle'**
  String get sheetTitle073;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 74 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Footing'**
  String get sheetTitle074;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 75 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Bracket Pair'**
  String get sheetTitle075;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 76 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Clamp Bar'**
  String get sheetTitle076;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 77 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Tie Plate'**
  String get sheetTitle077;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 78 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Plain Panel'**
  String get sheetTitle078;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 79 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cantilever'**
  String get sheetTitle079;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 80 (chapter 4), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Moment Frame'**
  String get sheetTitle080;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 81 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Master Plan'**
  String get sheetTitle081;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 82 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Subassembly'**
  String get sheetTitle082;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 83 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Exploded View'**
  String get sheetTitle083;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 84 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Fit Check'**
  String get sheetTitle084;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 85 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Torque Spec'**
  String get sheetTitle085;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 86 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Jig'**
  String get sheetTitle086;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 87 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Fixture'**
  String get sheetTitle087;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 88 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Calm Bench'**
  String get sheetTitle088;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 89 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Gearbox'**
  String get sheetTitle089;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 90 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get sheetTitle090;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 91 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Chassis'**
  String get sheetTitle091;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 92 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Panel Bay'**
  String get sheetTitle092;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 93 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Cover Set'**
  String get sheetTitle093;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 94 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Easy Torque'**
  String get sheetTitle094;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 95 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Engine Mount'**
  String get sheetTitle095;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 96 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Switchgear'**
  String get sheetTitle096;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 97 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Control Box'**
  String get sheetTitle097;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 98 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Drafting Table'**
  String get sheetTitle098;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 99 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Final Inspection'**
  String get sheetTitle099;

  /// Glossary: a "sheet" is one puzzle level (styled as a technical drawing), a "plate" is a board piece held by screws, the "tray" holds removed screws. Name of campaign sheet 100 (chapter 5), also used for daily sheets. Workshop and technical drawing vocabulary; a natural short name or pun beats a literal translation. Shown in the gameplay header, chapter map and daily card. Max ~18 characters.
  ///
  /// In en, this message translates to:
  /// **'Sign Off'**
  String get sheetTitle100;
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
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
