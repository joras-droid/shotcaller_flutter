import '../../../../core/result/result.dart';
import '../entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';

/// Use case for user signup
class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Result<UserProfile>> call({
    required String email,
    required String otp,
    required String name,
    required String phone,
    required String password,
  }) async {
    // Validate input
    if (email.isEmpty || otp.isEmpty || name.isEmpty || phone.isEmpty || password.isEmpty) {
      return const Failure('All fields are required');
    }

    if (password.length < 6) {
      return const Failure('Password must be at least 6 characters');
    }

    return await repository.signup(
      email: email,
      otp: otp,
      name: name,
      phone: phone,
      password: password,
    );
  }
}

