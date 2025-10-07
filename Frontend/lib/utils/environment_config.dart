class EnvironmentConfig {
  // API Configuration - Updated to point to local backend
  static const String _defaultApiUrl = 'http://localhost:3000';
  static const String _defaultApiVersion = 'api/v1';
  
  // Get environment variables with fallbacks
  static String get apiBaseUrl {
    const url = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: _defaultApiUrl,
    );
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
  
  static String get apiVersion {
    return const String.fromEnvironment(
      'API_VERSION',
      defaultValue: _defaultApiVersion,
    );
  }
  
  // Complete API URL
  static String get fullApiUrl => '$apiBaseUrl/$apiVersion';
  
  // API Endpoints
  static String get authEndpoint => '$fullApiUrl/auth';
  static String get usersEndpoint => '$fullApiUrl/users';
  static String get personsEndpoint => '$fullApiUrl/persons';
  
  // Specific endpoints  
  static String get registerEndpoint => '$fullApiUrl/auth/register';
  static String get loginEndpoint => '$fullApiUrl/auth/login';
  static String get refreshTokenEndpoint => '$fullApiUrl/auth/refresh';
  
  // Environment information
  static bool get isDevelopment {
    return const bool.fromEnvironment(
      'DEVELOPMENT_MODE',
      defaultValue: true,
    );
  }
  
  static bool get enableLogging {
    return const bool.fromEnvironment(
      'ENABLE_API_LOGGING',
      defaultValue: true,
    );
  }
  
  // Timeout configurations
  static Duration get apiTimeout {
    const timeoutSeconds = int.fromEnvironment(
      'API_TIMEOUT_SECONDS',
      defaultValue: 30,
    );
    return Duration(seconds: timeoutSeconds);
  }
  
  // Helper method to log configuration (only in development)
  static void logConfiguration() {
    if (isDevelopment) {
      // ignore: avoid_print
      print('=== Environment Configuration ===');
      // ignore: avoid_print
      print('API Base URL: $apiBaseUrl');
      // ignore: avoid_print
      print('API Version: $apiVersion');
      // ignore: avoid_print
      print('Full API URL: $fullApiUrl');
      // ignore: avoid_print
      print('Development Mode: $isDevelopment');
      // ignore: avoid_print
      print('Enable Logging: $enableLogging');
      // ignore: avoid_print
      print('API Timeout: ${apiTimeout.inSeconds}s');
      // ignore: avoid_print
      print('================================');
    }
  }
}