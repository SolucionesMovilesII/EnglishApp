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
  String get darkTheme => 'Тёмная';

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
  String get welcomeBack => 'С возвращением!';

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
  String get loadingExperience => 'Загружаем ваш опыт обучения...';

  @override
  String get initializingExperience => 'Инициализируем опыт обучения...';

  @override
  String get or => 'ИЛИ';

  @override
  String get user => 'Пользователь';

  @override
  String livesRemaining(int lives) {
    // Формат как "3/5"
    return '$lives/5';
  }

  @override
  String get chapterProgress => 'Глава 4/5';

  @override
  String get software => 'Программное обеспечение';

  @override
  String get databases => 'Базы данных';

  @override
  String navigatingToSection(String section) {
    return 'Переход к разделу $section...';
  }

  @override
  String get emailPasswordRequired => 'Требуются электронная почта и пароль';

  @override
  String get invalidCredentials =>
      'Неверные данные. Проверьте почту и пароль.';

  @override
  String get googleSignInFailed => 'Ошибка входа через Google';

  @override
  String get appleSignInFailed => 'Ошибка входа через Apple';

  @override
  String get errorDuringLogout => 'Ошибка при выходе';

  @override
  String get errorCheckingAuth => 'Ошибка проверки статуса аутентификации';

  @override
  String get errorInMockLogin => 'Ошибка тестового входа';

  @override
  String get comingSoon => 'Скоро';

  @override
  String sectionTitle(String title) {
    return 'Раздел $title';
  }

  @override
  String get selectCustomColor => 'Выбрать собственный цвет';

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
  String get quiz => 'Викторина';

  @override
  String get question => 'Вопрос';

  @override
  String get submit => 'Отправить';

  @override
  String get nextQuestion => 'Следующий вопрос';

  @override
  String get score => 'Счёт';

  @override
  String get points => 'очков';

  @override
  String get completeePreviousEpisode =>
      'Завершите предыдущий эпизод, чтобы открыть этот';

  @override
  String get episodeCompleted => 'Эпизод завершён — нажмите, чтобы повторить';

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
  String get signUp => 'Зарегистрироваться';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get joinUsSlogan =>
      'Присоединяйтесь и начните путь в техническом английском';

  @override
  String get fullName => 'Полное имя';

  @override
  String get enterFullName => 'Введите ваше полное имя';

  @override
  String get confirmPassword => 'Подтвердить пароль';

  @override
  String get enterConfirmPassword => 'Повторите пароль';

  @override
  String get acceptTerms =>
      'Я принимаю Условия использования и Политику конфиденциальности';

  @override
  String get pleaseEnterName => 'Пожалуйста, введите имя';

  @override
  String get nameTooShort => 'Имя должно содержать минимум 2 символа';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get pleaseAcceptTerms => 'Пожалуйста, примите условия';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signIn => 'Войти';

  @override
  String get creatingAccount => 'Создаём ваш аккаунт...';

  @override
  String get register => 'Регистрация';

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
  String get checkYourEmail => 'Проверьте почту';

  @override
  String get forgotPasswordSubtitle =>
      'Не волнуйтесь! Введите адрес электронной почты, и мы отправим ссылку для сброса пароля.';

  @override
  String get emailSentMessage =>
      'Мы отправили ссылку для сброса пароля на вашу почту. Проверьте входящие и следуйте инструкциям.';

  @override
  String get emailAddress => 'Адрес электронной почты';

  @override
  String get enterEmailAddress => 'Введите адрес электронной почты';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get backToLogin => 'Вернуться ко входу';

  @override
  String get emailSent => 'Письмо отправлено';

  @override
  String get sendingResetLink => 'Отправляем ссылку для сброса...';

  @override
  String get emailSentSuccessfully =>
      'Письмо для сброса пароля успешно отправлено!';

  @override
  String get resendEmail => 'Отправить ещё раз';

  @override
  String get openEmailApp => 'Открыть почтовое приложение';

  @override
  String get resetLinkSentAgain => 'Ссылка для сброса отправлена повторно!';

  @override
  String get openingEmailApp => 'Открываем почтовое приложение...';

  @override
  String get forgotPasswordQuestion => 'Забыли пароль?';

  @override
  String get rememberSession => 'Запомнить сессию';

  @override
  String get folders => 'Папки';

  @override
  String get errorLoadingLives => 'Ошибка загрузки жизней';

  @override
  String get retry => 'Повторить';

  @override
  String get noLivesRemaining => 'Жизни закончились!';

  @override
  String get livesResetTomorrow => 'Жизни обновятся завтра';

  @override
  String get nextResetTomorrow => 'Следующее обновление — завтра';

  @override
  String get refresh => 'Обновить';

  // ----- Повтор главы -----

  @override
  String get repeatChapterTitle => 'Повторить главу';

  @override
  String get repeatChapterWarning =>
      'Вы уже завершили эту главу. Повтор не повлияет на текущий результат, но поможет закрепить знания!';

  @override
  String currentScore(int score) {
    return 'Текущий счёт: $score баллов';
  }

  @override
  String get repeatChapterBenefit =>
      'Практика ведёт к мастерству! Используйте шанс укрепить знания.';

  @override
  String get repeatChapter => 'Повторить главу';

  @override
  String chapterResetForRepetition(String chapterTitle) {
    return 'Глава «$chapterTitle» сброшена для повтора. Исходный результат сохранён!';
  }

  @override
  String get progress => 'Прогресс';

  @override
  String get episodeContent => 'Содержание эпизода';

  @override
  String get episodeContentPlaceholder =>
      'Содержание эпизода будет отображено здесь';

  @override
  String get replayEpisode => 'Повторить эпизод';

  @override
  String get startEpisode => 'Начать эпизод';

  @override
  String startingEpisode(String episodeTitle) {
    return 'Запуск $episodeTitle...';
  }

  // ----- Оценивание / Evaluation -----

  @override
  String get evaluationDetails => 'Детали оценки';

  @override
  String get completedDate => 'Дата завершения';

  @override
  String get attempts => 'Попытки';

  @override
  String get timeSpent => 'Затраченное время';

  @override
  String get skillBreakdown => 'Разбор навыков';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get featureComingSoon => 'Эта функция скоро появится!';

  @override
  String get chapter => 'Глава';

  @override
  String get evaluationInfo => 'Информация об оценке';

  @override
  String get chapterResults => 'Результаты главы';

  @override
  String get allChapters => 'Все главы';

  @override
  String get noEvaluationsFound => 'Оценки не найдены';

  @override
  String get completeChaptersToSeeResults =>
      'Завершайте главы, чтобы увидеть результаты';

  // ----- Главы словаря -----

  @override
  String get vocabularyChaptersTitle => 'Главы словаря';

  @override
  String get loadingVocabularyChapters => 'Загрузка глав словаря...';

  @override
  String get errorLoadingChapters => 'Ошибка загрузки глав';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get dismiss => 'Закрыть';

  @override
  String get tryAgain => 'Повторить попытку';

  @override
  String get noChaptersAvailable => 'Нет доступных глав';

  @override
  String get noChaptersDescription =>
      'Загляните позже: появятся новые главы словаря';

  @override
  String get yourProgress => 'Ваш прогресс';

  @override
  String get chaptersCompleted => 'Глав завершено';

  @override
  String get unlocked => 'Разблокировано';

  @override
  String get locked => 'Заблокировано';

  @override
  String get completed => 'Завершено';

  @override
  String get continue_ => 'Продолжить';

  @override
  String get start => 'Начать';

  @override
  String get chapterLocked => 'Глава заблокирована';

  @override
  String chapterLockedDescription(int previousChapter) {
    return 'Чтобы открыть эту главу, завершите главу $previousChapter';
  }

  @override
  String get understood => 'Понятно';

  @override
  String get chapterCompleted => 'Глава завершена';

  @override
  String get chapterCompletedDescription =>
      'Вы уже завершили эту главу. Можно просматривать её в любое время.';

  @override
  String completedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);
    return 'Завершено $dateString';
  }

  @override
  String get close => 'Закрыть';

  @override
  String get reviewChapter => 'Просмотреть главу';

  @override
  String get noLivesTitle => 'Нет жизней';

  @override
  String get noLivesMessage =>
      'Чтобы начать главу, нужна хотя бы одна жизнь. Жизни обновляются ежедневно.';

  @override
  String nextResetAt(String time) {
    return 'Следующее обновление в $time';
  }
}
