/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Cache keys
  static const String cacheKeyUserProfile = 'user_profile';
  static const String cacheKeyAuthToken = 'auth_token';
  static const String cacheKeyRefreshToken = 'refresh_token';

  // API endpoints
  static const String apiBaseUrl = 'http://3.151.155.30/api/v1';
  static const String apiSendOtpEndpoint = '/auth/send-otp';
  static const String apiVerifyOtpEndpoint = '/auth/verify-otp';
  static const String apiLoginEndpoint = '/auth/sign-in';
  static const String apiPasswordResetEndpoint = '/auth/password-reset/reset';
}

