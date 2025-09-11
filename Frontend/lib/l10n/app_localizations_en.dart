// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Language Learning App';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginWithGoogle => 'Sign in with Google';

  @override
  String get loginWithApple => 'Sign in with Apple';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 12 characters';

  @override
  String get hi => 'Hi';

  @override
  String get continueText => 'Continue';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get reading => 'Reading';

  @override
  String get interview => 'Interview';

  @override
  String get home => 'Home';

  @override
  String get documents => 'Documents';

  @override
  String get book => 'Book';

  @override
  String get help => 'Help';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get colorPalette => 'Color Palette';

  @override
  String get system => 'System';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled => 'Notifications enabled';

  @override
  String get notificationsDisabled => 'Notifications disabled';

  @override
  String get logout => 'Logout';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectColorPalette => 'Select Color Palette';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get yourLearningPath => 'Your Learning Path';

  @override
  String get learningSlogan => 'Learn • Practice • Master';

  @override
  String get signingYouIn => 'Signing you in...';

  @override
  String get connectingWithGoogle => 'Connecting with Google...';

  @override
  String get connectingWithApple => 'Connecting with Apple...';

  @override
  String get loadingExperience => 'Loading your learning experience...';

  @override
  String get initializingExperience =>
      'Initializing your learning experience...';

  @override
  String get or => 'OR';

  @override
  String get user => 'User';

  @override
  String livesRemaining(int lives) {
    return '$lives lives remaining';
  }

  @override
  String get chapterProgress => 'Cap 4/5';

  @override
  String get software => 'Software';

  @override
  String get databases => 'Databases';

  @override
  String navigatingToSection(String section) {
    return 'Navigating to $section section...';
  }

  @override
  String get emailPasswordRequired => 'Email and password are required';

  @override
  String get invalidCredentials =>
      'Invalid credentials. Please check your email and password.';

  @override
  String get googleSignInFailed => 'Google sign in failed';

  @override
  String get appleSignInFailed => 'Apple sign in failed';

  @override
  String get errorDuringLogout => 'Error during logout';

  @override
  String get errorCheckingAuth => 'Error checking authentication status';

  @override
  String get errorInMockLogin => 'Error in mock login';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String sectionTitle(String title) {
    return '$title Section';
  }

  @override
  String get selectCustomColor => 'Select Custom Color';

  @override
  String get hue => 'Hue';

  @override
  String get saturation => 'Saturation';

  @override
  String get lightness => 'Lightness';

  @override
  String get quickColors => 'Quick Colors';

  @override
  String get selectColor => 'Select Color';

  @override
  String get quiz => 'Quiz';

  @override
  String get question => 'Question';

  @override
  String get submit => 'Submit';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get score => 'Score';

  @override
  String get points => 'points';

  @override
  String get completeePreviousEpisode =>
      'Complete the previous episode to unlock this one';

  @override
  String get episodeCompleted => 'Episode completed - Tap to replay';

  @override
  String get continueEpisode => 'Continue episode';

  @override
  String get completePreviousEpisode => 'Complete previous episode to unlock';

  @override
  String playingEpisode(String episodeTitle) {
    return 'Playing $episodeTitle';
  }

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUsSlogan => 'Join us to start your technical English journey';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterConfirmPassword => 'Re-enter your password';

  @override
  String get acceptTerms => 'I accept the Terms of Service and Privacy Policy';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get pleaseAcceptTerms => 'Please accept the terms and conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get creatingAccount => 'Creating your account...';

  @override
  String get register => 'Register';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get creatingAccountWithGoogle => 'Creating account with Google...';

  @override
  String get creatingAccountWithApple => 'Creating account with Apple...';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get forgotPasswordSubtitle =>
      'Don\'t worry! Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get emailSentMessage =>
      'We\'ve sent a password reset link to your email address. Please check your inbox and follow the instructions.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmailAddress => 'Enter your email address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get emailSent => 'Email Sent';

  @override
  String get sendingResetLink => 'Sending reset link...';

  @override
  String get emailSentSuccessfully => 'Password reset email sent successfully!';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get openEmailApp => 'Open Email App';

  @override
  String get resetLinkSentAgain => 'Reset link sent again!';

  @override
  String get openingEmailApp => 'Opening email app...';

  @override
  String get forgotPasswordQuestion => 'Forgot your password?';

  @override
  String get rememberSession => 'Remember session';

  @override
  String get folders => 'Folders';

  @override
  String get errorLoadingLives => 'Error loading lives';

  @override
  String get retry => 'Retry';

  @override
  String get noLivesRemaining => 'No lives remaining!';

  @override
  String get livesResetTomorrow => 'Lives reset tomorrow';

  @override
  String get nextResetTomorrow => 'Next reset tomorrow';

  @override
  String get refresh => 'Refresh';
}
