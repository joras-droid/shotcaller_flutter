/// Base exception class for data layer errors
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Server exception (API errors, network issues)
final class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exception (local storage errors)
final class CacheException extends AppException {
  const CacheException(super.message);
}

/// Authentication exception
final class AuthException extends AppException {
  const AuthException(super.message);
}

