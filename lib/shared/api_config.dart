/// Central place for backend API configuration so the base URL is never
/// hardcoded per-call.
class ApiConfig {
  const ApiConfig._();

  /// Default points at the Android emulator's alias for the host machine's
  /// localhost, where the Spring Boot backend runs during development.
  static const String baseUrl = 'http://10.0.2.2:8080';
}
