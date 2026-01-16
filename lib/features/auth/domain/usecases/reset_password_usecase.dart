import '../../../../core/result/result.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case for resetting password
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Result<void>> call({
    required String password,
    required String token,
  }) async {
    if (password.isEmpty || token.isEmpty) {
      return const Failure('Password and token are required');
    }

    if (password.length < 6) {
      return const Failure('Password must be at least 6 characters');
    }

    return await repository.resetPassword(
      password: password,
      token: token,
    );
  }
}

