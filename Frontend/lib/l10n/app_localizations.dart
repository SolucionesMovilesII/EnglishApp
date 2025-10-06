import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_qu.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
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
    Locale('es'),
    Locale('pt'),
    Locale('qu'),
    Locale('ru'),
  ];

  // ======================= Common / Auth =======================

  String get appTitle;
  String get login;
  String get email;
  String get password;
  String get loginButton;
  String get loginWithGoogle;
  String get loginWithApple;
  String get emailRequired;
  String get emailInvalid;
  String get passwordRequired;
  String get passwordTooShort;
  String get hi;
  String get continueText;

  // ======================= Main Sections =======================

  String get vocabulary;
  String get reading;
  String get interview;
  String get home;
  String get documents;
  /// Book section title
  String get book;
  String get help;
  String get settings;
  String get theme;
  String get language;
  String get lightTheme;
  String get darkTheme;
  String get colorPalette;
  String get system;

  // ======================= Notifications =======================

  String get notifications;
  String get notificationsEnabled;
  String get notificationsDisabled;

  // ======================= Session / UI =======================

  String get logout;
  String get selectLanguage;
  String get selectColorPalette;
  String get confirmLogout;
  String get logoutConfirmation;
  String get cancel;
  String get welcomeBack;
  String get yourLearningPath;
  String get learningSlogan;
  String get signingYouIn;
  String get connectingWithGoogle;
  String get connectingWithApple;
  String get loadingExperience;
  String get initializingExperience;
  String get or;
  String get user;

  // Lives / Progress snippets
  String livesRemaining(int lives);
  String get chapterProgress;

  // Tech topics
  String get software;
  String get databases;

  // Navigation helper
  String navigatingToSection(String section);

  // Auth errors
  String get emailPasswordRequired;
  String get invalidCredentials;
  String get googleSignInFailed;
  String get appleSignInFailed;
  String get errorDuringLogout;
  String get errorCheckingAuth;
  String get errorInMockLogin;
  String get comingSoon;

  // Generic section title
  String sectionTitle(String title);

  // Color picker
  String get selectCustomColor;
  String get hue;
  String get saturation;
  String get lightness;
  String get quickColors;
  String get selectColor;

  // Quiz
  String get quiz;
  String get question;
  String get submit;
  String get nextQuestion;
  String get score;
  String get points;

  // Episodes
  String get completeePreviousEpisode;
  String get episodeCompleted;
  String get continueEpisode;
  String get completePreviousEpisode;
  String playingEpisode(String episodeTitle);

  // Account / Register
  String get dontHaveAccount;
  String get signUp;
  String get createAccount;
  String get joinUsSlogan;
  String get fullName;
  String get enterFullName;
  String get confirmPassword;
  String get enterConfirmPassword;
  String get acceptTerms;
  String get pleaseEnterName;
  String get nameTooShort;
  String get passwordsDontMatch;
  String get pleaseAcceptTerms;
  String get alreadyHaveAccount;
  String get signIn;
  String get creatingAccount;
  String get register;
  String get signUpWithGoogle;
  String get signUpWithApple;
  String get creatingAccountWithGoogle;
  String get creatingAccountWithApple;

  // Forgot password
  String get forgotPassword;
  String get checkYourEmail;
  String get forgotPasswordSubtitle;
  String get emailSentMessage;
  String get emailAddress;
  String get enterEmailAddress;
  String get sendResetLink;
  String get backToLogin;
  String get emailSent;
  String get sendingResetLink;
  String get emailSentSuccessfully;
  String get resendEmail;
  String get openEmailApp;
  String get resetLinkSentAgain;
  String get openingEmailApp;
  String get forgotPasswordQuestion;

  // Misc
  String get rememberSession;
  /// Folders section title
  String get folders;
  String get errorLoadingLives;
  String get retry;
  String get noLivesRemaining;
  String get livesResetTomorrow;
  String get nextResetTomorrow;
  String get refresh;

  // ======================= Repeat Chapter (hu-005-02) =======================

  String get repeatChapterTitle;
  String get repeatChapterWarning;
  String currentScore(int score);
  String get repeatChapterBenefit;
  String get repeatChapter;
  String chapterResetForRepetition(String chapterTitle);

  // These appear in some locales together with repeat chapter:
  String get progress; // generic progress label
  String get episodeContent;
  String get episodeContentPlaceholder;
  String get replayEpisode;
  String get startEpisode;
  String startingEpisode(String episodeTitle);

  // ======================= Evaluation (hu-006-1) =======================

  /// 'Evaluation Details'
  String get evaluationDetails;
  /// 'Completed Date'
  String get completedDate;
  /// 'Attempts'
  String get attempts;
  /// 'Time Spent'
  String get timeSpent;
  /// 'Skill Breakdown'
  String get skillBreakdown;
  /// 'Feedback'
  String get feedback;
  /// 'This feature is coming soon!'
  String get featureComingSoon;
  /// 'Chapter'
  String get chapter;
  /// 'Evaluation Information'
  String get evaluationInfo;
  /// 'Chapter Results'
  String get chapterResults;
  /// 'All Chapters'
  String get allChapters;
  /// 'No evaluations found'
  String get noEvaluationsFound;
  /// 'Complete chapters to see results'
  String get completeChaptersToSeeResults;

  // ======================= Vocabulary Chapters (main) =======================

  String get vocabularyChaptersTitle;
  String get loadingVocabularyChapters;
  String get errorLoadingChapters;
  String get unknownError;
  String get dismiss;
  String get tryAgain;
  String get noChaptersAvailable;
  String get noChaptersDescription;
  String get yourProgress;
  String get chaptersCompleted;
  String get unlocked;
  String get locked;

  // Shared CTAs / states used alongside vocabulary chapters
  String get completed;
  String get continue_;
  String get start;
  String get chapterLocked;
  String chapterLockedDescription(int previousChapter);
  String get understood;
  String get chapterCompleted;
  String get chapterCompletedDescription;
  String completedOn(DateTime date);
  String get close;
  String get reviewChapter;
  String get noLivesTitle;
  String get noLivesMessage;
  String nextResetAt(String time);

  /// No description provided for @repeatChapterWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to repeat this chapter? Your current progress will be saved.'**
  String get repeatChapterWarning;

  /// No description provided for @evaluationHistory.
  ///
  /// In en, this message translates to:
  /// **'View your evaluation history and progress'**
  String get evaluationHistory;

  /// No description provided for @currentScore.
  ///
  /// In en, this message translates to:
  /// **'Current Score'**
  String get currentScore;

  /// No description provided for @viewProgress.
  ///
  /// In en, this message translates to:
  /// **'View Progress'**
  String get viewProgress;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits of repeating:'**
  String get benefits;

  /// No description provided for @improveScore.
  ///
  /// In en, this message translates to:
  /// **'• Improve your score'**
  String get improveScore;

  /// No description provided for @reinforceLearning.
  ///
  /// In en, this message translates to:
  /// **'• Reinforce learning'**
  String get reinforceLearning;

  /// No description provided for @betterUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'• Better understanding'**
  String get betterUnderstanding;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @chapterResults.
  ///
  /// In en, this message translates to:
  /// **'Chapter Results'**
  String get chapterResults;

  /// No description provided for @allChapters.
  ///
  /// In en, this message translates to:
  /// **'All Chapters'**
  String get allChapters;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @noEvaluationsFound.
  ///
  /// In en, this message translates to:
  /// **'No evaluations found'**
  String get noEvaluationsFound;

  /// No description provided for @completeChaptersToSeeResults.
  ///
  /// In en, this message translates to:
  /// **'Complete chapters to see your results here'**
  String get completeChaptersToSeeResults;

  /// No description provided for @evaluationInfo.
  ///
  /// In en, this message translates to:
  /// **'Evaluation Information'**
  String get evaluationInfo;

  /// No description provided for @completedDate.
  ///
  /// In en, this message translates to:
  /// **'Completed Date'**
  String get completedDate;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time Spent'**
  String get timeSpent;

  /// No description provided for @skillBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Skill Breakdown'**
  String get skillBreakdown;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// No description provided for @repeatChapter.
  ///
  /// In en, this message translates to:
  /// **'Repeat Chapter'**
  String get repeatChapter;
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
      <String>['en', 'es', 'pt', 'qu', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
    case 'qu':
      return AppLocalizationsQu();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
