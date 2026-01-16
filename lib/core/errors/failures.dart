/// Base failure class for domain layer errors
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Server failure (API errors, network issues)
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Cache failure (local storage errors)
final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Authentication failure
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

