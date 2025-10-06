// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  // ======================= Common / Auth =======================

  @override
  String get appTitle => 'App de Aprendizaje de Inglés';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginWithGoogle => 'Iniciar con Google';

  @override
  String get loginWithApple => 'Iniciar con Apple';

  @override
  String get emailRequired => 'El correo es requerido';

  @override
  String get emailInvalid => 'Ingrese un correo válido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get passwordTooShort => 'La contraseña debe tener al menos 12 caracteres';

  @override
  String get hi => 'Hola';

  @override
  String get continueText => 'Continuar';

  // ======================= Main Sections =======================

  @override
  String get vocabulary => 'Vocabulario';

  @override
  String get reading => 'Lectura';

  @override
  String get interview => 'Entrevista';

  @override
  String get home => 'Inicio';

  @override
  String get documents => 'Documentos';

  @override
  String get book => 'Libro';

  @override
  String get help => 'Ayuda';

  @override
  String get settings => 'Configuración';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get colorPalette => 'Paleta de Colores';

  @override
  String get system => 'Sistema';

  // ======================= Notifications =======================

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationsEnabled => 'Notificaciones activadas';

  @override
  String get notificationsDisabled => 'Notificaciones desactivadas';

  // ======================= Session / UI =======================

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get selectColorPalette => 'Seleccionar Paleta de Colores';

  @override
  String get confirmLogout => 'Confirmar Cierre de Sesión';

  @override
  String get logoutConfirmation => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get welcomeBack => '¡Bienvenido de vuelta!';

  @override
  String get yourLearningPath => 'Tu Ruta de Aprendizaje';

  @override
  String get learningSlogan => 'Aprende • Practica • Domina';

  @override
  String get signingYouIn => 'Iniciando sesión...';

  @override
  String get connectingWithGoogle => 'Conectando con Google...';

  @override
  String get connectingWithApple => 'Conectando con Apple...';

  @override
  String get loadingExperience => 'Cargando tu experiencia de aprendizaje...';

  @override
  String get initializingExperience => 'Inicializando tu experiencia de aprendizaje...';

  @override
  String get or => 'O';

  @override
  String get user => 'Usuario';

  // Lives / Progress snippets
  @override
  String livesRemaining(int lives) => '$lives/5';

  @override
  String get chapterProgress => 'Cap 4/5';

  // Tech topics
  @override
  String get software => 'Software';

  @override
  String get databases => 'Bases de Datos';

  // Navigation helper
  @override
  String navigatingToSection(String section) => 'Navegando a la sección $section...';

  // Auth errors
  @override
  String get emailPasswordRequired => 'El correo y la contraseña son requeridos';

  @override
  String get invalidCredentials => 'Credenciales inválidas. Verifica tu correo y contraseña.';

  @override
  String get googleSignInFailed => 'Error al iniciar sesión con Google';

  @override
  String get appleSignInFailed => 'Error al iniciar sesión con Apple';

  @override
  String get errorDuringLogout => 'Error al cerrar sesión';

  @override
  String get errorCheckingAuth => 'Error al verificar el estado de autenticación';

  @override
  String get errorInMockLogin => 'Error en el inicio de sesión de prueba';

  @override
  String get comingSoon => 'Próximamente';

  // Generic section title
  @override
  String sectionTitle(String title) => 'Sección $title';

  // Color picker
  @override
  String get selectCustomColor => 'Seleccionar Color Personalizado';

  @override
  String get hue => 'Matiz';

  @override
  String get saturation => 'Saturación';

  @override
  String get lightness => 'Luminosidad';

  @override
  String get quickColors => 'Colores Rápidos';

  @override
  String get selectColor => 'Seleccionar Color';

  // Quiz
  @override
  String get quiz => 'Quiz';

  @override
  String get question => 'Pregunta';

  @override
  String get submit => 'Enviar';

  @override
  String get nextQuestion => 'Siguiente Pregunta';

  @override
  String get score => 'Puntuación';

  @override
  String get points => 'puntos';

  // Episodes
  @override
  String get completeePreviousEpisode => 'Completa el episodio anterior para desbloquear este';

  @override
  String get episodeCompleted => 'Episodio completado - Toca para repetir';

  @override
  String get continueEpisode => 'Continuar episodio';

  @override
  String get completePreviousEpisode => 'Completa el episodio anterior para desbloquear';

  @override
  String playingEpisode(String episodeTitle) => 'Reproduciendo $episodeTitle';

  // Account / Register
  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Registrarse';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get joinUsSlogan => 'Únete para comenzar tu viaje con el inglés técnico';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get enterFullName => 'Ingresa tu nombre completo';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get enterConfirmPassword => 'Confirma tu contraseña';

  @override
  String get acceptTerms => 'Acepto los Términos de Servicio y la Política de Privacidad';

  @override
  String get pleaseEnterName => 'Por favor, ingresa tu nombre';

  @override
  String get nameTooShort => 'El nombre debe tener al menos 2 caracteres';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get pleaseAcceptTerms => 'Por favor, acepta los términos y condiciones';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get creatingAccount => 'Creando tu cuenta...';

  @override
  String get register => 'Registrarse';

  @override
  String get signUpWithGoogle => 'Registrarse con Google';

  @override
  String get signUpWithApple => 'Registrarse con Apple';

  @override
  String get creatingAccountWithGoogle => 'Creando cuenta con Google...';

  @override
  String get creatingAccountWithApple => 'Creando cuenta con Apple...';

  // Forgot password
  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get checkYourEmail => 'Revisa tu correo';

  @override
  String get forgotPasswordSubtitle =>
      '¡No te preocupes! Ingresa tu dirección de correo y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get emailSentMessage =>
      'Hemos enviado un enlace para restablecer tu contraseña a tu dirección de correo. Revisa tu bandeja de entrada y sigue las instrucciones.';

  @override
  String get emailAddress => 'Dirección de correo';

  @override
  String get enterEmailAddress => 'Ingresa tu dirección de correo';

  @override
  String get sendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get backToLogin => 'Volver al inicio de sesión';

  @override
  String get emailSent => 'Correo enviado';

  @override
  String get sendingResetLink => 'Enviando enlace de restablecimiento...';

  @override
  String get emailSentSuccessfully => '¡Correo de restablecimiento enviado exitosamente!';

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String get openEmailApp => 'Abrir aplicación de correo';

  @override
  String get resetLinkSentAgain => '¡Enlace de restablecimiento enviado nuevamente!';

  @override
  String get openingEmailApp => 'Abriendo aplicación de correo...';

  @override
  String get forgotPasswordQuestion => '¿Olvidaste tu contraseña?';

  // Misc
  @override
  String get rememberSession => 'Recordar sesión';

  @override
  String get folders => 'Carpetas';

  @override
  String get errorLoadingLives => 'Error al cargar vidas';

  @override
  String get retry => 'Reintentar';

  @override
  String get noLivesRemaining => '¡No quedan vidas!';

  @override
  String get livesResetTomorrow => 'Las vidas se reinician mañana';

  @override
  String get nextResetTomorrow => 'Próximo reinicio mañana';

  @override
  String get refresh => 'Actualizar';

  // ======================= Repetir Capítulo =======================

  @override
  String get repeatChapterTitle => 'Repetir Capítulo';

  @override
  String get repeatChapterWarning =>
      'Ya has completado este capítulo. Repetirlo no afectará tu puntuación actual, ¡pero es una excelente manera de reforzar tu aprendizaje!';

  @override
  String currentScore(int score) => 'Puntuación actual: $score puntos';

  @override
  String get repeatChapterBenefit =>
      '¡La práctica lleva a la perfección! Aprovecha esta oportunidad para fortalecer tu conocimiento.';

  @override
  String get repeatChapter => 'Repetir Capítulo';

  @override
  String chapterResetForRepetition(String chapterTitle) =>
      'El capítulo "$chapterTitle" ha sido reiniciado para repetición. ¡Tu puntuación original se mantiene!';

  // ======================= Capítulos de Vocabulario =======================

  @override
  String get vocabularyChaptersTitle => 'Capítulos de Vocabulario';

  @override
  String get loadingVocabularyChapters => 'Cargando capítulos de vocabulario...';

  @override
  String get errorLoadingChapters => 'Error al cargar capítulos';

  @override
  String get unknownError => 'Ocurrió un error desconocido';

  @override
  String get dismiss => 'Descartar';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get noChaptersAvailable => 'No hay capítulos disponibles';

  @override
  String get noChaptersDescription => 'Vuelve más tarde para ver nuevos capítulos de vocabulario';

  @override
  String get yourProgress => 'Tu Progreso';

  @override
  String get chaptersCompleted => 'Capítulos Completados';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get locked => 'Bloqueado';

  @override
  String get progress => 'Progreso';

  @override
  String get completed => 'Completado';

  @override
  String get continue_ => 'Continuar';

  @override
  String get start => 'Comenzar';

  @override
  String get chapterLocked => 'Capítulo Bloqueado';

  @override
  String chapterLockedDescription(int previousChapter) =>
      'Completa el capítulo $previousChapter para desbloquear este capítulo';

  @override
  String get understood => 'Entendido';

  @override
  String get chapterCompleted => 'Capítulo Completado';

  @override
  String get chapterCompletedDescription =>
      'Ya completaste este capítulo. Puedes repasarlo cuando quieras.';

  @override
  String completedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);
    return 'Completado el $dateString';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get reviewChapter => 'Repasar Capítulo';

  @override
  String get noLivesTitle => 'Sin Vidas Disponibles';

  @override
  String get noLivesMessage =>
      'Necesitas al menos una vida para comenzar un capítulo. Las vidas se reinician diariamente.';

  @override
  String nextResetAt(String time) => 'Próximo reinicio a las $time';

  // ======================= Evaluación (hu-006-1) =======================

  @override
  String get evaluationDetails => 'Detalles de la Evaluación';

  @override
  String get completedDate => 'Fecha de Finalización';

  @override
  String get attempts => 'Intentos';

  @override
  String get timeSpent => 'Tiempo Empleado';

  @override
  String get skillBreakdown => 'Desglose por Habilidades';

  @override
  String get feedback => 'Retroalimentación';

  @override
  String get featureComingSoon => '¡Función próximamente disponible!';

  @override
  String get chapter => 'Capítulo';

  @override
  String get evaluationInfo => 'Información de la Evaluación';

  @override
  String get chapterResults => 'Resultados por Capítulo';

  @override
  String get allChapters => 'Todos los Capítulos';

  @override
  String get noEvaluationsFound => 'No se encontraron evaluaciones';

  @override
  String get completeChaptersToSeeResults => 'Completa capítulos para ver resultados';
}
