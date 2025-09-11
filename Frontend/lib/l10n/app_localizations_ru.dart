// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Приложение для изучения языков';

  @override
  String get login => 'Вход';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginWithGoogle => 'Войти через Google';

  @override
  String get loginWithApple => 'Войти через Apple';

  @override
  String get emailRequired => 'Требуется электронная почта';

  @override
  String get emailInvalid => 'Введите действительный адрес электронной почты';

  @override
  String get passwordRequired => 'Требуется пароль';

  @override
  String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String get hi => 'Привет';

  @override
  String get continueText => 'Продолжить';

  @override
  String get vocabulary => 'Словарь';

  @override
  String get reading => 'Чтение';

  @override
  String get interview => 'Интервью';

  @override
  String get home => 'Главная';

  @override
  String get documents => 'Документы';

  @override
  String get book => 'Книга';

  @override
  String get help => 'Помощь';

  @override
  String get settings => 'Настройки';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Темная';

  @override
  String get colorPalette => 'Цветовая палитра';

  @override
  String get system => 'Система';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get notificationsDisabled => 'Уведомления отключены';

  @override
  String get logout => 'Выйти';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get selectColorPalette => 'Выбрать цветовую палитру';

  @override
  String get confirmLogout => 'Подтвердить выход';

  @override
  String get logoutConfirmation => 'Вы уверены, что хотите выйти?';

  @override
  String get cancel => 'Отмена';

  @override
  String get welcomeBack => 'Добро пожаловать!';

  @override
  String get yourLearningPath => 'Ваш путь обучения';

  @override
  String get learningSlogan => 'Изучай • Практикуй • Овладевай';

  @override
  String get signingYouIn => 'Выполняется вход...';

  @override
  String get connectingWithGoogle => 'Подключение к Google...';

  @override
  String get connectingWithApple => 'Подключение к Apple...';

  @override
  String get loadingExperience => 'Загрузка вашего опыта обучения...';

  @override
  String get initializingExperience => 'Инициализация вашего опыта обучения...';

  @override
  String get or => 'ИЛИ';

  @override
  String get user => 'Пользователь';

  @override
  String get livesRemaining => '5/5';

  @override
  String get chapterProgress => 'Глава 4/5';

  @override
  String get software => 'Программное обеспечение';

  @override
  String get databases => 'Базы данных';

  @override
  String navigatingToSection(String section) {
    return 'Navigating to $section section...';
  }

  @override
  String get emailPasswordRequired => 'Требуется электронная почта и пароль';

  @override
  String get invalidCredentials =>
      'Invalid credentials. Please check your email and password.';

  @override
  String get googleSignInFailed => 'Ошибка входа через Google';

  @override
  String get appleSignInFailed => 'Ошибка входа через Apple';

  @override
  String get errorDuringLogout => 'Ошибка при выходе';

  @override
  String get errorCheckingAuth => 'Ошибка проверки статуса аутентификации';

  @override
  String get errorInMockLogin => 'Ошибка в тестовом входе';

  @override
  String get comingSoon => 'Скоро';

  @override
  String sectionTitle(String title) {
    return 'Раздел $title';
  }

  @override
  String get selectCustomColor => 'Выбрать пользовательский цвет';

  @override
  String get hue => 'Оттенок';

  @override
  String get saturation => 'Насыщенность';

  @override
  String get lightness => 'Яркость';

  @override
  String get quickColors => 'Быстрые цвета';

  @override
  String get selectColor => 'Выбрать цвет';

  @override
  String get quiz => 'Quiz';

  @override
  String get question => 'Вопрос';

  @override
  String get submit => 'Отправить';

  @override
  String get nextQuestion => 'Следующий вопрос';

  @override
  String get score => 'Score';

  @override
  String get points => 'очков';

  @override
  String get completeePreviousEpisode =>
      'Complete the previous episode to unlock this one';

  @override
  String get episodeCompleted => 'Эпизод завершен - Нажмите для повтора';

  @override
  String get continueEpisode => 'Продолжить эпизод';

  @override
  String get completePreviousEpisode =>
      'Завершите предыдущий эпизод, чтобы разблокировать этот';

  @override
  String playingEpisode(String episodeTitle) {
    return 'Воспроизводится $episodeTitle';
  }

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get signUp => 'Регистрация';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get joinUsSlogan =>
      'Присоединяйтесь к нам, чтобы начать изучение технического английского';

  @override
  String get fullName => 'Полное имя';

  @override
  String get enterFullName => 'Введите ваше полное имя';

  @override
  String get confirmPassword => 'Подтвердить пароль';

  @override
  String get enterConfirmPassword => 'Подтвердите ваш пароль';

  @override
  String get acceptTerms =>
      'Я принимаю Условия обслуживания и Политику конфиденциальности';

  @override
  String get pleaseEnterName => 'Пожалуйста, введите ваше имя';

  @override
  String get nameTooShort => 'Имя должно содержать не менее 2 символов';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get pleaseAcceptTerms => 'Пожалуйста, примите условия и положения';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get signIn => 'Войти';

  @override
  String get creatingAccount => 'Создание вашего аккаунта...';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get signUpWithGoogle => 'Зарегистрироваться через Google';

  @override
  String get signUpWithApple => 'Зарегистрироваться через Apple';

  @override
  String get creatingAccountWithGoogle => 'Создание аккаунта через Google...';

  @override
  String get creatingAccountWithApple => 'Создание аккаунта через Apple...';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get checkYourEmail => 'Проверьте вашу электронную почту';

  @override
  String get forgotPasswordSubtitle =>
      'Не волнуйтесь! Введите ваш адрес электронной почты, и мы отправим вам ссылку для сброса пароля.';

  @override
  String get emailSentMessage =>
      'Мы отправили ссылку для сброса пароля на ваш адрес электронной почты. Пожалуйста, проверьте входящие сообщения и следуйте инструкциям.';

  @override
  String get emailAddress => 'Адрес электронной почты';

  @override
  String get enterEmailAddress => 'Введите ваш адрес электронной почты';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get backToLogin => 'Вернуться к входу';

  @override
  String get emailSent => 'Письмо отправлено';

  @override
  String get sendingResetLink => 'Отправка ссылки для сброса...';

  @override
  String get emailSentSuccessfully =>
      'Письмо для сброса пароля успешно отправлено!';

  @override
  String get resendEmail => 'Отправить письмо повторно';

  @override
  String get openEmailApp => 'Открыть почтовое приложение';

  @override
  String get resetLinkSentAgain => 'Ссылка для сброса отправлена снова!';

  @override
  String get openingEmailApp => 'Открытие почтового приложения...';

  @override
  String get forgotPasswordQuestion => 'Забыли пароль?';

  @override
  String get rememberSession => 'Запомнить сессию';

  @override
  String get folders => 'Папки';
}
