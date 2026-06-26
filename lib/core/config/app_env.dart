class AppEnv {
  AppEnv._();

  static const String stagingBaseUrl = 'https://gz.api.splin.app';
  static const String localBaseUrl = 'http://192.168.1.6:3000';

  // Switch this to toggle environments
  static const String currentBaseUrl = localBaseUrl;
}
