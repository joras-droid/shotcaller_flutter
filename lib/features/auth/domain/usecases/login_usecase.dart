import '../../../../core/result/result.dart';
import '../entities/user_profile.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
/// Encapsulates the business logic for authentication
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<UserProfile>> call(String email, String password) async {
    // Validate input
    if (email.isEmpty || password.isEmpty) {
      return const Failure('Email and password are required');
    }

    // Call repository
    return await repository.login(email, password);
  }
}

